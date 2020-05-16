function filtered  = filtercloud(cloud)
n = length(cloud);
filtered = [];
min = 0.3;
max = 10;
for i=1:n
   xy = cloud(i,:);
   range = sqrt(xy*xy');
   if  range > min  && range < max
       filtered = [filtered; cloud(i,:)];
   end
   
end


end