% {}~

%% include libraries
% pathToLibrary="lib";
% addpath(genpath(pathToLibrary));
% pathToLibrary="externals";
% addpath(genpath(pathToLibrary));

clear time ff signals FF fSamp df;

%% parse picoscope file
fileName="pico_signals\2022-05-13\20220513-0007.txt";
[time,signals] = PICOread(fileName);
nPoints=length(time);

%% get FFTs
fSamp=1/(time(2)-time(1));          % sampling frequency [Hz]
df=fSamp/(nPoints-1);               % frequency step [Hz]
ff=(0:df:fSamp)'-fSamp/2;           % frequency domain [Hz]
FF=fftshift(fft(signals),1);        % FFT

%% show signals
PlotTimesFreqfig(time,ff,signals,FF);
