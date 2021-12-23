function [time,signal] = oscread(filename)

%OSCREAD used to save data coming from the picoscope in a txt file
%   There are two columns in the file: the first column is related to the
%   temporal samples instants while the second column stores the respective
%   values of the signal at each time (row).

if(~exist('filename','var'))
        filename='file.txt';
end

file=fopen(filename,'r');
A=fscanf(file,'%g %g',[2 inf]); % two columns and undefined rows as we do noot know f_sample a priori
fclose(file);

A=A';
time=A(:,1);
signal=A(:,2);

end

