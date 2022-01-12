function [time,signal] = generatesin(fpuls,intTime,fsamp)

%GENERATESIN used to generate a sin with full period

%   The aim of the code is to find an index in the (0:intTime) range to
%   produce a full period sinusoid to be repeated in the function generator

dt=1/fsamp;
t=(dt:dt:intTime)';
y=rem(t*fpuls,1);
[mini,ind]=min(y);
time=[ 0 ; t(1:ind)];
signal=sin(2*pi*fpuls*time);

end
