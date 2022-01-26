%% mainosc.m is used to take signals from main.m and use them as values in the .ini file

%file manipulation

fileread=fopen('template.ini','r');
filewrite=fopen('out.ini','w');

%% setting parameters

fsamp=125*10^6; % Hz --2bc
gain=1; % in range (1:6)
repeat=1; % 0 -> continuous (need to stop); >0 -> single
dt=1/fsamp; % temporal step
intTime=200*10^-6;
fsamp_pico=125*10^6; %Hz --2bc

%% from main.m

%setting desired signal
signal=lu; % values taken from main.m

%generation of the file .ini (need to add out.ini in your directory)
signalgenwrite(filewrite,fileread,signal,fsamp,gain,repeat);

%% file_IDs for reading

filename_fungen='511kHz_125_fgen.txt'; % --2bc
filename_pico='511kHz_125_pico_125.txt'; % --2bc
filename_schottky='511kHz_125_pico_125_up_up_hres.txt'; % --2bc

%% section used to generate some sinusoids in order to evaluate pico's  and pick-up performances

fpuls=[0.511,2.179,20.077]*10^6; % Hz --2bc
% fpuls=[0.468997,1.343040,1.756816,1.945041,2.209601,2.290283,2.753049,5.290283,7.543041,10.140529,12.577011,15.175314,17.577090,20.077017]*10^6;
[time,signal_m]=generatesin(fpuls,intTime,fsamp); % pass to funsin.m
n=size(time,1); %number of samples []
df=fsamp/n; %frequency step [Hz]
freqmat=(0:df:fsamp-df)'; %frequency vector [Hz]
FFT=fft(signal_m); % -- we can use also fftshift()? different spectra, maybe correct

%% generation tool

signalgenwrite(filewrite,fileread,signal_m,fsamp,gain,repeat); % generates a .ini file containing sin values

%% saving matrices and plot section (cropped&&normalized)

[T_sin,F_sin,t_sin,f_sin]=funsin(filename_fungen,filename_pico,fsamp_pico,fsamp,time,freqmat,signal_m,FFT,filename_schottky);
% here you can also add filename_schottky instead of filename_pico or as
% last input, but T_schottky_cropped should pass from (start:stop,3->4)
[start,stop]=cropsignal(T_sin(:,4)); % add other inputs
% if isempty(start)
%     start=1;
% end
T_schottky_cropped=T_sin(start:stop,4);
F_schottky_cropped=fft(T_schottky_cropped);
%crop also pico_only signals
[start_pico,stop_pico]=cropsignal(T_sin(:,3),0.075);
T_pico_cropped=T_sin(start_pico:stop_pico,3);
F_pico_cropped=fft(T_pico_cropped);
T_sin=padding(T_sin,T_pico_cropped);
F_sin=padding(F_sin,F_pico_cropped);
T_sin=padding(T_sin,T_schottky_cropped);
F_sin=padding(F_sin,F_schottky_cropped);
t_pico_cropped=(0:dt:(stop_pico-1)*dt)';
t_sin=padding(t_sin,t_pico_cropped);
t_schottky_cropped=(0:dt:(stop-1)*dt)';
t_sin=padding(t_sin,t_schottky_cropped);
df_pico=fsamp_pico/length(F_pico_cropped);
f_pico_cropped=(0:df_pico:fsamp-df)';
f_sin=padding(f_sin,f_pico_cropped);
df_schottky=fsamp_pico/length(F_schottky_cropped);
f_schottky_cropped=(0:df_schottky:fsamp-df)';
f_sin=padding(f_sin,f_schottky_cropped);
[T_sin(:,1),F_sin(:,1)]=normalize(T_sin(:,1),F_sin(:,1),df);
[T_sin(:,5),F_sin(:,5)]=normalize(T_sin(:,5),F_sin(:,5),df_pico);
[T_sin(:,6),F_sin(:,6),t_max,f_max]=normalize(T_sin(:,6),F_sin(:,6),df_schottky);
PlotTimesFreqfig(t_sin(:,[1 5 6]),f_sin(:,[1 5 6]),T_sin(:,[1 5 6]),F_sin(:,[1 5 6]));
% adapt also 'title' and 'legend'
title('Vertical Schottky response to sinusoid at fpuls = 20.077 MHz (fgen = 125 MHz, fsamp\_pico = 125 MHz), up\_down low res measure','FontSize',20);
% title('Sinusoids at fpuls = [0.511, 2.179, 20.077] MHz (fgen = 125 MHz, fsamp\_pico = 125 MHz), up\_down low res measure','FontSize',20);
legend('MATLAB\_norm','Pico\_only\_norm','Schottky\_cropped\_norm','FontSize',16); % 1->matlab, 3->pico_only, 5->schottky cropped
% FWHM=df*fwhm(f_sin(:,4),F_sin(:,4)); % --2bcontrolled and c

