clear;close all;clc
bag = rosbag('simulation.bag');
bagselect = select(bag,'topic','/cloud_profiler');
lasermsgs = readMessages(bagselect);
total_msgs = size(lasermsgs,1);


for i=1:total_msgs
    cloud = lasermsgs{i};
    cloud_xyz = cloud.readXYZ;
    x = cloud_xyz(:,1);
    y = cloud_xyz(:,2);
    
    
    % Processar a nuvem. Problema : Como gerar a posição do objeto ?
    
    plot(x,y)
    grid on
    drawnow
    pause(0.01)
end



grid on