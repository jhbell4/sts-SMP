function one_h_vec = one_hot_row(id_number,count)
%ONE_HOT_ROW Summary of this function goes here
%   Detailed explanation goes here

one_h_vec = zeros(1,count);
if id_number <= count
    one_h_vec(id_number) = 1;
end

end

