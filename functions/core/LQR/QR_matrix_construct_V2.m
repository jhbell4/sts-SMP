function [Q,R] = QR_matrix_construct_V2(LQR_param,SMP_lift)
%QR_MATRIX_CONSTRUCT Constructs Q and R matrices for LQR optimization given
%tunable LQR parameters
%   LQR parameters breakdown:
%   LQR_param(1) = c (R matrix scalar)
%   LQR_param(2:3) = d_2, d_3 (R matrix shape changer)
%   LQR_param(3 + (1:M)) = b_1,...,b_M (Q matrix membership function
%   weights)
%   LQR_param(3+M + (1:5)) = a_02,...,a_06 (Q global state shape changer)
%   LQR_param(3+M + 5*k + (1:5)) = a_k2,...,a_k6 from k = 1 to M (Q
%   membership-function-specific state shape changer)
%   LQR_param(6*M + 8 + (1:3)) = a_07,...,a_09 (Q global act. state shape
%   changer)
%   LQR_param(6*M + 8 + 3*k + (1:3)) = a_k7,...,a_k9 (Q 
%   membership-function-specific act. state shape changer)
%   Total parameters: 9*M + 11 parameters needed

%% Ensure LQR_param is a Row Vector, or Transpose
if size(LQR_param,1) ~= 1
    LQR_param = LQR_param.';
end

%% Apply Log Correction
LQR_param = 10.^LQR_param;

%% Establish Number of Lifting Functions and Check Parameter List
M = size(SMP_lift.RBF_centers,2);
zdim = SMP_lift.count;
if length(LQR_param) ~= (9*M + 11)
    error('Number of LQR tuning parameters does not match number of membership functions.');
end

%% Construct R Matrix
R_vec = ones(1,3);

R_vec(2:3) = LQR_param(2:3);
R_vec = R_vec*LQR_param(1);

R = diag(R_vec);

%% Construct Q Matrix
Q_vec = zeros(1,zdim-1);

for k = 0:M
    it_off = 10*k + (1:9);
    shape_change = LQR_param(3+M + 5*k + (1:5));
    shape_act_change = LQR_param(6*M + 8 + 3*k + (1:3));
    Q_vec(it_off) = [1, shape_change, shape_act_change];
    if k > 0
        scale = LQR_param(3 + k);
        Q_vec(it_off) = Q_vec(it_off) * scale;
    end
end

Q = diag(Q_vec);

end

