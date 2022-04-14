function [] = oscwrite(time,signal,filename)

%OSCWRITE used to semd data to the picoscope in a txt file
%   There are two columns in the file: the first column is related to the
%   temporal samples instants while the second column stores the respective
%   values of the signal at each time (row).

if(~exist('filename','var'))
        filename='file.txt';
end

A=[time;signal];
file=fopen(filename,'wt');
fprintf(file,'% 15.8E % 15.8E\n',A); % %6.2g means that 1st column has format of 9 digit with 8 decimal
% file name, format matrix
fclose(file);

end

