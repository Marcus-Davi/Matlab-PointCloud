% xy
% z
function  plotcloud(xy,color,size)
%k
if(nargin == 1)
plot(xy(:,1),xy(:,2),'.','markersize',5) %Alinhada
elseif(nargin == 2)
plot(xy(:,1),xy(:,2),'.','markersize',5,'color',color) %Alinhada
else
plot(xy(:,1),xy(:,2),'.','markersize',size,'color',color) %Alinhada
end

grid on
xlabel('X [m]')
ylabel('Y [m]')
% n = length(xy);
% n_str = num2str(n);
% title(strcat('N = ',n_str));
end

%x