% clear ;close all;clc
% rosshutdown
% rosinit
clear;close all;clc

laser = rossubscriber('/scan');


%Make object
data = receive(laser,1);
angles = data.AngleMin:data.AngleIncrement:data.AngleMax;
scan0 = lidarScan(data.Ranges,angles);
disp('scan0 gravado.');
disp('Gire um pouco...')
pause(1)
data = receive(laser,1);
scan1 = lidarScan(data.Ranges,angles);
disp('scan1 gravado.')
save('Scans_New','scan0','scan1')
plot(scan0)
hold on
plot(scan1)
return