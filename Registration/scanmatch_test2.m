clear;close all;clc
%% Load Points

load('lms_dataset.mat')


N_SCANS = length(SCANS);

% global transforms
R_ = eye(2);
T_ = [0 0]';

REF = SCANS{1}


for it = 2 : N_SCANS
    
    it
    % Hereafter, call point clouds as 'source' and 'target'
    %% Filtering
    target = SCANS{it-1};
    source = SCANS{it};
    
    % filter zeros
    
    source = source(source(:,1) ~= 0,:);
    target = target(target(:,1) ~= 0,:);
    
    % remove z
    source = source(:,1:2);
    target = target(:,1:2);
    
    N_part = 4;
    source_partitions = pc_partition(source,N_part);
    
    source_features = [];
    
    %% Feature extraction
    for i=1:N_part
        
%         [source_edges,source_planes] = extractFeatures(source_partitions{i},10,2,4);
        
        %     title('Features')
        
        % return
        
%         source_features = [source_features;source_edges;source_planes];
        %     target_features = [target_edges;target_planes];
        %     hold off
    end
    
    
    %% Plots
%     figure
%     plot(source(:,1),source(:,2),'b.') % Original
%     
%     hold on
%     plot(source_features(:,1),source_features(:,2),'r.','markersize',40);
%     plot(target(:,1),target(:,2),'r.') % Final
%     grid on
%     drawnow
    %% myICP
    match_iterations = 1;
    
    % Closest point (ñ mt eficiente?)
    %% KD TREE for closest. P0 -> Source Cloud / MAP ; P1 -> Target cloud / Last SCAN
    % P1_transformed = target;
    
    source_transformed = source;
    target_chosen = target;
    
    n_source = length(source_transformed);
    n_target = length(target_chosen);
    
    
    
    tic
    
    max_dists = 0.6;
    % figure
    Error = zeros(1,match_iterations);
    rmse = 0;
    n_fig = length(findobj('type','figure'))
    for k=1:match_iterations
        k
        
        % procura correspondencias em 'target' para cada ponto da 'source'
        [match,dists] = knnsearch(target_chosen,source_transformed,'K',2); %
        
        dists_index = dists < max_dists;
        %     dists_index = (dists_index(:,1) & dists_index(:,2));
        dists_index = (dists_index(:,1));
        
        if(sum(dists_index(:,1)) == 0)
            break
        end
        
        
        weights = dists_index;
        
        %         source_idx = true(1, n_source);
        %         target_idx = match;
        
        %     source_idx = true(1,dists_index)
        target_idx = match(dists_index,:);
        
        %     source_corr = source_transformed(source_idx,:);
        source_corr = source_transformed(dists_index,:);
        target_corr = target_chosen(target_idx(:,1),:);
        target_corr2 = target_chosen(target_idx(:,2),:);
        
        
        [R,T] = my_scanmatch2(source_corr',target_corr',target_corr2',weights,1);
        % %
        %         [R,T] = eq_point(source_corr',target_corr',weights(source_idx)');
        %         R = R';
        %         T = -T;
        
        R_ = R*R_; %totals
        T_ = R*T_ + T; %totals
        source_transformed = (R * source_transformed' + T)';
        
        %     rmse = source_corr - target_corr;
        %     rmse = rmse*rmse';
        %     rmse = trace(rmse);
        %     Error(k) = rmse;
        %
        
        
        
        %     plot(source_transformed(:,1),source_transformed(:,2),'g.')
        %     drawnow
        %     pause(0.5)
    end
    
    T_
    R_
    plot(REF(:,1),REF(:,2),'.')
    hold on
    plot(T_(1),T_(2),'*')
    drawnow
    hold off
    
    
end
