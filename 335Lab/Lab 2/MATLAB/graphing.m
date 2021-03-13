% Code by Michael White to develop graphs for ME 335L Lab Report
clear; close all; clc;

% Read in excel data
data = readtable('AverageVelocities');
extraData = readtable('AverageVelocities_60.xlsx');

% Combine data for 60mph Y-axis
y60position = vertcat(data.Position,extraData.Position);
y60data = vertcat(data.y60,extraData.y60);
y60 = [y60position,y60data];
y60 = sortrows(y60);

% Calculate averages for the sets of data
mean40 = mean([mean(data.x40),mean(data.y40)]);
mean60 = mean([mean(data.x60),mean(y60(:,2))]);
mean80 = mean([mean(data.x80),mean(data.y80)]);
mean100 = mean([mean(data.x100),mean(data.y100)]);

% Plot 40mph
figure;
hold on;
title('Results from 40 mph');
grid on;
plot(data.Position,data.x40);
plot(data.Position,data.y40);
plot(data.Position,linspace(mean40,mean40,length(data.Position)));
legend('X-axis','Y-axis','Average Velocity');


% Plot 60mph
figure
hold on;
title('Results from 60 mph');
grid on;
plot(data.Position,data.x60);
plot(y60(:,1),y60(:,2));
plot(y60(:,1),linspace(mean60,mean60,length(y60(:,1))));
legend('X-axis','Y-axis','Average Velocity');

% Plot 80mph
figure;
hold on;
title('Results from 80 mph');
grid on;
plot(data.Position,data.x80);
plot(data.Position,data.y80);
plot(data.Position,linspace(mean80,mean80,length(data.Position)));
legend('X-axis','Y-axis','Average Velocity');

% Plot 100mph
figure;
hold on;
title('Results from 100 mph');
grid on;
plot(data.Position,data.x100);
plot(data.Position,data.y100);
plot(data.Position,linspace(mean100,mean100,length(data.Position)));
legend('X-axis','Y-axis','Average Velocity');