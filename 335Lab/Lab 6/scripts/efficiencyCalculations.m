%% Work for Lab 6: Pump Efficieny
% This code written by Michael White, 4/21/2021
clear; clc; close all;

% Read in data from lab
rawData.RPM_3500 = readtable('data3500.xlsx');
rawData.RPM_3000 = readtable('data3000.xlsx');
rawData.RPM_2500 = readtable('data2500.xlsx');
rawData.RPM_2000 = readtable('data2000.xlsx');
rawData.RPM_1500 = readtable('data1500.xlsx');

% Generate cell list for referencing data names
rpmList = {'RPM_3500','RPM_3000','RPM_2500','RPM_2000','RPM_1500'};

% Parameters
params.rho = 997.83; %kg/m3
params.g = 9.81; %m/s2
params.heightDiff_in = 3.75; %in

%% Calculations using imported data
% Convert values to metric/angular velocity
params.heightDiff_m = params.heightDiff_in*0.0254;
for i = 1:length(rpmList)
    data.(char(rpmList(i))).motorActual_rad = rawData.(char(rpmList(i))).motorActual_RPM*2*pi/60;
    data.(char(rpmList(i))).motorActual_SD_rad = rawData.(char(rpmList(i))).motorActual_SD_RPM*2*pi/60;
    data.(char(rpmList(i))).deltaP_Pa_meas = rawData.(char(rpmList(i))).deltaP_inH20*249.088908; 
    data.(char(rpmList(i))).deltaP_SD_Pa_meas = rawData.(char(rpmList(i))).deltaP_SD_inH20*249.088908; 
    data.(char(rpmList(i))).flow_m3s = rawData.(char(rpmList(i))).flow_GPM/15850.323141;
    data.(char(rpmList(i))).flow_SD_m3s = rawData.(char(rpmList(i))).flow_SD_GPM/15850.323141;
    data.(char(rpmList(i))).torque_Nm = rawData.(char(rpmList(i))).torque_lbft*1.35582;
    data.(char(rpmList(i))).torque_SD_Nm = rawData.(char(rpmList(i))).torque_SD_lbft*1.35582;
end

% Calculate hydrostatic
params.heightDiffPress_Pa = params.rho*params.g*params.heightDiff_m;

% Calculate actual delta pressure considering hydrostatic and the mass flow
for i = 1:length(rpmList)
    data.(char(rpmList(i))).deltaP_Pa = data.(char(rpmList(i))).deltaP_Pa_meas-params.heightDiffPress_Pa;
    data.(char(rpmList(i))).deltaP_SD_Pa = data.(char(rpmList(i))).deltaP_SD_Pa_meas;
    data.(char(rpmList(i))).massFlow_kgs = data.(char(rpmList(i))).flow_m3s*params.rho;
    data.(char(rpmList(i))).massFlow_SD_kgs = data.(char(rpmList(i))).flow_SD_m3s*params.rho;
end

% Calculate the pressure and elevation head, as well as total head
for i = 1:length(rpmList)
    data.(char(rpmList(i))).elevHead_m = params.heightDiff_m.*[1 1 1 1 1]';
    data.(char(rpmList(i))).elevHead_SD_m = [0 0 0 0 0]';
    data.(char(rpmList(i))).pressHead_m = data.(char(rpmList(i))).deltaP_Pa/(params.rho*params.g);
    data.(char(rpmList(i))).pressHead_SD_m = data.(char(rpmList(i))).deltaP_SD_Pa/(params.rho*params.g);
    data.(char(rpmList(i))).totalHead_m = data.(char(rpmList(i))).pressHead_m...
        + data.(char(rpmList(i))).elevHead_m;
    data.(char(rpmList(i))).totalHead_SD_m = data.(char(rpmList(i))).pressHead_SD_m;
end

% Find ideal work, actual work, and efficiency
for i = 1:length(rpmList)
    data.(char(rpmList(i))).workActual = data.(char(rpmList(i))).torque_Nm...
        .* data.(char(rpmList(i))).motorActual_rad;
    data.(char(rpmList(i))).workIdeal = data.(char(rpmList(i))).massFlow_kgs*params.g...
        .* data.(char(rpmList(i))).totalHead_m;
    data.(char(rpmList(i))).efficiency = 100*data.(char(rpmList(i))).workIdeal...
        ./ data.(char(rpmList(i))).workActual;
end

