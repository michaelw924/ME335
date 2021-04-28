%% Work for Lab 6: Pump Efficieny
% This code written by Michael White, 4/21/2021
clear; clc; close all;

% Read in data from lab
data.RPM_3500 = readtable('data3500.xlsx');
data.RPM_3000 = readtable('data3000.xlsx');
data.RPM_2500 = readtable('data2500.xlsx');
data.RPM_2000 = readtable('data2000.xlsx');
data.RPM_1500 = readtable('data1500.xlsx');

% Generate cell list for referencing data names
rpmList = {'RPM_3500','RPM_3000','RPM_2500','RPM_2000','RPM_1500'};

% Parameters
params.rho = 997.83; %kg/m3
params.g = 9.81; %m/s2
params.heightDiff_in = 3.75; %in

% - - - Calculations using imported data - - - 
% Convert values to metric/angular velocity
params.heightDiff_m = params.heightDiff_in*0.0254;
for i = 1:length(rpmList)
    data.(char(rpmList(i))).motorActual_rad = data.(char(rpmList(i))).motorActual_RPM*2*pi/60;
    data.(char(rpmList(i))).motorActual_SD_rad = data.(char(rpmList(i))).motorActual_SD_RPM*2*pi/60;
    data.(char(rpmList(i))).deltaP_Pa_meas = data.(char(rpmList(i))).deltaP_inH20*249.088908; 
    data.(char(rpmList(i))).deltaP_SD_Pa_meas = data.(char(rpmList(i))).deltaP_SD_inH20*249.088908; 
    data.(char(rpmList(i))).flow_m3s = data.(char(rpmList(i))).flow_GPM/15850.323141;
    data.(char(rpmList(i))).flow_SD_m3s = data.(char(rpmList(i))).flow_SD_GPM/15850.323141;
    data.(char(rpmList(i))).torque_Nm = data.(char(rpmList(i))).torque_lbft*1.35582;
    data.(char(rpmList(i))).torque_SD_Nm = data.(char(rpmList(i))).torque_SD_lbft*1.35582;
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
    data.(char(rpmList(i))).workActual_J = data.(char(rpmList(i))).torque_Nm...
        .* data.(char(rpmList(i))).motorActual_rad;
    data.(char(rpmList(i))).workActual_SD_J = sqrt(data.(char(rpmList(i))).torque_SD_Nm.^2 ...
        + data.(char(rpmList(i))).motorActual_SD_rad.^2);
    data.(char(rpmList(i))).workIdeal_J = data.(char(rpmList(i))).massFlow_kgs*params.g...
        .* data.(char(rpmList(i))).totalHead_m;
    data.(char(rpmList(i))).workIdeal_SD_J = params.g*sqrt(data.(char(rpmList(i))).massFlow_kgs.^2 ...
        + data.(char(rpmList(i))).totalHead_m.^2);
    data.(char(rpmList(i))).efficiency = 100*data.(char(rpmList(i))).workIdeal_J...
        ./ data.(char(rpmList(i))).workActual_J;
end

