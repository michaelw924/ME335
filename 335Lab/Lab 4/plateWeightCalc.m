clear; clc;

% Supposed weight of the plate
supposedWeight = 5.9135;

% Known Values
density = 998.02;
height = 0.12344;
g = 9.81;
diameter = 0.013462;
area = (pi/4)*(diameter^2);
Q_GPM = 13.352;

% Calculate flow in m^3 / s
Q_m3s = Q_GPM/15850;

% Calculate velocity
V = Q_m3s/area;

% Calculate known forces
forceJet = (V^2)*density*area;
weightWater = density*area*height*g;

% Find weight of plate and percent diff
weightPlate = forceJet-weightWater;
percentDiff = (weightPlate-supposedWeight)/supposedWeight;
display(weightPlate);display(percentDiff);