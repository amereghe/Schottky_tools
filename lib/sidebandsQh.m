%sidebandsQh is used to generate and plot all signals for a specified value
%of horizontal tune, in order to compare them in terms of spectral shifts
%and resolution

fsamp=125*10^6; %sampling frequency of the signal
intTime = 200*10^-6; %integration time (OPT.)
fs=[1.173/2,1.173,2*1.173]*10^3; %synchrotron frequency ~1kHz
friv=2.167*10^6; %revolution frequency
Triv=1/friv; %revolution period
dt=1/fsamp; %temporal step
t=time(intTime,dt); %time vector (OPT.)
w=8*10^-9; %100ns: width of impulse/rect < (1/(2*friv))
n=size(t,1); %number of samples
df=fsamp/n; %frequency step
f=(0:df:fsamp-df)'; %frequency vector

%time modulation
taus=0.25*Triv; %width of space function (Triv!=cost.), must be <Triv/2=1/(2*friv)
%I choose tau/4 because it's 1st harmonic

%beatatron motion
q=[1.657,1.667,1.677]; %horizontal tune (int+fract)
a0=0; %mean value of the modulation sinusoid
a=1; %amplitude of the modulation sinusoid

% transverse unbunched: q~=0
tu=generate(0,t,q(1),friv,w,taus,a0,a);
TU=fft(tu);
tu1=generate(0,t,q(2),friv,w,taus,a0,a);
TU1=fft(tu1);
tu2=generate(0,t,q(3),friv,w,taus,a0,a);
TU2=fft(tu2);

T=(tu);
F=(TU);
[T,F]=padding(T,F,tu1,tu2,TU1,TU2);

PlotTimesFreqfig(t,f,T,F,friv);
legend('1.657','1.667','1.677','FontSize',14);
title('Transverse unbunched at different tune','FontSize',18);
