function updated_map = registerCloud(map,cloud_xy)
updated_map = map;
n = length(cloud_xy);
% cloud_tfed = (tf.R*cloud_xy' + tf.T)'; %transforma nuvem para coordenada grid
% cloud_xy(:,2) = -cloud_xy(:,2)
cloud_tfed = cloud_xy + [map.tfx map.tfy]; %transforma nuvem para coordenada grid


for i=1:n
    
    % iy,ix -> ix (mapa ) ~ y (continuo) / iy (mapa) ~ x (continuo). PODE
    % MELHORAR ?
    ix = fix( cloud_tfed(i,1)/map.resolution );
%     iy = fix( cloud_tfed(i,2)/map.resolution );
    iy = fix( cloud_tfed(i,2)/map.resolution );
    if(ix > map.size-1 || iy > map.size-1  || ix < 0 || iy < 0)
    else 
    updated_map.grid(ix,iy) = 100; 
    end
end

end