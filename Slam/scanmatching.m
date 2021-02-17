clear;close all;clc


load lidarScans.mat


referenceScan = lidarScans(180);
currentScan = lidarScans(190);


currScanCart = currentScan.Cartesian;
refScanCart = referenceScan.Cartesian;
figure
plot(refScanCart(:,1),refScanCart(:,2),'k.');
hold on
plot(currScanCart(:,1),currScanCart(:,2),'r.');
legend('Reference laser scan','Current laser scan','Location','NorthWest');


transform = matchScans(currentScan,referenceScan)
transScan = transformScan(currentScan,transform);


figure
plot(refScanCart(:,1),refScanCart(:,2),'k.');
hold on
transScanCart = transScan.Cartesian;
plot(transScanCart(:,1),transScanCart(:,2),'r.');
legend('Reference laser scan','Transformed current laser scan','Location','NorthWest');