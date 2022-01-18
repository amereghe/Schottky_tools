function [newF,R] = ratiofft(f,F,iRef)

%   RATIOFFT returns a new frequency vector adapted for matlab and picos
%   signals and a matrix containing ratios between ffts
%   After the generation of a new frequency vector, we use 'spline' in
%   order to obtain ffts of the same length evaluated in the same points;
%   this is mandatory in order to perform a ratio between two signals.

if ~exist('iRef','var'), iRef=1; end
nSignals=size(F,2);

fMins=f(1,:)'; fMaxs=NaN(nSignals,1); ind=NaN(nSignals,1);
for iCol=1:nSignals
    dd=find(diff(f(:,iCol))<0);
    if isempty(dd)
        ind(iCol)=length(f(:,iCol));
    else
        ind(iCol)=dd;
    end
    fMaxs(iCol)=f(ind(iCol),iCol);
end

fmin=max(fMins);
fmax=min(fMaxs);
newF=(fmin:(fmax-fmin)/(max(ind)-1):fmax)';

fftRef=spline(f(1:ind(iRef),iRef),abs(F(1:ind(iRef),iRef)),newF);
R=ones(length(newF),nSignals);
for iCol=1:nSignals
    if (iCol==iRef), continue; end
    if (ind(iCol)==length(newF) & f(1,iCol)==newF(1) & f(ind(iCol),iCol)==newF(end))
        R(:,iCol)=abs(f(1:ind(iCol),iCol))./fftRef;
    else
        R(:,iCol)=spline(f(1:ind(iCol),iCol),abs(F(1:ind(iCol),iCol)),newF)./fftRef;

    end
end


end
