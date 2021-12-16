function [] = newPlotTimesFreqfig(t,f,T,F,friv)

%   plot of signal in time in the intTime selected and their fft, we are
%   passing matrices containing temporal (T) and frequency (F) values with 
%   their corresponding values of signals both in time domain and FFT; if
%   'friv' is given, then we have a plot showing normalized frequency, if 0
%   values are not normalized.
    
    rest=size(t,2);
    resf=size(f,2);
    resT=size(T,2);
    resF=size(F,2);

%     %time domain
    figure;
    subplot(2,1,1);
    if rest == resT
        for i=1:rest
            plot(t(:,i),T(:,i));
            hold on
        end
    elseif rest == 1
        for i=1:resT
            plot(t(:,1),T(:,i));
            hold on
        end
    end
    xlabel('Time [s]');
    
    %frequency domain
    subplot(2,1,2);
    
    if(~exist('friv','var'))
        friv=false;
    end
    
    if(friv)
        if resf == resF
            for j=1:resf
                plot(f(:,j)/friv,abs(F(:,j)));
                hold on
            end
        elseif resf == 1
            for j=1:resF
                plot(f(:,1)/friv,abs(F(:,j)));
                hold on
            end
        end
        xlabel('Normalized frequency [A.U.]');
        
    else
        if resf == resF
            for k=1:resf
                plot(f(:,k),abs(F(:,k)));
                hold on
            end
        elseif resf == 1
            for k=1:resF
                plot(f(:,1)/friv,abs(F(:,k)));
                hold on
            end
        end
        xlabel('Frequency [Hz]');
        
    end
    
end

