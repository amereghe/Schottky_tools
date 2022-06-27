 % {}~

%% include libraries
pathToLibrary="lib";
addpath(genpath(pathToLibrary));
pathToLibrary="externals";
addpath(genpath(pathToLibrary));

%% user input
picoFileName="pico_signals\2022-06-09_test_bench_CViviani\sinusoid_kHz511.340_2ms_062p5MHz_repeated-0001.txt";

%% parse picoscope file
[time,signals] = PICOread(picoFileName);

%% get FFTs
[ff,FF]=FFTme(time,signals);

%% show signals
PlotTimesFreqfig(time,ff,signals,FF);
