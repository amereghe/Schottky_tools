%% program description
% The program generates and plots signals for three values of horizontal
% tune.
% The generated signals are transverse (delta) unbunched (on-momentum).

%% include libraries
% - include lib folder
pathToLibrary="lib";
addpath(genpath(pathToLibrary));

%% machine and beam parameters

% paramaters
fsamp=125*10^6; %sampling frequency of the signal [Hz]
intTime = 200*10^-6; %integration time of signal [s]
% fs=[1.173/2,1.173,2*1.173]*10^3; %synchrotron frequency ~1kHz [Hz]
friv=2.167*10^6; %revolution frequency [Hz]
Triv=1/friv; %revolution period [s]
dt=1/fsamp; %temporal step [s]
t=time(intTime,dt); %time vector [s]
w=8*10^-9; %100ns: width of impulse/rect < (1/(2*friv)) [s]
n=size(t,1); %number of samples []
df=fsamp/n; %frequency step [Hz]
f=(0:df:fsamp-df)'; %frequency vector [Hz]

% RF modulation (timing of particle passage)
taus=0.25*Triv; %width of space function (Triv!=cost.), must be <Triv/2=1/(2*friv) [s]
%I choose tau/4 because it's 1st harmonic

% beatatron motion
q=[1.657,1.667,1.677]; %horizontal tune (int+fract) []
a0=0; %mean value of the modulation sinusoid
a=1; %amplitude of the modulation sinusoid

%% generate signal and compute FFT

% transverse unbunched: q~=0
tu=generate(0,t,q(1),friv,w,taus,a0,a);
TU=fft(tu);
tu1=generate(0,t,q(2),friv,w,taus,a0,a);
TU1=fft(tu1);
tu2=generate(0,t,q(3),friv,w,taus,a0,a);
TU2=fft(tu2);

%% plot signals

T=padding(tu,tu1); T=padding(T,tu2); 
F=padding(TU,TU1); F=padding(F,TU2); 

PlotTimesFreqfig(t,f,T,F,friv);
legend('1.657','1.667','1.677','FontSize',16);
title('Transverse unbunched at different tune','FontSize',20);
