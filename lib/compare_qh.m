function [zz0,ZZ0,zz1,ZZ1] = compare_qh(qhv,a0,a,x,x1,friv,t,f)

%%Function to compare different values of horizontal tune to be evaluated on
%%two different plots: the first one is related to the transversal
%%unbunched beam motion and the second to the bunched transversal motion;
%%inputs are vector of horizontal tune values, mean value of the modulating
%%function, amplitude of the modulation, the two original signals, the
%%revolution frequency, the time  and frequencies vector; outputs are the
%%matrices related to signal and fft of both transversal unbunched
%%(zz0,ZZ0) and bunched (zz1,ZZ1) beam.


%furthermore we can also change 'friv' value to evaluate more different
%betatron frequencies.

fb1=qhv(1)*friv;
fb2=qhv(2)*friv;
fb3=qhv(3)*friv;

y1=(a0+a*cos(2*pi*fb1*t+pi/2));
y2=(a0+a*cos(2*pi*fb2*t+pi/2));
y3=(a0+a*cos(2*pi*fb3*t+pi/2));

%trans unbunched e bunched: new signal modulated in phase by the tune
if qhv(1)~=0 && qhv(2)~=0 && qhv(3)~=0 && a~=0
    z01=x.*y1; %trans unbunched
    z02=x.*y2;
    z03=x.*y3;
    %Z=fftshift(fft(z));
    Z01=fft(z01);
    Z02=fft(z02);
    Z03=fft(z03);

    z11=x1.*y1; %trans bunched
    z12=x1.*y2;
    z13=x1.*y3;
    %Z1=fftshift(fft(z1));
    Z11=fft(z11);
    Z12=fft(z12);
    Z13=fft(z13);

end

zz0=[t,z01,z02,z03]; %trans unbunched matrix
ZZ0=[f,Z01,Z02,Z03]; %fft trans unbunched matrix
zz1=[t,z11,z12,z13]; %trans bunched matrix
ZZ1=[f,Z11,Z12,Z13]; %fft trans bunched matrix

end
