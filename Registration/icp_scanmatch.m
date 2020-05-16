clear;close all;clc
%% Load Points
p0 = pcread('p0.pcd');
p1 = pcread('p1.pcd');
% pcshow(p0);
% hold on
% pcshow(p1)
X0 = p0.Location(:,1);
Y0 = p0.Location(:,2);

X1 = p1.Location(:,1);
Y1 = p1.Location(:,2);

P0 = [nonzeros(X0) nonzeros(Y0)];
P1 = [nonzeros(X1) nonzeros(Y1)];
%% Filtros
n = length(P0);
n1 = length(P1);
P0 = [P0 zeros(n,1)];
P1 = [P1 zeros(n1,1)];

%% a Few plots
%% Plots
plot(P0(:,1),P0(:,2),'b.') % Original
hold on
plot(P1(:,1),P1(:,2),'r.') % Final
drawnow

[Ricp Ticp ER t] = icp(P0', P1', 30, 'Matching', 'kDtree','iter',50);
P0_Transformed = (Ricp*P0' - Ticp)';
plot(P0_Transformed(:,1),P0_Transformed(:,2),'g.') % Final


