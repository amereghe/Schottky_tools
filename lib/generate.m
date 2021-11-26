function [x] = generate(fs,t,q,friv,w,taus,a0,a)

n=size(t,1);
dt=t(2)-t(1);
intTime=t(end)+dt;
nRect=intTime*friv;
tau=((0:nRect)/friv)';

x=zeros(n,1);

if(fs~=0)
    tau=tau+taus*sin(2*pi*fs*tau); %time modulation
end

for k=1:nRect+1
    x=x+rectpuls(t-tau(k),w); %longitudinal bunched
end

if(q~=0)
    %modulation sin, transverse position
    x=x.*(a0+a*cos(2*pi*q*friv*t+pi/2)); %transversal bunched
end

end
