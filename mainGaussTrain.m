% {}~

%% include libraries
% - include lib folder
pathToLibrary="lib";
addpath(genpath(pathToLibrary));
pathToLibrary="externals\ExternalMatLabTools";
addpath(genpath(pathToLibrary));

%% overall time and frequency domain
fsamp=125*10^6; %sampling frequency of the signal [Hz]
intTime=200*10^-6; %integration time of signal [s]
[tt,ff,dt,df]=StandardAxes(fsamp,intTime);

%% case of a single Gaussian, centred in t0=0s;
t0=0.0;
sigT=[100E-9 50E-9 20E-9 10E-9];
% sigT=10E-9;
sigF=1./(2*pi*sigT);
% AA=ones(size(sigT));
AA=sigT;

%% train of Gaussians
friv=2.167*10^6; %revolution frequency [Hz]
Triv=1/friv; %revolution period [s]
nCentres=round(intTime*friv); % number of full signals []
t0=((1:nCentres)/friv-intTime/2-intTime/(2*nCentres))';     % central time of particle passage [s]
intTime=nCentres*Triv;
% nPulses=1000;
% t0=((1:nPulses)/nPulses-0.5/nPulses)*intTime;
sigT=10E-9;
sigF=1./(2*pi*sigT);
AA=sigT;

%% legends
legends=strings(length(sigT),1);
for ii=1:length(sigT)
    legends(ii)=sprintf("\\sigma_t=% 5.1f ns; \\sigma_f=% 5.1f MHz",sigT(ii)*1E9,sigF(ii)*1E-6);
end

%% generate signals and plot
yy=zeros(size(tt,1),length(sigT));
yy=GenerateGaussians(tt,yy,t0,AA,sigT);
YY=fft(yy);
YY=fftshift(YY,1);
PlotTimesFreqfig(tt,ff,yy,YY);
legend(legends,"Location","best");
sgtitle(sprintf("fsamp=% 5.1f MHz, Tint=% 5.1f \\mus",fsamp*1E-6,intTime*1E6));

%% manipulate FFT
filterFFT=@(ff,fcut) (1i*ff/fcut)./(1+1i*ff/fcut);
% linspace=3:0.1:9;
% ffPlot=10.^linspace;
% figure();
% plot(ffPlot,filterFFT(ffPlot,10E6),".-");
% hold on ; plot(ffPlot,filterFFT(-ffPlot,10E6),".-");
% set(gca,'YScale','log'); set(gca,'XScale','log'); grid();
% xlabel("f [Hz]"); ylabel("Z(f) [\Omega]");
fcut=50E6; % cut frequency [Hz]
ZZ=YY.*filterFFT(ff,fcut);

%% inverse FFT to get signal and then FFT again
XX=ifftshift(ZZ,1); zz=ifft(XX);
% PlotTimesFreqfig(tt,ff,[yy zz],[YY ZZ]);
PlotTimesFreqfig(tt,ff,zz,ZZ);
legend(legends,"Location","best");
sgtitle(sprintf("fsamp=% 5.1f MHz, Tint=% 5.1f \\mus, fcut=%g Hz",fsamp*1E-6,intTime*1E6,fcut));
