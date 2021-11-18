%script generating 4 signals (longitudinal and transversal) for a single
%particle case with RF and without RF (bunched and unbunched case
%respectively);

%here follows a list of machine and beam parameters used to visualize
%signals

fsamp=125*10^6; %sampling frequency of the signal
intTime=10*10^-6; %integration time
fs=1.173*10^3; %synchrotron frequency ~1kHz
friv=2.167*10^6; %revolution frequency
Triv=1/friv; %revolution period
dt=1/fsamp; %temporal step
t=time(intTime,dt); %time vector
w=100*10^-9; %100ns: width of impulse/rect < (1/(2*friv))
n=size(t,1); %number of samples
df=fsamp/n; %frequency step
f=(0:df:fsamp-df)'; %frequency vector

%time modulation
taus=0.125*Triv; %width of space function (Triv!=cost.), must be <Triv/2=1/(2*friv)
%I choose tau/4 because it's 1st harmonic
tau=taus*sin(2*pi*fs*t);

%beatatron motion
qh=1.676; %horizontal tune (int+fract)
fb=qh*friv; %beatatron frequency
a0=0; %mean value of the modulation sinusoid
a=1; %amplitude of the modulation sinusoid
y=(a0+a*cos(2*pi*fb*t+pi/2)); %modulation sinusoid: transverse position


x=rectpuls(t,w); %longi unbunched
x1=x; %longi bunched

for i=1:n
    x=x+rectpuls(t-i*Triv,w); %longi unbunched
end

X=fftshift(fft(x));

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

X1=fftshift(fft(x1));

%trans unbunched e bunched: new signal modulated in phase by the tune
if qh~=0 && a~=0
    z=x.*y; %trans unbunched
    Z=fftshift(fft(z));
    z1=x1.*y; %trans bunched
    Z1=fftshift(fft(z1));
end

T=[t,x,x1,z,z1]; %matrix for time values
F=[f,X,X1,Z,Z1]; %matrix for frequency values

plotTimesFreqfig(T,F);
%title(['Intergration time=',num2str(T(end,1)+dt),'s']);
%title(['Sampling frequency=',num2str(fsamp),'Hz']);
%title(['Synchrotron frequency=',num2str(fs),'Hz']);
%title(['Betatron frequency @ (qh=1.676 & revolution frequency= 2.334 MHz)=',num2str(fb),'Hz']);
%title(['Avg. of the mod. sin=',num2str(a0),' maybe mA']);
%title(['Amp. of the mod. sin=',num2str(a),' maybe mA']);
%title(['Width of the spacing function=',num2str(taus),'s']);
