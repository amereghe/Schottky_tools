function [XXs,YYs] = ReadMany(fileNames,FileType,XXs,YYs)
    %% input checks
    if ( exist("MonType","var") | ismissing(FileType) ), FileType="PICO"; end
    if ( exist("XXs","var") & ~exist("YYs","var") )
        error("...you have provided a XXs array but not a signal array!");
    end
    if ( exist("YYs","var") )
        nYYs=size(YYs,2);
    else
        YYs=missing(); nYYs=0;
    end
    if ( exist("XXs","var") )
        nXXs=size(XXs,2);
    else
        XXs=missing(); nXXs=0;
    end
    if ( nXXs~=nYYs )
        error("...inconsistent set of (already existing) YYs: nXXs=%d, nYYs=%d",nXXs,nYYs);
    end
    
    %% actually parse files
    nParsedFiles=0;
    nParsedYYs=0;
    for iFile=1:length(fileNames)
        % - read file
        switch upper(FileType)
            case "PICO"
                [tmpXXs,tmpYYs]=PICOread(fileNames(iFile));
            case "RFSCOPE_FFT"
                [tmpXXs,tmpYYs]=SCOPEread(fileNames(iFile),"FFT");
            case "RFSCOPE_SIG"
                [tmpXXs,tmpYYs]=SCOPEread(fileNames(iFile),"SIG");
            case "INI"
                [tmpXXs,tmpYYs]=FGENread(fileNames(iFile));
            otherwise
                error("FileType not recognised: %s!",FileType);
        end
        nTmpYYs=size(tmpYYs,2);
        if ( nTmpYYs==0 )
            warning("...no signal found in file!");
            continue
        end
        
        % - store data
        XXs=PaddMe(tmpXXs,XXs);
        YYs=PaddMe(tmpYYs,YYs);
        
        % - get ready for next iteration
        nParsedFiles=nParsedFiles+1;
        nParsedYYs=nParsedYYs+nTmpYYs;
        nYYs=nYYs+nTmpYYs;
    end
    
    %% output a summary
    fprintf("...acquired %d files, for a total of %d YYs;\n",nParsedFiles,nParsedYYs);

end