% Identify max efficiency in entire data set
maxCalc.flowList = [data.RPM_3500.flow_GPM',data.RPM_3000.flow_GPM',...
    data.RPM_2500.flow_GPM',data.RPM_2000.flow_GPM',data.RPM_1500.flow_GPM'];
maxCalc.RPMList = [data.RPM_3500.motorActual_RPM',data.RPM_3000.motorActual_RPM',...
    data.RPM_2500.motorActual_RPM',data.RPM_2000.motorActual_RPM',data.RPM_1500.motorActual_RPM'];
maxCalc.effList = [data.RPM_3500.efficiency',data.RPM_3000.efficiency',...
    data.RPM_2500.efficiency',data.RPM_2000.efficiency',data.RPM_1500.efficiency'];
maxCalc.Point = [maxCalc.flowList(maxCalc.effList == max(maxCalc.effList)),...
    maxCalc.RPMList(maxCalc.effList == max(maxCalc.effList)),max(maxCalc.effList)];

% - - - Post-Processing: Generating figures and writing tables - - -
% Write data to external excel file
for i = 1:length(rpmList)
    writetable(data.(char(rpmList(i))),strcat('data/',char(rpmList(i)),'outputData.xlsx'));
end

% Plot 2D figure - Pressure Head
figure; hold on;
for i = 1:length(rpmList)
    plot(...
        data.(char(rpmList(i))).flow_GPM,...
        data.(char(rpmList(i))).pressHead_m,...
        'LineWidth',2);
end
title('Pressure Head (m) vs. Flow (GPM)');
xlabel('Flow (GPM)');
ylabel('Pressure Head (m)');
set(gcf,'Position',get(0,'Screensize')); grid on;
RPM_legend = legend(...
    {'motorRPM = 3500','motorRPM = 3000','motorRPM = 2500',...
    'motorRPM = 2000','motorRPM = 1500'});

% Plot 2D figure - Efficiency
figure; hold on;
for i = 1:length(rpmList)
    plot(...
        data.(char(rpmList(i))).flow_GPM,...
        data.(char(rpmList(i))).efficiency,...
        'LineWidth',2);
end
title('Efficiency vs. Flow (GPM)(%)');
xlabel('Flow (GPM)');
ylabel('Efficiency (%)');
set(gcf,'Position',get(0,'Screensize')); grid on;
dataPlot.maxPoint = plot(maxCalc.Point(1),maxCalc.Point(3),...
    'r*','MarkerSize',8,'LineWidth',2);
RPM_legend = legend(...
    {'motorRPM = 3500','motorRPM = 3000','motorRPM = 2500',...
    'motorRPM = 2000','motorRPM = 1500','Max Efficiency'},'Location','southeast');

% Plot 3D figure
figure;
% Draw lines for each rpm
for i = 1:length(rpmList)
    dataPlot.(char(rpmList(i))) = plot3(...
        data.(char(rpmList(i))).flow_GPM,...
        data.(char(rpmList(i))).motorActual_RPM,...
        data.(char(rpmList(i))).efficiency,...
        'LineWidth',2);
    hold on;
end
dataPlot.maxPoint_3D = plot3(maxCalc.Point(1),maxCalc.Point(2),maxCalc.Point(3),...
    'r*','MarkerSize',8,'LineWidth',2);
RPM_legend_3D = legend(...
    'motorRPM = 3500','motorRPM = 3000','motorRPM = 2500',...
    'motorRPM = 2000','motorRPM = 1500','Max Efficiency');
RPM_legend_3D.AutoUpdate = false;

% Create fill and mesh to add 3D shape
for i = 1:length(rpmList)
    for j = 1:length(rpmList)
        xVect(j) = data.(char(rpmList(j))).flow_GPM(i);
        yVect(j) = data.(char(rpmList(j))).motorActual_RPM(i);
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
set(gcf,'Position',get(0,'Screensize')); grid on;
title('3D Flow (GPM) vs. Efficiency (%)');
xlabel('Flow (GPM)');
ylabel('Motor Setting (RPM)');
zlabel('Efficiency (%)');

% - - - Show Tables in Report Order - - -
% Generate vectors to access data
rawDataVect = [1,2:9];
metricDataVect = [1,10:17];
pressAndMassVect = [1,18:21];
headVect = [1,22:27];
workVect = [1,28:32];

% Show raw data from motor
disp('Raw Motor Data @ 3500 RPM:'); disp(data.RPM_3500(:,rawDataVect));
disp('Raw Motor Data @ 3000 RPM:'); disp(data.RPM_3000(:,rawDataVect));
disp('Raw Motor Data @ 2500 RPM:'); disp(data.RPM_2500(:,rawDataVect));
disp('Raw Motor Data @ 2000 RPM:'); disp(data.RPM_2000(:,rawDataVect));
disp('Raw Motor Data @ 1500 RPM:'); disp(data.RPM_1500(:,rawDataVect));

% Show converted raw data from motor
disp('Converted Data @ 3500 RPM:'); disp(data.RPM_3500(:,metricDataVect));
disp('Converted Data @ 3000 RPM:'); disp(data.RPM_3500(:,metricDataVect));
disp('Converted Data @ 2500 RPM:'); disp(data.RPM_3500(:,metricDataVect));
disp('Converted Data @ 2000 RPM:'); disp(data.RPM_3500(:,metricDataVect));
disp('Converted Data @ 1500 RPM:'); disp(data.RPM_3500(:,metricDataVect));

% Show actual delta pressure and mass flow
disp('Delta Pressure and Mass Flow @ 3500 RPM:'); disp(data.RPM_3500(:,pressAndMassVect));
disp('Delta Pressure and Mass Flow @ 3000 RPM:'); disp(data.RPM_3000(:,pressAndMassVect));
disp('Delta Pressure and Mass Flow @ 2500 RPM:'); disp(data.RPM_2500(:,pressAndMassVect));
disp('Delta Pressure and Mass Flow @ 2000 RPM:'); disp(data.RPM_2000(:,pressAndMassVect));
disp('Delta Pressure and Mass Flow @ 1500 RPM:'); disp(data.RPM_1500(:,pressAndMassVect));

% Show actual delta pressure and mass flow
disp('Head Data @ 3500 RPM:'); disp(data.RPM_3500(:,headVect));
disp('Head Data @ 3000 RPM:'); disp(data.RPM_3000(:,headVect));
disp('Head Data @ 2500 RPM:'); disp(data.RPM_2500(:,headVect));
disp('Head Data @ 2000 RPM:'); disp(data.RPM_2000(:,headVect));
disp('Head Data @ 1500 RPM:'); disp(data.RPM_1500(:,headVect));

% Show work data
disp('Work Data @ 3500 RPM:'); disp(data.RPM_3500(:,workVect));
disp('Work Data @ 3000 RPM:'); disp(data.RPM_3000(:,workVect));
disp('Work Data @ 2500 RPM:'); disp(data.RPM_2500(:,workVect));
disp('Work Data @ 2000 RPM:'); disp(data.RPM_2000(:,workVect));
disp('Work Data @ 1500 RPM:'); disp(data.RPM_1500(:,workVect));