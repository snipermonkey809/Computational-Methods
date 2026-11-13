function regression_test()
    tol = 1e-8;
    %on the line
    x = 0:4;
    y = 2* x + 1;
    
    [a0, a1, r2] = l_regression(x, y);

    assert(abs(a0 - 1) <= tol, 'on line failed: a0 = %0.10f, expected 1.', a0);
    assert(abs(a1 - 2) <= tol, 'on line failed: a1 = %0.10f, expected 2.', a1);
    assert(abs(r2 - 1) <= tol, 'on line failed: r2 = %0.10f, expected 1.', r2);

    %off the line
    x = [0; 1; 2; 3];
    y = [1; 0; 3; 2];
    [a0, a1, r2] = l_regression(x, y);

    assert(abs(a0 - 0.6) <= tol, 'off line failed: a0 = %0.10f, expected 0.6.', a0);
    assert(abs(a1 - 0.6) <= tol, 'off line failed: a1 = %0.10f, expected 0.6.', a1);
    assert(abs(r2 - 0.36) <= tol, 'off line failed: r2 = %0.10f, expected 0.36.', r2);

    fprintf('All regression tests passed.\n');
end
