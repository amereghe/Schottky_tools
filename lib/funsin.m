function [T,F,t,f] = funsin(file_fungen,file_pico,fsamp_pico,fsamp,time_matlab,freq_matlab,signal_matlab,sMATLAB)
%MAINSIN Summary of this function goes here
%   Detailed explanation goes here

signal_fungen=funread(file_fungen);
[time_pico,signal_pico]=oscread(file_pico);
n_fungen=length(signal_fungen);
n_pico=length(signal_pico);
dt_fungen=1/fsamp;
df_fungen=fsamp/n_fungen;
df_pico=fsamp_pico/n_pico;

time_fungen=(0:dt_fungen:n_fungen*dt_fungen)';
freq_fungen=(0:df_fungen:fsamp-df_fungen)';
freq_pico=(0:df_pico:fsamp_pico-df_pico)';

T=padding(signal_matlab,signal_fungen);
T=padding(T,signal_pico);
sFUNGEN=fft(signal_fungen);
sPICO=fft(signal_pico);
F=padding(sMATLAB,sFUNGEN);
F=padding(F,sPICO);

t=padding(time_matlab,time_fungen);
t=padding(t,time_pico);

f=padding(freq_matlab,freq_fungen);
f=padding(f,freq_pico);

end
