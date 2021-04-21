%% Work for Pre-Lab 6: Problem PE1
% This code written by Michael White, 4/19/2021
clear;clc;

% Input values from problem statement
p1 = 96.5; %kPa
Q = 77.9; %GPM
d1 = 3; %in
wp = 3000; %rpm
T = 0.7; %ft-lbf
p2 = 123.2; %kPa
z_diff = 5.52; %ft -this equates to z2-z1
d2 = 2; %in
rho = 997.3; %kg/m3
g = 9.81; %m/s2

% Convert values to metric units
p1 = p1*1000; %Pa
d1 = d1*0.0254; %m
wp = wp*2*pi/60; %radians/sec
T = T*1.35582; %N*m
p2 = p2*1000; %Pa
Q = Q/15850.323141; %m3/s
z_diff = z_diff*0.3048; %m
d2 = d2*0.0254; %m

% Calculate mass flow
mdot = Q*rho; %kg/s

% Calculate areas
A1 = pi/4*d1^2; %m2
A2 = pi/4*d2^2; %m2

% Calculate velocities
V1 = Q/A1; %m/s
V2 = Q/A2; %m/s

% Calculate the actual shaft work, in watts and hp
W_actual = T*wp; %Watts
W_actual_hp = W_actual*0.001341022; %hp

% Calculate the pressure head
ph = (p2-p1)/(rho*g); %m

% Calculate the velocity head
vh = (V2^2-V1^2)/(2*g); %m

% Calculate the elevation head
eh = z_diff; %m

% Calculate the ideal shaft work, in watts and hp
W_ideal = mdot*g*(ph+vh+eh); %Watts
W_ideal_hp = W_ideal*0.001341022; %hp

% Calculate the input heads for actual and ideal work
Wh_ideal = W_ideal/(mdot*g); %m
Wh_actual = W_actual/(mdot*g); %m

% Calculate head loss (taking as positive value)
h_loss = abs(Wh_ideal-Wh_actual); %m

% Calculate the pump efficiency
n = W_ideal/W_actual*100; %percentage
n = strcat(num2str(n),'%');

% Display results in order requested on problem
disp('The actual work (in hp):'); disp(W_actual_hp);
disp('The pressure head (in m):'); disp(ph);
disp('The velocity head (in m):'); disp(vh);
disp('The elevation head (in m):'); disp(eh);
disp('The ideal shaft work input head (in m):'); disp(Wh_ideal);
disp('The actual shaft work input head (in m):'); disp(Wh_actual);
disp('The head loss (in m):'); disp(h_loss);
disp('The pump efficiency:'); disp(strcat("    ",n));