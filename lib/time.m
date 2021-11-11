function [t] = time(intTime,dt)

%TIME Summary of this function goes here

%   creazione vettore tempi per i plot, il primo valore rappressenta il
%   tempo di integrazione mentre il secondo è il passo temporale dato dalla
%   frequenza di campionamento

    t=(0:dt:intTime-dt)';
    
end

