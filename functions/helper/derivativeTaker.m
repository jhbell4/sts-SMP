function [vVec,aVec] = derivativeTaker(xVec,samp_freq)
% Performs a finite difference approximation to calculate the derivatives.

if nargin < 2
    samp_freq = 1;
end

h = 1/samp_freq;

xC_m1 = xVec(1:end-2);
xC_0 = xVec(2:end-1);
xC_p1 = xVec(3:end);

vVecCore = 1/2*(xC_p1 - xC_m1 );
aVecCore = xC_m1 - 2*xC_0 + xC_p1;

v_1 = -3/2*xVec(1) + 2*xVec(2) - 1/2*xVec(3);
v_end = 1/2*xVec(end-2) - 2*xVec(end-1) + 3/2*xVec(end);

a_1 = 2*xVec(1) - 5*xVec(2) + 4*xVec(3) - 1*xVec(4);
a_end = -1*xVec(end-3) + 4*xVec(end-2) - 5*xVec(end-1) + 2*xVec(end);

vVec = [v_1;vVecCore;v_end]./h;
aVec = [a_1;aVecCore;a_end]./(h^2);

end