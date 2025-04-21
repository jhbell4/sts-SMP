function dyn_func = human_body_dynamics_torque(human_param,seat_height)
%HUMAN_BODY_DYNAMICS_TORQUE Summary of this function goes here
%   Detailed explanation goes here

[encode,decode] = unknowns_coding();

dyn_func = @(theta,theta_d,torque) dynamics_evaluate_with_decision_tree(...
    theta,theta_d,torque,human_param,encode,decode,seat_height);

end

function theta_dd = dynamics_evaluate_with_decision_tree(...
    theta,theta_d,torque,hp,en,de,seat_height)

%% Calculate Absolute Angles
alpha = [theta(1);theta(1)+theta(2);theta(1)+theta(2)+theta(3)];
alpha_d = [theta_d(1);theta_d(1)+theta_d(2);theta_d(1)+theta_d(2)+theta_d(3)];

%% Base-of-Support Correction
% Calculate Center-of-Mass x Position
s1 = sin(alpha(1));s2 = sin(alpha(2));s3 = sin(alpha(3));
x_COM = hp.m1*hp.lc1*s1 + hp.m2*(hp.L1*s1+hp.lc2*s2) + ...
    hp.m3*(hp.L1*s1+hp.L2*s2+hp.lc3*s3);

% Apply Base-of-Support Override (If Needed)
if (x_COM < hp.w1) || (x_COM > hp.w2)
    torque(1) = 0;
end

%% Calculate Linear Problem Definition
lin_prob_def = define_linear_problem(alpha,alpha_d,torque,hp,en);

%% Contact Decision Tree
if lin_prob_def.y23 > seat_height % No Contact
    % Calculate Free Case
    MAT = lin_prob_def.Free.MAT;
    vec = lin_prob_def.Free.vec;
    sol = MAT\vec;
else % Yes Contact
    % Calculate Static Case
    MAT = lin_prob_def.Static.MAT;
    vec = lin_prob_def.Static.vec;
    sol = MAT\vec;
    % Report Static Seat Interaction Forces
    FN_Static = sol(de.FN);
    Ffr_Static = sol(de.Ffr);

    if FN_Static <= 0 % Body is accelerating upward
        % Calculate Free Case
        MAT = lin_prob_def.Free.MAT;
        vec = lin_prob_def.Free.vec;
        sol = MAT\vec;
    elseif Ffr_Static > hp.mu_s*FN_Static % Body is sliding backward
        % Calculate Sliding-Backward Case
        MAT = lin_prob_def.SlideB.MAT;
        vec = lin_prob_def.SlideB.vec;
        sol = MAT\vec;
    elseif Ffr_Static < -hp.mu_s*FN_Static
        % Calculate Sliding-Forward Case
        MAT = lin_prob_def.SlideF.MAT;
        vec = lin_prob_def.SlideF.vec;
        sol = MAT\vec;
    end
end

%% Report Absolute Acceleration Solutions
alpha_dd = [sol(de.a1_dd);sol(de.a2_dd);sol(de.a3_dd)];

%% Calculate Relative Accelerations
theta_dd = [alpha_dd(1);alpha_dd(2)-alpha_dd(1);alpha_dd(3)-alpha_dd(2)];

end

function linear_problem_def = ...
    define_linear_problem(alpha,alpha_d,torque,hp,en)

%% Pre-Calculate Functions of Angle and Velocity
% Angles
c1 = cos(alpha(1)); s1 = sin(alpha(1));
c2 = cos(alpha(2)); s2 = sin(alpha(2));
c3 = cos(alpha(3)); s3 = sin(alpha(3));
% Velocities
a1_d2 = alpha_d(1).^2;
a2_d2 = alpha_d(2).^2;
a3_d2 = alpha_d(3).^2;

