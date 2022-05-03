function [] = PlotTimesFreqfig(t,f,T,F,friv)
% PlotTimesFreqfig            to show signal(s) and theirs FFT.
%
% The function generates a figure with two plots:
% - top plot: all time signals;
% - bottom plot: all FFTs;
%
% input:
% - t (2D array, double precision): array of time vector [s];
% - f (2D array, double precision): array of frequency vector [Hz];
% - T (2D array, double precision): array of signal values [];
% - F (2D array, double precision): array of FFT values [];
% - friv (double precision, optional): revolution frequency [s];
%   if provided, the domain will be shown as normalised frequency;
%   otherwise, bare frequencies are shown.
%
% N.B.: t,f,T,F:
% - a column per series, e.g. two signals are stored as t(Nsamples,2),T(Nsamples,2);
% - if the signals share the same time domain, the function can handle a
%   unique time domain, e.g. t(Nsamples,1),T(Nsamples,Nsignals);
    
    %% checks
    rest=size(t,2); resf=size(f,2); resT=size(T,2); resF=size(F,2);
    if(exist('friv','var'))
        lfriv=true;
        fNormFact=friv;
    else
        lfriv=false;
        fNormFact=1.0;
    end
    
    %% font sizes
    LabelFontSize=20;
    TicksFontSize=18;
    
    %% plot
    figure;
    
    % time domain
    subplot(2,1,1);
    if rest == resT
        for ii=1:rest
            if(ii>1), hold on; end
            plot(t(:,ii),T(:,ii));
        end
    elseif rest == 1
        for ii=1:resT
            if(ii>1), hold on; end
            plot(t,T(:,ii));
        end
    end
    ax = gca; ax.FontSize = TicksFontSize;
    xlabel('Time [s]','FontSize',LabelFontSize);
    ylabel('Amplitude [A.U.]','FontSize',LabelFontSize);
    grid();
    
    % frequency domain
    subplot(2,1,2);
    if resf == resF
        for ii=1:resf
            if(ii>1), hold on; end
            plot(f(:,ii)/fNormFact,abs(F(:,ii)));
        end
    elseif resf == 1
        for ii=1:resF
            if(ii>1), hold on; end
            plot(f/fNormFact,abs(F(:,ii)));
        end
    end
    ax = gca; ax.FontSize = TicksFontSize;
    if (lfriv)
        xlabel('Normalized frequency [A.U.]','FontSize',LabelFontSize);
    else
        xlabel('Frequency [Hz]','FontSize',LabelFontSize);
    end
    ylabel('Absolute value [A.U.]','FontSize',LabelFontSize);
    set(gca,'YScale','log');
    grid();
    
end

