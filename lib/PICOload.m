function [time,ff,signals,FF]=PICOload(fileName,lPlot)
    if (~exist('lPlot','var')), lPlot=true; end

    %% parse picoscope file
    [time,signals] = PICOread(fileName);
    nPoints=length(time);

    %% get FFTs
    fSamp=1/(time(2)-time(1));          % sampling frequency [Hz]
    df=fSamp/(nPoints-1);               % frequency step [Hz]
    ff=(0:df:fSamp)'-fSamp/2;           % frequency domain [Hz]
    FF=fftshift(fft(signals),1);        % FFT

    %% show signals
    if ( lPlot ), PlotTimesFreqfig(time,ff,signals,FF); end
    
end