clear;close all;clc

pc = pcread('1mCubo.pcd')
% cloud_raw = load('caixa.pcd');
% cloud_raw = load('Cilindrao2.asc');
% cloud_raw = load('Caixa2.asc');
% cloud_raw = load('Pilha33_Raw.asc'); %MAIOR
% cloud_raw1 = load('Pilha32_Raw.asc'); %SEGUNDA MAIOR
% cloud_raw2 = load('Pilha31_Raw.asc'); %MENOR


cloud = double(pc.Location); %pega s pontos

% pcshow(cloud);
% figure
% % pcshow(cloud_raw1(:,1:3)); 
% % pcshow(cloud_raw2(:,1:3)); 
% xlabel('X');
% ylabel('Y');
% return
% Pega 4 cantos do PC;
%% HARD MODE -> Traça um plano entre os 4 (ou 3 )
% preenche o plano com pontos
% pff, nem tentei

%% EZ MODE -> Coordenadas baricentricas entre os 4 cantos
% Pega indices
% meio lixo, n valeu esforç
[x_max,ix_max] = max(cloud(:,1));
[x_min,ix_min] = min(cloud(:,1));
[y_max,iy_max] = max(cloud(:,2));
[y_min,iy_min] = min(cloud(:,2));

%% SMART MODE -> Projeção de toda a nuvem sobre plano (x,y)! 
% ai eh top
%%
densities = [0.01];
for density=densities
Cloud_floored = makeFloor(cloud,density);
% Varios Volumes
% alphas = [0.05 0.1 0.15 0.3 0.5 1 10];
alphas = [5];
V = zeros(length(alphas),1);
i = 1;
for alpha=alphas
    shape = alphaShape(Cloud_floored,alpha);
    V(i) = volume(shape);
    i = i+1;
end

%% Save Floored
pc_floored = pointCloud(Cloud_floored);
pcwrite(pc_floored,'1mCubo_floored.pcd','Encoding','binary');

%% Plots
close all

plot(alphas,V)
grid on
xlabel('Alpha')
ylabel('Volume [m³]')

figure
plot(shape)
xlabel('X [m]')
ylabel('Y [m]')
zlabel('Z [m]')
disp(V)
end



function cloud_floored = makeFloor(cloud,density)
step = round(1/density);
size_cloud = length(cloud);
orig = [0 0 0]';
normal = [0 0 1]';
size_floor = length(1:step:size_cloud);
Projected_points = zeros(size_floor,3);
k = 1;
for i=1:step:size_cloud
    p = cloud(i,:)';
v = p - orig;
dist = dot(v,normal);
Projected_points(k,:) = p - dist*normal;
k = k+1;
end
z_min = min(cloud(:,3));
Projected_points_offset = Projected_points + [0 0 z_min];
cloud_floored = [cloud;Projected_points_offset];
end


