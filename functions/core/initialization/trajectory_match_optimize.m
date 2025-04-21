function gamma_init = trajectory_match_optimize(x_init,SMP_lift,A_cl,ref_traj)
%THIRD_DERIVATIVE_PENALTY_COST Summary of this function goes here
%   Detailed explanation goes here

%% Define How Many Steps to try to Match
steps_to_match = 100;

%% Breaking Down Lifted State
gamma_dummy = [0;0;0];
M = size(SMP_lift.RBF_centers,2);
z_0_gamma = SMP_lift.eval(x_init,gamma_dummy);

% Identify Membership Functions
phi_idxs = 10*(1:M) + 1;
phi = z_0_gamma(phi_idxs);

%% Construct G Inverse
G_inv = zeros(6,SMP_lift.count);
G_inv(:,(2:7)) = eye(6);

%% Construct Gamma Coefficient
G_gamma = zeros(SMP_lift.count,3);
G_gamma((8:10),:) = eye(3);
for i = 1:M
    G_gamma(10*i + (8:10),:) = phi(i)*eye(3);
end

%% Construct LHS and RHS for LSE
LHS = [];
RHS = [];
for t = 1:steps_to_match
    LHS = [LHS; G_inv*(A_cl^t)*G_gamma];
    RHS = [RHS; ref_traj(:,t+1) - G_inv*(A_cl^t)*z_0_gamma];
end

%% Least Squares
gamma_init = LHS\RHS;

end

