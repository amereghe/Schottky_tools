%here follows a list of machine and beam parameters used to visualize
%signals

%%configuration paramaters
fsamp=125*10^6; %sampling frequency of the signal
intTime=20*10^-6; %integration time
fs=1.173*10^3; %synchrotron frequency ~1kHz
friv=2.167*10^6; %revolution frequency
Triv=1/friv; %revolution period
dt=1/fsamp; %temporal step
t=time(intTime,dt); %time vector
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

%longitudinal unbunched: fs=0
lu=generate(0,t,0,friv,w,taus,a0,a);
LU=abs(fft(lu));

%longitudinal bunched: fs~=0
lb=generate(fs,t,0,friv,w,taus,a0,a);
LB=abs(fft(lb));
lb2=generate(fs,t,0,friv,w,taus,1,a); %mean_value~=0
LB2=abs(fft(lb2));

% tL=[t,lu,lb];%,lb2]; %matrix for time values
% fL=[f,LU,LB];%,LB2]; %matrix for frequency values

% transverse unbunched: q~=0
tu=generate(0,t,q,friv,w,taus,a0,a);
TU=abs(fft(tu));

%transverse bunched: q~=0 && fs~=0
tb=generate(fs,t,q,friv,w,taus,a0,a);
TB=abs(fft(tb));
tb2=generate(fs,t,q,friv,w,taus,1,a);
TB2=abs(fft(tb2));

aa=[t,lu,lb,tu,tb];
AA=[f,LU,LB,TU,TB];

% tT=[t,tu,tb];
% fT=[f,TU,TB];

plotTimesFreqfig(aa,AA,friv);
legend('lu','lb','tu','tb');
title('intTime=20ms');

aa=aa(:,2:4);
AA=AA(:,2:4);
newPlotTimesFreqfig(t,f,aa,AA,friv);
legend('lu','lb','tu','tb');
title('intTime=20ms');

% plotTimesFreqfig(tT,fT,friv);
% legend('tu','tb','tb2');
% title('Transversal signals');
