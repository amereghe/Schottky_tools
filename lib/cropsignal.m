function [iSigStart,iSigStop]=cropsignal(SigIn,thresh,nCons,nSigNoise,lDebug)
    %% check input data
    if ( ~exist('thresh','var') ), thresh=0.023; end % []
    if ( ~exist('nCons','var') ), nCons=10; end %
    if ( ~exist('nSigNoise','var') ), nSigNoise=3; end %
    if ( ~exist('lDebug','var') ), lDebug=false; end %
    
    fprintf("cropping signal...\n");
    nData=length(SigIn);

    %% find intervals with noise
    thresh=thresh*max(abs(SigIn));
    myDiff=diff([abs(thresh)*1.1;abs(SigIn);abs(thresh)*1.1]<thresh);
    myINoiseStart = find(myDiff==1);
    myINoiseStop = find(myDiff==-1)-1;
    nOriIntervals=length(myINoiseStart);
    
    % loop through each block of noise, to remove:
    % - intervals with single signal points above threshold;
    % - intervals with single noise points;
    nNoise=0;
    iNoiseStart=zeros(nOriIntervals,1); iNoiseStop=zeros(nOriIntervals,1);
    for jj=1:nOriIntervals
        if ( myINoiseStop(jj)-myINoiseStart(jj)<nCons && ( myINoiseStart(jj)>1 || myINoiseStop(jj)<nData ) )
            continue % a very short section of noise points: most probably a node! ...do not store noise interval
        else
            if ( jj>1 && myINoiseStart(jj)-myINoiseStop(jj-1)<=2 && myINoiseStop(jj-1)-myINoiseStart(jj-1)>=nCons ) 
                iNoiseStop(nNoise)=myINoiseStop(jj); % continue previous noise section
            else
                nNoise=nNoise+1;
                iNoiseStart(nNoise)=myINoiseStart(jj);
                iNoiseStop(nNoise)=myINoiseStop(jj);
            end
        end
    end
    iNoiseStart=iNoiseStart(1:nNoise);
    iNoiseStop=iNoiseStop(1:nNoise);
    nIntervals=length(iNoiseStart);
    
    % debug plot
    if (lDebug)
        figure();
        myMax=max(SigIn)*1.1;
        plot(SigIn,"b*-");
        for ii=1:length(iNoiseStart)
            hold on;
            plot([iNoiseStart(ii):iNoiseStop(ii)],SigIn(iNoiseStart(ii):iNoiseStop(ii)),"go");
            % delimiters
            hold on; plot([iNoiseStart(ii) iNoiseStart(ii)],[-myMax myMax],"r-");
            hold on; plot([iNoiseStop(ii) iNoiseStop(ii)],[-myMax myMax],"r-");
        end
        hold on; plot([1 nData],[thresh thresh],"m-"); hold on; plot([1 nData],[-thresh -thresh],"m-");
        grid on; xlabel("ID []"); ylabel("[V]");
    end
    
    %% get indices of actual signal
    iSigStart=zeros(nIntervals,1); iSigStop=zeros(nIntervals,1);
    nSig=0; iSig=0;
    for jj=1:nIntervals % loop through each block of noise
        myNCons=nCons;
        if (iNoiseStop(jj)-iNoiseStart(jj)<nCons && ( myINoiseStart(jj)==1 || myINoiseStop(jj)==nData ) )
            myNCons=0;
        end
        iSig=iSig+1;
        mySig=SigIn(iNoiseStart(jj):iNoiseStop(jj));
        mySigStat=mySig(1+round(myNCons/2):end-round(myNCons/2));
        meanNoise=mean(mySigStat);
        stdNoise=std(mySigStat);
        fprintf("...noise interval #%3d: mean[V]=%6g; stdv[V]=%6g;\n",iSig,meanNoise,stdNoise);
        padded=[0;mySig-meanNoise;0];
        padded=abs(padded)/stdNoise;
        tmpDiff=diff(padded>nSigNoise);
        iStart=find(tmpDiff==1);
        iStop=find(tmpDiff==-1)-1;
        if ( jj==1 && iNoiseStart(jj)>1 )
            nSig=nSig+1; % a signal before first noise interval
            iSigStart(nSig)=1;
        end
        if ( jj>1 || ( jj==1 && iNoiseStart(jj)>1 ) )
            % get index where previous signal actually stops
            iSigStop(nSig)=iNoiseStart(jj);
            if ~isempty(iStop)
                if ( isempty(iStart) || iStop(1)-iStart(1)>2 )
                    iSigStop(nSig)=iSigStop(nSig)+iStop(1); % not a singular point
                end
            end
        end
        if (jj<nIntervals || ( jj==nIntervals && iNoiseStop(jj)<nData ) )
            nSig=nSig+1; % a new signal
            % get index where following signal actually starts
            iSigStart(nSig)=iNoiseStop(jj);
            if ~isempty(iStart)
                if ( isempty(iStop) || iStop(end)-iStart(end)>2 )
                    iSigStart(nSig)=iSigStart(nSig)-(length(padded)-iStart(end));
                end
            end
        end
        if ( jj==nIntervals && iNoiseStop(jj)<nData )
            iSigStop(nSig)=nData;
        end
    end
    iSigStart=iSigStart(1:nSig);
    iSigStop=iSigStop(1:nSig);
    
    %% debug plot
    if (lDebug)
        figure();
        myMax=max(SigIn)*1.1;
        plot(SigIn,"b*-");
        for ii=1:length(iSigStart)
            hold on;
            plot([iSigStart(ii):iSigStop(ii)],SigIn(iSigStart(ii):iSigStop(ii)),"go");
            % delimiters
            hold on; plot([iSigStart(ii) iSigStart(ii)],[-myMax myMax],"r-");
            hold on; plot([iSigStop(ii) iSigStop(ii)],[-myMax myMax],"r-");
            hold on; plot([1 nData],[thresh thresh],"m-"); hold on; plot([1 nData],[-thresh -thresh],"m-");
        end
        grid on; xlabel("ID []"); ylabel("[V]");
    end
    
    %% bye bye
    fprintf("...identified %d signals!\n",nSig);
end
