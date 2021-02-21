% xy
% z
function  plotcloud(xy,color)
%k
[~,cols] = size(xy);

if(cols == 2)
% fig = figure
if(nargin == 1)
plot(xy(:,1),xy(:,2),'.','markersize',5) %Alinhada
else
plot(xy(:,1),xy(:,2),'.','markersize',5,'color',color) %Alinhada
end
else %3 cols
% fig = figure;
pcshow(xy);
end

    

grid on
xlabel('X [m]')
ylabel('Y [m]')
% n = length(xy);
% n_str = num2str(n);
% title(strcat('N = ',n_str));
end

%x