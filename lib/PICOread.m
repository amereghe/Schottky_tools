function [time,signals] = PICOread(fileName)
% PICOread             read data acquired with a picoscope and saved in plain ASCII file

% A picoscope file contains:
% - a column with time, and up to 4 columns for the channels;
% - a line for every time entry;
% - three lines of header, eg:
%   "Tempo	Canale A"
%   "(us)	(V)"
%   ""

    fprintf("acquiring PICOscope plain ASCII file %s ...\n",fileName);

    %% parsing header
    fileID=fopen(fileName,'r');
    tmpLine=fgetl(fileID); % first line is skipped
    tmpLine=fgetl(fileID);
    fclose(fileID);
    units=split(string(tmpLine));
    T=units(1);
    V=units(2:end);
    
    %% getting actual content
    A=readmatrix(fileName,"NumHeaderLines",3);
    time=A(:,1);
    signals=A(:,2:end);
    nSignals=size(signals,2);
    nValues=size(signals,1);

    %% take into account units
    switch T
        case "(s)"
            fprintf("...time given in s: keep it as it is;\n");
        case "(ms)"
            time=1.0E-3*time;
            fprintf("...time given in ms: converting it to seconds;\n");
        case "(us)"
            time=1.0E-6*time;
            fprintf("...time given in us: converting it to seconds;\n");
        otherwise
            error("...unknown time unit in file: %s!",T);
    end
    for ii=1:nSignals
        switch V(ii)
            case "(V)"
                fprintf("...signal #%d given in V: keep it as it is;\n",ii);
            case "(mV)"
                signals(:,ii)=1.0E-3*signals(:,ii);
                fprintf("...signal #%d given in mV: converting it to V;\n",ii);
            case "(uV)"
                signals(:,ii)=1.0E-6*signals(:,ii);
                fprintf("...signal #%d given in uV: converting it to V;\n",ii);
            otherwise
                error("...unknown unit of signal #%d in file: %s!",V,ii);
        end
    end
    
    %% bye bye
    fprintf("...acquired %d signal(s) and %d values.\n",nSignals,nValues);

end
