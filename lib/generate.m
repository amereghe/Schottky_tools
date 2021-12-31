function [xx] = generate(fs,tt,qq,friv,ww,taus,a0,aa)
% generate             actually generates the time signal
%
% The signal is generated as the repetition of a basic signal, representing a
%    single of a single particle at the Schottky monitor.
% Signals that can be generated are:
% - sigma/longitudinal: the sum of the signal recorded by both plates of
%   the Schottky pick-up (same plane). This signal is proportional to
%   particle charge (i.e. beam intensity);
% - delta/transverse: the difference of the signal recorded by both plates of
%   the Schottky pick-up (same plane). This signal is proportional to
%   particle position;
%
% input:
% - fs (scalar, double precision): synchrotron frequency [Hz];
% - tt (1D array, double precision): time array [s];
% - qq (scalar, double precision): betatron tune (int+frac) [];
% - friv (scalar, double precision): revolution frequency [Hz];
% - ww (scalar, double precision): time length of the single-particle signal [s];
% - taus (scalar, double precision): amplitude of synchrotron motion [s];
% - a0 (scalar, double precision): average value of betatron modulation [].
%   This parameter can mimic a closed-orbit offset;
% - aa (scalar, double precision): amplitude of betatron modulation [].
%
% output:
% - xx (1D array, double precision): time signal [s]. It is of the same
%   size as tt;

    %% parameters
    nn=size(tt,1);                % number of samples []
    dt=tt(2)-tt(1);               % time resolution [s]
    intTime=tt(end)+dt;           % integration time [s]
    nCentres=round(intTime*friv); % number of full signals []
    tau=((0:nCentres)/friv)';     % central time of particle passage [s]

    %% atual signal
    % - initialisation
    xx=zeros(nn,1);

    % - synchrotron motion (changes time of passage of particle turn by turn)
    if(fs~=0), tau=tau+taus*sin(2*pi*fs*tau); end
    
    % - central time
    add=0; if (tau(end)/dt<nn), add=1; end
    for kk=1:nCentres+add
    %     xx=imp_one(tau(kk),ww,dt,tt,xx); %longitudinal bunched, maybe useful for gauss
        ind=round(tau(kk)/dt)+1;
        xx(ind)=1;
    end

    % - betatron motion (i.e. amplitude modulation, like transverse position)
    if(qq~=0), xx=xx.*(a0+aa*sin(2*pi*qq*friv*tt)); end

end

function [SS] = imp_one(t0,ww,dt,tS,SS)
% imp_one           inserts a single-particle,single-passage signal at t0
%
% input:
% - tS, SS (1D arrays, double precision): time [s] and original signal [];
% - t0 (scalar, double precision): central time at which the
%   single-particle, single-passage signal should be inserted [s];
% - ww (scalar, double precision): width of the single-particle, 
%   single-passage signal (non-zero part) should be inserted [s];
% - dt (scalar, double precision): resolution of time domain [s];
%
% output:
% - modified SS array;

    % basic single-particle, single passage signal to insert
    hRange=2.5;
    tt=(t0-hRange*ww:dt:t0+hRange*ww);
    ss=MyRect(tt-t0,ww);

    % places in S to be modified
    t1=min(tt)-dt/2; t2=max(tt)+dt/2;
    indT=find(t1<=tS & tS<=t2);

    % actually insert signal
    if ( length(indT)==length(tt) )
        SS(indT)=ss;
    end

end

function ff=MyRect(tt,ww)
% MyRect           generates a rect signal
% 
% input:
% - tt (1D array, double precision): time [s];
% - ww (scalar, double precision): width of the rect [s];
%
% output:
% - ff (1D array, double precision): rect signal []. The array has the
%      same size as that of tt;
%
    eps=1E-22;
    ff=zeros(length(tt),1);
    ff(abs(tt)<abs(ww)+eps)=1;
end
