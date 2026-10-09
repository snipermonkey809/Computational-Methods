%% ASEN 3502 Homework 4
% Starter code. Fill in every TODO, then create your pdf with
%
%   publish('hw4_starter.m', 'pdf')
%
% (rename the file if you like, e.g. hw4_<lastname>.m, and publish that).
% The pdf appears in a new |html| folder next to this file. Open it and
% check it before submitting.
%
% How |publish| works:
%
% * A line starting with |%%| begins a new section with a heading; the
%   headings make the table of contents at the top of the pdf.
% * Comment lines right after a |%%| line are formatted as text. Blank
%   comment lines separate paragraphs. Text between |$...$| is typeset as
%   LaTeX math, e.g. $x_{i+1} = x_i + h$, and |$$...$$| on its own line
%   gives a displayed equation. Use this for derivations.
% * Code output (anything without a semicolon, |disp|, |fprintf|) and
%   every figure are inserted after the section's code.
% * Local functions must be at the very end of the file, after all the
%   script code. They are printed in the pdf too.
%
% Type |doc publish| for more. If you prefer a Live Script (.mlx), the same
% layout applies and you can export to pdf from the Live Editor.
%
% Derivations may be typed as LaTeX in the comments, written in a Live
% Script, or done by hand and appended to the pdf.

%% Question 1(a): Euler update
% For the system $\{\dot x\} = \{f\}(t, \{x\})$, the explicit Euler
% update with step size $h$ is
% $$
% \{x_{n+1}\} = \{x_n\} + h\,\{f\}(t_n, \{x_n\}),
% \qquad t_{n+1} = t_n + h.
% $$
%% Question 1(b): Implementation
% The |euler| function is a local function at the end of this file.

%% Question 1(c): Harmonic oscillator
% TODO: implement the dynamics in the local function |osc_dyn|, then
% solve with h = 0.1 on [0 10].
[t, x] = euler(@osc_dyn, [0 10], [1; 0], 0.1);
figure
plot(t,x(:,1))
hold on
plot(t,cos(t))
xlabel('t')
ylabel('x_1(t)')
legend('Numerical', 'Exact')


%%
% The numerical solution tracks the exact solution $\cos t$ at first, but
% its amplitude grows with each cycle while the exact amplitude stays at 1.
% Explicit Euler adds a small amount of energy at every step, so the
% numerical solution spirals outward and the error grows with $t$. With
% $h = 0.1$ the amplitude reaches about 1.65 by $t = 10$.

%% Question 2: Verification
% TODO: derive the exact solution and the first-order system here, then
% implement the system in the local function |test_dyn| and the test in
% |test_ode|. When they work, this line should run without an error:
test_ode(@euler, 0.001, 2e-3)
disp('Euler passed the test.')

%% Question 3: Error trend
N = [10 20 40 80 160 320 640];
h = 1./N;
E_max = zeros(size(h));
for k = 1:numel(h)
    [t_k, x_k] = euler(@test_dyn, [0 1], [1; 1], h(k));
    E_max(k) = max(abs(x_k(:,1) - exp(t_k)));
end

figure
plot(h, E_max, 'o-')
xlabel('Step size h')
ylabel('Maximum absolute error')
grid on
snapnow

slope = log(E_max(end)/E_max(1)) / log(h(end)/h(1));
h_needed = h(end) * (1e-6/E_max(end))^(1/slope);
fprintf('Estimated slope: %.3f\n', slope)
fprintf('Estimated h for the error 1e-6: %.6g\n', h_needed)

%% Local functions
% These must stay at the end of the file.

function [t, x] = euler(dynamics, tspan, x0, h)
% EULER Explicit Euler integration of dx/dt = dynamics(t, x).
%   Same conventions as ode45: t is a column vector and x(i,:) is the
%   state at t(i).
    t = (tspan(1):h:tspan(2)).';
    x = zeros(length(t), length(x0));
    x(1,:) = x0;
    for i = 1:length(t)-1
        x(i+1,:) = x(i,:) + h * dynamics(t(i), x(i,:).').';
    end
end

function xdot = osc_dyn(t, x)
    xdot = [x(2); -x(1)]; 
end

function xdot = test_dyn(t, x)
% TEST_DYN First-order form of the test problem in Question 2.
    xdot = [x(2); x(1)]; 
end

function test_ode(integrator, h, E)
% TEST_ODE Raises an error unless integrator solves the test problem on
%   [0, 1] with maximum absolute error strictly less than E.
    [t, x]  =  integrator(@test_dyn, [0 1], [1; 1], h);
    max_error  =  max(abs(x(:,1) - exp(t)));
    assert(max_error < E, '%s failed: the maximum error %g is not below %g', ...
        func2str(integrator), max_error, E)
end
