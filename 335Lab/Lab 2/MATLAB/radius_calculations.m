% Code by Michael White to calculate the measurement radii and areas for Lab 2
clear;clc;

% Enter the diameter of the tube and number of equal areas
tubeDiam = 6.065; %inches
n = 5;

% Calculate total area of the tube
tubeArea_in = (pi/4)*(tubeDiam^2);

% Find area for split regions
equalArea_in = tubeArea_in/n;

% % Find the radii to produce equal area regions
for i = 1:n
    r(i) = (tubeDiam/2)*sqrt(i/n);
end

% Find the radii for measurements (area midpoint)
for i = 1:n
    p(i) = (tubeDiam/2)*sqrt(((2*i)-1)/(2*n));
end

% Convert equalArea and tubeArea to m^2
equalArea_m = equalArea_in*0.00064516;
tubeArea_m = tubeArea_in*0.00064516;

% Display the results
display(r);
display(p);
display(tubeArea_in);display(equalArea_in);
display(tubeArea_m);display(equalArea_m);