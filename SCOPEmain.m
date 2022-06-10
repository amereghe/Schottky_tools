% {}~

%% include libraries
pathToLibrary="lib";
addpath(genpath(pathToLibrary));
pathToLibrary="externals";
addpath(genpath(pathToLibrary));

%% clear memory
clear picoTime picoSignals scopeTime scopeSignal scopeFreq scopeFFT scopeFreqMl scopeFFTMl scopeFreqMl_BH scopeFFTMl_BH;

%% acquire PICOscope signal
% fileName="pico_signals\2022-06-09_test_bench_CViviani\sinusoid_kHz511.340_2ms_repeated-0001.txt";
fileName="pico_signals\2022-06-09_test_bench_CViviani\sinusoid_kHz511.340_5ms_repeated-0001.txt";
[picoTime,picoSignals] = PICOread(fileName);

%% acquire SCOPE signal in time
% fileName="scope_signals\2022-06-09_test_bench_CViviani\sinusoid_kHz511.340_2ms_repeated-0001_Sig_RefCurve_2022-06-09_0_145133.Wfm.csv";
fileName="scope_signals\2022-06-09_test_bench_CViviani\sinusoid_kHz511.340_5ms_repeated-0001_Sig_RefCurve_2022-06-09_4_163058.Wfm.csv";
[scopeTime,scopeSignal] = SCOPEread(fileName);

%% acquire SCOPE FFT
% fileName="scope_signals\2022-06-09_test_bench_CViviani\sinusoid_kHz511.340_2ms_repeated-0001_FFT_RefCurve_2022-06-09_0_152609.Wfm.csv";
fileName="scope_signals\2022-06-09_test_bench_CViviani\sinusoid_kHz511.340_5ms_repeated-0001_FFT_RefCurve_2022-06-09_2_163051.Wfm.csv";
[scopeFreq,scopeFFT] = SCOPEread(fileName,"FFT");

%% MatLab FFT of scope signal
[scopeFreqMl,scopeFFTMl]=FFTme(scopeTime,scopeSignal);
% apply windowing - see
%         https://it.mathworks.com/help/signal/windows.html?s_tid=CRUX_lftnav 
[scopeFreqMl_BH,scopeFFTMl_BH]=FFTme(scopeTime,scopeSignal.*blackmanharris(size(scopeSignal,1)));

%% time plot
figure();
plot(picoTime,picoSignals,".-");
hold on;
plot(scopeTime,scopeSignal,".-");
grid on;
legend("picoscope","scope","Location","best");

%% FFT plot
figure();
plot(scopeFreqMl,dBme(scopeFFTMl),".-");
hold on;
plot(scopeFreqMl_BH,dBme(scopeFFTMl_BH),".-");
hold on;
plot(scopeFreq,scopeFFT,".-");
grid on;
legend("scope ML rect","scope ML Blackman-Harris","scope","Location","best");