%% Define Equations
% Kinematic Equations
MAT_kin = [...
    en.x12_dd + hp.L1*c1*en.a1_dd;...%Eq 1 LHS
    en.y12_dd + hp.L1*s1*en.a1_dd;...%Eq 2 LHS
    -en.x12_dd + en.x23_dd + hp.L2*c2*en.a2_dd;...%Eq 3 LHS
    -en.y12_dd + en.y23_dd + hp.L2*s2*en.a2_dd;...%Eq 4 LHS
    en.xc1_dd + hp.lc1*c1*en.a1_dd;...%Eq 5 LHS
    en.yc1_dd + hp.lc1*s1*en.a1_dd;...%Eq 6 LHS
    -en.x12_dd + en.xc2_dd + hp.lc2*c2*en.a2_dd;...%Eq 7 LHS
    -en.y12_dd + en.yc2_dd + hp.lc2*s2*en.a2_dd;...%Eq 8 LHS
    -en.x23_dd + en.xc3_dd + hp.lc3*c3*en.a3_dd;...%Eq 9 LHS
    -en.y23_dd + en.yc3_dd + hp.lc3*s3*en.a3_dd...%Eq 10 LHS
    ];
vec_kin = [...
    hp.L1*s1*a1_d2;...%Eq 1 RHS
    -hp.L1*c1*a1_d2;...%Eq 2 RHS
    hp.L2*s2*a2_d2;...%Eq 3 RHS
    -hp.L2*c2*a2_d2;...%Eq 4 RHS
    hp.lc1*s1*a1_d2;...%Eq 5 RHS
    -hp.lc1*c1*a1_d2;...%Eq 6 RHS
    hp.lc2*s2*a2_d2;...%Eq 7 RHS
    -hp.lc2*c2*a2_d2;...%Eq 8 RHS
    hp.lc3*s3*a3_d2;...%Eq 9 RHS
    -hp.lc3*c3*a3_d2...%Eq 10 RHS
    ];
% Dynamic Equations
MAT_dyn = [...
    hp.m1*en.xc1_dd - en.R1x + en.R2x;...%Eq 11 LHS
    hp.m1*en.yc1_dd - en.R1y + en.R2y;...%Eq 12 LHS
    hp.I1*en.a1_dd - hp.lc1*(c1*en.R1x + s1*en.R1y) - (hp.L1-hp.lc1)*(c1*en.R2x + s1*en.R2y);...%Eq 13 LHS
    hp.m2*en.xc2_dd - en.R2x + en.R3x;...%Eq 14 LHS
    hp.m2*en.yc2_dd - en.R2y + en.R3y;...%Eq 15 LHS
    hp.I2*en.a2_dd - hp.lc2*(c2*en.R2x + s2*en.R2y) - (hp.L2-hp.lc2)*(c2*en.R3x + s2*en.R3y);...%Eq 16 LHS
    hp.m3*en.xc3_dd - en.R3x - en.Ffr;...%Eq 17 LHS
    hp.m3*en.yc3_dd - en.R3y - en.FN;...%Eq 18 LHS
    hp.I3*en.a3_dd - hp.lc3*( c3*(en.R3x+en.Ffr) + s3*(en.R3y+en.FN) )...%Eq 19 LHS
    ];
vec_dyn = [...
    0;...%Eq 11 RHS
    -hp.m1*hp.g;...%Eq 12 RHS
    torque(1) - torque(2);...%Eq 13 RHS
    0;...%Eq 14 RHS
    -hp.m2*hp.g;...%Eq 15 RHS
    torque(2) - torque(3);...%Eq 16 RHS
    0;...%Eq 17 RHS
    -hp.m3*hp.g;...%Eq 18 RHS
    torque(3);...%Eq 19 RHS
    ];

% Normal Contact Equation
MAT_contact = en.y23_dd;%Eq 20 LHS
vec_contact = 0;%Eq 20 RHS

