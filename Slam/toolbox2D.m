clear;close all;clc

load('offlineSlamData.mat');

maxLidarRange = 8;
mapResolution = 20;
slamAlg = lidarSLAM(mapResolution, maxLidarRange);

slamAlg.LoopClosureThreshold = 210;
slamAlg.LoopClosureSearchRadius = 8;


% for i=1:10
%     [isScanAccepted, loopClosureInfo, optimizationInfo] = addScan(slamAlg, scans{i});
%     if isScanAccepted
%         show(slamAlg);
%         drawnow
%         fprintf('Added scan %d \n', i);
%
%     end
% end


% [isScanAccepted, loopClosureInfo, optimizationInfo] = addScan(slamAlg, scans{1});

for i=2:length(scans) %Start from 2

    [isScanAccepted, loopClosureInfo, optimizationInfo] = addScan(slamAlg, scans{i});
    if isScanAccepted
        figure(1)
        show(slamAlg);
        drawnow
        fprintf('Added scan %d \n', i);
    else
        continue;
    end
    % visualize the first detected loop closure, if you want to see the
    % complete map building process, remove the if condition below
    if optimizationInfo.IsPerformed
        figure(2)
        show(slamAlg, 'Poses', 'off');
        hold on;
        show(slamAlg.PoseGraph);
        hold off;
        
        drawnow
    end
end
