function [time,signal] = generatesin(fpuls,intTime,fsamp)

%GENERATESIN used to generate a  train of sin with full period

%   The aim of the code is to find an index in the (0:intTime) range to
%   produce a full period sinusoid to be repeated in the function
%   generator; then we can put more signal in the same array passing as
%   input a vector of frequencies 'fpuls'

dt=1/fsamp;
wl_increment=4;
t=(dt:dt:intTime)';

for i=1:length(fpuls)
    y([1:length(t)],i)=rem(t*fpuls(i),1);
    [mini,ind]=sort(y);
    for i=1:length(ind)
        if mod(ind(i)+1,wl_increment)==0
            min_ind=ind(i);
            break;
        end
    end
    tt=[0;t(1:min_ind)];
    sig=zeros(length(tt),length(fpuls));
    for j=1:length(fpuls)
        sig(1:length(tt),j)=sin(2*pi*fpuls(j)*tt);
    end
    signal=[sig(:,1);sig(:,2)];
    for k=3:length(fpuls)
        signal=[signal;sig(:,k)];
    end
    time=(0:dt:(length(signal)-1)*dt)';
end


end
