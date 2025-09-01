% Accuracy Metrics for 8×8 approximate multiplier

% Pre‑allocate accumulators
total_ED    = 0.0;      % sum of absolute errors
total_RED   = 0.0;      % sum of relative errors
sum_sq_err  = 0.0;      % sum of squared errors
err_cases   = 0;      % count of nonzero ED
nonzero_M   = 0;      % count of exact products ≠ 0
pred_count  = 0;      % count of cases with RED > threshold

% Constants
n          = 8;       % input operand width in bits
Mmax       = 255.0 * 255.0;
total_cases = 256.0 * 256.0;
thresh      = 0.02;   % 2% threshold for PRED

% Loop over all inputs
for A = 0:255
    for B = 0:255
        exact  = A * B;
        approx = propapproxmul8(A, B);
        
        ED = abs(approx - exact);
        sum_sq_err = sum_sq_err + ED^2;
        total_ED    = total_ED    + ED;
        if ED ~= 0
            err_cases = err_cases + 1;
        end
        
        if exact ~= 0
            nonzero_M = nonzero_M + 1;
            RED = double(ED) / double(exact);
            total_RED = total_RED + RED;
            if RED > thresh
                pred_count = pred_count + 1;
            end
        end
    end
end

% Basic metrics
ER   = double (err_cases)    / double(total_cases) * 100;       % in %
MRED = double(total_RED )   / double(total_cases);             % mean relative error distance
NMED = double(total_ED )    / (double(total_cases) * double(Mmax));      % normalized mean ED


RMSE = ( double(sum_sq_err) / double(total_cases) ).^0.5;
NoEB = 2*n - log2(1 + RMSE);
PRED = double(pred_count) / double(nonzero_M) * 100;           % in %

% Display
fprintf('Propapproxmul8 Accuracy Metrics:\n');
fprintf('------------------------------\n');
fprintf('Error Rate (ER)         : %.3f%%\n', ER);
fprintf('Mean RED (MRED)         : %.15f\n', MRED);
fprintf('NMED                    : %.8e\n', NMED);
fprintf('RMSE                    : %.8f\n', RMSE);
fprintf('Number of Effective Bits: %.4f bits\n', NoEB);
fprintf('PRED (>2%% RED)       : %.3f%%\n', PRED);

