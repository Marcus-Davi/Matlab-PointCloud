clear;close all;clc

%angulos
data{1} = load('Angles/angles_1574701005.txt');
data{2} = load('Angles/angles_1574701406.txt');
data{3} = load('Angles/angles_1574702109.txt');
data{4} = load('Angles/angles_1574702573.txt');
data{5} = load('Angles/angles_1574703043.txt');
data{6} = load('Angles/angles_1574703390.txt');
data{7} = load('Angles/angles_1574703964.txt');
data{8} = load('Angles/angles_1574704717.txt');
data{9} = load('Angles/angles_1574705224.txt');
data{10} = load('Angles/angles_1574700877.txt');
data{11} = load('Angles/angles_1574701160.txt');


ensaio{01} = load('NPontos/N_pontos_1574701005.txt');
ensaio{02} = load('NPontos/N_pontos_1574701406.txt');
ensaio{03} = load('NPontos/N_pontos_1574702109.txt');
ensaio{04} = load('NPontos/N_pontos_1574702573.txt');
ensaio{05} = load('NPontos/N_pontos_1574703043.txt');
ensaio{06} = load('NPontos/N_pontos_1574703390.txt');
ensaio{07} = load('NPontos/N_pontos_1574703964.txt');
ensaio{08} = load('NPontos/N_pontos_1574704717.txt');
ensaio{09} = load('NPontos/N_pontos_1574705224.txt');
ensaio{10} = load('NPontos/N_pontos_1574700877.txt');
ensaio{11} = load('NPontos/N_pontos_1574701160.txt');


N          = length(ensaio)                 ;

figure
hold on;
grid on;

range =[9 10 11];

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
    grafico{i} = ensaio{i}(:,2)/Nmax;
    xAxis      = linspace(0,100,length(ensaio{i}));
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
    roll = data{i}(:,2);
    pitch= data{i}(:,3);
    yaw = data{i}(:,4);
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