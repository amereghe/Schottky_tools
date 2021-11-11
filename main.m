%script per la generazione di 4 segnali (longitudinale e trasversale) per
%caso di singola particella con e senza cavità RF (rispettivamente caso
%bunched ed unbunched);

%di seguito tutti i parametri di fascio, analisi e macchina utilizzati per
%la visualizzazione dei segnali

fsamp=125*10^6; %frequenza di campionamento del segnale
intTime=2*10^-6; %tempo di integrazione
fs=1.173*10e3; %frequenzza di sincrotrone ~1kHz
friv=2.167*10^6; %frequenza di rivoluzione
T=1/friv;
dt=1/fsamp; %passo temporale
t=time(intTime,dt); %vettore dei tempi
w=100*10^-9; %100ns: durata dell'impulso/rect < (1/(2*friv))
n=size(t,1); %numero di campioni
df=fsamp/n; %passo in frequenza
f=(0:df:fsamp-df)'; %vettore delle frequenze

%modulazione t
taus=0.25/friv; %ampiezza della funzione di spaziatura (Triv!=cost.), deve essere <Triv/2=1/(2*friv)
%scelgo tau/4 in quanto armomnica 1
tau=taus*sin(2*pi*fs*t);

%modulazione tune
qh=1.67; %tune orizzontale (intero+frazionario)
fb=qh*friv; %frequenza di betatrone
a0=0; %valore medio della sinusoide di modulazione
a=1; %ampiezza
y=(a0+a*cos(2*pi*fb*t+pi/2)); %simusoide di modulazione posizione transversa


x=rectpuls(t,w); %longi unbunched
x1=x; %longi bunched

for i=1:n
    x=x+rectpuls(t-i*T,w); %longi unbunched
end

X=fftshift(fft(x));

if taus~=0 %serve aggiungere n*1/friv dove n indica la posizione nell'array
    for k=1:n
    tau(k)=k/friv+tau(k);
    end
end

for j=1:n
    x1=x1+rectpuls(t-tau(j),w); %longi bunched
end
%IMP: in questo caso mi rendo conto che per risolvere la freq. di
%sincrotrone (~1kHz) ho bisogno di tempi di integrazione molto maggiori
%rispetto all'unbunched

X1=fftshift(fft(x1));

%trans unbunched e bunched: nuovo segnale modulato in fase da tune
if qh~=0 && a~=0
    z=x.*y; %trans unbunched
    Z=fftshift(fft(z));
    z1=x1.*y; %trans bunched
    Z1=fftshift(fft(z1));
end

plotall(n,t,x,x1,z,z1,f,X,X1,Z,Z1);