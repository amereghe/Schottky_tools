function [iSigStart,iSigStop]=cropsignal(SigIn,thresh,nCons,nSigmNoise)
%   SigIn has noise before and after useful signal!
    if ( ~exist('thresh','var') ), thresh=0.023; end % [V]
    if ( ~exist('nCons','var') ), nCons=10; end %
    if ( ~exist('nSigmNoise','var') ), nSigmNoise=5; end %
    % find intervals with noise
    thresh=thresh*max(abs(SigIn));
    myDiff=diff([abs(thresh)*1.1;abs(SigIn);abs(thresh)*1.1]<thresh);
    iNoiseStart = find(myDiff==1);
    iNoiseStop = find(myDiff==-1)-1;
    nIntervals=length(iNoiseStart);
    if ( nIntervals<2 ), error("...only one noise range!"); end
    iSigStart=[]; iSigStop=[];
    % get indices of actual signal, assuming that signal is a pure sinusoid
    nSig=0;
    for jj=1:numel(iNoiseStart) % loop through each block of noise
        if (iNoiseStop(jj)-iNoiseStart(jj)<nCons)
            continue;   % most probably a node
        end
        mySig=SigIn(iNoiseStart(jj):iNoiseStop(jj));
        meanNoise=mean(mySig(1+round(nCons/2):end-round(nCons/2)));
        stdNoise=std(mySig(1+round(nCons/2):end-round(nCons/2)));
        padded=abs([0;mySig-meanNoise;0])/stdNoise;
        myDiff=diff(padded>nSigmNoise);
        if (jj<numel(iNoiseStart))
            nSig=nSig+1; % a new signal
            % get index where following signal actually starts
            iSigStart(nSig)=iNoiseStop(jj);
            iStart=find(myDiff==1);
            if ~isempty(iStart)
                iSigStart(nSig)=iSigStart(nSig)-(length(padded)-iStart(end));
            end
        end
        if (jj>1)
            % get index where previous signal actually stops
            iSigStop(nSig)=iNoiseStart(jj)-1;
            iStop=find(myDiff==-1)-1;
            if ~isempty(iStop)
                iSigStop(nSig)=iSigStop(nSig)+iStop(1);
            end
        end
    end
end
