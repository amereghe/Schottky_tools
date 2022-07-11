function ShowFFT(freq,FFTs,F0s)
    if ( exist("F0s","var") )
        xLab="f []";
        if (size(F0s,1)==1), F0s(2,:)=0; end
    else
        F0s=ones(2,1); F0s(2,:)=0;
        xLab="f [Hz]";
    end
    nFFTs=size(FFTs,2);
    figure();
    for iFFT=1:nFFTs
        if ( iFFT>1 ), hold on; end
        % indices=~isnan(FFTs(:,iFFT));
        if ( size(freq,2)==1 ), iFreq=1; else iFreq=iFFT; end
        if ( size(F0s,2)==1 ), iF0=1; else iF0=iFFT; end
        plot(freq(:,iFreq)/F0s(1,iF0),FFTs(:,iFFT)-F0s(2,iF0),".-");
    end
    grid(); xlabel(xLab); ylabel("FFT [dBm]");
    xl=xlim();
    xlim([0.0 xl(2)]);
end
