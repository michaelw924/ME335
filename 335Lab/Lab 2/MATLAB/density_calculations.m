clear;clc;

% Setup initials
p = [13.908 13.911 13.908 13.908 13.908 13.905];
t = [24.475 24.65 24.75 24.775 24.8 24.75];
R = 287.2;

% Calculate mean temp and shift to kelvin
t = mean(t) + 273.15;

% convert pressure to Pa
p = p*6894.757;

% compute avg p
p = mean(p);

rho = p/(R*t);
display(rho);