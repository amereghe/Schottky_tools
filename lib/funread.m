function [signal] = funread(filename)

%OSCREAD used to save data coming from the picoscope in a txt file
%   There are two columns in the file: the first column is related to the
%   temporal samples instants while the second column stores the respective
%   values of the signal at each time (row).

if(~exist('filename','file'))
        filename='out20,077MHz.txt';
end

file=fopen(filename,'r');
a=textscan(file,'%q'); %  one column and undefined rows as we do noot know f_sample a priori
aa=a{1,1};
aa(end)=strcat(aa(end),';');
b=split(aa,';');
bb=b(:,1);
signal=str2double(bb);

end
