function [tOut,sOut] = generatesin(fpuls,intTime,fsamp)

%GENERATESIN used to generate a  train of sin with full period

%   The aim of the code is to find an index in the (0:intTime) range to
%   produce a full period sinusoid to be repeated in the function
%   generator; then we can put more signal in the same array passing as
%   input a vector of frequencies 'fpuls'

dt=1/fsamp;
wl_increment=4;
t=(dt:dt:intTime)';

for ii=1:length(fpuls)
    y([1:length(t)],ii)=rem(t*fpuls(ii),1);
    [mini,ind]=sort(y);
    for jj=1:length(ind)
        if mod(ind(jj)+1,wl_increment)==0
            min_ind=ind(jj);
            break;
        end
    end
    tt=[0;t(1:min_ind)];
    sig=sin(2*pi*fpuls(ii)*tt);
    if ( ii==1 )
        tOut=tt;
        sOut=sig;
    else
        tOut=[tOut;tt(1:end)+tOut(end)+dt];
        sOut=[sOut;sig(1:end)];
    end
end

end
