function equal_lim_stack = manual_axis_equals(data_lim_stack,buffer)
%MANUAL_AXIS_EQUALS Takes axis data limits, and generates centered axis
%limits, with some buffer

%% Check Validity of Limits
if size(data_lim_stack,2)~=2
    error('Limits must have 2 elements (a max and a min)');
end
if ~min(data_lim_stack(:,1)<=data_lim_stack(:,2))
    error('Limit minima must be less than or equal to limit maxima.');
end

%% Default Buffer
if nargin < 2
    buffer = 0.1;
end

%% Characterize Data Limits
data_widths = data_lim_stack(:,2) - data_lim_stack(:,1);
data_centers = ( data_lim_stack(:,2) + data_lim_stack(:,1) )/2;
max_data_width = max(data_widths);

%% Characterize New Data Widths
new_data_width = (1+buffer)*max_data_width;

%% Generate New Limit Stacks
equal_lim_stack = [data_centers - new_data_width/2,...
    data_centers + new_data_width/2];

end

