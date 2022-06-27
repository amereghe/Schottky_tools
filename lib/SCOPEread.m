function [XX,YY] = SCOPEread(fileName,lType)
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
