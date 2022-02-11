function [time,signal] = oscread(filename,ch)

%OSCREAD used to save data coming from the picoscope in a txt file
%   There are two columns in the file: the first column is related to the
%   temporal samples instants while the second column stores the respective
%   values of the signal at each time (row).

file=fopen(filename,'r');
h=textscan(file,'%s%s','headerlines',1);
fclose(file);
T=h{1,1}{1,1};
H=h{1,2}{1,1};

if(~exist('ch','var'))
        file=fopen(filename,'r');
        a=textscan(file,'%n %n','headerlines',3); % % two rows and undefined columns as we do noot know f_sample a priori
        fclose(file);
        A=cell2mat(a);
else
        file=fopen(filename,'r');
        a=textscan(file,'%n	%n %n','headerlines',3); % % three rows and undefined columns as we do noot know f_sample a priori
        fclose(file);
        A=cell2mat(a);
end


str='(mV)';
ini='(ms)';

if strcmp(T,ini)
    time=10^-3*A(:,1);
else
    time=10^-6*A(:,1);
end

if strcmp(H,str)
    signal=10^-3*A(:,2);
    if(exist('ch','var'))
        tmp=10^-3*A(:,3);
        signal=[signal,tmp];
    end
else
    signal=A(:,2);
    if(exist('ch','var'))
        tmp=A(:,3);
        signal=[signal,tmp];
    end
end

end
