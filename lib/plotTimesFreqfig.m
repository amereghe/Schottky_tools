function [] = plotTimesFreqfig(T,F,friv)

%   plot of signal in time in the intTime selected and their fft, we are
%   passing matrices containing temporal (T) and frequency (F) values with 
%   their corresponding values of signals both in time domain and FFT; if
%   'friv' is given, then we have a plot showing normalized frequency, if 0
%   values are not normalized.
    
%     %time domain
    figure;
    subplot(2,1,1);

    for i=1:(size(T,2)-1)
        plot(T(:,1),T(:,i+1));
        hold on
    end
    xlabel('Time [s]');
    
    %frequency domain
    subplot(2,1,2);
    
    if(~exist('friv','var'))
        friv=false;
    end
    
    if(friv)
        
        for j=1:(size(F,2)-1)
            plot(F(:,1)/friv,abs(F(:,j+1)));
            hold on
        end
        xlabel('Normalized frequency [A.U.]');
        
    else
        
        for k=1:(size(F,2)-1)
            plot(F(:,1),abs(F(:,k+1)));
            hold on
        end
        xlabel('Frequency [Hz]');
        
    end
    
end

