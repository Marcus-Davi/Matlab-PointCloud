% Point Cloud to Grid
clear; close all;clc
tic
filename = 'Pontos/exp11.asc'; % Seleciona Nuvem, entre [1-11] (Ja segmentada)
xyz = load(filename); 
xy = xyz(:,1:2); %Seleciona apenas 2D

%% Rotação da nuvem para alinhar 

% Calcula centro de rotação
x_c = (max(xy(:,1)) + min(xy(:,1)) )/2; 
y_c = (max(xy(:,2)) + min(xy(:,2)) )/2;

%% Decomente este bloco para uso de ângulo fixo
% tic
% [xy_rot,angle] = h_align(xy); %Alinha com horizontal
% toc
% %  return
% 
% % Gera figura de antes/depois
%  plotcloud(xy)
%  hold on
%  plotcloud(xy_rot)
%  legend('Before Alignment','After Alignment');
%  title('Alignment Experiment')
% set(1,'Position',[500 500 803 610])
% ylim([-150 0])
% box on
% angle
%  return


%% Usa o ângulo fixo
angle = -0.1933; % Fixa o ângulo. -0.1933 é o melhor pelo visto. a média é 0.1977
R = [cos(angle) -sin(angle);sin(angle) cos(angle)]; %Clockwise
xy_rotated = (R*(xy' - [x_c;y_c]) + [x_c;y_c])'; % rotaciona em torno do centro da pilah

%% Descomente este bloco para visualizar alinhamento
% scatter(xy_rotated(:,1),xy_rotated(:,2),0.5,'blue') %Alinhada
% hold on
% scatter(xy(:,1),xy(:,2),0.5,'red') %Original
% return


%% Contribuição BISMARK

xyz_alinhado = [xy_rotated,xyz(:,3)];
roi = [-500 -100 -100 -50 -200 200]; %Find the indices of the points that lie within the cuboid ROI.
xyzf = findPointsInRoi(xyz_alinhado,roi);

xy_rotated = xyzf(:,1:2); %Filtrado pelo ROI (Region of Interest)


% Translada grid para posi��o convers�vel para matrix
x_min = min(xy_rotated(:,1));
y_min = min(xy_rotated(:,2));
map.tfx = fix(x_min); %fix arredonda pra baixo. garantimos que assim que todos os indicies inteiros serão positivos
map.tfy = fix(y_min);
xy_real = xy_rotated - [map.tfx-2 map.tfy-2]; %-2 ?

% Descomente para visualiza nuvem transladada para inteiros positivos.
% plotcloud(xy_real)
% hold on
% plotcloud(xy_rotated)


 %Essa res não pode ser menor que a resolução do lidar. Recomendado = 0.5
RES = [0.5];
total_res = length(RES);
for j=1:total_res
res = RES(j) % metros
adjust = 1/res - 1;
xy_ = xy_real / res - [adjust adjust];

%nuvem de pontos inteiros
xy_int = round(xy_); % 'fix' ou 'round'
x_max_i = max(xy_int(:,1));
y_max_i = max(xy_int(:,2));

M = zeros(x_max_i,y_max_i);

n = length(xy_int);
for i=1:n
   M(xy_int(i,1),xy_int(i,2)) = 1 ;    
end

% Descomente para Visualizar o Gridification
plotgrid2(M);
plotmatrix(M);

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



