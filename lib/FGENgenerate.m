function [tOut,sOut,nSamps] = FGENgenerate(fPuls,intTime,fSamp,lConcatenate,sigType,as,ws)
% FGENgenerate     generates some signals with full periods, such
%                        that each sinusoid can be repeated indefinitively

    %% parameters
    dt=1/fSamp;                            % time resolution [s]
    basicTime=(0:dt:intTime)';
    nSamples=size(basicTime,1);            % number of samples []
    nPulseFreqs=length(fPuls);
    if (~exist('lConcatenate','var')), lConcatenate=true; end
    if (~exist('sigType','var')), sigType="SIN"; end
    if (~exist('as','var')), as=ones(nPulseFreqs,1); end
    
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
        nSamps(ii)=FGENtruncate(basicTime,fPuls(ii));
        if ( nSamps(ii)==0 )
            error("...unable to find a proper truncation point for Fpulse=%g and Fsamp=%g!",...
                fPuls(ii),1/dt);
        end
        
        % sample signal
        tt=basicTime(1:nSamps(ii)-1);
        if ( strcmpi(extractBetween(sigType,1,3),"SIN") )
            sig=as(ii)*sin(2*pi*fPuls(ii)*tt);
        elseif ( strcmpi(extractBetween(sigType,1,3),"COS") )
            sig=as(ii)*cos(2*pi*fPuls(ii)*tt);
        elseif ( strcmpi(extractBetween(sigType,1,5),"GAUSS") )
            nCentres=floor(tt(end)*fPuls(ii));
            tau=(((1:nCentres)-0.5)/fPuls(ii)+tt(1))'; % central time of particle passage [s]
            sig=zeros(length(tt),1);
            sig=GenerateGaussians(tt,sig,tau,as(ii),ws(ii),missing(),0.5/fPuls(ii));
        end
        
        % store data
        if ( lConcatenate )
            tOut(iStore+1:iStore+nSamps(ii)-1)=tt+tLast+dt;
            sOut(iStore+1:iStore+nSamps(ii)-1)=sig;
            iStore=iStore+nSamps(ii)-1;
            tLast=tOut(iStore);
        else
            tOut(1:nSamps(ii),ii)=tt;
            sOut(1:nSamps(ii),ii)=sig;
        end
    end
    
    if ( lConcatenate )
        indices=(isnan(tOut));
        tOut=tOut(~indices);
        sOut=sOut(~indices);
    end

end
