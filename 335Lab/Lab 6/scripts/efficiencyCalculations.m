%% Work for Lab 6: Pump Efficieny
% This code written by Michael White, 4/21/2021
clear;clc;

% Read in data from lab
data.RPM_3500 = readtable('data3500.xlsx');
data.RPM_3000 = readtable('data3500.xlsx');
data.RPM_2500 = readtable('data3500.xlsx');
data.RPM_2000 = readtable('data3500.xlsx');
data.RPM_1500 = readtable('data3500.xlsx');

% Generate cell list for referencing data names
rpmList = {'RPM_3500','RPM_3000','RPM_2500','RPM_2000','RPM_1500'};

% Parameters
params.rho = 997.83; %kg/m3
params.g = 9.81; %m/s2
params.heightDiff_in = 3.75; %in

% Convert values to metric/angular velocity
params.heightDiff_m = params.heightDiff_in*0.0254;
for i = 1:length(rpmList)
    data.(char(rpmList(i))).motorActual_rad = data.(char(rpmList(i))).motorActual_RPM*2*pi/60;
    data.(char(rpmList(i))).deltaP_Pa_meas = data.(char(rpmList(i))).deltaP_inH20*249.088908; 
    data.(char(rpmList(i))).flow_m3s = data.(char(rpmList(i))).flow_GPM/15850.323141;
    data.(char(rpmList(i))).torque_Nm = data.(char(rpmList(i))).torque_lbft*1.35582;
end

% Calculate hydrostatic
params.heightDiffPress_Pa = params.rho*params.g*params.heightDiff_m;

% Calculate actual delta pressure considering hydrostatic and the mass flow
for i = 1:length(rpmList)
    data.(char(rpmList(i))).deltaP_Pa = data.(char(rpmList(i))).deltaP_Pa_meas-params.heightDiffPress_Pa;
    data.(char(rpmList(i))).massFlow_kgs = data.(char(rpmList(i))).flow_m3s*params.rho;
end

% Calculate the pressure and elevation head, as well as total head
for i = 1:length(rpmList)
    data.(char(rpmList(i))).elevHead_m = params.heightDiff_m.*[1 1 1 1 1]';
    data.(char(rpmList(i))).pressHead_m = data.(char(rpmList(i))).deltaP_Pa/(params.rho*params.g);
    data.(char(rpmList(i))).totalHead_m = data.(char(rpmList(i))).pressHead_m...
        + data.(char(rpmList(i))).elevHead_m;
end


% Find ideal work, actual work, and efficiency
for i = 1:length(rpmList)
    data.(char(rpmList(i))).workActual = data.(char(rpmList(i))).torque_Nm...
        .* data.(char(rpmList(i))).motorActual_rad;
    data.(char(rpmList(i))).workIdeal = data.(char(rpmList(i))).massFlow_kgs*params.g...
        .* data.(char(rpmList(i))).totalHead_m;
    data.(char(rpmList(i))).efficiency = data.(char(rpmList(i))).workIdeal...
        ./ data.(char(rpmList(i))).workActual;
end

figure;
for i = 1:length(rpmList)
    plot3(...
        data.(char(rpmList(i))).flow_GPM,...
        data.(char(rpmList(i))).motorActual_RPM,...
        data.(char(rpmList(i))).efficiency);
end

% % Display results in order requested on problem
% disp('The pressure head (in m):'); disp(ph);
% disp('The velocity head (in m):'); disp(vh);
% disp('The elevation head (in m):'); disp(eh);
% disp('The total head (in m):'); disp(th);
% disp('The actual work (in W):'); disp(W_actual);
% disp('The ideal shaft work (in W):'); disp(W_ideal);
% disp('The pump efficiency:'); disp(strcat("    ",n));