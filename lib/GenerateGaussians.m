function yy=GenerateGaussians(tt,yy,t0,AA,sigT,tOn)
    for ii=1:length(sigT)
        if (~exist('tOn','var')), nSig=5; tOn=nSig*sigT(ii); end
        for jj=1:length(t0)
            myIndices=(t0(jj)-tOn<=tt & tt<=t0(jj)+tOn);
            yy(myIndices,ii)=yy(myIndices,ii)+AA(ii)/(sqrt(2*pi)*sigT(ii))*exp(-0.5*((tt(myIndices)-t0(jj))/sigT(ii)).^2);
        end
    end
end
