%input cloud, neighboors
function [edges,planes] = extractFeatures(input_cloud,window_size,n_edge,n_plane)

N = length(input_cloud);

window_cloud = zeros(window_size+1,2);


edges = [];
planes = [];
smoothness_list = [];
unreliable = zeros(N,1);

unreliable_pt = [];
% filtrar oclusoes
for i = window_size:N-window_size
    
    
    
    prev_pt = input_cloud(i-1,:);
    pt = input_cloud(i,:);
    next_pt = input_cloud(i+1,:);
    
%     plot(input_cloud(:,1),input_cloud(:,2),'.');
%     
%     hold on
%     plot(prev_pt(1),prev_pt(2),'black.','markersize',20)
%     plot(pt(1),pt(2),'black.','markersize',20)
%     plot(next_pt(1),next_pt(2),'black.','markersize',20)
    
%     if( i == 500)
%         i
%     end
    
    
    diffNext = dot(next_pt-pt,next_pt-pt); % sqr dist
    
    if(diffNext > 0.1)
        d1 = norm(pt);
        d2 = norm(next_pt);
        
        if (d1 > d2)
            w_pt = pt * d2/d1;
            w_dist = norm(next_pt - w_pt) / d2;
            
            if ( w_dist < 0.1)
                unreliable(i-window_size:i) = 1;
            end
            
        else % d1 < d2
            w_pt = next_pt * d1/d2;
            w_dist = norm(pt - w_pt) / d1;
            if( w_dist < 0.1)
                unreliable(i+1:i+1+window_size) = 1;
            end
            
        end
        
    end
    
    diffPrev = dot(pt-prev_pt,pt-prev_pt); % sqr dist
    dis = dot(pt,pt);
    
    if (diffNext > 0.0003 * dis && diffPrev > 0.0003 * dis)
        unreliable(i) = 1;
    end
%     
%     for i = 1:N
%         if (unreliable(i) == 1)
%             plot( input_cloud(i,1), input_cloud(i,2),'red.','markersize',20)
%         end
%     end
    
%     hold off
    
end

% plot unreliables
% figure(10)
% plot(input_cloud(:,1),input_cloud(:,2),'.')
% hold on
% for i = 1:N
%     if (unreliable(i) == 1)
%         plot( input_cloud(i,1), input_cloud(i,2),'black.','markersize',20)
%     end
% end

% input("go on")

% compute curvature
for i = window_size:N-window_size
    
    window_cloud(1,:) = input_cloud(i,:);
    count = 2;
    for j=1:(floor(window_size/2))
        window_cloud(count,:) = input_cloud(i+j,:);
        count = count + 1;
        window_cloud(count,:) = input_cloud(i-j,:);
        count = count + 1;
    end
    
    
    
    
    %     plot(input_cloud(:,1),input_cloud(:,2),'.');
    %     hold on
    %     plot(window_cloud(:,1),window_cloud(:,2),'.','markersize',10);
    %     hold off
    sum_ = 0;
    for k = 2:length(window_cloud)
        sum_ = sum_ + (window_cloud(1,:) - window_cloud(k,:));
    end
    
    %
    smoothness = norm(sum_) / (length(window_cloud) * norm(window_cloud(1,:)));
    
    smoothness_list = [smoothness_list; smoothness i];
    
    
    
end


sorted = sortrows(smoothness_list,1);

n_picked_edges = 0;

j = length(sorted);

while (n_picked_edges < n_edge && j > 0)
    
    idx = sorted(j,2);
    if (unreliable(idx) == 0)
        n_picked_edges = n_picked_edges+1;
        
        
        edges = [edges;input_cloud(idx,:)];      %push_back
        
        unreliable(idx) = 1;
        % remove neighborhood
        for k=1:window_size
            p1 = input_cloud(idx+k,:);
            p2 = input_cloud(idx+k-1,:);
            d1 = dot(p2-p1,p2-p1); %sqr dis
            if(d1 > 0.05)
                break
            end
            
            unreliable(idx+k) = 1;
        end
        
        for k=1:window_size
            p1 = input_cloud(idx-k,:);
            p2 = input_cloud(idx-k+1,:);
            d1 = dot(p2-p1,p2-p1); %sqr dis
            if(d1 > 0.05)
                break
            end
            unreliable(idx-k) = 1;
        end
        
        
    end
    j = j-1;
end

n_picked_planes = 0;
j = 1;

while (n_picked_planes < n_plane && j < length(unreliable))
    
    idx = sorted(j,2);
    if(idx > length(unreliable))
        return
    end
    if (unreliable(idx) == 0)
        n_picked_planes = n_picked_planes+1;
        
        
        planes = [planes;input_cloud(idx,:)];      %push_back
        
        unreliable(idx) = 1;
        % remove neighborhood
        for k=1:window_size
            p1 = input_cloud(idx+k,:);
            p2 = input_cloud(idx+k-1,:);
            d1 = dot(p2-p1,p2-p1); %sqr dis
            if(d1 > 0.05)
                break
            end
            
            unreliable(idx+k) = 1;
        end
        
        for k=1:window_size
            p1 = input_cloud(idx-k,:);
            p2 = input_cloud(idx-k+1,:);
            d1 = dot(p2-p1,p2-p1); %sqr dis
            if(d1 > 0.05)
                break
            end
            unreliable(idx-k) = 1;
        end
        
        
    end
    j = j+1;
end







%     edges_indices = flip(sorted(end-n_edge:end,2));
%     planes_indices = sorted(1:n_plane,2);
%
%     edges = input_cloud(edges_indices,:);
%     planes = input_cloud(planes_indices,:);




end


