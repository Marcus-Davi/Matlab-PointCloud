clear;close all;clc
%rosinit


%% Subscriber
sub_pc = rossubscriber('cloud_ldmrs');

%% TF

tftree = rostf;
%% Loop
global_xyz = [];
while(1)
    pc = receive(sub_pc);
    n_p = pc.Width;
    local_xyz = [readXYZ(pc) ones(n_p,1)]';
    disp('PC OK')
    disp(pc.Width)
    TF = getTransform(tftree, 'map', 'drone');
    Translate = TF.Transform.Translation;
    Rotate =  TF.Transform.Rotation;
    q = [ Rotate.W Rotate.X Rotate.Y Rotate.Z];
    T = [Translate.X Translate.Y Translate.Z]';
    R = quat2mat(q); %quaternion to rotation
    Transform_MAP_DRONE = [R T;0 0 0 1];
    q_ = eul2quat([0 pi/2 0],'ZYX');
    R_ = quat2mat(q_);
    T_ = [0 0 0]';
    Transform_DRONE_LIDAR = [R_ T_;0 0 0 1];
    
    Transform = Transform_MAP_DRONE*Transform_DRONE_LIDAR;
    
    transformed_xyz_ = Transform*local_xyz;
    transformed_xyz = (transformed_xyz_(1:3,:))';
    global_xyz = [global_xyz;transformed_xyz];
    
    
    
end



