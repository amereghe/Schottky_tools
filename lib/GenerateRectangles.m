function yy=GenerateRectangles(tt,yy,t0,AA,ww)
    for ii=1:length(ww)
        for jj=1:length(t0)
            myIndices=(t0(jj)-ww(ii)/2<=tt & tt<=t0(jj)+ww(ii)/2);
            yy(myIndices,ii)=yy(myIndices,ii)+AA(ii);
        end
    end
end
