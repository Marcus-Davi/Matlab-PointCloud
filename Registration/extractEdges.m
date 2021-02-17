%input cloud, neighboors
function extracted = extractEdges(input_cloud,window_size)
N = length(input_cloud);

window_cloud = zeros(window_size+1,2);


extracted = [];
for i = window_size:N-window_size
    
    input_cloud(i,:);
    window_cloud(1,:) = input_cloud(i,:);
    count = 2;
    for j=1:(floor(window_size/2))
     window_cloud(count,:) = input_cloud(i+j,:);
     count = count + 1;
     window_cloud(count,:) = input_cloud(i-j,:);
     count = count + 1;
    end
    
    centroid = mean(window_cloud);
    res = 9999;
    
    for j=2:length(window_cloud)
        pts = [window_cloud(1,:);window_cloud(j,:)];
        d = pdist(pts);
        if(d < res)
            res = d;
        end

    end
    
    isEdge = norm ( centroid - window_cloud(1,:));
    lambda = 6;
    
    if( isEdge > lambda * res)
        extracted = [extracted;input_cloud(i,:)];
%         i = i+window_size;
    end
    
    
    

end




end


