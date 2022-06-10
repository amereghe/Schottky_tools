function iMax=FGENtruncate(basicTime,currFPuls)
    % find best truncation point:
    %    funGen expects the array to be long a multiple of 4
    fGenMul=4;
    iMax=0;
    y=rem(basicTime*currFPuls,1);
    [mini,ind]=sort(y);
    for jj=1:length(ind)
        if mod(ind(jj),fGenMul)==0
            iMax=ind(jj);
            break;
        end
    end
end