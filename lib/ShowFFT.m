function ShowFFT(freq,FFTs,F0s)
    if ( exist("F0s","var") )
        xLab="f []";
    else
        F0s=1;
        xLab="f [Hz]";
    end
    nFFTs=size(FFTs,2);
    figure();
    for iFFT=1:nFFTs
        if ( iFFT>1 ), hold on; end
        % indices=~isnan(FFTs(:,iFFT));
        if ( size(freq,2)==1 ), iFreq=1; else iFreq=iFFT; end
        if ( length(F0s)==1 ), iF0=1; else iF0=iFFT; end
        plot(freq(:,iFreq)/F0s(iF0),FFTs(:,iFFT),".-");
    end
    grid(); xlabel(xLab); ylabel("FFT [dBm]");
    xl=xlim();
    xlim([0.0 xl(2)]);
end
