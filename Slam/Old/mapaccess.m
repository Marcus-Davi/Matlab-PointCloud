function occupancyValue = mapaccess(map,xy)
    x = xy(1) + map.tfx;
    y = xy(2) + map.tfx;

% iy,ix -> ix (mapa ) ~ y (continuo) / iy (mapa) ~ x (continuo)
    ix = fix( x*map.scale);
    iy = fix( y*map.scale);
     if(ix > map.size-1 || iy > map.size-1  || ix <= 0 || iy <= 0)
        occupancyValue = 0;
        return;
     end
    
%     p00 = map.grid(ix,iy);
%     p01 = map.grid(ix+1,iy);
%     p10 = map.grid(ix+1,iy+1);
%     p11 = map.grid(ix,iy+1);

    %Ver anotações tablet "Hecto scan match"
    p00 = getProb(map.grid(ix,iy)); %
    p10 = getProb(map.grid(ix+1,iy));
    p11 = getProb(map.grid(ix+1,iy+1));
    p01 = getProb(map.grid(ix,iy+1));
    
    %dá pra simplificar o uso de "map.resolution
    
    dx_x0 = x - map.resolution*ix; %xfac
    dy_y0 = y - map.resolution*iy;
    
    dx1_x =map.resolution*(ix+1) - x; %xfacInv
    dy1_y = map.resolution*(iy+1) - y;
    
    %diferente do artigo devido ao incremento em y
    occupancyValue = (dy1_y*map.scale2) * ( (dx1_x*p00) + (dx_x0*p10) ) + ...
                     (dy_y0*map.scale2) * ( (dx1_x*p01) + (dx_x0*p11) );
              
          
%    figure
%    plot(x,y,'*')
%    hold on;
%    plot(map.resolution*ix,map.resolution*iy,'bo')
%    plot(map.resolution*(ix+1),map.resolution*iy,'bo')
%    plot(map.resolution*ix,map.resolution*(iy+1),'bo')
%    plot(map.resolution*(ix+1),map.resolution*(iy+1),'bo')
%    close all
  
    


end


function prob = getProb(logOdd)
odd = exp(logOdd);
prob = odd/(odd+1);
end
