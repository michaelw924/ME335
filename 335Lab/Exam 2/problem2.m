clear;clc;
syms u(x,y) v(x,y) K x y

u = -K*y/(x^2+y^2);
v = K*x/(x^2+y^2);

u_diff = diff(u,x);
v_diff = diff(v,y);