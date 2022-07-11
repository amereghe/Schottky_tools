function yOut=dBme(yIn)
    yOut=NaN(size(yIn));
    for iSig=1:size(yIn,2)
        tmpSig=yIn(~isnan(yIn(:,iSig)),iSig);
        nPoints=length(tmpSig);
        yOut(1:nPoints,iSig)=20*log10((abs(tmpSig)/nPoints).^2./50*1E3);
    end
end
