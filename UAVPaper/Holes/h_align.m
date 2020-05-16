% Alinha nuvem de pontos com a horizontal
function [xy_rotated,angle] = h_align(xy)
xc = (max(xy(:,1)) + min(xy(:,1)) )/2;
yc = (max(xy(:,2)) + min(xy(:,2)) )/2;

% Define a reta y = xc + 0
n = length(xy);

% e > 0 -> giro horário
rate = 0.001;
angle = 0;
for it=1:100
R = [cos(angle) -sin(angle);sin(angle) cos(angle)]; %CW
xy_rotated = (R*(xy' - [xc;yc]) + [xc;yc])'; %em torno do centro da pilha
xleft = (xy(:,1)<xc);
xright = (xy(:,1)>xc);
eleft = (yc - xy_rotated(xleft,2));
eright = (xy_rotated(xright,2) - yc);

e = (sum(eleft) + sum(eright))/n;
angle = angle - rate*e;

% DEBUG
% plot(xy(:,1),xy(:,2),'.r')
% hold on
% plot(xy_rotated(:,1),xy_rotated(:,2),'.b')
% hold off
% drawnow

end



% plot(x,y)
% hold on
% plot(xy(:,1),xy(:,2),'.')



end