function [time,signal] = FGENread(filename)
% FGENread                       read a signal in a .ini file

%SIGNALGENREAD used to save data coming from the generator of functions in
%a .ini file

%   There are two sections in the file: the first is the header where we
%   find the value of sampling frequency, gain of the acquisition chain and
%   the repetition number (value) to ensure a continuous acquisition; the
%   second section is storing the values of the generated signal.
%   Temporal samples instants will be created by the sampling frequency and
%   the length of the acquired array (signal).

% add these following two lines in the main code
% [file,folder]=uigetfile('*.ini');
% filename=fullfile(folder,file);

ini=ini2struct(filename);
fsamp=str2double(split(ini.header.fcamp,';'));
signal=str2double(split(ini.signal.values,';'));

fsamp=fsamp(1);
if isnan(signal(end))
    signal(end)=[];
end

deltaT=1/fsamp;
% time=(deltaT:deltaT:length(signal)*deltaT)'; %if we want to start from dt
time=(0:deltaT:(length(signal)-1)*deltaT)';

end

