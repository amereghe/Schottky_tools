function yy=GenerateGaussians(tt,yy,t0,AA,sigT,AM,trunc,tOn)
    if ( ~exist('AM','var') ), AM=missing(); end
    if ( ~exist('trunc','var') ), trunc=0.0; end
    if ( trunc<0 || trunc>1 ), error("truncation out of range: [0:1]!"); end
    for ii=1:length(sigT)
        if (~exist('tOn','var')), nSig=5; tOn=nSig*sigT(ii); end
        for jj=1:length(t0)
            myIndices=(t0(jj)-tOn<tt & tt<=t0(jj)+tOn);
            % update signal array only in case of non-zero indices
            if ( sum(myIndices)>0 )
                % update value at lower extreme only in case of first
                %    Gaussian
                if ( tt(1)==t0(jj)-tOn ), myIndices(1)=true; end
                mySig=AA(ii)/(sqrt(2*pi)*sigT(ii))*(exp(-0.5*((tt(myIndices)-t0(jj))/sigT(ii)).^2)-trunc);
                if ( trunc>0 ), mySig(mySig<0)=0.0; end
                if ( ~ismissing(AM) ), mySig=mySig*AM(jj); end
                yy(myIndices,ii)=yy(myIndices,ii)+mySig;
            end
        end
    end
end
