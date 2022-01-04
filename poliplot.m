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
t1=time(intTime(1),dt); t2=time(intTime(2),dt); t3=time(intTime(3),dt); %time vectors [s]
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
lu=generate(0,t1,0,friv,w,taus,a0,a);
LU=fft(lu);
lu1=generate(0,t2,0,friv,w,taus,a0,a);
LU1=fft(lu1);
lu2=generate(0,t3,0,friv,w,taus,a0,a);
LU2=fft(lu2);

% longitudinal (sigma) bunched (off-momentum, RF on): fs~=0
lb=generate(fs,t1,0,friv,w,taus,a0,a);
LB=fft(lb);
lb1=generate(fs,t2,0,friv,w,taus,a0,a);
LB1=fft(lb1);
lb2=generate(fs,t3,0,friv,w,taus,a0,a);
LB2=fft(lb2);

% transverse (delta) unbunched (on-momentum): q~=0
tu=generate(0,t1,q,friv,w,taus,a0,a);
TU=fft(tu);
tu1=generate(0,t2,q,friv,w,taus,a0,a);
TU1=fft(tu1);
tu2=generate(0,t3,q,friv,w,taus,a0,a);
TU2=fft(tu2);

% transverse (delta) bunched (off-momentum, RF on): q~=0 && fs~=0
tb=generate(fs,t1,q,friv,w,taus,a0,a);
TB=fft(tb);
tb1=generate(fs,t2,q,friv,w,taus,a0,a);
TB1=fft(tb1);
tb2=generate(fs,t3,q,friv,w,taus,a0,a);
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