% Identify max efficiency in entire data set
maxCalc.flowList = [rawData.RPM_3500.flow_GPM',rawData.RPM_3000.flow_GPM',...
    rawData.RPM_2500.flow_GPM',rawData.RPM_2000.flow_GPM',rawData.RPM_1500.flow_GPM'];
maxCalc.RPMList = [rawData.RPM_3500.motorActual_RPM',rawData.RPM_3000.motorActual_RPM',...
    rawData.RPM_2500.motorActual_RPM',rawData.RPM_2000.motorActual_RPM',rawData.RPM_1500.motorActual_RPM'];
maxCalc.effList = [data.RPM_3500.efficiency',data.RPM_3000.efficiency',...
    data.RPM_2500.efficiency',data.RPM_2000.efficiency',data.RPM_1500.efficiency'];
maxCalc.Point = [maxCalc.flowList(maxCalc.effList == max(maxCalc.effList)),...
    maxCalc.RPMList(maxCalc.effList == max(maxCalc.effList)),max(maxCalc.effList)];

%% Post-Processing: Generating figures
figure;
% Draw lines for each rpm
for i = 1:length(rpmList)
    dataPlot.(char(rpmList(i))) = plot3(...
        rawData.(char(rpmList(i))).flow_GPM,...
        rawData.(char(rpmList(i))).motorActual_RPM,...
        data.(char(rpmList(i))).efficiency,...
        'LineWidth',2);
    hold on;
end
dataPlot.maxPoint = plot3(maxCalc.Point(1),maxCalc.Point(2),maxCalc.Point(3),...
    'r*','MarkerSize',8,'LineWidth',2);
RPM_legend = legend(...
    'motorRPM = 3500','motorRPM = 3000','motorRPM = 2500',...
    'motorRPM = 2000','motorRPM = 1500','Max Efficiency');
RPM_legend.AutoUpdate = false;

% Create fill and mesh to add 3D shape
for i = 1:length(rpmList)
    for j = 1:length(rpmList)
        xVect(j) = rawData.(char(rpmList(j))).flow_GPM(i);
        yVect(j) = rawData.(char(rpmList(j))).motorActual_RPM(i);
        zVect(j) = data.(char(rpmList(j))).efficiency(i);
    end
    plot3(xVect,yVect,zVect,'-k');
    if i > 1
        x = [dataPlot.(char(rpmList(i-1))).XData, fliplr(dataPlot.(char(rpmList(i))).XData)];
        y = [dataPlot.(char(rpmList(i-1))).YData, fliplr(dataPlot.(char(rpmList(i))).YData)];
        z = [dataPlot.(char(rpmList(i-1))).ZData, fliplr(dataPlot.(char(rpmList(i))).ZData)];
        dataFills.(char(rpmList(i))) = fill3(x, y, z, [0.9 0.9 0.9], 'edgeColor', [0.9 0.9 0.9]);
    end
end

% Add cleaning features to 3D figure
grid on;
xlabel('Flow (GPM)');
ylabel('Motor Setting (RPM)');
zlabel('Efficiency (%)');

%% Show Tables in Report Order
% Show raw data from motor
disp('Raw Motor Data @ 3500 RPM:'); disp(rawData.RPM_3500);
disp('Raw Motor Data @ 3000 RPM:'); disp(rawData.RPM_3000);
disp('Raw Motor Data @ 2500 RPM:'); disp(rawData.RPM_2500);
disp('Raw Motor Data @ 2000 RPM:'); disp(rawData.RPM_2000);
disp('Raw Motor Data @ 1500 RPM:'); disp(rawData.RPM_1500);

% Show converted raw data from motor
disp('Converted Data @ 3500 RPM:'); disp(data.RPM_3500);
disp('Converted Data @ 3000 RPM:'); disp(data.RPM_3000);
disp('Converted Data @ 2500 RPM:'); disp(data.RPM_2500);
disp('Converted Data @ 2000 RPM:'); disp(data.RPM_2000);
disp('Converted Data @ 1500 RPM:'); disp(data.RPM_1500);

% Show converted raw data from motor
disp('Converted Data @ 3500 RPM:'); disp(data.RPM_3500);
disp('Converted Data @ 3000 RPM:'); disp(data.RPM_3000);
disp('Converted Data @ 2500 RPM:'); disp(data.RPM_2500);
disp('Converted Data @ 2000 RPM:'); disp(data.RPM_2000);
disp('Converted Data @ 1500 RPM:'); disp(data.RPM_1500);