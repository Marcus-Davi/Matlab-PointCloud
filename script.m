       clear;close all;clc
pc_raw = load('nanook.asc');
% pc_raw = load('Cilindrao.asc');
% pc_raw = load('Cilindro.asc');
pc_raw = pc_raw(:,1:3)
pc = pointCloud(pc_raw);
x = pc_raw(:,1);
y = pc_raw(:,2);
z = pc_raw(:,3);
pcshow(pc);
AS = alphaShape(x,y,z,0.2);
figure;
plot(AS)
V = volume(AS)

v_analitico = pi*(0.075^2)*0.3