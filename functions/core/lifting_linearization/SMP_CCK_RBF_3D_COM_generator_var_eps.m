function [SMP_set,SMP_eval,RBF_centers,SMP_count] =...
   SMP_CCK_RBF_3D_COM_generator_var_eps(cluster,COM_remap,COM_remap_deriv,eps)
%THETA_THETAD_RBF_GENERATOR

%% Generate Theta RBFs
[RBF_3D_set,RBF_3D_eval,RBF_centers,RBF_3D_count] = ...
    RBF_3D_COM_generator_var_eps(cluster,COM_remap,COM_remap_deriv,eps);

%% Define SMP Metadata
SMP_count = (6+3+1)*(1+RBF_3D_count);

%% Define SMP Set
SMP_set = cell(SMP_count,1);

SMP_set{1} = @(x,gamma) ones(1,size(x,2));
for st_it = 1:6
    SMP_set{1+st_it} = @(x,gamma) x(st_it,:);
end
for gamma_it = 1:3
    SMP_set{1+6+gamma_it} = @(x,gamma) gamma(gamma_it,:);
end

for RBF_it = 1:RBF_3D_count
    SMP_set{(6+3+1)*RBF_it+1} = @(x,gamma) RBF_3D_set{RBF_it}(x);
    for st_it = 1:6
        SMP_set{(6+3+1)*RBF_it+1+st_it} = @(x,gamma) RBF_3D_set{RBF_it}(x).*x(st_it,:);
    end
    for gamma_it = 1:3
        SMP_set{(6+3+1)*RBF_it+1+6+gamma_it} = @(x,gamma) RBF_3D_set{RBF_it}(x).*gamma(gamma_it,:);
    end
end

%% Define Efficient SMP Evaluator
SMP_eval = @(x,gamma) SMP_RBF_evaluator(x,gamma,RBF_3D_eval,RBF_3D_count,SMP_count);

end

function SMP_eval = SMP_RBF_evaluator(x,gamma,RBF_3D_eval,RBF_3D_count,SMP_count)

data_count = size(x,2);
RBF_3D = RBF_3D_eval(x);

SMP_eval = NaN(SMP_count,data_count);

SMP_eval(1,:) = ones(1,data_count);
SMP_eval(2:7,:) = x(1:6,:);
SMP_eval(8:10,:) = gamma(1:3,:);

for it = 1:RBF_3D_count
    SMP_eval((6+3+1)*it+1,:) = RBF_3D(it,:);
    SMP_eval((6+3+1)*it+(2:7),:) = RBF_3D(it,:).*x(1:6,:);
    SMP_eval((6+3+1)*it+(8:10),:) = RBF_3D(it,:).*gamma(1:3,:);
end

end