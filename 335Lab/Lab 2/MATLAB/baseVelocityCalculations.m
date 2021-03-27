% Code by Michael White to calculate the base velocity characteristics for ME 335L Lab Report 2
clear;clc;

% Enter mass flow rate values from 
mdot_tube = [0.2557 0.2017 0.1508 0.1014];

% Enter the calculated density and std dev of density
rho = 1.1222;
rhoStdDev = 4.8250e-04;

% Calculate total area of the tube
fanArea = 6^2;

% Convert area to m^2
fanArea = fanArea*0.00064516;

% Read in raw velocities (currently in MPH) and write averages and standard deviations
% to individual vectors
fanSpeeds_MPH = readtable('RawFanSpeeds');
Vavg_MPH = [mean(fanSpeeds_MPH.Fan100) mean(fanSpeeds_MPH.Fan80) mean(fanSpeeds_MPH.Fan60) mean(fanSpeeds_MPH.Fan40)];
VstdDev_MPH = [std(fanSpeeds_MPH.Fan100) std(fanSpeeds_MPH.Fan80) std(fanSpeeds_MPH.Fan60) std(fanSpeeds_MPH.Fan40)];

% Convert velocity averages to m/s
Vavg_mps = Vavg_MPH*0.44704;
VstdDev_mps = VstdDev_MPH*0.44704;

% Calculate volumetric flow rates and std deviations from Vavg, VavgStdDev, and tubeArea
Q_fan = Vavg_mps*fanArea;
QstdDev_fan = VstdDev_mps*fanArea;

% Calculate mass flow rate from Qtube, QstdDev, and density
mdot_fan = Q_fan*rho;
mdotStdDev_fan = mdot_fan*sqrt((QstdDev_fan/Q_fan)^2+(rhoStdDev/rho)^2);

% Calculate percent error from experimental values
for i = 1:length(mdot_fan)
    percentError(i) = (mdot_tube(i)/mdot_fan(i))-1;
end

% Display results as they appear in the report
display(Vavg_MPH);display(VstdDev_MPH);
display(Vavg_mps);display(VstdDev_mps);
display(Q_fan);display(QstdDev_fan);
display(mdot_fan);display(mdotStdDev_fan);
display(percentError);