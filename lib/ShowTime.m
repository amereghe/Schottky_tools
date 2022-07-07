function ShowTime(time,signals)
    figure();
    for iSig=1:size(signals,2)
        if ( iSig>1 ), hold on; end
        indices=~isnan(signals(:,iSig));
        if ( size(time,2)==1 ), iTime=1; else iTime=iSig; end
        plot(time(indices,iTime),signals(indices,iSig),".-");
    end
    grid(); xlabel("t [s]"); ylabel("signal [V]");
end
