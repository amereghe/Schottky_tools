function [ff,FF]=FFTme(time,signals)
    ff=NaN(size(time)); FF=NaN(size(signals));
    for iSig=1:size(signals,2)
        % arrays
        if ( iSig==1 || (iSig>1 && size(signals,2)==size(time,2) ) )
            tmpTime=time(~isnan(time(:,iSig)),iSig);
        end
        tmpSig=signals(~isnan(signals(:,iSig)),iSig);
        % dimension
        nPoints=length(tmpTime);
        % actual calculation
        fSamp=1/(tmpTime(2)-tmpTime(1));            % sampling frequency [Hz]
        df=fSamp/(nPoints-1);                       % frequency step [Hz]
        ff(1:nPoints,iSig)=(0:df:fSamp)'-fSamp/2;   % frequency domain [Hz]
        FF(1:nPoints,iSig)=fftshift(fft(tmpSig),1); % FFT
    end
end
