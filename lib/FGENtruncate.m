function iMax=FGENtruncate(basicTime,currFPuls)
    % find best truncation point:
    %    funGen expects the array to be long a multiple of 4
    fGenMul=4;
    iMax=0;
    y=rem(basicTime*currFPuls,1); % y belongs to [0,1]
    [mini,ind]=sort(y);
    for jj=1:length(ind)
        if ( jj==1 && mini(ind(jj))==0 ), continue; end % exclude first zero
        if mod(ind(jj)-1,fGenMul)==0
            iMax=ind(jj);
            break;
        end
    end
end