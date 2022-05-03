function [tt,ff,dt,df]=StandardAxes(fsamp,intTime,lMid)
    if (~exist('lMid','var')), lMid=true; end
    
    % time domain
    dt=1/fsamp;          %temporal step [s]
    tt=(0:dt:intTime)';  %time vector [s]
    nn=size(tt,1);       %number of samples []
    
    % frequency domain
    df=fsamp/(nn-1);     %frequency step [Hz]
    ff=(0:df:fsamp)';    %frequency vector [Hz]
    
    if ( lMid )
        tt=tt-intTime/2;
        ff=ff-fsamp/2;
    end
end