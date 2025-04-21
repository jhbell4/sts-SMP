function [COM_remap,COM_remap_deriv] = COM_remap_define(human_param)
%UNTITLED2 Summary of this function goes here
%   Detailed explanation goes here

%% Define COM parameters
COM_param = COM_param_builder(human_param);

%% Define COM Remapping Functions
COM_remap = @(state) COM_eval_raw(state,COM_param);
COM_remap_deriv = @(state) COM_deriv_eval_raw(state,COM_param);


end

function COM_track = COM_eval_raw(state,param)

ps1 = param(1).*sin(state(1,:));
ps12 = param(2).*sin(state(1,:)+state(2,:));
ps123 = param(3).*sin(state(1,:)+state(2,:)+state(3,:));
pc1 = param(1).*cos(state(1,:));
pc12 = param(2).*cos(state(1,:)+state(2,:));
pc123 = param(3).*cos(state(1,:)+state(2,:)+state(3,:));

COM_track = [...
    -ps1 - ps12 - ps123;...
    pc1 + pc12 + pc123...
    ];

end

function COM_deriv = COM_deriv_eval_raw(state,param)

ps1 = param(1).*sin(state(1,:));
ps12 = param(2).*sin(state(1,:)+state(2,:));
ps123 = param(3).*sin(state(1,:)+state(2,:)+state(3,:));
pc1 = param(1).*cos(state(1,:));
pc12 = param(2).*cos(state(1,:)+state(2,:));
pc123 = param(3).*cos(state(1,:)+state(2,:)+state(3,:));

COM_deriv.th1 = [...
    -pc1 - pc12 - pc123;...
    -ps1 - ps12 - ps123...
    ];
COM_deriv.th2 = [...
    -pc12 - pc123;...
    -ps12 - ps123...
    ];
COM_deriv.th3 = [...
    -pc123;...
    -ps123...
    ];

end

function COM_param = COM_param_builder(human_param)

m1 = human_param.m1;
m2 = human_param.m2;
m3 = human_param.m3;
L1 = human_param.L1;
L2 = human_param.L2;
lc1 = human_param.lc1;
lc2 = human_param.lc2;
lc3 = human_param.lc3;

COM_param = NaN(1,3);

COM_param(1) = (m1*lc1+(m2+m3)*L1)/(m1+m2+m3);
COM_param(2) = (m2*lc2+m3*L2)/(m1+m2+m3);
COM_param(3) = (m3*lc3)/(m1+m2+m3);

end