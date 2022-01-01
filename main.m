%% program description
% The program generates and plots signals for a specific integration time.
% The generated signals are longitudinal/transverse (sigma/delta)
%   unbunched/bunched (on-momentum, off-momentum with RF on).

%% include libraries
% - include lib folder
pathToLibrary="lib";
addpath(genpath(pathToLibrary));

%% machine and beam parameters

% paramaters
fsamp=125*10^6; %sampling frequency of the signal [Hz]
intTime=2*10^-3; %integration time of signal [s]
fs=1.173*10^3; %synchrotron frequency ~1kHz [Hz]
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

% longitudinal (sigma) unbunched (on-momentum): fs=0
lu=generate(0,t,0,friv,w,taus,a0,a);
LU=fft(lu);

% longitudinal (sigma) bunched (off-momentum, RF on): fs~=0
lb=generate(fs,t,0,friv,w,taus,a0,a);
LB=fft(lb);
% lb2=generate(fs,t,0,friv,w,taus,1,a); %mean_value ~= 0
% LB2=fft(lb2);

% transverse (delta) unbunched (on-momentum): q~=0
tu=generate(0,t,q,friv,w,taus,a0,a);
TU=fft(tu);

% transverse (delta) bunched (off-momentum, RF on): q~=0 && fs~=0
tb=generate(fs,t,q,friv,w,taus,a0,a);
TB=fft(tb);
% tb2=generate(fs,t,q,friv,w,taus,1,a); %avg mod sin ~= 0
% TB2=fft(tb2);

%% plot signals

PlotTimesFreqfig(t,f,[lu,lb,tu,tb],[LU,LB,TU,TB],friv);
legend('lu','lb','tu','tb','FontSize',16);
title('intTime=2ms','FontSize',20);
