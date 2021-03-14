% Code by Michael White to develop 3D figures for ME 335L Lab Report
clear;
close all;
clc;

% Read in excel data
data = readtable('AverageVelocities');

angles = linspace(0,2*pi,500);

% Plot 40s
mph40 = figure;
zeros = linspace(0,0,height(data.y40));
scatter3(data.Position,zeros,data.x40);
hold on;
plot3(data.Position*cos(angles),data.Position*sin(angles),data.x40);
% for i = 1:length(data.Position)
%     plot3(data.Position(i)*cos(angles),data.Position(i)*sin(angles),linspace(data.x40(i),data.x40(i),length(angles)),'b');
%     plot3(data.Position(i)*cos(angles),data.Position(i)*sin(angles),linspace(data.y40(i),data.y40(i),length(angles)),'b');
% end
grid on;
box on;
scatter3(zeros,data.Position,data.y40);
xlabel('X Position (in)');
ylabel('Y Position (in)');
xlim([-3,3]);
ylim([-3,3]);
