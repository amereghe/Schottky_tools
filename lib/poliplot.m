fsamp=125*10^6; %sampling frequency of the signal
intTime = [2000,200,2]*10^-6; %integration time
fs=1.173*10^3; %synchrotron frequency ~1kHz
friv=2.167*10^6; %revolution frequency
Triv=1/friv; %revolution period
dt=1/fsamp; %temporal step
t1=time(intTime(1),dt); t2=time(intTime(2),dt); t3=time(intTime(3),dt); %time vectors
w=8*10^-9; %100ns: width of impulse/rect < (1/(2*friv))

f1=(0:fsamp/(size(t1,1)):fsamp*(1-1/(size(t1,1))))'; %frequency vector
f2=(0:fsamp/(size(t2,1)):fsamp*(1-1/(size(t2,1))))'; %frequency vector
f3=(0:fsamp/(size(t3,1)):fsamp*(1-1/(size(t3,1))))'; %frequency vector

%time modulation
taus=0.25*Triv; %width of space function (Triv!=cost.), must be <Triv/2=1/(2*friv)
%I choose tau/4 because it's 1st harmonic

%beatatron motion
q=1.667; %horizontal tune (int+fract)
a0=0; %mean value of the modulation sinusoid
a=1; %amplitude of the modulation sinusoid

%longitudinal unbunched: fs=0
lu=generate(0,t1,0,friv,w,taus,a0,a);
LU=10*abs(fft(lu));
lu1=generate(0,t2,0,friv,w,taus,a0,a);
LU1=10*abs(fft(lu1));
lu2=generate(0,t3,0,friv,w,taus,a0,a);
LU2=10*abs(fft(lu2));

%longitudinal bunched: fs~=0
lb=generate(fs,t1,0,friv,w,taus,a0,a);
LB=10*abs(fft(lb));
lb1=generate(fs,t2,0,friv,w,taus,a0,a);
LB1=10*abs(fft(lb1));
lb2=generate(fs,t3,0,friv,w,taus,a0,a);
LB2=10*abs(fft(lb2));

% transverse unbunched: q~=0
tu=generate(0,t1,q,friv,w,taus,a0,a);
TU=10*abs(fft(tu));
tu1=generate(0,t2,q,friv,w,taus,a0,a);
TU1=10*abs(fft(tu1));
tu2=generate(0,t3,q,friv,w,taus,a0,a);
TU2=10*abs(fft(tu2));

% transverse bunched: q~=0 && fs~=0
tb=generate(fs,t1,q,friv,w,taus,a0,a);
TB=10*abs(fft(tb));
tb1=generate(fs,t2,q,friv,w,taus,a0,a);
TB1=10*abs(fft(tb1));
tb2=generate(fs,t3,q,friv,w,taus,a0,a);
TB2=10*abs(fft(tb2));

%matrix to be passed and then plotted
t=(t1);
f=(f1);
[t,f]=padding(t,f,t2,t3,f2,f3);


T=(tb);
F=(TB);
[T,F]=padding(T,F,tb1,tb2,TB1,TB2);

PlotTimesFreqfig(t,f,T,F,friv);
title('Transverse bunched','FontSize',18);
legend('2ms','200us','20us','FontSize',14);
