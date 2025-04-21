function [close_points,close_idxs,average_point] = ...
    find_points_near_function_output(points,func,ref,threshold)
%FIND_POINTS_NEAR_FUNCTION_OUTPUT Summary of this function goes here
%   Detailed explanation goes here

%% Evaluate Points with Function
func_pts = func(points);

%% Check within Threshold
check_within = vecnorm(func_pts-ref)<threshold;
close_points = points(:,check_within);
close_idxs = find(check_within);

%% Calculate Average Point
average_point = mean(close_points,2);

end

