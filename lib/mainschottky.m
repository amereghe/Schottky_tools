%% file IDs

fOsc1='array_125_pico_125_2ch_up_down.txt';
fOsc2='array_125_pico_125_2ch_up_down_0dB_1dB.txt';
fOsc3='array_125_pico_125_2ch_up_down_0dB_8dB.txt';
fOsc4='array_125_pico_125_2ch_up_down_0dB_16dB.txt';

%% file reading and cropping of signals

ch=1;

[tt1,ss1]=oscread(fOsc1,ch); % add second input for 2chs mode
[tt2,ss2]=oscread(fOsc2,ch);
[tt3,ss3]=oscread(fOsc3,ch);
[tt4,ss4]=oscread(fOsc4,ch);

fsamp=125*10^6;
[start1,stop1]=cropsignal(ss1(:,1),0.15,20); % signal, thresh, nCons
[start2,stop2]=cropsignal(ss2(:,1),0.15,20); % signal, thresh, nCons
[start3,stop3]=cropsignal(ss3(:,1),0.15,20); % signal, thresh, nCons
[start4,stop4]=cropsignal(ss4(:,1),0.15,20); % signal, thresh, nCons

sig1=ss1(start1:stop1);
sig2=ss2(start2:stop2);
sig3=ss3(start3:stop3);
sig4=ss4(start4:stop4);

%% fft 

FFT1=fft(sig1);
n1=length(sig1);
ff1=(0:fsamp/n1:fsamp*(1-1/n1))';
t1=tt1(start1:stop1);
FFT2=fft(sig2);
n2=length(sig2);
ff2=(0:fsamp/n2:fsamp*(1-1/n2))';
t2=tt2(start2:stop2);
FFT3=fft(sig3);
n3=length(sig3);
ff3=(0:fsamp/n3:fsamp*(1-1/n3))';
t3=tt3(start3:stop3);
FFT4=fft(sig4);
n4=length(sig4);
ff4=(0:fsamp/n4:fsamp*(1-1/n4))';
t4=tt4(start4:stop4);

%% matrices

t=padding(t1,t2);
t=padding(t,t3);
t= padding(t,t4);

f=padding(ff1,ff2);
f=padding(f,ff3);
f=padding(f,ff4);

sig=padding(sig1,sig2);
sig=padding(sig,sig3);
sig=padding(sig,sig4);

FFT=padding(FFT1,FFT2);
FFT=padding(FFT,FFT3);
FFT=padding(FFT,FFT4);

%% plot of matrices

PlotTimesFreqfig(t,f,sig,FFT);
title('Vertical Schottky response to multiple sinusoids (fgen = 125 MHz, fsamp\_pico = 125 MHz), up\_down wideband measure','FontSize',20);
legend('0dB\_0dB','0dB\_1dB','0dB\_8dB','0dB\_16dB','FontSize',16);
