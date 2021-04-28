% Pre-Lab "Written Out" Question: LD2 
% This code by Michael White
clear; clc;

% Setup parameters from temp = 25 C and initial velocity
density_kgm3 = 1.184; %kg/m3
dynVisc_kgms = 1.849e-5; %kg/m*s
velocity_ms = 40; %m/s

% Enter different diameters
bigDiam_in = 3.10; %in
smallDiam_in = 1.55; %in

% Convert diameters to meters
bigDiam_m = 0.0254*bigDiam_in; 
smallDiam_m = 0.0254*smallDiam_in;

% Part 1: Hollow Hemisphere - Flat Face Forward
% Calculate area and drag coefficient from Figure 3
part1.area_m2 = pi/4*bigDiam_m^2;
part1.dragCoeff = 1.42;

% Calculate drag force
part1.dragForce_N = part1.dragCoeff*0.5*density_kgm3*velocity_ms^2*part1.area_m2;

% Display results
disp('1. The Drag Force (N) for a Hollow Hemisphere - Flat Face Forward:');
disp(part1.dragForce_N);

% Part 2: Hollow Hemisphere - Curved Face Forward
% Calculate area and drag coefficient from Figure 3
part2.area_m2 = pi/4*bigDiam_m^2;
part2.dragCoeff = 0.38;

% Calculate drag force
part2.dragForce_N = part2.dragCoeff*0.5*density_kgm3*velocity_ms^2*part2.area_m2;

% Display results
disp('2. The Drag Force (N) for a Hollow Hemisphere - Curved Face Forward:');
disp(part2.dragForce_N);

% Part 3: Smooth Sphere - Big Diameter (3.10 inch)
% Calculate area and Reynolds number
part3.area_m2 = pi/4*bigDiam_m^2;
part3.reynolds = density_kgm3*velocity_ms*bigDiam_m/dynVisc_kgms; 

% Determine drag coefficient from Reynolds number of 2.0168e5 and Figure 5
part3.dragCoeff = 0.52;

% Calculate drag force
part3.dragForce_N = part3.dragCoeff*0.5*density_kgm3*velocity_ms^2*part3.area_m2;

% Display results
disp('3. The Drag Force (N) for a Smooth Hemisphere - Big Diameter (3.10 inch):');
disp(part3.dragForce_N);

% Part 4: Smooth Sphere - Small Diameter (1.55 inch)
% Calculate area and Reynolds number
part4.area_m2 = pi/4*smallDiam_m^2;
part4.reynolds = density_kgm3*velocity_ms*smallDiam_m/dynVisc_kgms; 

% Determine drag coefficient from Reynolds number of 1.0084e5 and Figure 5
part4.dragCoeff = 0.51;

% Calculate drag force
part4.dragForce_N = part4.dragCoeff*0.5*density_kgm3*velocity_ms^2*part4.area_m2;

% Display results
disp('4. The Drag Force (N) for a Smooth Sphere - Small Diameter (1.55 inch):');
disp(part4.dragForce_N);

% Part 5: Golf Ball - Big Diameter (3.10 inch)
% Calculate area and Reynolds number - this is a big golf ball :)
part5.area_m2 = pi/4*bigDiam_m^2;
part5.reynolds = density_kgm3*velocity_ms*bigDiam_m/dynVisc_kgms; 

% Determine drag coefficient from Reynolds number of 1.0084e5 and Figure 5
part5.dragCoeff = 0.24;

% Calculate drag force
part5.dragForce_N = part5.dragCoeff*0.5*density_kgm3*velocity_ms^2*part5.area_m2;

% Display results
disp('5. The Drag Force (N) for a Golf Ball (3.10 inch):');
disp(part5.dragForce_N);

% Display marked Figure 5 for reynolds numbers
imshow('PreLab-Figure5.JPG');