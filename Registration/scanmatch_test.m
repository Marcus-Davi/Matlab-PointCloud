clear;close all;clc
%% Load Points

load('lms_dataset.mat')

% return

%% Filtros


source = SCANS{1};
target = SCANS{100};


% filter zeros

source = source(source(:,1) ~= 0,:);
target = target(target(:,1) ~= 0,:);

source = source(:,1:2);
target = target(:,1:2);

n_source = length(source);
n_target = length(target);


%% Plots
plot(source(:,1),source(:,2),'b.') % Original
hold on
plot(target(:,1),target(:,2),'r.') % Final
drawnow
%% myICP
match_iterations = 30;

% Closest point (ñ mt eficiente?)
%% KD TREE for closest. P0 -> Source Cloud / MAP ; P1 -> Target cloud / Last SCAN
% P1_transformed = target;

source_transformed = source;
% KD = KDTreeSearcher(source','BucketSize',10);
r = 1; %distance
R_ = eye(2);
T_ = [0 0]';
tic
for k=1:match_iterations
    k
      
    % procura correspondencias em 'target' para cada ponto da 'source'
%     [match,~] = knnsearch(target,source_transformed,'K',1); %
    [match,~] = knnsearch(target,source_transformed,'K',2); %
    
    
    
    %           match = brutesearch(P0,P1_transformed);
    
    
    weights = ones(1,length(match));
    
    
    
    source_idx = true(1, n_source);
    target_idx = match;
    
    source_corr = source_transformed(source_idx,:);
    target_corr = target(target_idx,:);
    
%             err_ = (source_corr - target_corr)';
%             err = sum(err_);
%             norm(err)
%             norm(err_)
    
    [R,T] = my_scanmatch(source_corr',target_corr',weights,1);

%         [R,T] = eq_point(source_corr',target_corr',weights(source_idx));
%         R = R';
%         T = -T;
    
    R_ = R*R_; %totals
    T_ = R*T_ + T; %totals
    source_transformed = (R * source_transformed' + T)';
    
    
    plot(source_transformed(:,1),source_transformed(:,2),'g.')
    drawnow
end
toc

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