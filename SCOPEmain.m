% {}~

%% include libraries
pathToLibrary="lib";
addpath(genpath(pathToLibrary));
pathToLibrary="externals";
addpath(genpath(pathToLibrary));

%% acquire PICOscope signal
clear picoTime picoSignals;
fileName="pico_signals\2022-06-09_test_bench_CViviani\sinusoid_kHz511.340_2ms_repeated-0001.txt";
% fileName="pico_signals\2022-06-09_test_bench_CViviani\sinusoid_kHz511.340_5ms_repeated-0001.txt";
[picoTime,picoSignals] = PICOread(fileName);

%% acquire SCOPE signal in time
clear scopeTime scopeSignal;
fileName="scope_signals\2022-06-09_test_bench_CViviani\sinusoid_kHz511.340_2ms_repeated-0001_Sig_RefCurve_2022-06-09_0_145133.Wfm.csv";
% fileName="scope_signals\2022-06-09_test_bench_CViviani\sinusoid_kHz511.340_5ms_repeated-0001_Sig_RefCurve_2022-06-09_4_163058.Wfm.csv";
[scopeTime,scopeSignal] = SCOPEread(fileName);

%% acquire SCOPE FFT
clear scopeFreq scopeFFT;
fileName="scope_signals\2022-06-09_test_bench_CViviani\sinusoid_kHz511.340_2ms_repeated-0001_FFT_RefCurve_2022-06-09_0_152609.Wfm.csv";
% fileName="scope_signals\2022-06-09_test_bench_CViviani\sinusoid_kHz511.340_5ms_repeated-0001_FFT_RefCurve_2022-06-09_2_163051.Wfm.csv";
[scopeFreq,scopeFFT] = SCOPEread(fileName,"FFT");

%% MatLab FFT of scope signal
clear scopeFreqMl scopeFFTMl scopeFreqMl_BH scopeFFTMl_BH;
[scopeFreqMl,scopeFFTMl]=FFTme(scopeTime,scopeSignal);
% apply windowing - see
%         https://it.mathworks.com/help/signal/windows.html?s_tid=CRUX_lftnav 
[scopeFreqMl_BH,scopeFFTMl_BH]=FFTme(scopeTime,scopeSignal.*blackmanharris(size(scopeSignal,1)));

%% MatLab FFT of picoscope
clear picoFreq picoFFT picoFreq_BH picoFFT_BH;
[picoFreq,picoFFT]=FFTme(picoTime,picoSignals);
[picoFreq_BH,picoFFT_BH]=FFTme(picoTime,picoSignals.*blackmanharris(size(picoSignals,1)));

%% time plot
figure();
plot(picoTime,picoSignals,".-");
hold on; plot(scopeTime,scopeSignal,".-");
legend("picoscope","scope","Location","best");
grid(); xlabel("t [s]"); ylabel("signal [V]");
title("2ms, repeated");
% title("5ms, repeated");

%% FFT plot (RF scope)
figure();
plot(scopeFreqMl,dBme(scopeFFTMl),".-");
hold on; plot(scopeFreqMl_BH,dBme(scopeFFTMl_BH)+12,".-");
hold on; plot(scopeFreq,scopeFFT,".-");
legend("scope signal - MatLab rect","scope signal - MatLab Blackman-Harris","scope FFT","Location","best");
grid(); xlabel("f [Hz]"); ylabel("FFT [dBm]");
title("2ms, repeated");
% title("5ms, repeated");

%% FFT plot (PICOscope)
F0=511.340E3;
figure();
plot(picoFreq/F0,dBme(picoFFT),".-");
hold on; plot(picoFreq_BH/F0,dBme(picoFFT_BH),".-");
legend("PICO rect","PICO Blackman-Harris","Location","best");
grid(); xlabel(sprintf("normalised f [] (F_0=%g Hz)",F0)); ylabel("FFT [dBm]");
title("2ms, repeated");
% title("5ms, repeated");

%% FFT plot (PICOscope vs RF scope with BH)
figure();
plot(scopeFreqMl_BH/F0,dBme(scopeFFTMl_BH),".-");
hold on; plot(scopeFreq/F0,scopeFFT-12,".-");
hold on; plot(picoFreq_BH/F0,dBme(picoFFT_BH),".-");
legend("scope, MatLab BH","scope (-12dBm)","PICO, BH","Location","best");
grid(); xlabel(sprintf("normalised f [] (F_0=%g Hz)",F0)); ylabel("FFT [dBm]");
title("2ms, repeated");
% title("5ms, repeated");

