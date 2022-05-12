function [tOut,sOut,nSamps] = FGENgenerateSinusoids(fPuls,intTime,fSamp,lConcatenate)
% FGENgenerateSinusoids     generates some sinusoids with full periods, such
%                             that each sinusoid can be repeated indefinitively

    %% parameters
    if (~exist('lConcatenate','var')), lConcatenate=true; end
    dt=1/fSamp;                            % time resolution [s]
    basicTime=(0:dt:intTime)';
    nSamples=size(basicTime,1);            % number of samples []
    nPulseFreqs=length(fPuls);
    
    %% output variables
    if ( lConcatenate )
        tOut=NaN(nSamples*nPulseFreqs,1);
        sOut=NaN(nSamples*nPulseFreqs,1);
        iStore=0; tLast=0;
    else
        tOut=NaN(nSamples,nPulseFreqs);
        sOut=NaN(nSamples,nPulseFreqs);
    end
    nSamps=NaN(nPulseFreqs,1);

    %% generate signals
    for ii=1:nPulseFreqs
        % find best truncation point
        % NB: if the first signal is being crunched, we have to consider 0!
        iStart=1;
        if ( lConcatenate && ii>1 ), iStart=2; end
        nSamps(ii)=FGENTruncate(basicTime(iStart:end),fPuls(ii));
        if ( nSamps(ii)==0 )
            error("...unable to find a proper truncation point for Fpulse=%g and Fsamp=%g!",...
                fPuls(ii),1/dt);
        end
        
        % sample signal
        tt=basicTime(iStart:nSamps(ii)+iStart-1);
        sig=sin(2*pi*fPuls(ii)*tt);
        
        % store data
        if ( lConcatenate )
            tOut(iStore+1:iStore+nSamps(ii))=tt+tLast;
            sOut(iStore+1:iStore+nSamps(ii))=sig;
            iStore=iStore+nSamps(ii);
            tLast=tOut(iStore);
        else
            tOut(1:nSamps(ii),ii)=tt;
            sOut(1:nSamps(ii),ii)=sig;
        end
    end

end
