% {}~

%% include libraries
pathToLibrary="lib";
addpath(genpath(pathToLibrary));
pathToLibrary="externals";
addpath(genpath(pathToLibrary));

%% sampling parameters
% fPuls=[ 511.34E3 20.0145E6]; % [Hz]
fPuls=511.34E3; % [Hz]
intTime=200E-6; % [s]
fSamp=125E6; % [Hz]
lConcatenate=true;
% for Gaussian signals only
ws=50E-9; % sigma_time [s]
as=sqrt(2*pi)*ws;

%% generate sinusoidal signals
[tOut,sOut,nSamps] = FGENgenerate(fPuls,intTime,fSamp,lConcatenate);
if ( lConcatenate ), nPoints=sum(nSamps); else nPoints=nSamps; end

%% generate Gaussian train
[tOut,sOut,nSamps] = FGENgenerate(fPuls,intTime,fSamp,lConcatenate,"GAUSS",as,ws);
if ( lConcatenate ), nPoints=sum(nSamps); else nPoints=nSamps; end

%% get FFTs
ff=zeros(size(sOut)); FF=zeros(size(sOut));
for ii=1:size(sOut,2)
    df=fSamp/(nPoints(ii)-1);              %frequency step [Hz]
    ff(1:nPoints(ii),ii)=(0:df:fSamp)';    %frequency vector [Hz]
    FF(1:nPoints(ii),ii)=fft(sOut(1:nPoints(ii),ii));
end

%% FFT shift
for ii=1:size(sOut,2)
    ff(1:nPoints(ii),ii)=ff(1:nPoints(ii),ii)-fSamp/2;
    FF(1:nPoints(ii),ii)=fftshift(FF(1:nPoints(ii),ii),1);
end

% %% compare Gaussian train
% [myTime,myFreq,myDt,myDf]=StandardAxes(fSamp,intTime,false);
% myNSamps=size(myTime,1);
% tOut(1:myNSamps,size(sOut,2)+1)=myTime;
% sOut(1:myNSamps,size(sOut,2)+1)=SimulatePartPassages(myTime,fPuls,0,0,0,0,0,"GAUSS",as,ws);
% ff(1:myNSamps,size(ff,2)+1)=(0:myDf:fSamp)'-fSamp/2;
% FF(1:myNSamps,size(FF,2)+1)=fftshift(fft(sOut(1:myNSamps,size(sOut,2)) ),1);

%% plot signals and FFTs
PlotTimesFreqfig(tOut,ff,sOut,FF);

%% write to file
fixedName="sinusoid";
for ii=1:size(sOut,2)
    oFileName=GenOFileNameSingSignal(fixedName,fPuls(ii));
    % oFileName="";
    FGENwrite(oFileName,"template.ini",sOut(1:nPoints(ii),ii));
end

%% read back file and check
[time,signal] = FGENread("sinusoid_kHz511.340.ini");% [time,signal] = FGENread("out.ini");
dt=time(2)-time(1); fSamp=1/dt; df=fSamp/(length(signal)-1);
ffs=(0:df:fSamp)'-fSamp/2; FFs=fftshift(fft(signal),1);
nSig=size(sOut,2);
tOut(1:length(time),nSig+1)=time;
sOut(1:length(time),nSig+1)=signal;
ff(1:length(time),nSig+1)=ffs;
FF(1:length(time),nSig+1)=FFs;
PlotTimesFreqfig(tOut,ff,sOut,FF);

function oFileName=GenOFileNameSingSignal(fixedName,fPulse)
    if ( fPulse>1E6 )
        oFileName=sprintf("%s_MHz%07.3f.ini",fixedName,fPulse*1E-06);
    elseif ( fPulse>1E3 )
        oFileName=sprintf("%s_kHz%07.3f.ini",fixedName,fPulse*1E-03);
    else
        oFileName=sprintf("%s_Hz%g.ini",fixedName,fPulse);
    end
end