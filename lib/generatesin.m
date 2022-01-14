function [time,signal] = generatesin(fpuls,intTime,fsamp)

%GENERATESIN used to generate a sin with full period

%   The aim of the code is to find an index in the (0:intTime) range to
%   produce a full period sinusoid to be repeated in the function generator

dt=1/fsamp;
wl_increment=4;
t=(dt:dt:intTime)';
y=rem(t*fpuls,1);
[mini,ind]=sort(y);

for i=1:length(ind)
    if mod(ind(i)+1,wl_increment)==0
        min_ind=ind(i);
        break;
    end
end

time=[0;t(1:min_ind)];
signal=sin(2*pi*fpuls*time);

end
