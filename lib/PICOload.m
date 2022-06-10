function [time,ff,signals,FF]=PICOload(fileName,lPlot)
    if (~exist('lPlot','var')), lPlot=true; end

    %% parse picoscope file
    [time,signals] = PICOread(fileName);

    %% get FFTs
    [ff,FF]=FFTme(time,signals);

    %% show signals
    if ( lPlot ), PlotTimesFreqfig(time,ff,signals,FF); end
    
end