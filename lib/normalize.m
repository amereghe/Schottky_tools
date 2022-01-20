function [signalnorm,fftnorm,tt,ff] = normalize(signal,fft,df)

%NORMALIZE used to put signals and their fft in range [-1;1]

%   inputs: matrices of signals and their ffts and frequency step (df)
%   outputs: normalizzed matrices and arrays with maximum of each signal
%            contained in the single column

tt=max(abs(signal),[],1);
for i=1:size(signal,2)
    signalnorm(:,i)=signal(:,i)./tt(i);
end
ff=df*sum(abs(fft),1);
for j=1:size(fft,2)
    fftnorm(:,j)=fft(:,j)./ff(j);
end

end
