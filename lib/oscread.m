function [time,signal] = oscread(filename)

%OSCREAD used to save data coming from the picoscope in a txt file
%   There are two columns in the file: the first column is related to the
%   temporal samples instants while the second column stores the respective
%   values of the signal at each time (row).

file=fopen(filename,'r');
h=textscan(file,'%s%s','headerlines',1);
fclose(file);
T=h{1,1}{1,1};
H=h{1,2}{1,1};


file=fopen(filename,'r');
a=textscan(file,'%n	%n %n %n %n','headerlines',3);
fclose(file);
A=cell2mat(a);


for j=size(A,2):-1:3
    if isnan(A(1,j))
        A(:,j)=[];
    end
end


str='(mV)';
ini='(ms)';

if strcmp(T,ini)
    time=10^-3*A(:,1);
else
    time=10^-6*A(:,1);
end

siz=size(A,2);
B=A(:,2:siz);

if strcmp(H,str)
    signal=10^-3*B;
else
    signal=B;
end

end
