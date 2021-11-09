function [y]=treno(t,T)
         i=T;
         y=delta(t); %delta in 0
    while i<=max(t) 
        y=y+delta(t-i)+delta(t+i); 
        i=T+i;
    end
end