%sidebandsFs is used to generate and plot all signals for a specified value
%of syncrotron frequencies, in order to compare them in terms of spectral
%shifts and resolution

fsamp=125*10^6; %sampling frequency of the signal
intTime = 2*10^-3; %integration time (OPT.)
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
q=1.667; %horizontal tune (int+fract)
a0=0; %mean value of the modulation sinusoid
a=1; %amplitude of the modulation sinusoid

%longitudinal bunched: fs~=0
lb=generate(fs(1),t,0,friv,w,taus,a0,a);
LB=abs(fft(lb));
lb1=generate(fs(2),t,0,friv,w,taus,a0,a);
LB1=abs(fft(lb1));
lb2=generate(fs(3),t,0,friv,w,taus,a0,a);
LB2=abs(fft(lb2));

T=(lb);
F=(LB);
[T,F]=padding(T,F,lb1,lb2,LB1,LB2);

PlotTimesFreqfig(t,f,T,F,friv);
legend('586.5 Hz','1173 Hz','2346 Hz','FontSize',16);
title('Longitudinal bunched at different synchrotron frequencies','FontSize',20);
