clear; clc;

weight = 5.9135;
density = 998.02;
height = 0.12344;
g = 9.81;
diameter = 0.013462;

Area = (pi/4)*(diameter^2);

V = sqrt((weight+(density*height*g*Area))/(density*Area));
Q = V*Area;

Q_gpm = Q*15850;