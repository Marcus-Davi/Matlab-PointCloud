clear;close all;clc
% Escolhe um arquivo '.bag'
bagfile = 'complete_experiment.bag';
bag = rosbag(bagfile);
bagselect = select(bag,'topic','/cloud_ldmrs');
clouds = readMessages(bagselect);

%% Save
N_clouds = length(clouds)-1;

map_cloud = [];

for i=10:N_clouds
    
    i
    
    T = getTransform(bag,'map','ldmrs',clouds{i}.Header.Stamp);
    %         PC = clouds{i}.readXYZ;
    
    % Transforma
    PC_tf_msg = apply(T, clouds{i});
    
    PC_tf_xyz = PC_tf_msg.readXYZ;
    % as nuvens podem ser lidar usando clouds{1}.readXYZ
    
    map_cloud = [map_cloud;PC_tf_xyz]; % p/ montar o mapa
    
    % Salva nuvens locais
    
    filename_clouds_tf = strcat('individual_clouds_transformed/cloud_',int2str(i),'.pcd');
    filename_clouds_raw = strcat('individual_clouds_raw/cloud_',int2str(i),'.pcd');
%     filename_transforms = strcat('individual_transforms/tf_',int2str(i),'.txt');
    % TODO Abrir arquivo
    
    pc_local_tf = pointCloud(PC_tf_xyz);
    pc_local = pointCloud(clouds{i}.readXYZ);
    
    pcwrite(pc_local_tf,filename_clouds_tf);
    pcwrite(pc_local,filename_clouds_raw);
    
    
end

pcshow(map_cloud)


