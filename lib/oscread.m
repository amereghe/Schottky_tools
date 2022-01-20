function [time,signal] = oscread(filename)

%OSCREAD used to save data coming from the picoscope in a txt file
%   There are two columns in the file: the first column is related to the
%   temporal samples instants while the second column stores the respective
%   values of the signal at each time (row).

% if(~exist(filename,'file'))
%         filename='20MHz_125_pico_up_down_lres.txt';
% end

file=fopen(filename,'r');
h=textscan(file,'%s %s','headerlines',1);
fclose(file);
H=h{1,2}{1,1};
file=fopen(filename,'r');
a=textscan(file,'%n	%n','headerlines',3); % % two rows and undefined columns as we do noot know f_sample a priori
fclose(file);
A=cell2mat(a);


str='(mV)';

time=10^-6*A(:,1);
if strcmp(H,str)
    signal=10^-3*A(:,2);
else
    signal=A(:,2);
end

end
