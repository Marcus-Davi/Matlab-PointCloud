clear;close all;clc

%angulos
angulo{1} = load('Logfiles/angles1.txt');
angulo{2} = load('Logfiles/angles2.txt');
angulo{3} = load('Logfiles/angles3.txt');
angulo{4} = load('Logfiles/angles4.txt');
angulo{5} = load('Logfiles/angles5.txt');
angulo{6} = load('Logfiles/angles6.txt');
angulo{7} = load('Logfiles/angles7.txt');
angulo{8} = load('Logfiles/angles8.txt');
angulo{9} = load('Logfiles/angles9.txt');
angulo{10} = load('Logfiles/angles10.txt');
angulo{11} = load('Logfiles/angles11.txt');


npontos{01} = load('Logfiles/npoints1.txt');
npontos{02} = load('Logfiles/npoints2.txt');
npontos{03} = load('Logfiles/npoints3.txt');
npontos{04} = load('Logfiles/npoints4.txt');
npontos{05} = load('Logfiles/npoints5.txt');
npontos{06} = load('Logfiles/npoints6.txt');
npontos{07} = load('Logfiles/npoints7.txt');
npontos{08} = load('Logfiles/npoints8.txt');
npontos{09} = load('Logfiles/npoints9.txt');
npontos{10} = load('Logfiles/npoints10.txt');
npontos{11} = load('Logfiles/npoints11.txt');


N          = length(npontos)                 ;

figure
hold on;
grid on;

% Range dos plots, 1 a 11
range =[1:11];

legenda = cell(1,length(range));
grafico = cell(1,length(range));
Med = zeros(length(range),2);
j = 0;

subplot(2,1,1)
hold on
for i = range
    if max(i == [1:4 10])
        Nmax = 880;
    elseif max(i == [5:8 11])
        Nmax = 440;
    else
        Nmax = 880;
    end
    grafico{i} = npontos{i}(:,2)/Nmax;
    xAxis      = linspace(0,100,length(npontos{i}));
%     xAxis      = 1:length(ensaio{i}(:,1));
    plot(xAxis,100*grafico{i},'linewidth',1);
    j = j+1;
    Med(j,:) = [i mean(grafico{i})];
    legenda{j} = ['Exp. ' num2str(i)];
end
title('Flight Data Analysis')
legend(legenda)
xlabel('Progress %')
ylim([0 100]);
ylabel('Detected Points [%]')
grid on
box on
subplot(2,1,2)
hold on

for i=range
    roll = angulo{i}(:,2);
    pitch= angulo{i}(:,3);
    yaw = angulo{i}(:,4);
    t = length(roll);
    pct = linspace(0,100,t);
%     plot(pct,roll)

    plot(pct,pitch*360/2/pi,'linewidth',1)
%     plot(pct,yaw)

end

% h = gcf;
% h.Children.YLim = [0 1];

legend(legenda)
ylabel('Pitch [degree°]')
xlabel('Progress %')
grid on
box on
set(gcf, 'Position',  [300, 300, 1000, 500])
% return


%% Data processing
% close all
% Correlação
CORRS = zeros(11,3);
for ensaio_n = 1:11
an = angulo{ensaio_n}(:,2:4);
pon = npontos{ensaio_n}(:,2);
data = [abs(an) pon];
corr_matrix = corrcoef(data);
CORRS(ensaio_n,:) = corr_matrix(4,1:3);
end
%% 
figure
hold on
% Correlação sem Buracos
% trechos com água = [10%-20%] e [80%-90%] -> [1-2 , 8-9]
trechos_agua_pct = [12 23;82 92];
% trechos_agua_pct = [];
CORRS_NOHOLES = zeros(11,3);
for ensaio_n = 1:11
n_data = length(angulo{ensaio_n});
% calculo dos indices dos trechos
trechos_agua = fix(trechos_agua_pct*n_data*0.01);
trechos = [];
for n_trechos = 1:size(trechos_agua,2)
    trechos = [trechos trechos_agua(n_trechos,1):trechos_agua(n_trechos,2)];
end

an = angulo{ensaio_n}(:,2:4);
pon = npontos{ensaio_n}(:,2);

an(trechos,:) = [];
pon(trechos,:) = [];
% plot(pon) % so pra ter ideia

data = [abs(an) pon];
corr_matrix = corrcoef(data);
CORRS_NOHOLES(ensaio_n,:) = corr_matrix(4,1:3);
end
CORRS
CORRS_NOHOLES


% livro 1235 págs
% qts algarismos '1' na numeração das páginas
