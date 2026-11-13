function [theta, r_sqrd] = l_regression(x, y)

%ADDME take the scalar linear regression of a data set

% l_regression initializes 

% theta - a column vector of 2 rows, 

% n - an integer with value of the length of input x
% x - input data
% y - output data

% it then calculates a_1 and a_o, the minimized values of a linear model J(theta) 

% this creates a best fit line for a set of data

% r_sqrd is then calculated using the linear model J(theta) = a_1.*x+a_o-y 

% r_sqrd is a number describing how much better the linear model fits a
% given data than the mean of said data set, higher r is better from 0 < r
% < 1

theta = zeros(2,1);
n = length(x);
x = x(:);
y = y(:);
a_1 = (n*sum(x.*y) - sum(x)*sum(y)) / (n*sum(x.^2) - sum(x)^2);

a_o = (sum(y)-a_1.*sum(x))/n;

theta = [a_o ;a_1];

r_sqrd = 1 - sum((y - (a_o + a_1*x)).^2) / sum((y - mean(y)).^2);

return
