% Code by Michael White to calculate the measurement radii for Lab 2
clear;clc;

% Enter the diameter of the tube and number of equal areas
d_tube = 6.065; %inches
n = 5;

% Calculate total area of the tube
A_tube = (pi/4)*(d_tube^2);

% Find area for split regions
equal_area = A_tube/n;

% Find the radii to produce equal area regions
for i = 1:n
    if i > 1
        r(i) = sqrt((equal_area+pi*r(i-1)^2)/pi);
    else
        r(i) = sqrt(equal_area/pi);
    end
end

% Find the radii for measurements (area midpoint)
for i = 1:n
    if i > 1
        p(i) = sqrt(((r(i)^2)+(r(i-1)^2))/2);
    else
        p(i) = sqrt((r(i)^2)/2);
    end
end

% Display the results
display(p);