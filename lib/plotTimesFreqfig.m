function [] = plotTimesFreqfig(T,F)

%PLOTALL Summary of this function goes here

%   plot of signal in time in the intTime selected and their fft, we are
%   passing matrices containing temporal (T) and frequency (F) values with 
%   their corresponding values of signals both in time domain and FFT
    
    %time domain
    figure;
    subplot(2,1,1);

    for i=1:(size(T,2)-1)
        plot(T(:,1),T(:,i+1));
        hold on
    end
    xlabel('Time [s]');

    %frequency domain
    subplot(2,1,2);

    for j=1:(size(F,2)-1)
        plot(F(:,1),abs(F(:,j+1))/size(F,1));
        hold on
    end
    xlabel('Frequency [Hz]');
    legend('Longi. unbunched','Longi. bunched','Trans. unbunched','Trans. bunched','location','best');
    %comment the prewious line of code in order to avoid ignoring extra
    %LEGEND entries, if expressed in other scripts
    
end