% Friction Mode Equation (Variants)
MAT_fric_static = en.x23_dd;%Eq 21 LHS
vec_fric_static = 0;%Eq 21 RHS
MAT_fric_slideF = hp.mu_s*en.FN + en.Ffr;%Eq 21 LHS
vec_fric_slideF = 0;%Eq 21 RHS
MAT_fric_slideB = -hp.mu_s*en.FN + en.Ffr;%Eq 21 LHS
vec_fric_slideB = 0;%Eq 21 RHS

%% Construct Problem Definitions from Equations
% Free Problem (No Contact)
linear_problem_def.Free.MAT = [MAT_kin(:,1:19);MAT_dyn(:,1:19)];
linear_problem_def.Free.vec = [vec_kin;vec_dyn];

% Contact: Static Friction
linear_problem_def.Static.MAT = [MAT_kin;MAT_dyn;MAT_contact;MAT_fric_static];
linear_problem_def.Static.vec = [vec_kin;vec_dyn;vec_contact;vec_fric_static];

% Contact: Forward Sliding Kinetic Friction
linear_problem_def.SlideF.MAT = [MAT_kin;MAT_dyn;MAT_contact;MAT_fric_slideF];
linear_problem_def.SlideF.vec = [vec_kin;vec_dyn;vec_contact;vec_fric_slideF];

% Contact: Backward Sliding Kinetic Friction
linear_problem_def.SlideB.MAT = [MAT_kin;MAT_dyn;MAT_contact;MAT_fric_slideB];
linear_problem_def.SlideB.vec = [vec_kin;vec_dyn;vec_contact;vec_fric_slideB];

% Butt Height
linear_problem_def.y23 = hp.L1*c1 + hp.L2*c2;

end

function [encode,decode] = unknowns_coding()

%% Unknown Counts
unknown_count = 21;

%% One-Hot Encodings
% Angular Accelerations
encode.a1_dd = one_hot_row(1,unknown_count);
encode.a2_dd = one_hot_row(2,unknown_count);
encode.a3_dd = one_hot_row(3,unknown_count);
% Joint Accelerations
encode.x12_dd = one_hot_row(4,unknown_count);
encode.y12_dd = one_hot_row(5,unknown_count);
encode.x23_dd = one_hot_row(6,unknown_count);
encode.y23_dd = one_hot_row(7,unknown_count);
% Link COM Accelerations
encode.xc1_dd = one_hot_row(8,unknown_count);
encode.yc1_dd = one_hot_row(9,unknown_count);
encode.xc2_dd = one_hot_row(10,unknown_count);
encode.yc2_dd = one_hot_row(11,unknown_count);
encode.xc3_dd = one_hot_row(12,unknown_count);
encode.yc3_dd = one_hot_row(13,unknown_count);
% Reaction Forces
encode.R1x = one_hot_row(14,unknown_count);
encode.R1y = one_hot_row(15,unknown_count);
encode.R2x = one_hot_row(16,unknown_count);
encode.R2y = one_hot_row(17,unknown_count);
encode.R3x = one_hot_row(18,unknown_count);
encode.R3y = one_hot_row(19,unknown_count);
% Seat Interaction Forces
encode.FN = one_hot_row(20,unknown_count);
encode.Ffr = one_hot_row(21,unknown_count);

%% Retrieval IDs
decode.a1_dd = 1;
decode.a2_dd = 2;
decode.a3_dd = 3;
decode.x12_dd = 4;
decode.y12_dd = 5;
decode.x23_dd = 6;
decode.y23_dd = 7;
decode.xc1_dd = 8;
decode.yc1_dd = 9;
decode.xc2_dd = 10;
decode.yc2_dd = 11;
decode.xc3_dd = 12;
decode.yc3_dd = 13;
decode.R1x = 14;
decode.R1y = 15;
decode.R2x = 16;
decode.R2y = 17;
decode.R3x = 18;
decode.R3y = 19;
decode.FN = 20;
decode.Ffr = 21;

end