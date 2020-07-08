% Alinha nuvem de pontos com a horizontal
% Algoritmo não é perfeito. buracos atrapalham um pouco

function [xy_rotated,angle] = h_align(xy)
xc = (max(xy(:,1)) + min(xy(:,1)) )/2;
yc = (max(xy(:,2)) + min(xy(:,2)) )/2;

% Define a reta y = xc + 0
n = length(xy);

% e > 0 -> giro horário
rate = 0.005;
angle = 0;
tolerance = 0.0001;
e = 100;
while abs(e) > tolerance
R = [cos(angle) -sin(angle);sin(angle) cos(angle)]; %CW
xy_rotated = (R*(xy' - [xc;yc]) + [xc;yc])'; %em torno do centro da pilha
xleft = (xy(:,1)<xc);
xright = (xy(:,1)>xc);
eleft = (yc - xy_rotated(xleft,2));
eright = (xy_rotated(xright,2) - yc);

e = (sum(eleft) + sum(eright))/n;
angle = angle - rate*e;

% DEBUG Comente aqui para desativar animação
% plotcloud(xy);
% hold on
% plotcloud(xy_rotated);
% hold off
% grid on
% drawnow

end



% plot(x,y)
% hold on
% plot(xy(:,1),xy(:,2),'.')



end