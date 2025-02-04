% {}~

%% description
% script to generate a signal and save it in a .ini file for LabView FGEN

%% include libraries
pathToLibrary="lib";
addpath(genpath(pathToLibrary));
pathToLibrary="externals";
addpath(genpath(pathToLibrary));

%% sampling parameters
tUP=500E-3; % [s]
tDW=100E-3; % [s]
tTT=tUP+tDW;
% fPuls=[ 511.34E3 5.1134E6 15.437E6 ]; % [Hz]
fPuls=1/tTT; % [Hz]
% fPuls=500E3; % [Hz]
% fPuls=5.1134E6; % [Hz]
intTime=tTT; % [s]
fSamp=5E6; % [Hz]
lConcatenate=true;
sigType="rectpart";
% for Rectangle only
ws=tUP;
as=1;
% % for Gaussian signals only
% ws=0.1./fPuls;     % sigma_time [s]
% as=sqrt(2*pi)*ws;  % amplitude
% trunc=[0.2 0.8];         % truncation level [0:1]

%% clear stuff
clear tOut sOut; tOut=missing(); sOut=missing();
clear myLabels; myLabels=missing();
clear ff FF; ff=missing(); FF=missing();

%% generate signals
switch upper(sigType)
    case {"SIN","COS"}
        [ttOut,stOut] = FGENgenerate(fPuls,intTime,fSamp,lConcatenate,sigType);
    case "GAUSS"
        [ttOut,stOut] = FGENgenerate(fPuls,intTime,fSamp,lConcatenate,sigType,as,ws);
    case "GAUSSPART"
        [ttOut,myFreq,myDt,myDf]=StandardAxes(fSamp,intTime,false);
        stOut=SimulatePartPassages(ttOut,fPuls,0,0,0,0,0,"GAUSS",as,ws,trunc);
        nSamps=FGENtruncate(ttOut,fPuls); ttOut=ttOut(1:nSamps-1); stOut=stOut(1:nSamps-1);
    case "RECTPART"
        [ttOut,myFreq,myDt,myDf]=StandardAxes(fSamp,intTime,false);
        stOut=SimulatePartPassages(ttOut,fPuls,0,0,0,0,0,"RECTANGLE",as,ws);
        nSamps=FGENtruncate(ttOut,fPuls); ttOut=ttOut(1:nSamps-1); stOut=stOut(1:nSamps-1);
    otherwise
        error("unknown signal type: %s!",sigType);
end
tOut=PaddMe(ttOut,tOut); sOut=PaddMe(stOut,sOut);
if ( length(fPuls)==1 )
    myLabels=PaddMe(GenNameSingSignal(sigType,fPuls),myLabels);
else
    myLabels="combined";
end

%% write to file
for ii=1:size(sOut,2)
    oFileName=sprintf("%s.ini",myLabels(ii));
    FGENwrite(oFileName,"template.ini",sOut(~ismissing(sOut(:,ii)),ii),fSamp);
end

%% read back file
files=dir("rectpart*.ini");
for iFile=1:length(files)
    oFileName=strcat(files(iFile).folder,"\",files(iFile).name);
    [ttOut,stOut] = FGENread(oFileName);
    tOut=PaddMe(ttOut,tOut); sOut=PaddMe(stOut,sOut);
    myLabels=PaddMe(string(files(iFile).name),myLabels);
end

%% apply windowing
tOut=PaddMe(tOut,tOut); sOut=PaddMe(WindowMe(sOut,"BH"),sOut);
myLabels=PaddMe(strcat(myLabels,"_BH"),myLabels);

%% get FFTs
[tff,tFF]=FFTme(tOut,sOut);
ff=PaddMe(tff,ff); FF=PaddMe(tFF,FF);

%% plot 
ShowTime(tOut,sOut); legend(LabelMe(myLabels),"Location","best"); % set(gca, 'YScale', 'log'); % time signals
% ShowFFT(ff,dBme(FF)); legend(LabelMe(myLabels),"Location","best"); % FFTs

function oFileName=GenNameSingSignal(fixedName,fPulse)
    if ( fPulse>1E6 )
        oFileName=sprintf("%s_MHz%07.3f",fixedName,fPulse*1E-06);
    elseif ( fPulse>1E3 )
        oFileName=sprintf("%s_kHz%07.3f",fixedName,fPulse*1E-03);
    else
        oFileName=sprintf("%s_Hz%g",fixedName,fPulse);
    end
end
