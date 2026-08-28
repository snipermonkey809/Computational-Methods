% Starter code for the condition number plot (Week 3).
% Fill in every TODO.

k = 0.01;
Ks = logspace(-2, 14, 100);
conds = zeros(size(Ks));

for i = 1:length(Ks)
    K = Ks(i);
    A = [];             % TODO: the stiffness matrix
    conds(i) = 0;       % TODO: call your condition calculator
end

figure
loglog(Ks, conds)
grid on
xlabel('K')
ylabel('condition number')
