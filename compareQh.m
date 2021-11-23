%%Script to compare different values of horizontal tune to be evaluated on
%%two different plots: the first one is related to the transversal
%%unbunched beam motion and the second to the bunched transversal motion

%furthermore we can also change 'friv' value to evaluate more different
%betatron frequencies

fsamp=125*10^6; %sampling frequency of the signal
intTime=20*10^-6; %integration time
fs=1.173*10^3; %synchrotron frequency ~1kHz
friv=2.167*10^6; %revolution frequency
Triv=1/friv; %revolution period
dt=1/fsamp; %temporal step
t=time(intTime,dt); %time vector
w=80*10^-9; %100ns: width of impulse/rect < (1/(2*friv))
n=size(t,1); %number of samples
df=fsamp/n; %frequency step
f=(0:df:fsamp-df)'; %frequency vector

%time modulation
taus=0.125*Triv; %width of space function (Triv!=cost.), must be <Triv/2=1/(2*friv)
%I choose tau/4 because it's 1st harmonic
tau=taus*sin(2*pi*fs*t);

%beatatron motion
qh=[1.656, 1.666, 1.676]; %horizontal tune (int+fract)
fb1=qh(1)*friv; %beatatron frequency
fb2=qh(2)*friv; %beatatron frequency
fb3=qh(3)*friv; %beatatron frequency
a0=0; %mean value of the modulation sinusoid
a=1; %amplitude of the modulation sinusoid
y1=(a0+a*cos(2*pi*fb1*t+pi/2)); %modulation sinusoid: transverse position
y2=(a0+a*cos(2*pi*fb2*t+pi/2)); %modulation sinusoid: transverse position
y3=(a0+a*cos(2*pi*fb3*t+pi/2)); %modulation sinusoid: transverse position


x=rectpuls(t,w); %longi unbunched
x1=x; %longi bunched

for i=1:n
    x=x+rectpuls(t-i*Triv,w); %longi unbunched
end

%X=fftshift(fft(x));
X=fft(x);

if taus~=0 %need to add n*1/friv where n is the array position
    for k=1:n
        tau(k)=k/friv+tau(k);
    end
end

for j=1:n
    x1=x1+rectpuls(t-tau(j),w); %longi bunched
end

%IMPeng: in this case I realize that to resolve the synchrotron frequency
%(~ 1kHz) I need much longer integration times than unbunched case
%IMPit: in questo caso mi rendo conto che per risolvere la freq. di
%sincrotrone (~1kHz) ho bisogno di tempi di integrazione molto maggiori
%rispetto all'unbunched

%X1=fftshift(fft(x1));
X1=fft(x1);

%trans unbunched e bunched: new signal modulated in phase by the tune
if qh(1)~=0 && qh(2)~=0 && qh(3)~=0 && a~=0
    z01=x.*y1; %trans unbunched
    z02=x.*y2;
    z03=x.*y3;
    %Z=fftshift(fft(z));
    Z01=fft(z01);
    Z02=fft(z02);
    Z03=fft(z03);

    z11=x1.*y1; %trans bunched
    z12=x1.*y2;
    z13=x1.*y3;
    %Z1=fftshift(fft(z1));
    Z11=fft(z11);
    Z12=fft(z12);
    Z13=fft(z13);

end

z0=[t,z01,z02,z03]; %trans unbunched matrix
Z0=[f,Z01,Z02,Z03]; %fft trans unbunched matrix
z1=[t,z11,z12,z13]; %trans bunched matrix
Z1=[f,Z11,Z12,Z13]; %fft trans bunched matrix

%plot
plotTimesFreqfig(z0,Z0);
title('Transversal unbunched curves with different horizontal tune values');
legend('qh=1.656','qh=1.666','qh=1.676')
hold on;
plotTimesFreqfig(z1,Z1);
title('Transversal bunched curves with different horizontal tune values');
legend('qh=1.656','qh=1.666','qh=1.676')