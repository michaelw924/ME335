function [x40,y40,x60,y60,x80,y80,x100,y100,extra60] = acquireData()
% Read in excel data
x40 = readtable('x40');
y40 = readtable('y40');
x60 = readtable('x60');
y60 = readtable('y60');
extra60 = readtable('extra60');
x80 = readtable('x80');
y80 = readtable('y80');
x100 = readtable('x100');
y100 = readtable('y100');
end