%% evaluate differences btw single fft and all fft
% signals without zeros between them
fpuls=[0.511,2.179,20.077]*10^6; % Hz --2bc
[time,signal_m]=generatesin(fpuls,intTime,fsamp); % pass to funsin.m
n=size(time,1); %number of samples []
df=fsamp/n; %frequency step [Hz]
freqmat=(0:df:fsamp-df)'; %frequency vector [Hz]
FFT=fft(signal_m); % -- we can use also fftshift()? different spectra, maybe correct
% single signals
[t1,signal1]=generatesin(fpuls(1),intTime,fsamp);
n1=size(t1,1);
df1=fsamp/n1;
freq1=(0:df1:fsamp-df1)';
FFT1=fft(signal1);
[t2,signal2]=generatesin(fpuls(2),intTime,fsamp);
n2=size(t2,1);
df2=fsamp/n2;
freq2=(0:df2:fsamp-df2)';
FFT2=fft(signal2);
[t3,signal3]=generatesin(fpuls(3),intTime,fsamp);
n3=size(t3,1);
df3=fsamp/n3;
freq3=(0:df3:fsamp-df3)';
FFT3=fft(signal3);
tt=padding(time,t1);
tt=padding(tt,t2);
tt=padding(tt,t3);
ff=padding(freqmat,freq1);
ff=padding(ff,freq2);
ff=padding(ff,freq3);
sig=padding(signal_m,signal1);
sig=padding(sig,signal2);
sig=padding(sig,signal3);
FFT_all=padding(FFT,FFT1);
FFT_all=padding(FFT_all,FFT2);
FFT_all=padding(FFT_all,FFT3);
PlotTimesFreqfig(tt,ff,sig,FFT_all);

%% +norm (to evaluate possible reflection of signal coming from up_down || down_up)

[T_sin,F_sin,t_sin,f_sin]=funsin(filename_fungen,filename_schottky,fsamp_pico,fsamp,time,freqmat,signal_m,FFT);
[signorm,fftnorm,t_max,ff]=normalize(T_sin,F_sin,df);
[start,stop]=cropsignal(signorm(:,3));
T_schottky_cropped=signorm(start(1):stop(end),3);
F_schottky_cropped=fft(T_schottky_cropped);
T_ss=padding(signorm,T_schottky_cropped);
F_ss=padding(fftnorm,F_schottky_cropped);
t_schottky_cropped=(0:dt:(stop-1)*dt)';
t_ss=padding(t_sin,t_schottky_cropped);
f_schottky_cropped=(0:df:fsamp-df)';
f_ss=padding(f_sin,f_schottky_cropped);
PlotTimesFreqfig(t_ss,f_ss,T_ss,F_ss);
% adapt also 'title' and 'legend'
title('Vertical Schottky response to sinusoid at fpuls = 20.077 MHz (fgen = 125 MHz, fsamp\_pico = 125 MHz), up\_down wideband measure','FontSize',20);
legend('MATLAB','fun\_gen','Schottky','Schottky cropped','FontSize',16);

%% plot only_pico && only Schottky (carefully match filenames with fpuls)

fpuls=[0.511,2.179,20.077]*10^6; % Hz --2bc
% single signals
[t1,signal1]=generatesin(fpuls(1),intTime,fsamp);
n1=size(t1,1);
df1=fsamp/n1;
freq1=(0:df1:fsamp-df1)';
FFT1=fft(signal1);
[t2,signal2]=generatesin(fpuls(2),intTime,fsamp);
n2=size(t2,1);
df2=fsamp/n2;
freq2=(0:df2:fsamp-df2)';
FFT2=fft(signal2);
[t3,signal3]=generatesin(fpuls(3),intTime,fsamp);
n3=size(t3,1);
df3=fsamp/n3;
freq3=(0:df3:fsamp-df3)';
FFT3=fft(signal3);

filename_fungen_1='511kHz_125_fgen.txt';
filename_fungen_2='2MHz_125_fgen.txt';
filename_fungen_3='20MHz_125_fgen.txt';
filename_pico_1='511kHz_125_pico_125.txt';
filename_pico_2='2MHz_125_pico_125.txt';
filename_pico_3='20MHz_125_pico_125.txt';
% select the modality and operation features
filename_schottky_1='511kHz_125_pico_125_up_up.txt';
filename_schottky_2='2MHz_125_pico_125_up_up.txt';
filename_schottky_3='20MHz_125_pico_125_up_up.txt';
% you can easily set up filename_schottky for the same frequency in
% different measure modalities: just use a single frequency so a single
% *_fungen and a single *_pico_125 file and modify also the legend related
% to the second plot (plot wideband, low res, high res)

[T_pico_schottky1,F_pico_schottky1,t_pico_schottky1,f_pico_schottky1]=funsin(filename_fungen_1,filename_pico_1,fsamp_pico,fsamp,t1,freq1,signal1,FFT1,filename_schottky_1);
[T_pico_schottky2,F_pico_schottky2,t_pico_schottky2,f_pico_schottky2]=funsin(filename_fungen_2,filename_pico_2,fsamp_pico,fsamp,t2,freq2,signal2,FFT2,filename_schottky_2);
[T_pico_schottky3,F_pico_schottky3,t_pico_schottky3,f_pico_schottky3]=funsin(filename_fungen_3,filename_pico_3,fsamp_pico,fsamp,t3,freq3,signal3,FFT3,filename_schottky_3);

