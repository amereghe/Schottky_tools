function [ff,FF]=FFTme(time,signals)
    nPoints=length(time);
    fSamp=1/(time(2)-time(1));          % sampling frequency [Hz]
    df=fSamp/(nPoints-1);               % frequency step [Hz]
    ff=(0:df:fSamp)'-fSamp/2;           % frequency domain [Hz]
    FF=fftshift(fft(signals),1);        % FFT
end