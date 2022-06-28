function yy=GenerateRectangles(tt,yy,t0,AA,ww,AM)
    if ( ~exist('AM','var') ), AM=missing(); end
    for ii=1:length(ww)
        for jj=1:length(t0)
            myIndices=(t0(jj)-ww(ii)/2<=tt & tt<=t0(jj)+ww(ii)/2);
            mySig=AA(ii);
            if ( ~ismissing(AM) ), mySig=mySig*AM(jj); end
            yy(myIndices,ii)=yy(myIndices,ii)+mySig;
        end
    end
end
