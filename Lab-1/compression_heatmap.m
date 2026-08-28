% Starter code for the worst-loading-case heatmap (Week 2).
% Fill in every TODO.

f1 = 5000;  f2 = 1200;  f3 = 100;   % kN, the Week 1 loads
extra = 8000;                       % kN of additional load to be split up

A = [];  % TODO: the truss matrix from Week 1

% Your matrix probably has a zero on the diagonal, and LU without pivoting
% cannot handle that. If you get NaNs, reorder the equations (the rows of A,
% and the entries of b the same way) so that every pivot is nonzero.

[L, U] =                         % TODO: call your code to decompose ONCE, outside the loops

% To make the heatmap, we will loop through each "pixel" corresponding to values of f1, f2, and f3 and calculate the max compressive force at each case
N = 60;
df1 = linspace(0, extra, N);
df2 = linspace(0, extra, N);
maxcomp = nan(N, N);                % entries stay NaN where the split is invalid

for i = 1:N
    for j = 1:N
        d3 = extra - df1(i) - df2(j);
        if d3 < 0
            continue                % this split needs a negative load
        end
        b = [];                    % TODO: right hand side for these loads
        x = [];                    % TODO: find x with your LU based solver
        maxcomp(j,i) = 0;          % TODO: largest compressive force in any member
    end
end

figure
imagesc(df1, df2, maxcomp, 'AlphaData', ~isnan(maxcomp))  % leave invalid splits blank
set(gca, 'YDir', 'normal')
axis square
xlabel('FILL IN AXIS LABEL')           % TODO: fill in axis label
ylabel('FILL IN AXIS LABEL')           % TODO: fill in axis label
title('Maximum compressive axial force (kN)')
colorbar
