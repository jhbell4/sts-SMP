function [local_CL_taylor,local_CL_simp] = ...
    calculate_local_systems_auto(model,SMP_lift,RBF_deriv_set,x_ref)
%CALCULATE_LOCAL_SYSTEMS Summary of this function goes here
%   Detailed explanation goes here

%% Calculate Closed-Loop Model
%A_CL = model.A - model.B*K;
A_CL = model.A;

%gamma_ref = second_derivative_penalty_optimize(x_ref,SMP_lift,A_CL);

%% Sample Membership Functions
%z_dummy = SMP_lift.eval(x_ref,gamma_ref);
z_dummy = SMP_lift.eval(x_ref);
%xgam_ref = z_dummy(2:10);
M = size(SMP_lift.RBF_centers,2);
phi = NaN(1,M+1);
for k = 0:M
    phi(k+1) = z_dummy(7*k+1);
end



%% Define Key Indices
x_it = NaN(M+1,6);
% gam_it = NaN(M+1,3);
% xgam_it = NaN(M+1,9);
phi_it = NaN(M+1,1);
for k = 0:M
    phi_it(k+1) = 7*k + 1;
    x_it(k+1,:) = 7*k + (2:7);
    % gam_it(k+1,:) = 10*k + (8:10);
    % xgam_it(k+1,:) = 10*k + (2:10);
end

%% Calculate Local Simple CL System
A_local_simp = zeros(6,6);
b_local_simp = zeros(6,1);
for k = 0:M
    A_local_simp = A_local_simp + ...
        phi(k+1)*A_CL(x_it(1,:),x_it(k+1,:));
    b_local_simp = b_local_simp + ...
        phi(k+1)*A_CL(x_it(1,:),phi_it(k+1));
end

%% Calculate Local Taylor CL System
A_local_taylor = A_local_simp;
b_local_taylor = b_local_simp;
for k = 1:M
    phi_d = [RBF_deriv_set{k}(x_ref).',zeros(1,3)];
    mod_mat = ( A_CL(x_it(1,:),phi_it(k+1)) + ...
        A_CL(x_it(1,:),x_it(k+1,:))*x_ref)*phi_d;
    A_local_taylor = A_local_taylor + mod_mat;
    b_local_taylor = b_local_taylor - mod_mat*x_ref;
end

%% Eigenvalue Post-Processing
[V_simp,D_simp] = eig(A_local_simp);
D_simp = diag(D_simp);
[~,sort_D_simp] = sort(abs(D_simp),'descend');
V_simp = V_simp(:,sort_D_simp);
D_simp = D_simp(sort_D_simp);

[V_taylor,D_taylor] = eig(A_local_taylor);
D_taylor = diag(D_taylor);
[~,sort_D_taylor] = sort(abs(D_taylor),'descend');
V_taylor = V_taylor(:,sort_D_taylor);
D_taylor = D_taylor(sort_D_taylor);

%% Equilibrium Point Calculation
eq_simp = (eye(6)-A_local_simp)\b_local_simp;
eq_taylor = (eye(6)-A_local_taylor)\b_local_taylor;

%% Packaging
local_CL_taylor.A = A_local_taylor;
local_CL_taylor.b = b_local_taylor;
local_CL_taylor.eval = @(xgam) A_local_taylor*xgam + b_local_taylor;
local_CL_taylor.eig_info.vals = D_taylor;
local_CL_taylor.eig_info.vecs = V_taylor;
local_CL_taylor.eig_info.equil = eq_taylor;

local_CL_simp.A = A_local_simp;
local_CL_simp.b = b_local_simp;
local_CL_simp.eval = @(xgam) A_local_simp*xgam + b_local_simp;
local_CL_simp.eig_info.vals = D_simp;
local_CL_simp.eig_info.vecs = V_simp;
local_CL_simp.eig_info.equil = eq_simp;

end

