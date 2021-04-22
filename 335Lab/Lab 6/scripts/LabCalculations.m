clear;clc;

% Readout Values
Q = 55.19; %GPM
delta_P_meas = 541.41; %in H20
height_diff = 3.75; %in
Torque_meas = 2.066; %lbf-ft
Motor_RPM = 3514.094; %RPM

% Parameters
rho = 997.83; %kg/m3
g = 9.81; %m/s2

% Convert values to metric
Q = Q/15850.323141; %m3/s
delta_P_meas = delta_P_meas*249.088908; %Pa
height_diff = height_diff*0.0254; %m
Torque_meas = Torque_meas*1.35582; %N*m
w = Motor_RPM*2*pi/60; %rad/s

% Calculate hydrostatic
hydrostatic = rho*g*height_diff;

% Calculate actual delta_P
delta_P = delta_P_meas-hydrostatic;

% Calculate mass flow
mdot = Q*rho; %kg/s

% Calculate the actual shaft work in watts
W_actual = Torque_meas*w; %Watts

% Calculate the pressure head
ph = (delta_P)/(rho*g); %m

% Calculate the velocity head
% vh = (V2^2-V1^2)/(2*g); %m
vh = 0; %m

% Calculate the elevation head
eh = height_diff; %m

% Calculat the total head
th = ph+vh+eh;

% Calculate the ideal shaft work, in watts and hp
W_ideal = mdot*g*(ph+vh+eh); %Watts

% Calculate the pump efficiency
n = W_ideal/W_actual*100; %percentage
n = strcat(num2str(n),'%');

% Display results in order requested on problem
disp('The pressure head (in m):'); disp(ph);
disp('The velocity head (in m):'); disp(vh);
disp('The elevation head (in m):'); disp(eh);
disp('The total head (in m):'); disp(th);
disp('The actual work (in W):'); disp(W_actual);
disp('The ideal shaft work (in W):'); disp(W_ideal);
disp('The pump efficiency:'); disp(strcat("    ",n));