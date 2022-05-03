% {}~

%% program description
% The program generates and plots signals for three integration times.
% The generated signals are longitudinal/transverse (sigma/delta)
%   unbunched/bunched (on-momentum, off-momentum with RF on), but those
%   shown are only the longitudinal unbunched ones.

%% include libraries
% - include lib folder
pathToLibrary="lib";
addpath(genpath(pathToLibrary));

%% machine and beam parameters

% paramaters
fsamp=125*10^6; %sampling frequency of the signals [Hz]
intTime = [2000,200,2]*10^-6; %integration time of signals [s]
fs=1.173*10^3; %synchrotron frequency ~1kHz [Hz]
friv=2.167*10^6; %revolution frequency [Hz]
Triv=1/friv; %revolution period [s]
dt=1/fsamp; %temporal step [s]
t1=(0:dt:intTime(1)-dt)'; t2=(0:dt:intTime(2)-dt)'; t3=(0:dt:intTime(3)-dt)'; %time vectors [s]
w=8*10^-9; %100ns: width of impulse/rect < (1/(2*friv)) [s]

f1=(0:fsamp/(size(t1,1)):fsamp*(1-1/(size(t1,1))))'; %frequency vector [Hz]
f2=(0:fsamp/(size(t2,1)):fsamp*(1-1/(size(t2,1))))'; %frequency vector [Hz]
f3=(0:fsamp/(size(t3,1)):fsamp*(1-1/(size(t3,1))))'; %frequency vector [Hz]

% RF modulation (timing of particle passage)
taus=0.25*Triv; %width of space function (Triv!=cost.), must be <Triv/2=1/(2*friv) [s]
%I choose tau/4 because it's 1st harmonic

%beatatron motion
q=1.667; %horizontal tune (int+fract) []
a0=0; %mean value of the modulation sinusoid
a=1; %amplitude of the modulation sinusoid

%% generate signal and compute FFT

% longitudinal (sigma) unbunched (on-momentum): fs=0
lu=SimulatePartPassages(t1,friv,0,0,0,a0,a,"DELTA",1,w);
LU=fft(lu);
lu1=SimulatePartPassages(t2,friv,0,0,0,a0,a,"DELTA",1,w);
LU1=fft(lu1);
lu2=SimulatePartPassages(t3,friv,0,0,0,a0,a,"DELTA",1,w);
LU2=fft(lu2);

% longitudinal (sigma) bunched (off-momentum, RF on): fs~=0
lb=SimulatePartPassages(t1,friv,fs,taus,0,a0,a,"DELTA",1,0);
LB=fft(lb);
lb1=SimulatePartPassages(t2,friv,fs,taus,0,a0,a,"DELTA",1,0);
LB1=fft(lb1);
lb2=SimulatePartPassages(t3,friv,fs,taus,0,a0,a,"DELTA",1,0);
LB2=fft(lb2);

% transverse (delta) unbunched (on-momentum): q~=0
tu=SimulatePartPassages(t1,friv,0,0,q,a0,a,"DELTA",1,0);
TU=fft(tu);
tu1=SimulatePartPassages(t2,friv,0,0,q,a0,a,"DELTA",1,0);
TU1=fft(tu1);
tu2=SimulatePartPassages(t3,friv,0,0,q,a0,a,"DELTA",1,0);
TU2=fft(tu2);

% transverse (delta) bunched (off-momentum, RF on): q~=0 && fs~=0
tb=SimulatePartPassages(t1,friv,fs,taus,q,a0,a,"DELTA",1,0);
TB=fft(tb);
tb1=SimulatePartPassages(t2,friv,fs,taus,q,a0,a,"DELTA",1,0);
TB1=fft(tb1);
tb2=SimulatePartPassages(t3,friv,fs,taus,q,a0,a,"DELTA",1,0);
TB2=fft(tb2);

%% plot signals

%matrix to be passed and then plotted
t=padding(t1,t2);
t=padding(t,t3);
f=padding(f1,f2);
f=padding(f,f3);


T=padding(lu,lu1);
T=padding(T,lu2);

F=padding(LU,LU1);
F=padding(F,LU2);

PlotTimesFreqfig(t,f,T,F,friv);
title('Transverse unbunched','FontSize',20);
legend('2ms','200us','20us','FontSize',16);
