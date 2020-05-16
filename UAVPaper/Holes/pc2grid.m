clear; close all;clc
tic
% xyz = load('pilha_densa.txt');
filename = 'Pontos/exp11.asc'; %AQUI VC SELECIONA A NUVEM J� SEGMENTADA
xyz = load(filename); 
% xyz = xyz(:,1:3);
xy = xyz(:,1:2);
%return
%% Rotação da nuvem para alinhar 

x_c = (max(xy(:,1)) + min(xy(:,1)) )/2;
y_c = (max(xy(:,2)) + min(xy(:,2)) )/2;

% % FUNCAO UTILITÁRIA
%  [xy_rot,angle] = h_align(xy); %Alinha com horizontal
%  plotcloud(xy_rot,'blue')
%  hold on
%  plotcloud(xy,'red')
%  angle
%  return

% angle
 angle = -0.1929;% 0.188 ALINHADO
R = [cos(angle) -sin(angle);sin(angle) cos(angle)]; %CW
xy_rotated = (R*(xy' - [x_c;y_c]) + [x_c;y_c])'; %em torno do centro da pilha

% PLOTS DE TESTE
% scatter(xy_rotated(:,1),xy_rotated(:,2),0.5,'blue') %Alinhada
% hold on
% scatter(xy(:,1),xy(:,2),0.5,'red') %Original

% return
%% BISMARK

xyz_alinhado = [xy_rotated,xyz(:,3)];
roi = [-500 -100 -100 -50 -200 200]; %Find the indices of the points that lie within the cuboid ROI.
xyzf = findPointsInRoi(xyz_alinhado,roi);

xy_rotated = xyzf(:,1:2); %Filtrado
% return
% XY 2 GRID
% Translada grid para posi��o convers�vel para matrix
x_min = min(xy_rotated(:,1));
y_min = min(xy_rotated(:,2));
map.tfx = fix(x_min);
map.tfy = fix(y_min);


xy_real = xy_rotated - [map.tfx-2 map.tfy-2]; %-2 ?
% plot(xy_(:,1),xy_(:,2),'.')


 %Essa res não pode ser menor que a resolução do lidar.
RES = [0.5];
total_res = length(RES);
for j=1:total_res
res = RES(j) %m
adjust = 1/res - 1;
xy_ = xy_real / res - [adjust adjust];

xy_int = round(xy_); % 'fix' ou 'round'
x_max_i = max(xy_int(:,1));
y_max_i = max(xy_int(:,2));

M = zeros(x_max_i,y_max_i);

n = length(xy_int);
for i=1:n
   M(xy_int(i,1),xy_int(i,2)) = 1 ;    
end

% VISUALIZAR
% plotgrid2(M);
% plotmatrix(M);

[row,col] = size(M);

total_cells = row*col;
total_filled = sum(M(:));
pct(j) = total_filled/total_cells;

end
pct
return
figure
plot(RES,1-pct,'linewidth',2);
grid on
xlabel('Res [m]');
ylabel('Holes %');
legend(filename)
fig_name = strcat(filename,'.fig');
savefig(fig_name)

toc
% x-> column
% y -> row



