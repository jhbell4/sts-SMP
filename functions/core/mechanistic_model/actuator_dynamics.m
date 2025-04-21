function [act_dyn_func,torque_func] = ...
    actuator_dynamics(actuator_param)
%ACTUATOR_DYNAMICS Summary of this function goes here
%   Detailed explanation goes here

%% Unpack Actuator Parameters
T = actuator_param.time_constant;
k = actuator_param.stiffness;
Tk = T*k;

%% Define Series-Elastic Torque Function
torque_func = @(theta,gamma) k*(gamma - theta);

%% Define Actuator Dynamics (Actuator Velocity Function)
act_dyn_func = @(torque,input) (input - torque)/Tk;

end

% Dynamics:
% T k \gamma_dot + k (gammma - theta) = u
