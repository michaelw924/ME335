% Code by Michael White to develop graphs and calculate experimental values for ME 335L Lab Report 2
clear; close all; clc;

% Read in excel data
data.rawData = readtable('AverageVelocitiesWithStdDev');
data.extraData = readtable('AverageVelocities_60.xlsx');

% Separate the raw data into the averages and standard deviations
data.velocityData = data.rawData(:,[1,2,4,6,8,10,12,14,16]);
data.stdDevData = data.rawData(:,[1,3,5,7,9,11,13,15,17]);

% Enter the diameter of the tube and number of equal areas
tubeDiam = 6.065; %inches
n = 5;

% Enter the calculated density and std dev of density
rho = 1.1222;
rhoStdDev = 4.8250e-04;

% Calculate total area of the tube
tubeArea = (pi/4)*(tubeDiam^2);
clear tubeDiam;

% Find area for split regions
equalArea = tubeArea/n;

% Convert equalArea and tubeArea to m^2
equalArea = equalArea*0.00064516;
tubeArea = tubeArea*0.00064516;

% Find average velocity and standard deviation of this velocity per region
for speed = 1:4
    data.velocityDataSource = table2array(data.velocityData(:,2*speed:2*speed+1));
    data.stdDevDataSource = table2array(data.stdDevData(:,2*speed:2*speed+1));
    for position = 1:n
        avgVelocitiesInRegions(position) = mean([data.velocityDataSource(position,1:2) data.velocityDataSource(12-position,1:2)]);
        stdDevInRegions(position) = sqrt(sum([data.stdDevDataSource(position,1:2) data.stdDevDataSource(12-position,1:2)].^2));
    end
    Vavg(speed) = sum(avgVelocitiesInRegions*equalArea)/tubeArea;
    VavgStdDev(speed) =  sqrt(sum((stdDevInRegions*equalArea).^2)/tubeArea);
    clear avgVelocitiesInRegions; clear stdDevInRegions; clear position;
end
clear data.velocityDataSource; clear data.stdDevDataSource; clear speed; clear n;

% Combine data for 60% Y-axis
y60position = vertcat(data.velocityData.Position,data.extraData.Position);
y60data = vertcat(data.velocityData.y60,data.extraData.y60);
y60 = [y60position,y60data];
y60 = sortrows(y60);

% Plot Fan = 40%
figure;
set(gcf, 'Position', get(0, 'Screensize'));
subplot(2,2,1);
hold on;
title('Results from Fan = 40%');
grid on;
plot(data.velocityData.Position,data.velocityData.x40,'LineWidth',2);
plot(data.velocityData.Position,data.velocityData.y40,'LineWidth',2);
plot(data.velocityData.Position,linspace(Vavg(4),Vavg(4),length(data.velocityData.Position)),'LineWidth',2,'Color','g');
legend('X-axis','Y-axis','Average Velocity');
xlabel('Position (in)');ylabel('Velocity (m/s)');

% Plot Fan = 60%
subplot(2,2,2);
hold on;
title('Results from Fan = 60%');
grid on;
plot(data.velocityData.Position,data.velocityData.x60,'LineWidth',2);
plot(y60(:,1),y60(:,2),'LineWidth',2);
plot(y60(:,1),linspace(Vavg(3),Vavg(3),length(y60(:,1))),'LineWidth',2,'Color','g');
legend('X-axis','Y-axis','Average Velocity');
xlabel('Position (in)');ylabel('Velocity (m/s)');

% Plot Fan = 80%
subplot(2,2,3);
hold on;
title('Results from Fan = 80%');
grid on;
plot(data.velocityData.Position,data.velocityData.x80,'LineWidth',2);
plot(data.velocityData.Position,data.velocityData.y80,'LineWidth',2);
plot(data.velocityData.Position,linspace(Vavg(2),Vavg(2),length(data.velocityData.Position)),'LineWidth',2,'Color','g');
legend('X-axis','Y-axis','Average Velocity');
xlabel('Position (in)');ylabel('Velocity (m/s)');

% Plot Fan = 100%
subplot(2,2,4);
hold on;
title('Results from Fan = 100%');
grid on;
plot(data.velocityData.Position,data.velocityData.x100,'LineWidth',2);
plot(data.velocityData.Position,data.velocityData.y100,'LineWidth',2);
plot(data.velocityData.Position,linspace(Vavg(1),Vavg(1),length(data.velocityData.Position)),'LineWidth',2,'Color','g');
legend('X-axis','Y-axis','Average Velocity');
xlabel('Position (in)');ylabel('Velocity (m/s)');

% Calculate volumetric flow rates and std deviations from Vavg, VavgStdDev, and tubeArea
Qtube = Vavg*tubeArea;
QstdDev = VavgStdDev*tubeArea;

% Calculate mass flow rate from Qtube, QstdDev, and density
mdot = Qtube*rho;
mdotStdDev = mdot*sqrt((QstdDev/Qtube)^2+(rhoStdDev/rho)^2);

% Calculate the development percentage by approximating Vmax and
% dividing measured Vmax by this theoretical value
Vmax_theoretical = Vavg*2;
data.Vmax_data = table2array(data.rawData(6,2:2:16));
for i = 1:length(Vmax_theoretical)
    Vmax_experimental(i) = mean([data.Vmax_data(2*i-1) data.Vmax_data(2*i)]);
    developmentPercent(i) = Vmax_experimental(i)/Vmax_theoretical(i);
end