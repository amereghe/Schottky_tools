function [T,F] = funsin(signal_matlab,sMATLAB)
%MAINSIN Summary of this function goes here
%   Detailed explanation goes here

filename='out2,179MHz.txt';
file='2,179MHz.txt';

n=length(signal_matlab);
signal_fungen=funread(filename);
[time_pico,signal_pico]=oscread(file);

signal_fungen=signal_fungen(1:n);
signal_pico=signal_pico(1:n);

T=padding(signal_matlab,signal_fungen);
T=padding(T,signal_pico);
sFUNGEN=fft(signal_fungen);
sPICO=fft(signal_pico);
F=padding(sMATLAB,sFUNGEN);
F=padding(F,sPICO);

end