pico_t=[t_pico_schottky1(:,3),t_pico_schottky2(:,3)];
pico_t=padding(pico_t,t_pico_schottky3(:,3));
pico_T=[T_pico_schottky1(:,3),T_pico_schottky2(:,3)];
pico_T=padding(pico_T,T_pico_schottky3(:,3));
pico_f=[f_pico_schottky1(:,3),f_pico_schottky2(:,3)];
pico_f=padding(pico_f,f_pico_schottky3(:,3));
pico_F=[F_pico_schottky1(:,3),F_pico_schottky2(:,3)];
pico_F=padding(pico_F,F_pico_schottky3(:,3));

schottky_t=[t_pico_schottky1(:,4),t_pico_schottky2(:,4)];
schottky_t=padding(pico_t,t_pico_schottky3(:,4));
schottky_T=[T_pico_schottky1(:,4),T_pico_schottky2(:,4)];
schottky_T=padding(pico_T,T_pico_schottky3(:,4));
schottky_f=[f_pico_schottky1(:,4),f_pico_schottky2(:,4)];
schottky_f=padding(pico_f,f_pico_schottky3(:,4));
schottky_F=[F_pico_schottky1(:,4),F_pico_schottky2(:,4)];
schottky_F=padding(pico_F,F_pico_schottky3(:,4));
% pico plot
PlotTimesFreqfig(pico_t,pico_f,pico_T,pico_F);
% adapt also 'title' and 'legend'
title('Pico signals at fpuls = [0.511,2.179,20.077] MHz (fgen = 125 MHz, fsamp\_pico = 125 MHz), up\_up wideband measure','FontSize',20);
legend('fpuls(1)','fpuls(2)','fpuls(3)','FontSize',16);
% schottky plot
PlotTimesFreqfig(schottky_t,schottky_f,schottky_T,schottky_F);
% adapt also 'title' and 'legend'
title('Schottky signals at fpuls = [0.511,2.179,20.077] MHz (fgen = 125 MHz, fsamp\_pico = 125 MHz), up\_up wideband measure','FontSize',20);
legend('fpuls(1)','fpuls(2)','fpuls(3)','FontSize',16);

%% saving matrices and plot section for matlab+fungen && matlab+pico+schottky

[T,F,t,f]=funsin(filename_fungen,filename_pico,fsamp_pico,fsamp,time,freqmat,signal_m,FFT,filename_schottky);
[signorm,fftnorm,t_max,ff]=normalize(T,F,df);
% PlotTimesFreqfig(t(:,[1 2]),f(:,[1 2]),T(:,[1 2]),F(:,[1 2]));
PlotTimesFreqfig(t(:,[1 2]),f(:,[1 2]),signorm(:,[1 2]),fftnorm(:,[1 2])); % norm. plot
% adapt also 'title' and 'legend'
title('Sinusoid at fpuls = 2.179 MHz (fgen = 125 MHz, fsamp\_pico = 125 MHz)','FontSize',20);
legend('MATLAB','fun\_gen','FontSize',16);
% adapt also 'title' and 'legend'
% PlotTimesFreqfig(t(:,[1 3 4]),f(:,[1 3 4]),T(:,[1 3 4]),F(:,[1 3 4]));
PlotTimesFreqfig(t(:,[1 3 4]),f(:,[1 3 4]),signorm(:,[1 3 4]),fftnorm(:,[1 3 4])); % norm. plot
title('Sinusoid at fpuls = 2.179 MHz up\_up (fgen = 125 MHz, fsamp\_pico = 125 MHz)','FontSize',20);
legend('MATLAB','pico\_only','pico\_schottky','FontSize',16);

%% section to plot RATIOS between signals: pico/matlab and schottky/matlab

[T,F,t,f]=funsin(filename_fungen,filename_pico,fsamp_pico,fsamp,time,freqmat,signal_m,FFT,filename_schottky);
[freqnew,ratio]=ratiofft(f,F);
PlotTimesFreqfig(t(:,[1 3]),freqnew,T(:,[1 3]),ratio(:,[3 4])); % ratio btw pico and matlab
% adapt also 'title' and 'legend'
title('Ratio between ffts','FontSize',20);
legend('pico/MATLAB','schottky/MATLAB','FontSize',16);

%% section used to generate gaussian pulse in order to evaluate pico's
intTime=intTime/3.5; % having declared intTime=200us in first rows of main
t=(-intTime/2:dt:intTime/2-dt)';
mu=0;
sigma=10^-5;
signal=exp(-(t-mu).^2/(2*sigma^2));
% signalgenwrite(filewrite,fileread,signal,fsamp,gain,repeat);
