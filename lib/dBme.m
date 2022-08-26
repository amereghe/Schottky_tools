function yOut=dBme(yIn,myImpedance)
    if ( ~exist("myImpedance","var" ) ), myImpedance=50.0; end % default impedance: 50 Ohm
    yOut=NaN(size(yIn));
    for iSig=1:size(yIn,2)
        tmpFFT=yIn(~isnan(yIn(:,iSig)),iSig);
        nPoints=length(tmpFFT);
        yOut(1:nPoints,iSig)=10*log10(2*(tmpFFT/nPoints).*conj(tmpFFT/nPoints)/(2*myImpedance)*1E3);
    end
end
