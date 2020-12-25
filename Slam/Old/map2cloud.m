function cloud = map2cloud(map)
size = map.size*map.size;
width = map.size;
height = map.size;

p0x = map.startx*map.size*map.resolution;
p0y = map.starty*map.size*map.resolution;
cloud = [];
for i=1:size
    if(map.grid(i))
        
        %row major
%         col = mod(i,height);
%         row= fix(i/width);


        %column major (MATLAB)
        col = fix(i/width);
        row = mod(i,height);
        
        
        
        x = col*map.resolution;
        y = row*map.resolution;        
        x = x - p0x;
        y = y - p0y;
        cloud = [cloud;x y];
        
    end
    
end