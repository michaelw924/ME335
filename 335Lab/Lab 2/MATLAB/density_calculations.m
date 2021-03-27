% Code by Michael White to calculate the density for ME 335L Lab Report 2
clear;clc;

% Setup initials
rawP_PSI = [13.908 13.911 13.908 13.908 13.908 13.905];
rawT_C = [24.475 24.65 24.75 24.775 24.8 24.75];
R = 286.9;

% Caclulate the mean and std dev of absolute pressure in PSI
avgP_PSI = mean(rawP_PSI);
stdP_PSI = std(rawP_PSI);

% Calculate mean and std dev of temperature in Celsius
avgT_C = mean(rawT_C);
stdT_C = std(rawT_C);

% Convert raw data to desired units
rawP_Pa = rawP_PSI*6894.757;
rawT_K = rawT_C+273.15;

% Calculate mean and std dev of absolute pressure in Pa
avgP_Pa = mean(rawP_Pa);
stdP_Pa = std(rawP_Pa);

% Calcuate mean and std dev of temperature in Kelvin
avgT_K = mean(rawT_K);
stdT_K = std(rawT_K);

% Calculate rho and std dev of rho from known values in SI
rho = avgP_Pa/(R*avgT_K);
rho_std = rho*sqrt((stdP_Pa/avgP_Pa)^2+(stdT_K/avgT_K)^2);

% Display pressure values in PSI and Pa
display(avgP_PSI);display(stdP_PSI);
display(avgP_Pa);display(stdP_Pa);

% Display temperature values in C and K
display(avgT_C);display(stdT_C);
display(avgT_K);display(stdT_K);

% Display rho
display(rho);
display(rho_std);