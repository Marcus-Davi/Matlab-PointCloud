clear;close all;clc

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
n = 11;
figure
hold on
grid on


% 10 m/s
for i=[1 3 5 7]
    roll = data{i}(:,2);
    pitch= data{i}(:,3);
    yaw = data{i}(:,4);
    t = length(roll);
    pct = linspace(0,1,t);
%     plot(pct,roll)
    plot(pct,pitch*360/2/pi)
%     plot(pct,yaw)

end
legend('1','3','5','7')


% % 4 m/s
% for i=6
%     roll = data{i}(:,2);
%     pitch= data{i}(:,3);
%     yaw = data{i}(:,4);
%     t = length(roll);
%     pct = linspace(0,100,t);
% %     plot(pct,roll)
%     plot(pct,pitch)
% %     plot(pct,yaw)
% end
% 
% 
% legend('Pitch 10 m/s', 'Pitch 4 m/s')
% legend('Roll 10 m/s', 'Roll 4 m/s')



% data = data(:,2:end);

%roll pitch yaw
% plot(data(:,3))
