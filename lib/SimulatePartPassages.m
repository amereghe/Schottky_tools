function yy = SimulatePartPassages(tt,friv,fs,taus,qq,a0,aa,sigType,as,ws)
% SimulatePartPassages             actually generates the time signal of 
%                                     particles passing at the Schottky,
%                                     turn by turn
%
% The signal is generated as the repetition of a basic signal, given by a
%    single passage of a single particle at the Schottky monitor.
% Signals that can be generated are:
% - sigma/longitudinal: the sum of the signal recorded by both plates of
%   the Schottky pick-up. This signal gives insights into the longitudinal
%   beam dynamics and it is proportional to particle charge (i.e. beam intensity);
% - delta/transverse: the difference of the signal recorded by both plates of
%   the Schottky pick-up (same plane). This signal gives insights into the
%   transverse beam dynamics and it is proportional to particle position;
%
% input:
% - tt (1D array, double precision): time array [s];
% - friv (scalar, double precision): revolution frequency [Hz];
% - fs (scalar, double precision): synchrotron frequency [Hz];
% - taus (scalar, double precision): amplitude of synchrotron motion [s];
% - qq (scalar, double precision): betatron tune (int+frac) [];
% - a0 (scalar, double precision): average value of betatron modulation [].
%   This parameter can mimic a closed-orbit offset;
% - aa (scalar, double precision): amplitude of betatron modulation [];
% - sigType (string): type of signal (DELTA/RECT/GAUSS);
% - as (scalar, double precision): amplitude of signal [V] (all signals);
% - ws (scalar, double precision): width of signal [s] (only RECT and GAUSS);
%   RECT: full duration of RECT;
%   GAUSS: sigma of Gaussian profile;
%
% output:
% - yy (1D array, double precision): time signal [V]. It is of the same
%   size as tt;

    %% parameters
    nSamples=size(tt,1);            % number of samples []
    dt=tt(2)-tt(1);                 % time resolution [s]
    intTime=tt(end)-tt(1);          % integration time [s]
    
    % - initialisation
    yy=zeros(nSamples,1);

    %% integrity checks
    if ( CompFloats((nSamples-1)*dt,intTime,"GT") )
        error("...something wrong with the signal generation!");
    end
    
    if ( as<=0 ), warning("...as<=0: null signal!!"); end
    
    % signal types
    if ( ~strcmpi(extractBetween(sigType,1,5),"DELTA") )
        if ( ws<0 ), error("...negative duration of single passage signal!"); end
        if ( ws==0 )
            warning("...reverting signal to DELTA!"); sigType="DELTA";
        end
        if ( ~strcmpi(extractBetween(sigType,1,4),"RECT") & ~strcmpi(extractBetween(sigType,1,5),"GAUSS") )
            error("...un-recognised signal type: %s (only DELTA, RECT, GAUSS)",sigType);
        end
    end
    
    % longitudinal beam dynamics
    if (ismissing(fs)), fs=0; end
    if (ismissing(taus)), taus=0; end
    if ( (fs==0 && taus~=0) | (fs~=0 && taus==0) )
        warning("...inconsisten set of values of fs and taus: setting to 0.0 both!");
        fs=0; taus=0;
    end
    % transverse beam dynamics
    if (ismissing(qq)), qq=0; end
    if (ismissing(aa)), aa=0; end
    if ( (qq==0 && aa~=0) | (qq~=0 && aa==0) )
        warning("...inconsisten set of values of qq and aa: setting to 0.0 both!");
        qq=0; aa=0;
    end

    %% atual signal
    % - number of passages []
    nCentres=floor(intTime*friv);
    
    % - central times
    tau=(((1:nCentres)-0.5)/friv+tt(1))'; % central time of particle passage [s]

    % - synchrotron motion (changes time of passage of particle turn by turn)
    if(fs~=0), tau=tau+taus*sin(2*pi*fs*tau); end
    
    % - betatron motion (i.e. amplitude modulation, like transverse position)
    if(qq~=0), betaAmpli=(a0+aa*sin(2*pi*qq*friv*tau)); else betaAmpli=missing(); end

    % - actual time signals
    if ( strcmpi(extractBetween(sigType,1,5),"DELTA") )
        yy=GenerateDeltas(tt,yy,tau,as,betaAmpli);
    elseif ( strcmpi(extractBetween(sigType,1,4),"RECT") )
        yy=GenerateRectangles(tt,yy,tau,as,ws,betaAmpli);
    elseif ( strcmpi(extractBetween(sigType,1,5),"GAUSS") )
        yy=GenerateGaussians(tt,yy,tau,as,ws,betaAmpli);
    end


end
