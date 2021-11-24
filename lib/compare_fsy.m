function [xx1,XX1] = compare_fsy(fsy,friv,t,taus,x,w,f)

%%Function to compare different values of synchrotron frequency to be
%%evaluated on the same plot: results to be overlapped to the same curve,
%%so the contribute to the motion can be considered quite independent from
%%the 'fs' value; input values are the array containing different
%%synchrotron frequency values, the revolution frequency, time vector, time
%%modulation amplitude, the original signal x, the pulse width and vector
%%of frequencies; output are matrix xx1 and XX1 containing both signals in 
%%time and their respective fft.

%time modulation
tau1=taus*sin(2*pi*fsy(1)*t);
tau2=taus*sin(2*pi*fsy(2)*t);
tau3=taus*sin(2*pi*fsy(3)*t);

x11=x; %longi bunched with fsy(1)
x12=x; %longi bunched with fsy(2)
x13=x; %longi bunched with fsy(3)

if taus~=0

    for k=1:size(t,1)
        tau1(k)=k/friv+tau1(k);
    end

    for l=1:size(t,1)
        tau2(l)=l/friv+tau2(l);
    end

    for m=1:size(t,1)
        tau3(m)=m/friv+tau3(m);
    end

end

for j=1:size(t,1)
    x11=x11+rectpuls(t-tau1(j),w); %longi bunched w/ fs(1)
end

for b=1:size(t,1)
    x12=x12+rectpuls(t-tau2(b),w); %longi bunched w/ fs(2)
end

for d=1:size(t,1)
    x13=x13+rectpuls(t-tau3(d),w); %longi bunched w/ fs(3)
end

xx1=[t,x11,x12,x13]; %matrix with signals in time
X11=fft(x11);
X12=fft(x12);
X13=fft(x13);
XX1=[f,X11,X12,X13]; %matrix with fft

end
