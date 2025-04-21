function [RBF_set,RBF_eval,RBF_centers,RBF_count,...
    RBF_deriv_set] = ...
    RBF_3D_COM_generator_var_eps(cluster,COM_remap,COM_remap_deriv,eps)
%THETA_RBF_GENERATOR 
%% Unpack Clustering Metadata
center_list = cluster.cluster_metadata.centers;
std_list = cluster.cluster_metadata.stds;

RBF_centers = center_list;

%% Define Shape Parameters
shape_param_list = 1./(std_list)*eps;
% Manual Override
%shape_param_list(:) = 1/0.0317;

%% Define Number of RBFs
RBF_count = size(center_list,2);

%% Define RBF Set
RBF_set = cell(RBF_count,1);
RBF_deriv_set = cell(RBF_count,1);
for it = 1:RBF_count
    RBF_set{it} = RBF(center_list(:,it),shape_param_list(it),COM_remap);
    RBF_deriv_set{it} = RBF_deriv(center_list(:,it),shape_param_list(it),COM_remap,COM_remap_deriv);
end

%% RBF Evaluation
RBF_eval = @(x) evaluate_function_set(RBF_set,RBF_count,x);

end

function func_handle = RBF(center,shape_param,COM_remap)

func_handle = @(x) RBF_eval(center,shape_param,COM_remap(x));

end

function func_handle = ...
    RBF_deriv(center,shape_param,COM_remap,COM_remap_deriv)

func_handle = @(x) RBF_deriv_eval(center,shape_param,...
    COM_remap(x),COM_remap_deriv(x));

end

function RBF = RBF_eval(center,shape_param,COM)

RBF = exp(-(shape_param.*vecnorm(COM - center)).^2);

end

function RBF_deriv = RBF_deriv_eval(center,shape_param,COM,COM_deriv)

RBF_deriv_raw = ...
    RBF_eval(center,shape_param,COM) .* 2.* shape_param.*(center-COM);
RBF_deriv = [dot(COM_deriv.th1,RBF_deriv_raw);...
    dot(COM_deriv.th2,RBF_deriv_raw);...
    dot(COM_deriv.th3,RBF_deriv_raw)];

end