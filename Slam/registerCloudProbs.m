function map = registerCloudProbs(map,cloud_xy,pose)

map.currMarkFreeIndex = map.currUpdateIndex+1;
map.currMarkOccIndex = map.currUpdateIndex+2;

n = length(cloud_xy);
% cloud_tfed = (tf.R*cloud_xy' + tf.T)'; %transforma nuvem para coordenada grid
% cloud_xy(:,2) = -cloud_xy(:,2)
cloud_tfed = cloud_xy + [map.tfx map.tfy]; %transforma nuvem para coordenada grid
ix0 = fix((pose(1) + map.tfx)* map.scale) ;
iy0 = fix((pose(2) + map.tfy)* map.scale) ;
for i=1:n
%     if(i==65)
%        i 
%     end
    % iy,ix -> ix (mapa ) ~ y (continuo) / iy (mapa) ~ x (continuo). PODE
    % MELHORAR ?
    ix = round( (cloud_tfed(i,1))*map.scale);
%     iy = fix( cloud_tfed(i,2)/map.resolution );
    iy = round( (cloud_tfed(i,2))*map.scale);
    if(ix > map.size-1 || iy > map.size-1  || ix <= 0 || iy <= 0)
        
    else 
        
        %usar modelo de probabilidade

    map = breseham(map,ix0,iy0,ix,iy);  %free 
%     updated_map.grid(ix,iy) = 100; %chamar occ model
    if(map.grid_index(ix,iy) < map.currMarkOccIndex)
        
        if(map.grid_index(ix,iy) == map.currMarkFreeIndex)
          map.grid(ix,iy) = updateUnsetFree(map.grid(ix,iy),map); %unset free
        end
        
        
        map.grid(ix,iy) = updateSetOcc(map.grid(ix,iy),map); %chamar free model
        map.grid_index(ix,iy) = map.currMarkOccIndex;

    end
    end
end


map.currUpdateIndex = map.currUpdateIndex+3;

end

function map = breseham(map, x0,y0, x1,y1)
    if abs(y1 - y0) < abs(x1 - x0)
        if x0 > x1
           map  = plotLineLow(map,x1, y1, x0, y0);
        else
            map = plotLineLow(map,x0, y0, x1, y1);
        end
    else
        if y0 > y1
           map =  plotLineHigh(map,x1, y1, x0, y0);
        else
           map =  plotLineHigh(map,x0, y0, x1, y1);
        end
    end
end


function map = plotLineLow(map,x0,y0, x1,y1)
    dx = x1 - x0;
    dy = y1 - y0;
    yi = 1;
    if dy < 0
        yi = -1;
        dy = -dy;
    end
    D = 2*dy - dx;
    y = y0;

    for x=x0:1:x1
%         plot(x, y)
        if(map.grid_index(x,y) < map.currUpdateIndex)
        map.grid(x,y) = updateSetFree(map.grid(x,y),map); %chamar free model
        map.grid_index(x,y) = map.currMarkFreeIndex;
        end
        if D > 0
               y = y + yi;
               D = D - 2*dx;
        end
        D = D + 2*dy;
    end
end


function map = plotLineHigh(map,x0,y0, x1,y1)
    dx = x1 - x0;
    dy = y1 - y0;
    xi = 1;
    if dx < 0
        xi = -1;
        dx = -dx;
    end
    D = 2*dx - dy;
    x = x0;

    for y=y0:1:y1
%         plot(x, y,'.')
        if(map.grid_index(x,y) < map.currUpdateIndex)
        map.grid(x,y) = updateSetFree(map.grid(x,y),map); %chamar free model
        map.grid_index(x,y) = map.currMarkFreeIndex;
        end
        if D > 0
               x = x + xi;
               D = D - 2*dy;
        end
        D = D + 2*dx;
    end
end

% 0 < logOdd < 100
function LogOdd = updateSetOcc(LogOdd_in,map)
    
    if(LogOdd_in < 50)
    LogOdd = LogOdd_in + map.logOddOcc;
    else
    LogOdd = LogOdd_in;
    end
end

function LogOdd = updateSetFree(LogOdd_in,map)
    
    LogOdd = LogOdd_in + map.logOddFree;
    
end

function LogOdd = updateUnsetFree(LogOdd_in,map)
    
    LogOdd = LogOdd_in - map.logOddFree;
end




        

% function update = inv_sensor_model()
% 
% 
% end