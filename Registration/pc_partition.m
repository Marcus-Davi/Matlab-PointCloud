function [partitions] = pc_partition(pointcloud,N)
%PARTITION Summary of this function goes here
%   Detailed explanation goes here
partitions = cell(N,1);

n_pts = length(pointcloud);
blk_size = floor(n_pts / N);
remainder = rem(n_pts,N);


for i=1:N
%     i
    for j=1:blk_size
       partitions{i}(j,:) = pointcloud((i-1)*blk_size + j,:);
    end
    
end

for i=1:remainder
   partitions{end} =  [partitions{end};pointcloud(N*blk_size+i,:)];
end






end

