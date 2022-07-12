function SigOut=WindowMe(SigIn,WindowName)

    %% check input
    switch upper(WindowName)
        case {"BH","BLACKMANHARRIS"}
            fprintf("...windowing signals with BH!\n");
        otherwise
            error("...unknown windowing: %s!",WindowName);
    end
    
    %% actually do the job
    SigOut=NaN(size(SigIn));
    for iSig=1:size(SigIn,2)
        tmpSig=SigIn(~isnan(SigIn(:,iSig)),iSig);
        nPoints=length(tmpSig);
        switch upper(WindowName)
            case {"BH","BLACKMANHARRIS"}
                SigOut(1:nPoints,iSig)=SigIn(1:nPoints,iSig).*blackmanharris(nPoints);
                RR=sum(tmpSig,"omitNan")/sum(SigOut(1:nPoints,iSig),"omitNan");
                SigOut(1:nPoints,iSig)=SigOut(1:nPoints,iSig)*RR;
        end
    end
        
end
