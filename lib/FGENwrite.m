function FGENwrite(oFileName,iFileName,signal,fsamp,gain,repeat)
% FGENwrite                       write a signal in a .ini file

%   There are two sections in the file: the first is the header where we
%   find the value of sampling frequency, gain of the acquisition chain and
%   the repetition number (value) to ensure a continuous acquisition; the
%   second section is storing the values of the generated signal. You need
%   to add an empty file in your folder named 'out.ini' in order to save
%   passed result; if signal is passed from the Schottky_tools you would
%   need to trasnpose 'signal' before you pass it in the main while. You
%   also need the 'template.ini' file in the same folder.

    %% check input parameters
    if ~exist('fsamp','var'),  fsamp=125E6; end % default sampling frequency [Hz]
    if ~exist('gain','var'),   gain=1;      end % default gain [%]
    if ~exist('repeat','var'), repeat=1;    end % default repeat flag
    if ( strlength(oFileName)==0 || ismissing(oFileName) ), oFileName="out.ini"; end
    if ( strlength(iFileName)==0 || ismissing(iFileName) ), iFileName="template.ini"; end
        
    fprintf("saving signal to file %s ...\n",oFileName);
    
    %% convert signal from numeric to text
    signalTxt=sprintf("%13.6E; ",signal(1:end-1))+sprintf("%13.6E ",signal(end));
    fprintf("...signal made of %d points...\n",length(signal));

    %% crunch template file and re-write it accordingly
    iFileID=fopen(iFileName,'r');
    oFileID=fopen(oFileName,'w');
    while ~feof(iFileID)
        line=fgetl(iFileID);
        if startsWith(line,'#') || startsWith(line,'[')
            fprintf(oFileID,'%s\r\n',line);
        elseif startsWith(line,'fcamp')
            fprintf(oFileID,'%s%g\r\n','fcamp = ',fsamp);
        elseif startsWith(line,'gain')
            fprintf(oFileID,'%s%u\r\n','gain = ',gain);
        elseif startsWith(line,'repeat')
            fprintf(oFileID,'%s%u\r\n','repeat = ',repeat);
        elseif startsWith(line,'values')
            fprintf(oFileID,'%s%s\r\n','values = ',signalTxt); %need to add %c also here? mat col ends with no ender
        end
    end

    %% bye bye
    fclose(iFileID);
    fclose(oFileID);
    fprintf("...done.\n");

end

