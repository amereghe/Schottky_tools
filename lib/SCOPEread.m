function [times,signals] = SCOPEread(fileNames,lType,times,signals)
% SCOPEread             wrapper for the actual SCOPEread function. The wrapper
%                        simply loops over a list of files and saves data
%                        in colums

    %% input checks
    if (~exist('lType','var')), lType="SIG"; end
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
        [tmpTime,tmpSignals]=SCOPEreadActual(fileNames(iFile),lType);
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

function [XX,YY] = SCOPEreadActual(fileName,lType)
% SCOPEread             read data acquired with the RF SCOPE and saved in
%                          plain ASCII file (csv)

% An RF scope file contains (*.Wfm.csv):
% - only a column with data;
% - a line for every time entry;
% There is also a header file to be parsed.

    %% checks
    if (~exist('lType','var')), lType="SIG"; end
    if ( strcmpi(lType,"SIG") )
        fprintf("...time domain;\n");
    elseif (strcmpi(lType,"FFT") )
        fprintf("...frequency domain;\n");
    else
        error("...unrecognised file type %s! Available only FFT and SIG",lType);
    end

    %% parsing header file
    headerFileName=strrep(fileName,".Wfm","");
    fprintf("...parsing header file %s ...\n",headerFileName);
    TT=readcell(headerFileName,"delimiter",":");
    % generating XX array
    fKeys=string(TT);
    if ( strcmpi(lType,"SIG") )
        % - time resolution [s]
        index=find(strcmpi(fKeys,"Resolution"));
        if ( index>0 )
            myDelta=cell2mat(TT(index,2));
        else
            error("...unable to find Resolution in header file!");
        end
        % - min time [s]
        index=find(strcmpi(fKeys,"HardwareXStart"));
        if ( index>0 )
            myMin=cell2mat(TT(index,2));
        else
            error("...unable to find HardwareXStart in header file!");
        end
        % - max time [s]
        index=find(strcmpi(fKeys,"HardwareXStop"));
        if ( index>0 )
            myMax=cell2mat(TT(index,2));
        else
            error("...unable to find HardwareXStop in header file!");
        end
        XX=(myMin:myDelta:myMax-myDelta)';
    elseif (strcmpi(lType,"FFT") )
        % - min freq [Hz]
        index=find(strcmpi(fKeys,"FrequencyStart"));
        if ( index>0 )
            myMin=cell2mat(TT(index,2));
        else
            error("...unable to find FrequencyStart in header file!");
        end
        % - max freq [Hz]
        index=find(strcmpi(fKeys,"FrequencyStop"));
        if ( index>0 )
            myMax=cell2mat(TT(index,2));
        else
            error("...unable to find FrequencyStop in header file!");
        end
        % - freq resolution [Hz]
        index=find(strcmpi(fKeys,"SignalHardwareRecordLength"));
        if ( index>0 )
            nPoints=cell2mat(TT(index,2));
        else
            error("...unable to find SignalHardwareRecordLength in header file!");
        end
        myDelta=(myMax-myMin)/(nPoints-1);
        XX=(myMin:myDelta:myMax)';
    end
    fprintf("   ...done.\n");
   
    %% getting actual content
    fprintf("...parsing data file %s ...\n",fileName);
    YY=readmatrix(fileName);
    nValues=size(YY,1);
    nSignals=size(YY,2);
    fprintf("   ...done.\n");
    
    %% checks
    if ( length(XX)~=nValues )
        error("...something wrong at parsing! Different number of values between XX (%d) and YY (%d)",length(XX),nValues);
    end

    %% bye bye
    if ( nSignals==1 )
        fprintf("...acquired a single signal of %d values.\n",nValues);
    else
        fprintf("...acquired %d signals of %d values each.\n",nSignals,nValues);
    end

end
