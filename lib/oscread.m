function [time,signal] = oscread(filename)

%OSCREAD used to save data coming from the picoscope in a txt file
%   There are two columns in the file: the first column is related to the
%   temporal samples instants while the second column stores the respective
%   values of the signal at each time (row).

if(~exist('filename','file'))
        filename='20,077MHz.txt';
end

file=fopen(filename,'r');
a=textscan(file,'%n	%n','headerlines',3); % % two rows and undefined columns as we do noot know f_sample a priori
A=cell2mat(a);

time=10^-6*A(:,1);
signal=A(:,2);

end
