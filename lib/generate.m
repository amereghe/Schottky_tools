function [x] = generate(fs,t,q,friv,w,taus,a0,a)
%generate is the final tool that helps us in generating sigma and delta
%(longitudinal and transversal) signals related to the Schottky analysis

n=size(t,1);
dt=t(2)-t(1);
intTime=t(end)+dt;
nRect=round(intTime*friv);
tau=((0:nRect)/friv)';

x=zeros(n,1);

if(fs~=0)
    tau=tau+taus*sin(2*pi*fs*tau); %time modulation
end

if tau(end)/dt<n
    add=1;
else
    add=0;
end

for k=1:nRect+add
%     x=foo(tau(k),w,dt,t,x); %longitudinal bunched, maybe useful for gauss
    ind=round(tau(k)/dt)+1;
    x(ind)=1;
end

if(q~=0)
    %modulation sin, transverse position
    x=x.*(a0+a*sin(2*pi*q*friv*t)); %transversal bunched
end

end

function [S] = foo(tau_1,w,dt,t,S)
%foo returns the signal with ones in the right position in order to build
%the signal of our interest

% signal to insert
tt=(tau_1-2.5*w:dt:tau_1+2.5*w);
s=MyRect(tt-tau_1,w);

% places in S to be modified
t1=min(tt)-dt/2;
t2=max(tt)+dt/2;
indT=find(t1<=t & t<=t2);

if ( length(indT)==length(tt) )
    S(indT)=s;
end

end

function ff=MyRect(tt,w)
%MyRect places ones where needed in an initial array of zeros

    eps=1E-22;
    ff=zeros(length(tt),1);
    ff(abs(tt)<abs(w)+eps)=1;
end
