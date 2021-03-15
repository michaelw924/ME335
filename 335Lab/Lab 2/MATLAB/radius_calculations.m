% Code by Michael White to calculate the measurement radii for Lab 2
clear;clc;

% Enter the diameter of the tube and number of equal areas
tubeDiam = 6.065; %inches
n = 5;

% Calculate total area of the tube
tubeArea = (pi/4)*(tubeDiam^2);

% Find area for split regions
equal_area = tubeArea/n;

% % Find the radii to produce equal area regions
for i = 1:n
    r(i) = (tubeDiam/2)*sqrt(i/n);
end

% Find the radii for measurements (area midpoint)
for i = 1:n
    p(i) = (tubeDiam/2)*sqrt(((2*i)-1)/(2*n));
end

% Display the results
display(p);