function model = koopman_CCK_LSQ_train_from_data_regularized(...
    g_eval,sim_dataset,lambda)
%KOOPMAN_LSQ_TRAIN_FROM_DYN

%% Unpack
A_state_prev = sim_dataset.state_aug.prev(1:6,:);
A_state_next = sim_dataset.state_aug.next(1:6,:);
A_act_prev = sim_dataset.state_aug.prev(7:9,:);
A_act_next = sim_dataset.state_aug.next(7:9,:);
input = sim_dataset.input;

%% Lift Data
A_zt = g_eval(A_state_prev,A_act_prev);
A_ztp1 = g_eval(A_state_next,A_act_next);

%% Regularization
z_size = size(A_zt,1);
%u_size = size(input,1);

reg_stable_input = lambda*eye(z_size);
reg_stable_input(1,:) = 1;

%% Calculate Autonomous Portions Piece-by-Piece
auto_output = [A_ztp1(2:7,:);A_ztp1(11:end,:)];
auto_output_size = size(auto_output,1);
auto_reg_stable_output = zeros(auto_output_size,z_size);

A_auto = [auto_output, auto_reg_stable_output]/[A_zt, reg_stable_input];

%% Calculate Actuator Portions
act_1_output = A_act_next(1,:);
act_2_output = A_act_next(2,:);
act_3_output = A_act_next(3,:);

act_1_input = [A_state_prev(1,:);A_act_prev(1,:);input(1,:)];
act_2_input = [A_state_prev(2,:);A_act_prev(2,:);input(2,:)];
act_3_input = [A_state_prev(3,:);A_act_prev(3,:);input(3,:)];

cf_1 = act_1_output/act_1_input;
cf_2 = act_2_output/act_2_input;
cf_3 = act_3_output/act_3_input;

%% Reconstruct Actuator Portions
A_act = zeros(3,z_size);
A_act(1,1+1) = cf_1(1); A_act(1,1+6+1) = cf_1(2);
A_act(2,1+2) = cf_2(1); A_act(2,1+6+2) = cf_2(2);
A_act(3,1+3) = cf_3(1); A_act(3,1+6+3) = cf_3(2);

B_act = zeros(3);
B_act(1,1) = cf_1(3);
B_act(2,2) = cf_2(3);
B_act(3,3) = cf_3(3);

%% Reconstruct Overall Matrices
one_row = zeros(1,z_size); one_row(1,1) = 1;
A = [one_row; A_auto(1:6,:); A_act; A_auto(7:end,:)];
B = [zeros(1+6,3);B_act;zeros(z_size-(1+6+3),3)];

%% Package
model.A = A;
model.B = B;

end

