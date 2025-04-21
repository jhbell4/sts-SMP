function new_A_mat = pole_correct_A_matrix(A_mat,threshold)
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here

A_dim = size(A_mat,1);

max_stable = 1 - threshold;
min_unstable = 1 + threshold;

%% Perform Eigenvalue Decomposition for A Matrix
[V,D] = eig(A_mat);

%% Test Eigenvalue Identity
change_flag = false;

for eig_it = 1:A_dim
    eig_now = D(eig_it,eig_it);
    eig_mag = abs(eig_now);
    if eig_mag > 1
        if eig_mag < min_unstable
            D(eig_it,eig_it) = eig_now / eig_mag * min_unstable;
            change_flag = true;
        end
    elseif eig_mag < 1
        if eig_mag > max_stable
            D(eig_it,eig_it) = eig_now / eig_mag * max_stable;
            change_flag = true;
        end
    end
end

%% Reconstruct A Matrix
if change_flag
    new_A_mat = V*D/V;
    new_A_mat = real(new_A_mat);
else
    new_A_mat = A_mat;
end

end