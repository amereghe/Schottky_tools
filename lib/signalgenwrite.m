function signalgenwrite(signal,fsamp,gain,repeat)

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

% signal=signal';

if ~exist('fsamp','var')
    fsamp='125E6'; %[Hz]
end

if ~exist('gain','var')
    gain=1;
end

if ~exist('repeat','var')
    repeat=1;
end
   
fileread=fopen('template.ini','r');
filewrite=fopen('out.ini','w');
ID_linea=1;
nline=22;

while (ID_linea<nline)
    
    linea=fgetl(fileread);
    
    if ~ischar(linea)
        break;
    end
    
    if linea(1)=='#' || linea(1)=='['
        fprintf(filewrite,'%s\n',linea);
    end
    if linea(1)=='f'
        fprintf(filewrite,'%s%s\n','fcamp = ',fsamp);
    end
    if linea(1)=='g'
        fprintf(filewrite,'%s%u\n','gain = ',gain);
    end
    if linea(1)=='r'
        fprintf(filewrite,'%s%u\n','repeat = ',repeat);
    end
    if linea(1)=='v'
        fprintf(filewrite,'%s\n',signal);
    end
    
ID_linea=ID_linea+1;

end

fclose(fileread);
fclose(filewrite);

end

