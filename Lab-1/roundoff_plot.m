% Starter code for the round-off error plot (Week 3).
% Fill in every TODO.

k = 0.01;
F = 1;
Tinf = -F/2;

Ks = logspace(0, 14, 100);
Tdouble = zeros(size(Ks));
Tsingle = zeros(size(Ks));
bound_double = zeros(size(Ks));
bound_single = zeros(size(Ks));

for i = 1:length(Ks)
    K = Ks(i);
    A = [];                     % TODO: the stiffness matrix
    b = [];                     % TODO: the force vector

    u = [];                     % TODO: solve for u with your LU-based inverse
    Tdouble(i) = 0;             % TODO: T_mat = K*(u2 - u1)

    % single precision: do NOT convert back to double anywhere below
    As = single(A);
    bs = single(b);
    us = [];                    % TODO: the same solve, in single precision
    Tsingle(i) = 0;             % TODO: same formula, in single precision

    % rough error bound: the relative error in the solution is about cond*eps
    c = 0;                      % TODO: call your condition calculator
    bound_double(i) = c*eps;
    bound_single(i) = c*eps('single');
end

figure
loglog(Ks, abs(Tdouble - Tinf)/abs(Tinf), 'b', Ks, abs(Tsingle - Tinf)/abs(Tinf), 'r')
hold on
loglog(Ks, bound_double, 'b--', Ks, bound_single, 'r--')
hold off
grid on
xlabel('K')
ylabel('|T_{mat} - T_\infty| / |T_\infty|')
legend('double', 'single', 'cond*eps bound (double)', 'cond*eps bound (single)', ...
       'Location', 'south')
