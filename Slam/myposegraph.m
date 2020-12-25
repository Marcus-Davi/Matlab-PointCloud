clear; close all;clc
load('offlineSlamData.mat');

maxLidarRange = 8;
mapResolution = 20;
n_scans = length(scans);

p_0 = eye(3); % homogeneous




Nodes.Matrix = p_0;
Nodes.Matrix_{1} = p_0;
Nodes.nodes{1} = [0 0 0];
Nodes.Scans = {};
Nodes.NextScanID = 1;
Nodes.N = 1;

Edges.edges = [];
Edges.Matrix = [];
Edges.Matrix_ = {};
Edges.N = 0;

first_scan = true;

% T_abs =

for i=2:n_scans
    % Relative transform
    loop_closure = false;
    if(first_scan)
        currentScan = scans{i}; %source
        Nodes.Scans{1} = currentScan;
        Nodes.NextScanID = Nodes.NextScanID + 1;
        first_scan = false;        
    else
       
    
    currentScan = scans{i}; %source
    refereceScan = scans{i-1}; %target
    [relPose, stats] = matchScansGrid(currentScan, refereceScan,...
        'MaxRange', maxLidarRange, 'Resolution', mapResolution);
    transform = matchScans(currentScan,refereceScan,'InitialPose',relPose) % NDT  0.0025   -0.0002   -0.0005
    
    
    infoMat = [1 0 0 1 0 1];
    infoMat_ = eye(3);
    
    
    Trel = poseToTformSE2(transform);
    
    Edges.edges = [Edges.edges; Edges.N Edges.N+1];
    Edges.N = Edges.N + 1;
    Edges.Matrix_{Edges.N} = [Edges.Matrix; Trel];
    Edges.Matrix = [Edges.Matrix; Trel];
    
    
    Nodes.Matrix = [Nodes.Matrix; Nodes.Matrix_{Nodes.N}*Trel];
    Nodes.Matrix_{Nodes.N+1} = Nodes.Matrix_{Nodes.N}*Trel;
    Nodes.Scans{Nodes.NextScanID} = currentScan;
    Nodes.N = Nodes.N + 1;
    Nodes.NextScanID = Nodes.NextScanID + 1;


    end
    
    
    % * detect loop closure * HOW ???
    
    
    %     if ~loop_closure
    %
    %     else
    %
    %     end
    
    showMap(Nodes);
    drawnow
%     pause(0.5)
    
end

function showMap(nodes)
ax = newplot
poses = []
hold(ax,'on')
for i=1:nodes.NextScanID - 1
       scan_pre = nodes.Scans{i}.removeInvalidData('RangeLimits', [0.02 8]) ; % 8 = max lidar
       scan = scan_pre.Cartesian;
       T = nodes.Matrix_{i}
    
    %    T(1:2,1:2) = T(1:2,1:2)';
    %     T = eye(3);
       scan_ = [scan'; ones(1,length(scan))];
       scan_T = (T*scan_)';
       plot(scan_T(:,1),scan_T(:,2),'.', 'MarkerSize', 3, 'color', 'm')
       poses = [poses; T(1,3) T(2,3)];
    
%     sc = transformScan(nodes.Scans{i}.removeInvalidData('RangeLimits', [0.02 8]), nodes.nodes{i});
%     nodes.nodes{i}
%     scPoints = sc.Cartesian
%     plot(scPoints(:,1), scPoints(:,2), '.', 'MarkerSize', 3, 'color', 'm');
    
end

    plot(poses(:,1),poses(:,2), '.-', 'MarkerSize', 5, 'color', 'b')


grid(ax,'on')
hold(ax,'off')

end



function T = poseToTformSE2(pose)
%poseToTformSE2
x = pose(1);
y = pose(2);
theta = pose(3);
T = [cos(theta), -sin(theta), x; sin(theta), cos(theta), y; 0 0 1];
end

