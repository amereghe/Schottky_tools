function [newf,R] = ratiofft(f,F)

%   RATIOFFT returns a new frequency vector adapted for matlab and picos
%   signals and a matrix containing ratios between ffts
%   After the generation of a new frequency vector, we use 'spline' in
%   order to obtain ffts of the same length evaluated in the same points;
%   this is mandatory in order to perform a ratio between two signals.

f_mat=f(:,1);
f_pico=f(:,3);
fmin=min(f_mat(1),f_pico(1));
fmax=max(f_mat(end),f_pico(end));
ind1=(fmin<=f_mat & f_mat<=fmax);
n1=sum(ind1);
ind2=(fmin<=f_pico & f_pico<=fmax);
n2=sum(ind2);
newf=(fmin:(fmax-fmin)/max(n1,n2):fmax)';

d1=diff(f(:,1));
indM=find(d1<0);
if isempty(indM)
    indM=length(f(:,1));
else
    indM=indM;
end
d3=diff(f(:,3));
indP=find(d3<0);
if isempty(indP)
    indP=length(f(:,3));
else
    indP=indP;
end
d4=diff(f(:,4));
indS=find(d4<0);
if isempty(indS)
    indS=length(f(:,4));
else
    indS=indS;
end

fftM=spline(f(1:indM,1),abs(F(1:indM,1)),newf);
fftP=spline(f(1:indP,3),abs(F(1:indP,3)),newf);
fftS=spline(f(1:indS,4),abs(F(1:indS,4)),newf);

ratioPM=fftP./fftM;
ratioSM=fftS./fftM;
R=[ratioPM,ratioSM]; % 1st: ratio btw pico and matlab; 2nd: ratio btw schottky and matlab

end
