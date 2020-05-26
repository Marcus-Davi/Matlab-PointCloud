clear;close all;clc

%angulos
data{1} = load('angles1.txt');
data{2} = load('angles2.txt');
data{3} = load('angles3.txt');
data{4} = load('angles4.txt');
data{5} = load('angles5.txt');
data{6} = load('angles6.txt');
data{7} = load('angles7.txt');
data{8} = load('angles8.txt');
data{9} = load('angles9.txt');
data{10} = load('angles10.txt');
data{11} = load('angles11.txt');


ensaio{01} = load('npoints1.txt');
ensaio{02} = load('npoints2.txt');
ensaio{03} = load('npoints3.txt');
ensaio{04} = load('npoints4.txt');
ensaio{05} = load('npoints5.txt');
ensaio{06} = load('npoints6.txt');
ensaio{07} = load('npoints7.txt');
ensaio{08} = load('npoints8.txt');
ensaio{09} = load('npoints9.txt');
ensaio{10} = load('npoints10.txt');
ensaio{11} = load('npoints11.txt');


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