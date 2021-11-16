function [y]=delta(t)

    y=zeros(1,length(t)); 
    [~,i]=min(abs(t)); 
    y(i)=1/(t(2)-t(1)); 
    
end