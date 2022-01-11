function signalgenwrite(filewrite,fileread,signal,fsamp,gain,repeat)

%SIGNALGENWRITE used to write data coming from the genearor of functions in
% a .ini file

%   There are two sections in the file: the first is the header where we
%   find the value of sampling frequency, gain of the acquisition chain and
%   the repetition number (value) to ensure a continuous acquisition; the
%   second section is storing the values of the generated signal. You need
%   to add an empty file in your folder named 'out.ini' in order to save
%   passed result; if signal is passed from the Schottky_tools you would
%   need to trasnpose 'signal' before you pass it in the main while. You
%   also need the 'template.ini' file in the same folder.

% add these followimg two lines in the main code
% fileread=fopen('template.ini','r');
% filewrite=fopen('out.ini','w');

% signal=signal';
signal1=sprintf("%13.6E; ",signal(1:end-1))+sprintf("%13.6E ",signal(end));

if ~exist('fsamp','var')
    fsamp=125E6; %[Hz]
end

if ~exist('gain','var')
    gain=1;
end

if ~exist('repeat','var')
    repeat=1;
end
   
ID_line=1;
nline=22;

while (ID_line<nline)
    
    line=fgetl(fileread);
    
    if ~ischar(line)
        break;
    end
    
    if startsWith(line,'#') || startsWith(line,'[')
        fprintf(filewrite,'%s\n',line);
    end
    if startsWith(line,'fcamp')
        fprintf(filewrite,'%s%g\n','fcamp = ',fsamp);
    end
    if startsWith(line,'gain')
        fprintf(filewrite,'%s%u\n','gain = ',gain);
    end
    if startsWith(line,'repeat')
        fprintf(filewrite,'%s%u\n','repeat = ',repeat);
    end
    if startsWith(line,'values')
        fprintf(filewrite,'%s%s\n','values = ',signal1); %need to add %c also here? mat col ends with no ender
    end
    
ID_line=ID_line+1;

end

fclose(fileread);
fclose(filewrite);

end

