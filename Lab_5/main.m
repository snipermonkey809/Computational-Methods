clc;
clear;
close all; 

Part1_1;
regression_test();

data = readmatrix("lab5_nist_vtec.csv");
x = data(:, 1); %time
y = data(:, 2); %vtec
window = x >= 14 & x <= 18;

[theta, r_sqrd] = l_regression(x(window), y(window));
a0 = theta(1);
a1 = theta(2);



fprintf("a0 = %.6f, a1 = %.6f, r^2 = %.6f\n", a0, a1, r_sqrd);