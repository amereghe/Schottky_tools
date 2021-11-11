function [] = plotall(n,t,x,x1,z,z1,f,X,X1,Z,Z1)

%PLOTALL Summary of this function goes here

%   plot of signal in time in the intTime selected and their fft: il primo
%   parametro è il numero di campioni, poi abbiamo il vettore tempi ed i 4
%   segnali nel tempo, infine vettore frequenze e le quattro fft

    figure;
    subplot(2,1,1);
    plot(t,x,'-r');
    hold on
    plot(t,x1,'-b');
    hold on
    plot(t,z,'-m');
    hold on
    plot(t,z1,'-c');
    xlabel('Time [s]');
    subplot(2,1,2);
    plot(f,abs(X)/n,'-r');
    hold on
    plot(f,abs(X1)/n,'-b');
    hold on
    plot(f,abs(Z)/n,'-m');
    hold on
    plot(f,abs(Z1)/n,'-c');
    xlabel('Frequency [Hz]');
    
end

