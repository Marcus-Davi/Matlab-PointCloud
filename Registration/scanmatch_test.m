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

%% Filtros


P0 = [nonzeros(X0)'; nonzeros(Y0)'];
P1 = [nonzeros(X1)'; nonzeros(Y1)'];

n = length(P0);
n1 = length(P1);

%% a Few plots
%% Plots
plot(P0(1,:),P0(2,:),'b.') % Original
hold on
plot(P1(1,:),P1(2,:),'r.') % Final
drawnow
%% myICP
match_iterations = 30;
% Closest point (ñ mt eficiente?)

%% KD TREE for closest. P0 -> Fixed Cloud / MAP ; P1 -> Moving cloud / Last SCAN
P1_transformed = P1;
KD = KDTreeSearcher(P0','BucketSize',10);
r = 1; %distance
R_ = eye(2);
T_ = [0 0]';
tic
for k=1:match_iterations
          k
        % Find correlations procura KD(P0) por pontos proximos de CADA ponto em P1
        [match ~] = knnsearch(KD,P1_transformed');
%           match = brutesearch(P0,P1_transformed);
        
        
        weights = ones(1,length(match));
        

        p1_idx = true(1, n1);
        p0_idx = match;
        
        P0_corr = P0(:,p0_idx);
        P1_corr = P1_transformed(:,p1_idx);
        
        err_ = (P0_corr - P1_corr)';
        err = sum(err_);
        norm(err)
%         norm(err_)
    
    [R,T] = my_scanmatch(P0_corr,P1_corr,weights,1);
%     [R,T] = eq_point(P0_corr,P1_corr,weights(p1_idx));

    R_ = R*R_; %totals
    T_ = R*T_ + T; %totals
    P1_transformed = R * P1_transformed + T;
    
    
    plot(P1_transformed(1,:),P1_transformed(2,:),'g.')
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