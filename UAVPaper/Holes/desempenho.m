%% IMPORTANTE
% Como levar tudo em conta ? 
% Velocidade, Duração, Desempenho, Frequencias, Altura, Delta_Bateria
% Trials/Ciclo

%%
clear;close all;clc
ID = 0.01*[89.07 93.84 93.05 94.39 88.71 92.53 89.60 93.61 92.21 86.63 84.62]';
Vels = [8 8 4 4 8 8 4 4 6 10 10]';
H = [30 25 30 25 30 25 30 25 27.5 30 30]';
Freqs = [12.5 12.5 12.5 12.5 50 50 50 50 25 12.5 50]';

Vels_i = 1./Vels;
H_i = 1./H;
Freqs_i = 1./Freqs;

Corr = [ID Vels Vels_i H H_i Freqs];
cov(Corr)
corrcoef(Corr)
return

n = length(ID);
Y = ID;
% X = Durs';
X_i =  [ones(n,1) Vels_i H_i Freqs_i];
X_normal = [ones(n,1) Vels Vels_i H H_i Freqs];

X = X_normal;

Beta = inv((X'*X))*X'*Y; %Mínimos Quadrados

disp('Erro médio quadrático')
Err = Y - X*Beta
Errsqr = Err'*Err
Beta

plot(Y)
hold on
plot(X*Beta)
grid on
legend('Output','Model Estimation')
return
%% Try 100
Qb = 1;
nx = size(X,2);
Qx = eye(nx);
% Qx = zeros(size(X,2));
Qx(1,1) = 0;
% J = (1-X*Beta)'*Qb*(1-X*Beta) + X'*Qx*X

% X_otm = inv(Beta*Beta' + Qx)*Beta

% J_otm = (1-X_otm'*Beta)'*Qb*(1-X_otm'*Beta) + X_otm'*Qx*X_otm

% ID = X_otm'*Beta

%          min 0.5*x'*H*x + f'*x   subject to:  A*x <= b 
%               x  

H = Beta*Beta'+Qx;
f = Beta;
Acon = [eye(nx);-eye(nx)];
Xmax = [1.1 300 100 100 300]; %limite máximo variavies
Xmin = [0.9 0 0 0 0]; % // mínimo
Bcon = [Xmax;-Xmin];

X_otm = -quadprog(H,f,Acon,Bcon) %N funciona

ID = X_otm'*Beta
J_otm = (1-X_otm'*Beta)'*Qb*(1-X_otm'*Beta) + X_otm'*Qx*X_otm

return %Ignora
%% Cost
% X = [delta_t h f vels]
Ref = 100;
alfa = Ref - Beta(1);
Beta_ = Beta(2:end);
n_beta = length(Beta_)
Qb = eye(n_beta);
%          min 0.5*x'*H*x + f'*x   subject to:  A*x <= b 
%               x  

H = Beta_*Beta_'+Qb
f = Beta_*alfa;
Acon = [eye(n_beta);-eye(n_beta)];
Xmax = [300 100 100 10]; %limite máximo variavies
Xmin = [-100 -100 -100 -100]; % // mínimo
Bcon = [Xmax;-Xmin];
X_otm = quadprog(H,f,Acon,Bcon) %N funciona

% Performance = Beta(1) + Beta_'*X(1,2:end)'
Performance = Beta(1) + Beta_'*X_otm

% Qb = eye(length(Beta_))
% Qb(2,2) = 0;
% % Qb(3,3) = 1
% X_otm = inv(Beta_*Beta_'+Qb)*Beta_*alfa
% % X_otm = X(1,2:end)'
% J = (alfa - Beta_'*X_otm) + X_otm'*Qb*X_otm

return %Ignora
% ???
% MaxID = 100;
% alfa = [MaxID*ones(n,1) - Beta(1)*ones(n,1) - Beta(2)*Durs - Beta(3)*H - Beta(4)*Freqs - Beta(5)*Vels]
% Qd = eye(n);
% Qt = eye(n);
% 
% Durs_ = inv(Beta(2)*Qd+Qt)*(Beta(2)*Qd*alfa)
% ??? END


