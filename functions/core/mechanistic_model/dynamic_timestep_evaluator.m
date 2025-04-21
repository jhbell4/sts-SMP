function aug_state_updator = dynamic_timestep_evaluator(...
    human_param,actuator_param,seat_height,dt,timestep_divisions)
%EVALUATE_DYNAMIC_TIMESTEP Summary of this function goes here
%   Detailed explanation goes here

%% Default: Do not divide timestep
if nargin < 5
    timestep_divisions = 1;
end

%% Define Dynamics Functions
body_dyn = human_body_dynamics_torque(human_param,seat_height);
[act_dyn,torque_fun] = actuator_dynamics(actuator_param);

%% Calculate Timestep Information for Simulation
dt_integrate = dt / timestep_divisions;
dt22_integrate = dt_integrate^2 / 2;

%% Define Single Integration Step Evolver
single_ts_evolve = @(aug_state,input) single_timestep_evaluator(...
    aug_state,input,body_dyn,act_dyn,torque_fun,dt_integrate,dt22_integrate);

%% Define Final Updator
if timestep_divisions > 1
    aug_state_updator = @(aug_state,input) multiple_timestep_evaluator(...
        single_ts_evolve,aug_state,input,timestep_divisions);
else
    aug_state_updator = single_ts_evolve;
end

end

function aug_state_next = single_timestep_evaluator(...
    aug_state,input,body_dyn,act_dyn,torque_fun,dt,dt22)

%% Unpack Augmented State
theta = aug_state(1:3);
theta_d = aug_state(4:6);
gamma = aug_state(7:9);

%% Plug Into Dynamics
torque = torque_fun(theta,gamma);
theta_dd = body_dyn(theta,theta_d,torque);
gamma_d = act_dyn(torque,input);

%% Integrate Forward (Modified Forward Euler)
theta_next = theta + theta_d*dt + theta_dd*dt22;
theta_d_next = theta_d + theta_dd*dt;
gamma_next = gamma + gamma_d*dt;

%% Package Augmented State
aug_state_next = aug_state;
aug_state_next(1:3) = theta_next;
aug_state_next(4:6) = theta_d_next;
aug_state_next(7:9) = gamma_next;

end

function aug_state_end = multiple_timestep_evaluator(...
    single_ts_evolver,aug_state,input,step_count)

for step = 1:step_count
    aug_state = single_ts_evolver(aug_state,input);
end
aug_state_end = aug_state;

end