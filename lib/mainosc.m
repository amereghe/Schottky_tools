fileread=fopen('template.ini','r');
filewrite=fopen('out.ini','w');

fsamp=125*10^6; % Hz
gain=1; % in range (1:6)
repeat=100; % 0 -> continuous (need to stop); >0 -> single

signal=lu; % values taken from main.m

signalgenwrite(filewrite,fileread,signal,fsamp,gain,repeat);