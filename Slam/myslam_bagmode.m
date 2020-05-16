clear;close all;clc
% Final pose my  | hector 
%    0.5435       x: 0.556652069092
%    -1.5385  y: -1.54119920731
%    -4.7844

% rosinit
bag = rosbag('laser.bag');
bagselect = select(bag,'topic','/cloud');
lasermsgs = readMessages(bagselect);

%% Map Specs
map.resolution = 0.1; % = cell length
map.scale = 1/map.resolution;
map.scale2 = map.scale^2;
map.size = 400; %cells
disp('Map side length') ;
disp(map.resolution*map.size); %dist em metros
map.startx = 0.5; % 0 < x < 1
map.starty = 0.5; % 0 < y < 1

%translada ponto para grid
map.tfx = map.startx*map.resolution*map.size;
map.tfy = map.starty*map.resolution*map.size;

map.grid = zeros(map.size);
map.grid_index = -ones(map.size);

% probabilidades
map.updateOcc = 0.9;
map.updateFree = 0.4;

% formato Logodd (atualiza mais rapidamente)
map.logOddOcc = log(map.updateOcc / (1 - map.updateOcc));
map.logOddFree = log(map.updateFree / (1 - map.updateFree));

% funcionalidade para evitar que vários "beams" atualizem uma msm célula
map.currUpdateIndex = 0;
map.currMarkFreeIndex = -1;
map.currMarkOccIndex = -1;


%% Loop
% lidar_read = rossubscriber('/cloud');
map_init = false;

world_pose = [0 0 0]';
last_mapupdate_pose = world_pose;

% endpois
total_msgs = size(lasermsgs,1);
init_map_scans = 10;
for i=1:total_msgs

  cloud = lasermsgs{i};
  cloud_xyz = cloud.readXYZ;
  cloud_xy = cloud_xyz(:,1:2);
  
  % filtra cloud
  cloud_xy_filter = filtercloud(cloud_xy);
  
  n = length(cloud_xy_filter);
  
  if(~map_init)
%       map = registerCloud(map,cloud_xy_filter);
        map = registerCloudProbs(map,cloud_xy_filter,world_pose)
        
    
        if i == init_map_scans
            map_init = true;
            plot(cloud_xy_filter(:,1),cloud_xy_filter(:,2),'.');
%             plotmatrix(map.grid)
        end
      
%       figure
%       
      
  else 
      de = 0;
      H = zeros(3);
      dtr = zeros(3,1);
      iterations = 5;
      estimate = world_pose;4
      for it=1:iterations
         
          for j=1:n
          endpoint = cloud_xy_filter(j,:); %sensor reading
          endpoint_tf = transform_endpoints(endpoint,estimate);
          %as duas funções abaixo podem ser uma só
          funval = 1 - mapaccess(map,endpoint_tf);
          dm = mapgradient(map,endpoint_tf);
          jac = model_deriv(endpoint,estimate);

          dtr = dtr + (dm*jac)'*funval; 
          H = H + (dm*jac)'*(dm*jac);
          end

          if(H(1,1) ~= 0 && H(2,2) ~= 0)
             searchdir = inv(H)*dtr;
          end
             estimate = estimate + searchdir;
             %normalize estimate(3)
      end
      world_pose = estimate
               
         updist = sqrt ((last_mapupdate_pose(1:2) - world_pose(1:2))'*(last_mapupdate_pose(1:2) - world_pose(1:2)))       
         angleDiff = last_mapupdate_pose(3) - world_pose(3);
           if (angleDiff > pi)
            angleDiff = angleDiff - pi * 2.0;
           elseif (angleDiff < -pi)
            angleDiff = angleDiff + pi * 2.0;          
           end
          angdist = abs(angleDiff)
         % Preciso atualizar o angdist não em relação ao ultimo update, mas
         
         if(updist > 0.3 || angdist > 0.06) %Map Update
             cloud_t = transform_cloud(cloud_xy_filter,world_pose);
             figure(1)
             hold on
             plotcloud(cloud_t);
             % usar probabilidade
             map = registerCloudProbs(map,cloud_t,world_pose)
             figure(2)
             plotmatrix(map.grid)
             last_mapupdate_pose = world_pose;
             drawnow
         end
         
      end
      
      
%       plotmatrix(map.grid)
%       drawnow
      
      
end
  
  
  
  
  
   
  


function jac = model_deriv(endpoint,pose)
theta = pose(3);
jac = [1 0 -sin(theta)*endpoint(1)-cos(theta)*endpoint(2);
       0 1  cos(theta)*endpoint(1)-sin(theta)*endpoint(2)];

end





% function tf = pose2tf(pose)
% tf.R = [cos(pose.phi) -sin(pose.phi)
%     sin(pose.phi) cos(pose.phi)];
% 
% tf.T = [pose.x;pose.y];
% 
% end

%aproximate


%   for(unsigned int i=0;i<size;++i){
% 	if(map_g->data[i] > LOW_LIMIT){ //verifica se ponto eh valido
% 	points++;
% 	column = i%height;
% 	row = i/width;
% //	ROS_INFO("i = %d, row = %d, column = %d",i,row,column);
% 	y = row*resolution;
% 	x = column*resolution;
% 	x = x + p0.position.x;
% 	y = y + p0.position.y;
% //	ROS_INFO("x = %f, y = %f",x,y);
% 	cloud->push_back(pcl::PointXYZ (x,y,0));
% 	  }
%   }




