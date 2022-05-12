function yy=GenerateGaussians(tt,yy,t0,AA,sigT,nSig)
    if (~exist('nSig','var')), nSig=5; end
    for ii=1:length(sigT)
        for jj=1:length(t0)
            myIndices=(t0(jj)-nSig*sigT(ii)<=tt & tt<=t0(jj)+nSig*sigT(ii));
            yy(myIndices,ii)=yy(myIndices,ii)+AA(ii)/(sqrt(2*pi)*sigT(ii))*exp(-0.5*((tt(myIndices)-t0(jj))/sigT(ii)).^2);
        end
    end
end
