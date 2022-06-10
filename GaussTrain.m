% {}~

%% include libraries
% - include lib folder
pathToLibrary="lib";
addpath(genpath(pathToLibrary));
pathToLibrary="externals\ExternalMatLabTools";
addpath(genpath(pathToLibrary));

%% overall time and frequency domain
fsamp=125*10^6; %sampling frequency of the signal [Hz]
intTime=2*10^-3; %integration time of signal [s]
[tt,ff,dt,df]=StandardAxes(fsamp,intTime);

%% train of signals
friv=2.167*10^6; %revolution frequency [Hz]
Triv=1/friv; %revolution period [s]
fs=0; taus=0; 
qq=1.6667; a0=0.3; aa=0.01;
% ws=0; as=1; sigType="DELTA";
ws=10E-9; as=(ws*sqrt(2*pi)); sigType="GAUSSIAN";
[yy] = SimulatePartPassages(tt,friv,fs,taus,qq,a0,aa,sigType,as,ws);
YY=fft(yy);
YY=fftshift(YY,1); % ff=ff-mean(ff);
PlotTimesFreqfig(tt,ff,yy,YY,friv);

%% apply filter
filterFFT=@(ff,fcut) (1i*ff/fcut)./(1+1i*ff/fcut);
fcut=40E6; % cut frequency [Hz]
ZZ=YY.*filterFFT(ff,fcut);
XX=ifftshift(ZZ,1); zz=ifft(XX);
PlotTimesFreqfig(tt,ff,[yy zz],[YY ZZ]);
