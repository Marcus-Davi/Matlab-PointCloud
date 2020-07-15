clear;close all;clc
bag = rosbag('simulation.bag');
bagselect = select(bag,'topic','/cloud_profiler');
lasermsgs = readMessages(bagselect);
total_msgs = size(lasermsgs,1);

while(1)
for i=1:total_msgs
    cloud = lasermsgs{i};
    cloud_xyz = cloud.readXYZ;

    
    
    % Processar a nuvem. Problema : Como gerar a posição do objeto ?
    % altura do objeto -> x
    objCloud = selectObject(cloud_xyz);
    
    pos = getPos(objCloud);
    f_pos = getFrontPos(objCloud);
    % chão -> 1.5m
    
    
    
    plotcloud(cloud_xyz,'blue',20);
    hold on
    plotcloud(objCloud,'red',8);
    plot(pos(1),pos(2),'black*')
    plot(1.5,pos(2),'black*')
    plot(1.5,f_pos(2),'black*')
    grid on
    hold off
    drawnow
    pause(0.01)
end
end

%


function obj_pts = selectObject(cloud) 
n = length(cloud);


obj_pts = [];
count = 1;
for i=1:n
    if (cloud(i,1) < 1.4)
       obj_pts(count,1) = cloud(i,1);
       obj_pts(count,2) = cloud(i,2);
       
       count = count +1;
    end
    
end

end

%position media
function pos = getPos(objCloud)

x_pos = mean(objCloud(:,1));
y_pos = mean(objCloud(:,2));
pos = [x_pos y_pos];   

end


%position fronteira
function pos = getFrontPos(objCloud)
%pegar o maior y do objeto
x_pos = mean(objCloud(:,1));
y_pos = max(objCloud(:,2));
pos = [x_pos y_pos];

end