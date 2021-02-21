clear;close all;clc
%% Load Points

load('lms_dataset.mat')

source = SCANS{1};
target = SCANS{150};


%% Load from folder
source = pcread('scanmatch/c3.pcd')
source = source.Location(:,1:3);

target = pcread('scanmatch/c2.pcd')
target = target.Location(:,1:3);

% tform = pcregistericp(source,target)
% source = pcdownsample(source,'gridAverage',0.02)
% source_moved = pctransform(source,tform);
% pcshow(source_moved.Location,'white')
% hold on
% pcshow(target.Location,'red')
% pcshow(source.Location,'green')
% return


% Hereafter, call point clouds as 'source' and 'target'
%% Filtering

% filter zeros

source = source(source(:,1) ~= 0,:);
target = target(target(:,1) ~= 0,:);

% remove z
source = source(:,1:2);
target = target(:,1:2);



%% Feature extraction
source_ = extractEdges(source,4);

% plot(source(:,1),source(:,2),'b.') % Original
% hold on
% plot(source_(:,1),source_(:,2),'r.') % Original
% 
% return



%% Plots
plot(source(:,1),source(:,2),'b.') % Original
hold on
plot(target(:,1),target(:,2),'r.') % Final
drawnow
%% myICP
match_iterations = 15;

% Closest point (ñ mt eficiente?)
%% KD TREE for closest. P0 -> Source Cloud / MAP ; P1 -> Target cloud / Last SCAN
% P1_transformed = target;

source_transformed = source_;

n_source = length(source_transformed);
n_target = length(target);


% KD = KDTreeSearcher(source','BucketSize',10);
r = 1; %distance
R_ = eye(2);
T_ = [0 0]';
tic

max_dists = 5;
% figure
Error = zeros(1,match_iterations);
for k=1:match_iterations
    k
      
    % procura correspondencias em 'target' para cada ponto da 'source'
    [match,dists] = knnsearch(target,source_transformed,'K',2); %
    
    dists_index = dists < max_dists;
    dists_index = (dists_index(:,1) & dists_index(:,2));
        
    
    weights = dists_index;
    
    source_idx = true(1, n_source);
    target_idx = match;
    
    source_corr = source_transformed(source_idx,:);
    target_corr = target(target_idx(:,1),:);
    target_corr2 = target(target_idx(:,2),:);
    
%     % DEBUG PLOT
    figure(2)
    hold off
    plotcloud(source_corr)
    hold on
    plotcloud(target_corr)
    for i = 1:length(source_corr)
        x0 = source_corr(i,1);
        y0 = source_corr(i,2);
        x1 = target_corr(i,1);
        y1 = target_corr(i,2);
       
       plot([x0 x1],[y0 y1],'r-')
    end
%     % DEBUG PLOT END
    
    
    
    [R,T] = my_scanmatch(source_corr',target_corr',weights,1);
%     [R,T] = my_scanmatch2(source_corr',target_corr',target_corr2',weights,1);
% % 
%         [R,T] = eq_point(source_corr',target_corr',weights(source_idx)');
%         R = R';
%         T = -T;
    
    R_ = R*R_; %totals
    T_ = R*T_ + T; %totals
    source_transformed = (R * source_transformed' + T)';
    
    rmse = source_transformed - target_corr;
    rmse = rmse*rmse';
    rmse = trace(rmse);
    Error(k) = rmse;
    
    
    
    
    plot(source_transformed(:,1),source_transformed(:,2),'g.')
    drawnow
%     pause(0.1)
end
toc

% figure
% plot(Error)
% grid on
disp('Final RMSE')
disp(rmse)

figure
source_transformed_final = (R_ * source' + T_)';
plot(source_transformed_final(:,1),source_transformed_final(:,2),'g.')
hold on
plot(target(:,1),target(:,2),'r.') % Final
grid on

function [R,T] = eq_point(q,p,weights)

m = size(p,2);
n = size(q,2);

% normalize weights
weights = weights ./ sum(weights);

% find data centroid and deviations from centroid
q_bar = q * transpose(weights);
q_mark = q - repmat(q_bar, 1, n);
% Apply weights
q_mark = q_mark .* repmat(weights, 2, 1); %Modificado (weights, 3, 1) -> (weights, 2, 1)

% find data centroid and deviations from centroid
p_bar = p * transpose(weights);
p_mark = p - repmat(p_bar, 1, m);
% Apply weights
%p_mark = p_mark .* repmat(weights, 3, 1);

N = p_mark*transpose(q_mark); % taking points of q in matched order

[U,~,V] = svd(N); % singular value decomposition

R = V*diag([1 det(U*V')])*transpose(U);

T = q_bar - R*p_bar;
end


function match = brutesearch(p0,p1)
n0 = length(p0);
n1 = length(p1);
match = zeros(n1,1);
for i=1:n1 %sweep p1
    mindist = 100000;
    mindex = 1;
    for j=1:n0 %sweep p0
        dist = norm(p0(:,j) - p1(:,i));
        if dist < mindist
            mindist = dist;
            mindex = j;
        end
    end
    match(i) = mindex;
end


end