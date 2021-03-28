%% Calculations for Lab 3: Obstruction Flow
% This code written by Michael White
clear; clc; close all;

% Import tap location tables with the averaged data
data.rpm3000 = readtable('rpm3000.xlsx');
data.rpm2500 = readtable('rpm2500.xlsx');
data.rpm2000 = readtable('rpm2000.xlsx');
data.rpm1500 = readtable('rpm1500.xlsx');

% Identify the average flow rate for each rpm setting and write to vector
rpmSettings = fieldnames(data);
for i = 1:numel(rpmSettings)
    calcValues.avgFlowMeasured_GPM(i,1) = mean(data.(char(rpmSettings(i))).FlowRate_GPM);
end

% Generate vector of flow rates in m^3/s to data struct
for i = 1:length(calcValues.avgFlowMeasured_GPM)
    calcValues.avgFlowMeasured_m3s(i,1) = calcValues.avgFlowMeasured_GPM(i)/15850.3;
end

% Convert pressures from table into pascals and write to new vector
for i = 1:numel(rpmSettings)
    for j = 1:length(data.(char(rpmSettings(i))).TapPressure_H20)
        calcValues.tapPress_Pa.(char(rpmSettings(i)))(j,1) = data.(char(rpmSettings(i))).TapPressure_H20(j)*249.0889;
    end
end

% Plot tap pressure against location for each pump setting on one figure
figure; hold on; set(gcf, 'Position', get(0, 'Screensize')); grid on;
for i = 1:numel(rpmSettings)
    plot(data.(char(rpmSettings(i))).TapLocation_in,calcValues.tapPress_Pa.(char(rpmSettings(i))),...
        'LineWidth',3,'Marker','*','MarkerSize',10);
    xlimMin(i) = min(data.(char(rpmSettings(i))).TapLocation_in);
    xlimMax(i) = max(data.(char(rpmSettings(i))).TapLocation_in);
end
xlim([min(xlimMin),max(xlimMax)]); clear xlimMax; clear xlimMin;
xlabel('Tap Location (in)'); ylabel('Tap Pressure (Pa)');
legend('3000 RPM','2500 RPM','2000 RPM','1500 RPM');
title('Tap Pressures (Pa) vs. Tap Location (in)');

% Input variables from system for calculating different parameters
system.D_in = 1.939; % in
system.D_m = system.D_in*0.0254; % m
system.d_in = 1.375; % in
system.d_m = system.d_in*0.0254; % m
system.Ap_m2 = (pi/4)*(system.D_m)^2; % m2
system.Ao_m2 = (pi/4)*(system.d_m)^2; % m2
system.dynVisc = 0.000965; % (N*s)/m2
system.kinVisc = 9.667e-7; % m2/s
system.density = 997.8857; % kg/m3
system.Beta = system.d_m/system.D_m;

% Calculated velocity from measured flow values
for i = 1:numel(rpmSettings)
    calcValues.avgVelocityMeasured_ms(i,1) = calcValues.avgFlowMeasured_m3s(i)/system.Ap_m2;
end

% Calculated Reynolds numbers from velocities with system parameters
for i = 1:numel(rpmSettings)
    system.reynolds(i,1) = ...
        system.density*calcValues.avgVelocityMeasured_ms(i)*system.D_m/system.dynVisc;
end

% Using reynolds values and Beta, identify Co values from graph
system.Co = [0.616 0.619 0.623 0.626];

% Calculate differential pressures from values on either side of orifice
for i = 1:numel(rpmSettings)
    calcValues.pressureDiff_Pa(i,1) = ...
        calcValues.tapPress_Pa.(char(rpmSettings(i)))(4)- ...
        calcValues.tapPress_Pa.(char(rpmSettings(i)))(5);
end

% Calculate theoretical flows from differential pressure
for i = 1:numel(rpmSettings)
    calcValues.avgFlowCalculated_m3s(i,1) = system.Co(i)*system.Ao_m2*...
        sqrt((2*calcValues.pressureDiff_Pa(i))/(system.density*(1-system.Beta^4)));
end

% Calculate percent difference between calculted and measured flows
for i = 1:numel(rpmSettings)
    calcValues.percentError(i,1) = ((calcValues.avgFlowMeasured_m3s(i)-calcValues.avgFlowCalculated_m3s(i))/...
        calcValues.avgFlowMeasured_m3s(i))*100;
end

% Generate table for output of measured & calculated flows w/ % difference
flowTable = table(rpmSettings, calcValues.avgFlowMeasured_m3s,...
    calcValues.avgFlowCalculated_m3s, calcValues.percentError);
flowTable.Properties.VariableNames = ...
    {'rpmSettings' 'avgFlowMeasured_m3s' 'avgFlowCalculated_m3s' 'percentError'};