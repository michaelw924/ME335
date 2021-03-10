% Code by Michael White for Pre-Lab Question O1
clear;clc;

% Setup initial variables
rho_air = 1.22;
rho_liquid = 800;
mdot = 0.5;
d = 4;

% Convert diameter from inches to meters
d = 0.0254*d;

% Calculate the area of the tube
A = pi/4*(d)^2;

% Calculate Vavg from mdot, rho_air, and the Area
Vavg = mdot/(rho_air*A);

% Calculate Vmax from Vavg, being 2*Vavg
Vmax = Vavg*2;

% Calculate delta_h by equating dynamic pressure and hydrostatic pressure+
delta_h = (Vmax^2)*rho_air/(2*rho_liquid*9.81);

% Convert delta_h to both 1 significant figure and centimeters
delta_h = round(delta_h,1)*100;

% Display results
disp(strcat("The height difference (delta h) is ",num2str(delta_h)," cm."));