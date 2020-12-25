clear;close all;clc
% rosinit

%% ROS STUFF

tftree = rostf
transfm = rosmessage('geometry_msgs/TransformStamped');
transfm.ChildFrameId = 'matlab_pose';
transfm.Header.FrameId = 'map';
transfm.Transform.Translation.X = 0;
transfm.Transform.Rotation.W = 1;
transfm.Transform.Rotation.X = 0;
transfm.Transform.Rotation.Y = 0;
transfm.Transform.Rotation.Z = 0;



%% Map Specs
map.resolution = 0.05;
map.size = 300; %cells
disp('Map side length') ;
disp(map.resolution*map.size);
map.startx = 0.5; % 0 < x < 1
map.starty = 0.5; % 0 < y < 1

%translada cloud para origem da grid para acessar em forma de matrix
map.tfx = map.startx*map.resolution*map.size;
map.tfy = map.starty*map.resolution*map.size;
map.grid = zeros(map.size);
map.updateOcc = 0.9;
map.updateFree = 0.4;
map.logOddOcc = log(map.updateOcc / (1 - map.updateOcc));
map.logOddFree = log(map.updateFree / (1 - map.updateFree));



%% Loop
lidar_read = rossubscriber('/cloud');
first_cloud = false;

world_pose = [0 0 0]';
last_mapupdate_pose = world_pose;

% endpois

while(1)
  cloud = receive(lidar_read);
  cloud_time = cloud.Header.Stamp;
  cloud_xyz = cloud.readXYZ;
  cloud_xy = cloud_xyz(:,1:2);
  
  % filtra cloud
  cloud_xy_filter = filtercloud(cloud_xy);
  
  n = length(cloud_xy_filter);
  
  if(~first_cloud)
      first_cloud = true;
%       map = registerCloud(map,cloud_xy_filter);
        map = registerCloudProbs(map,cloud_xy_filter,world_pose)
    
      plot(cloud_xy_filter(:,1),cloud_xy_filter(:,2),'.');
%       figure
%       plotmatrix(map.grid)
      
  else 
      de = 0;
      H = zeros(3);
      dtr = zeros(3,1);
      iterations = 3;
      estimate = world_pose;
      for it=1:iterations
         
          for i=1:n
          endpoint = cloud_xy_filter(i,:); %sensor reading
          endpoint_tf = transform_endpoints(endpoint,estimate);
          %as duas funções abaixo podem ser uma só
          funval = 1 - mapaccess(map,endpoint_tf);
          dm = mapgradient(map,endpoint_tf); %1 x 2
          jac = model_deriv(endpoint,estimate); % 2 x 3

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
      
%          q = eul2quat([pose(3) 0 0]);
%          transfm.Transform.Translation.X = pose(1);
%          transfm.Transform.Translation.Y = pose(2);
%          transfm.Transform.Rotation.W = q(1);
%          transfm.Transform.Rotation.X = q(2);
%          transfm.Transform.Rotation.Y = q(3);
%          transfm.Transform.Rotation.Z = q(4);
%          transfm.Header.Stamp = cloud_time;
%          tftree.sendTransform(transfm);
         
         updist = sqrt ((last_mapupdate_pose(1:2) - world_pose(1:2))'*(last_mapupdate_pose(1:2) - world_pose(1:2)))
         
         angleDiff = last_mapupdate_pose(3) - world_pose(3);
           if (angleDiff > pi)
            angleDiff = angleDiff - pi * 2.0;
           elseif (angleDiff < -pi)
            angleDiff = angleDiff + pi * 2.0;          
           end
          angdist = abs(angleDiff)
         % Preciso atualizar o angdist não em relação ao ultimo update, mas
         % incrementalmente ?
         
         if(updist > 0.3 || angdist > 0.06)
              cloud_t = transform_cloud(cloud_xy_filter,world_pose);
             figure(1)
             hold on
             plotcloud(cloud_t);
             % usar probabilidade
             map = registerCloudProbs(map,cloud_t,world_pose)
             figure(2)
             hold on
             plotmatrix(map.grid)
             last_mapupdate_pose = world_pose;
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




