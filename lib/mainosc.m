%% mainosc.m is used to take signals from main.m and use them as values in the .ini file

%file manipulation
fileread=fopen('template.ini','r');
filewrite=fopen('out.ini','w');

%% setting parameters

fsamp=125*10^6; % Hz
gain=1; % in range (1:6)
repeat=1; % 0 -> continuous (need to stop); >0 -> single
dt=1/fsamp; % temporal step
intTime=200*10^-6;

%% from main.m

%setting desired signal
signal=lu; % values taken from main.m

%generation of the file .ini (need to add out.ini in your directory)
signalgenwrite(filewrite,fileread,signal,fsamp,gain,repeat);

%% section used to generate some sinusoids in order to evaluate pico's  and pick-up performances

fpuls=2.179*10^6; % Hz
[time,signal_m]=generatesin(fpuls,intTime,fsamp); % pass to funsin.m
n=size(time,1); %number of samples []
df=fsamp/n; %frequency step [Hz]
freq=(0:df:fsamp-df)'; %frequency vector [Hz]
FFT=fft(signal_m);
% signalgenwrite(filewrite,fileread,signal,fsamp,gain,repeat); % generates a .ini file containing sin values
[T_sin,F_sin]=funsin(signal_m,FFT);

PlotTimesFreqfig(time,freq,T_sin,F_sin);
title('Siusoid at fpuls = 2.179 MHz','FontSize',20);
legend('MATLAB','fun_gen','picoscope','FontSize',16);

%% section used to generate gaussian pulse in order to evaluate pico's

t=(-intTime/2:dt:intTime/2)';
mu=0;
sigma=0.00001;
signal=exp(-(t-mu).^2/(2*sigma^2));
signalgenwrite(filewrite,fileread,signal,fsamp,gain,repeat);