function [iSigStart,iSigStop]=cropsignal(SigIn,thresh,nCons,nSigNoise)
    if ( ~exist('thresh','var') ), thresh=0.023; end % []
    if ( ~exist('nCons','var') ), nCons=10; end %
    if ( ~exist('nSigNoise','var') ), nSigNoise=5; end %
    fprintf("cropping signal...\n");
    % find intervals with noise
    thresh=thresh*max(abs(SigIn));
    myDiff=diff([abs(thresh)*1.1;abs(SigIn);abs(thresh)*1.1]<thresh);
    iNoiseStart = find(myDiff==1);
    iNoiseStop = find(myDiff==-1)-1;
    iSigStart=zeros(length(iNoiseStart),1); iSigStop=zeros(length(iNoiseStart),1);
    % get indices of actual signal
    nSig=0;
    for jj=1:numel(iNoiseStart) % loop through each block of noise
        myNCons=nCons;
        if (iNoiseStop(jj)-iNoiseStart(jj)<nCons)
            if ( 1<jj && jj<numel(iNoiseStart) )
                continue;   % most probably a node
            else
                % very short noise before/after first/last signal
                myNCons=0;
            end
        end
        mySig=SigIn(iNoiseStart(jj):iNoiseStop(jj));
        mySigStat=mySig(1+round(myNCons/2):end-round(myNCons/2));
        meanNoise=mean(mySigStat);
        stdNoise=std(mySigStat);
        fprintf("...noise interval #%3d: mean[V]=%6g; stdv[V]=%6g;\n",meanNoise,stdNoise);
        padded=[0;mySig-meanNoise;0];
        padded=abs(padded)/stdNoise;
        myDiff=diff(padded>nSigNoise);
        if ( jj==1 && iNoiseStart(jj)>1 )
            nSig=nSig+1; % a signal before first noise interval
            iSigStart(nSig)=1;
        end
        if ( jj>1 || ( jj==1 && iNoiseStart(jj)>1 ) )
            % get index where previous signal actually stops
            iSigStop(nSig)=iNoiseStart(jj)-1;
            iStop=find(myDiff==-1)-1;
            if ~isempty(iStop)
                iSigStop(nSig)=iSigStop(nSig)+iStop(1);
            end
        end
        if (jj<numel(iNoiseStart) || ( jj==numel(iNoiseStart) && iNoiseStop(jj)<length(SigIn) ) )
            nSig=nSig+1; % a new signal
            % get index where following signal actually starts
            iSigStart(nSig)=iNoiseStop(jj);
            iStart=find(myDiff==1);
            if ~isempty(iStart)
                iSigStart(nSig)=iSigStart(nSig)-(length(padded)-iStart(end));
            end
        end
        if ( jj==numel(iNoiseStart) && iNoiseStop(jj)<length(SigIn) )
            iSigStop(nSig)=length(SigIn);
        end
    end
    iSigStart=iSigStart(1:nSig);
    iSigStop=iSigStop(1:nSig);
    fprintf("...identified %d signals!\n",nSig);
end
