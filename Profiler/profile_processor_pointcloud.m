clear;close all;clc
bag = rosbag('moving_truck3.bag');
bagselect = select(bag,'topic','/cloud_profiler');
tf_select = select(bag,'topic','/tf');
lasermsgs = readMessages(bagselect);
total_msgs = size(lasermsgs,1);

cloud = lasermsgs{1};
PC_old = pointCloud(cloud.readXYZ);
tfs    = readMessages(tf_select);

filter_height = 3.8;

cloud0 = lasermsgs{1};   
PC0 = pointCloud(cloud0.readXYZ);
PC0_filtered = filterFloor(PC0,filter_height);

%% Test

% cloud2 = lasermsgs{50};   
% PC2 = pointCloud(cloud2.readXYZ);
% PC2_filtered = filterFloor(PC2,filter_height);
% 
% pcshow(PC1_filtered)
% hold on
% pcshow(PC2_filtered)
% [T,PC_out]= pcregistericp(PC2_filtered,PC1_filtered);

% pcshow(PC_out)
% return
%% Simula

delta = 0;
deltaMy = 0;
x0 = tfs{1}.Transforms.Transform.Translation.X;
while(1)
for i=20:total_msgs
    cloud = lasermsgs{i};   
    x = tfs{i}.Transforms.Transform.Translation.X;
    
    
    cloud_xyz = cloud.readXYZ;
    PC = pointCloud(cloud_xyz);
    PC_filtered = filterFloor(PC,filter_height);
    
    
    
    % Processing
%     T_myicp = icp_single_axis(PC0_filtered,PC_filtered);
%    
    T = pcregistericp(PC0_filtered,PC_filtered)
%     
    PC0_filtered = PC_filtered;
%     
    delta = delta + T.Translation(2)
%     deltaMy = deltaMy + T_myicp
    realDelta = x - x0

    
    
    
%     pcshow(PC_filtered)
    plotcloud(cloud_xyz,'blue',20);
    axis equal
%     grid on
%     hold off
    drawnow
%     pause(0.01)
end
end


% Tem que ser no frame do lidar
function cloud_nofloor = filterFloor(pointcloud,threshold)
indexes = pointcloud.Location(:,1,1) < threshold;
cloud_nofloor = pointCloud(pointcloud.Location(indexes,:,:));
end
