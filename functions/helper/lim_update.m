function new_lim = lim_update(old_lim,data)
%LIM_UPDATE Summary of this function goes here
%   Detailed explanation goes here

if old_lim(2) < old_lim(1)
    error('Max of Limit is less than Min of Limit.');
end

max_data = max(data,[],"all");
min_data = min(data,[],"all");

new_lim = old_lim;

if ~(max_data <= old_lim(2))
    new_lim(2) = max_data;
end
if ~(min_data >= old_lim(1))
    new_lim(1) = min_data;
end

end

