clear;close all;clc
load('Scans')
%% Scan Matching
transform = matchScans(scan0,scan1)
T = transform(1:2);
theta = transform(3);

scan0_transformed = transformScan(scan0,transform);

%% Plots
close all
plot(scan0)
hold on
plot(scan1)
plot(scan0_transformed)
legend('Posição Inicial','Posição Final','Transformação')



