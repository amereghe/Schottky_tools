%% program description
% The program generates and plots signals for three values of synchrotron
% frequency.
% The generated signals are longitudinal (sigma) bunched (off-momentum with RF on).

%% include libraries
% - include lib folder
pathToLibrary="lib";
addpath(genpath(pathToLibrary));

%% machine and beam parameters

% paramaters
fsamp=125*10^6; %sampling frequency of the signal [Hz]
intTime = 2*10^-3; %integration time of signal [s]
fs=[1.173/2,1.173,2*1.173]*10^3; %synchrotron frequency ~1kHz [Hz]
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
q=1.667; %horizontal tune (int+fract) []
a0=0; %mean value of the modulation sinusoid
a=1; %amplitude of the modulation sinusoid

%% generate signal and compute FFT

% longitudinal (sigma) bunched (off-momentum, RF on): fs~=0
lb=generate(fs(1),t,0,friv,w,taus,a0,a);
LB=abs(fft(lb));
lb1=generate(fs(2),t,0,friv,w,taus,a0,a);
LB1=abs(fft(lb1));
lb2=generate(fs(3),t,0,friv,w,taus,a0,a);
LB2=abs(fft(lb2));

%% plot signals

[T,F]=padding(lb,LB,lb1,LB1);
[T,F]=padding( T, F,lb2,LB2);

PlotTimesFreqfig(t,f,T,F,friv);
legend('586.5 Hz','1173 Hz','2346 Hz','FontSize',16);
title('Longitudinal bunched at different synchrotron frequencies','FontSize',20);
