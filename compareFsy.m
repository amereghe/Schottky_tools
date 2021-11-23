%%Script to compare different values of synchrotron frequency to be
%%evaluated on the same plot: results to be overlapped to the same curve,
%%so the contribute to the motion can be considered quite independent from
%%the 'fs' value

%Setting parameters
fsamp=125*10^6; %sampling frequency of the signal
intTime=10*10^-6; %integration time
fs=([0.5865, 1.173, 2.346]*10^3)'; %synchrotron frequency ~1kHz
friv=2.167*10^6; %revolution frequency
Triv=1/friv; %revolution period
dt=1/fsamp; %temporal step
t=time(intTime,dt); %time vector
w=8*10^-9; %100ns: width of impulse/rect < (1/(2*friv))
n=size(t,1); %number of samples
df=fsamp/n; %frequency step
f=(0:df:fsamp-df)'; %frequency vector

%time modulation
taus=0.125*Triv; %width of space function (Triv!=cost.), must be <Triv/2=1/(2*friv)
%I choose tau/4 because it's 1st harmonic
tau1=taus*sin(2*pi*fs(1)*t);
tau2=taus*sin(2*pi*fs(2)*t);
tau3=taus*sin(2*pi*fs(3)*t);

%beatatron motion
qh=1.676; %horizontal tune (int+fract)
fb=qh*friv; %beatatron frequency
a0=0; %mean value of the modulation sinusoid
a=1; %amplitude of the modulation sinusoid
y=(a0+a*cos(2*pi*fb*t+pi/2)); %modulation sinusoid: transverse position


x=rectpuls(t,w); %longi unbunched
x11=x; %longi bunched with fs(1)
x12=x; %longi bunched with fs(2)
x13=x; %longi bunched with fs(3)

for i=1:n
    x=x+rectpuls(t-i*Triv,w); %longi unbunched
end

X=fft(x);

if taus~=0 %need to add n*1/friv where n is the array position

    for k=1:n
    	tau1(k)=k/friv+tau1(k);
    end

    for l=1:n
    	tau2(l)=l/friv+tau2(l);
    end

    for m=1:n
    	tau3(m)=m/friv+tau3(m);
    end

end

for j=1:n
    x11=x11+rectpuls(t-tau1(j),w); %longi bunched w/ fs(1)
end

for b=1:n
    x12=x12+rectpuls(t-tau2(b),w); %longi bunched w/ fs(2)
end

for d=1:n
    x13=x13+rectpuls(t-tau3(d),w); %longi bunched w/ fs(3)
end

x1=[t,x11,x12,x13];
X11=fft(x11);
X12=fft(x12);
X13=fft(x13);
X1=[f,X11,X12,X13];
plotTimesFreqfig(x1,X1);
title('Curves with different synchrotron frequency values');
legend('Longi Bunched w/ fs(1)','Longi Bunched w/ fs(2)','Longi Bunched w/ fs(3)');