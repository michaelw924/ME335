% Code by Michael White to develop 3D figures for ME 335L Lab Report
clear;clc;

% Read in excel data
x40 = readtable('x40');
y40 = readtable('y40');
x60 = readtable('x60');
y60 = readtable('y60');
extra60 = readtable('extra60');
x80 = readtable('x80');
y80 = readtable('y80');
x100 = readtable('x100');
y100 = readtable('y100');



% Append the extra values to the 60 speed tables
extra60.Properties.VariableNames = ["X_in","DiffPress_Pa"];
x60 = vertcat(x60,extra60);
extra60.Properties.VariableNames = ["Y_in","DiffPress_Pa"];
y60 = vertcat(y60,extra60);

% % Convert tables to arrays
% x40 = table2array(x40);
% y40 = table2array(y40);
% x60 = table2array(x60);
% y60 = table2array(y60);
% x80 = table2array(x80);
% x80 = table2array(y80);
% x100 = table2array(x100);
% x100 = table2array(x100);

% Plot 40s
figure;
zeros = linspace(0,0,height(x40));
plot3(x40.X_in,zeros,x40.DiffPress_Pa);
grid on;
box on;
hold on;
plot3(zeros,y40.Y_in,y40.DiffPress_Pa);

% Plot 60s
figure;
zeros = linspace(0,0,height(x60));
plot3(x60.X_in,zeros,x60.DiffPress_Pa);
grid on;
box on;
hold on;
plot3(zeros,y60.Y_in,y60.DiffPress_Pa);