function stack_eval = evaluate_function_set(func_set,func_count,x)
%EVALUATE_FUNCTION_SET 

%% Find Input Count
input_count = size(x,2);

%% Define Output Array
stack_eval = NaN(func_count,input_count);

for it = 1:func_count
    stack_eval(it,:) = func_set{it}(x);
end

end