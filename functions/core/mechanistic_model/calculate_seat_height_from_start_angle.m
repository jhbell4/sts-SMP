function seat_height = ...
    calculate_seat_height_from_start_angle(theta_0,hp,offset)
%CALCULATE_SEAT_HEIGHT_FROM_TRAJ Summary of this function goes here
%   Detailed explanation goes here

%% Default Offset of Zero
if nargin < 3
    offset = 0;
end

%% Calculate Butt Height
butt_height = hp.L1*cos(theta_0(1)) + hp.L2*cos(theta_0(1)+theta_0(2));

%% Calculate Seat Height
seat_height = butt_height + offset;


end

