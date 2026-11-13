clc;
clear;
close all;

% Load nist vtec
load("lab5_nist_vtec.mat")
vtec = readmatrix("lab5_nist_vtec.csv");

% Make Plot
figure;
plot(vtec(:, 1), vtec(:, 2), 'LineWidth', 1.2);
xlabel('Time UTC');
ylabel('VTEC');
title('Vertical Total Electron Content vs Time')
grid on;

% Vertical Lines
xline(14, Color='r')
xline(18, Color='r')
