function [iSigStart,iSigStop]=cropsignal(SigIn,thresh,nCons)
%   SigIn has noise before and after useful signal!
    if ( ~exist('thresh','var') ), thresh=0.023; end % [V]
    if ( ~exist('nCons','var') ), nCons=10; end %
    % find intervals with noise
    myDiff=diff([0;abs(SigIn);0]<thresh);
    iNoiseStart = find(myDiff==1);
    iNoiseStop = find(myDiff==-1)-1;
    nIntervals=length(iNoiseStart);
    if ( nIntervals<2 ), error("...only one noise range!"); end
    iSigStart=zeros(nIntervals,1); iSigStop=zeros(nIntervals,1);
    % get indices of actual signal, assuming that signal is a pure sinusoid
    nSig=0;
    for jj=1:numel(iNoiseStart) % loop through each block of noise
        if ( iNoiseStart(jj)-iNoiseStop(jj)<nCons ), continue; end   % most probably a node
        padded=[0;SigIn(iNoiseStart(jj):iNoiseStop(jj));0];
        if ( jj<numel(iNoiseStart) )
            nSig=nSig+1; % a new signal
            % get index where following signal actually starts
            myDiff=diff(padded>0);
            iStart = find(myDiff==1);
            iSigStart(nSig)=iNoiseStop(jj)-iStart(end);
        end
        if ( jj>1 )
            % get index where previous signal actually stops
            myDiff=diff(padded<0);
            iStop = find(myDiff==-1)-1;
            iSigStop(nSig)=iNoiseStart(jj)+iStop(1);
        end
    end
end
