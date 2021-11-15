function [t] = time(intTime,dt)

%TIME Summary of this function goes here

%   creation of vector times for plots, the first value represents the
%   integration time while the second is the time step given by the sampling 
%   frequency

    t=(0:dt:intTime-dt)';
    
end

