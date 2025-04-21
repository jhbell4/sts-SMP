function A = koopman_LSQ_train_from_data_regularized(g_eval,dset,lambda)
%KOOPMAN_LSQ_TRAIN_FROM_DYN

%% Lift Data
gt = g_eval(dset.prev);
gtp1 = g_eval(dset.next);

%% Regularization
reg_stable_gt = lambda*eye(size(gt,1));
reg_stable_gtpt = zeros(size(gt,1));
reg_stable_gtpt(1,1) = lambda;

%% Calculate Koopman A Matrix
A = [gtp1, reg_stable_gtpt]/[gt, reg_stable_gt];

%% Correct Line 1 (SMP)
A(1,1) = 1;
A(1,2:end) = 0;

end

