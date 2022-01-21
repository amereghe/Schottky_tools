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
filename_schottky='511kHz_125_pico_125_up_up.txt'; % --2bc

%% section used to generate some sinusoids in order to evaluate pico's  and pick-up performances

fpuls=0.511*10^6; % Hz --2bc
[time,signal_m]=generatesin(fpuls,intTime,fsamp); % pass to funsin.m
n=size(time,1); %number of samples []
df=fsamp/n; %frequency step [Hz]
freqmat=(0:df:fsamp-df)'; %frequency vector [Hz]
FFT=fft(signal_m); % -- we can use also fftshift()? different spectra, maybe correct

%% generation tool

signalgenwrite(filewrite,fileread,signal_m,fsamp,gain,repeat); % generates a .ini file containing sin values

%% saving matrices and plot section

[T_sin,F_sin,t_sin,f_sin]=funsin(filename_fungen,filename_schottky,fsamp_pico,fsamp,time,freqmat,signal_m,FFT);
[start,stop]=cropsignal(T_sin(:,3));
if isempty(start)
    start=1;
end
% if isempty(stop)
%     stop=size(T_sin,1);
% end
T_schottky_cropped=T_sin(start:stop,3);
F_schottky_cropped=fft(T_schottky_cropped);
T_sin=padding(T_sin,T_schottky_cropped);
F_sin=padding(F_sin,F_schottky_cropped);
t_schottky_cropped=(0:dt:(stop-1)*dt)';
t_sin=padding(t_sin,t_schottky_cropped);
f_schottky_cropped=(0:df:fsamp-df)';
f_sin=padding(f_sin,f_schottky_cropped);
PlotTimesFreqfig(t_sin,f_sin,T_sin,F_sin);
% adapt also 'title' and 'legend'
title('Vertical Schottky response to sinusoid at fpuls = 0.511 MHz (fgen = 125 MHz, fsamp\_pico = 125 MHz), up_up wideband measure','FontSize',20);
legend('MATLAB','fun\_gen','Schottky','Schottky cropped','FontSize',16);

%% saving matrices and plot section for matlab+fungen && matlab+pico+schottky

[T,F,t,f]=funsin(filename_fungen,filename_pico,fsamp_pico,fsamp,time,freqmat,signal_m,FFT,filename_schottky);
[signorm,fftnorm,t_max,ff]=normalize(T,F,df);
% PlotTimesFreqfig(t(:,[1 2]),f(:,[1 2]),T(:,[1 2]),F(:,[1 2]));
PlotTimesFreqfig(t(:,[1 2]),f(:,[1 2]),signorm(:,[1 2]),fftnorm(:,[1 2])); % norm. plot
% adapt also 'title' and 'legend'
title('Sinusoid at fpuls = 20.077 MHz (fgen = 125 MHz, fsamp\_pico = 125 MHz)','FontSize',20);
legend('MATLAB','fun\_gen','FontSize',16);
% adapt also 'title' and 'legend'
% PlotTimesFreqfig(t(:,[1 3 4]),f(:,[1 3 4]),T(:,[1 3 4]),F(:,[1 3 4]));
PlotTimesFreqfig(t(:,[1 3 4]),f(:,[1 3 4]),signorm(:,[1 3 4]),fftnorm(:,[1 3 4])); % norm. plot
title('Sinusoid at fpuls = 20.077 MHz up\_up (fgen = 125 MHz, fsamp\_pico = 125 MHz)','FontSize',20);
legend('MATLAB','pico\_only','pico\_schottky','FontSize',16);

%% section to plot RATIOS between signals: pico/matlab and schottky/matlab

[T,F,t,f]=funsin(filename_fungen,filename_pico,fsamp_pico,fsamp,time,freqmat,signal_m,FFT,filename_schottky);
[freqnew,ratio]=ratiofft(f,F);
PlotTimesFreqfig(t(:,[1 3]),freqnew,T(:,[1 3]),ratio(:,[3 4])); % ratio btw pico and matlab
% adapt also 'title' and 'legend'
title('Ratio between ffts','FontSize',20);
legend('pico/MATLAB','schottky/MATLAB','FontSize',16);

%% section used to generate gaussian pulse in order to evaluate pico's

t=(-intTime/2:dt:intTime/2)';
mu=0;
sigma=1;
signal=exp(-(t-mu).^2/(2*sigma^2));
signalgenwrite(filewrite,fileread,signal,fsamp,gain,repeat);
