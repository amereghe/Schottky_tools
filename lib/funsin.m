function [T,F,t,f] = funsin(file_fungen,file_pico,fsamp_pico,fsamp,time_matlab,freq_matlab,signal_matlab,sMATLAB,file_schottky)
%MAINSIN Summary of this function goes here
%   Detailed explanation goes here

signal_fungen=funread(file_fungen);
[time_pico,signal_pico]=oscread(file_pico);
if exist('file_schottky','var')
    [time_schottky,signal_schottky]=oscread(file_schottky);
end
n_fungen=length(signal_fungen);
n_pico=length(signal_pico);
df_fungen=fsamp/n_fungen;
df_pico=fsamp_pico/n_pico;

time_fungen=time_matlab;
freq_fungen=(0:df_fungen:fsamp-df_fungen)';
freq_pico=(0:df_pico:fsamp_pico-df_pico)';

T=padding(signal_matlab,signal_fungen);
T=padding(T,signal_pico);
if exist('file_schottky','var')
    T=padding(T,signal_schottky);
end
sFUNGEN=fft(signal_fungen);
sPICO=fft(signal_pico);
F=padding(sMATLAB,sFUNGEN);
F=padding(F,sPICO);
if exist('file_schottky','var')
    sSCHOTTKY=fft(signal_schottky);
    F=padding(F,sSCHOTTKY);
end

t=padding(time_matlab,time_fungen);
t=padding(t,time_pico);
if exist('file_schottky','var')
    t=padding(t,time_schottky);
end

f=padding(freq_matlab,freq_fungen);
f=padding(f,freq_pico);
if exist('file_schottky','var')
    f=padding(f,freq_pico);
end

end
