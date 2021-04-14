clear; clc;

diameter_m = 0.0243;
density_kgm3 = 997.83;
dynVisc = 9.613e-4;

flow_GPM = [0.23 0.3 0.44 0.6 1.02];
flow_m3s = 0.000063090196*flow_GPM;
Area_m2 = pi/4*diameter_m^2;

Re = density_kgm3*flow_m3s/Area_m2*diameter_m/dynVisc;
display(Re);