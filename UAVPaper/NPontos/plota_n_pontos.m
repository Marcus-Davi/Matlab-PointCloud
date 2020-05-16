clear;close all;clc

ensaio{01} = load('N_pontos_1574701005.txt');
ensaio{02} = load('N_pontos_1574701406.txt');
ensaio{03} = load('N_pontos_1574702109.txt');
ensaio{04} = load('N_pontos_1574702573.txt');
ensaio{05} = load('N_pontos_1574703043.txt');
ensaio{06} = load('N_pontos_1574703390.txt');
ensaio{07} = load('N_pontos_1574703964.txt');
ensaio{08} = load('N_pontos_1574704717.txt');
ensaio{09} = load('N_pontos_1574705224.txt');
ensaio{10} = load('N_pontos_1574700877.txt');
ensaio{11} = load('N_pontos_1574701160.txt');
N          = length(ensaio)                 ;

figure
hold on;
grid on;

range =[1 3 5 7];

legenda = cell(1,length(range));
grafico = cell(1,length(range));
Med = zeros(length(range),2);
j = 0;
for i = range
    if max(i == [1:4 10])
        Nmax = 880;
    elseif max(i == [5:8 11])
        Nmax = 440;
    else
        Nmax = 880;
    end
    grafico{i} = ensaio{i}(:,2)/Nmax;
    xAxis      = linspace(0,1,length(ensaio{i}));
%     xAxis      = 1:length(ensaio{i}(:,1));
    plot(xAxis,grafico{i});
    j = j+1;
    Med(j,:) = [i mean(grafico{i})];
    legenda{j} = ['Trial ' num2str(i)];
end

h = gcf;
h.Children.YLim = [0 1];
legend(legenda)
xlabel('Iteration')
ylabel('Detected Points')
