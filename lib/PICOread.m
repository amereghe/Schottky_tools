function [times,signals] = PICOread(fileNames,times,signals)
% PICOread             wrapper for the actual PICOread function. The wrapper
%                        simply loops over a list of files and saves data
%                        in colums

    %% input checks
    if ( exist("times","var") & ~exist("signals","var") )
        error("...you have provided a times array but not a signal array!");
    end
    if ( exist("signals","var") )
        nSignals=size(signals,2);
    else
        signals=missing(); nSignals=0;
    end
    if ( exist("times","var") )
        nTimes=size(times,2);
    else
        times=missing(); nTimes=0;
    end
    if ( nTimes~=nSignals )
        error("...inconsistent set of (already existing) signals: nTimes=%d, nSignals=%d",nTimes,nSignals);
    end
    
    %% actually parse files
    nParsedFiles=0;
    nParsedSignals=0;
    for iFile=1:length(fileNames)
        [tmpTime,tmpSignals]=PICOreadActual(fileNames(iFile));
        nTmpSignals=size(tmpSignals,2);
        if ( nTmpSignals==0 )
            warning("...no signal found in file!");
            continue
        end
        if ( nSignals==0 )
            % first signal(s) to be acquired
            times=tmpTime;
            signals=tmpSignals;
        else
            nVals=size(times,1); nCurrVals=size(tmpTime,1);
            if ( nVals<nCurrVals )
                % fill in existing columns with NaNs instead of 0.0
                times(nVals+1:nCurrVals,:)=NaN();
                signals(nVals+1:nCurrVals,:)=NaN();
            end
            for ii=1:nTmpSignals
                % only a time column per picofile
                times(1:nCurrVals,nSignals+ii)=tmpTime;
            end
            signals(1:nCurrVals,nSignals+1:nSignals+nTmpSignals)=tmpSignals;
            if ( nVals>nCurrVals )
                % fill in added columns with NaNs instead of 0.0
                times(nCurrVals+1:nVals,nSignals+nTmpSignals)=NaN();
                signals(nCurrVals+1:nVals,nSignals+nTmpSignals)=NaN();
            end
        end
        nParsedFiles=nParsedFiles+1;
        nParsedSignals=nParsedSignals+nTmpSignals;
        nSignals=nSignals+nTmpSignals;
    end
    
    %% output a summary
    fprintf("...acquired %d files, for a total of %d signals;\n",nParsedFiles,nParsedSignals);

end

function [time,signals] = PICOreadActual(fileName)
% PICOreadActual             read data acquired with a picoscope and saved in plain ASCII file

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
