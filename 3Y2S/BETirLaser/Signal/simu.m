clear all
close all

%declaration des paramètres
T=1;
M=32;
Te=T/M;
Tsim=T-Te;
Fsin=5.5;



%simulation
sim('essaisimu')

%calcul fft
F=1/T;%Ftotal=1/Te=32 2*fmax<F?!
fre_fft=[0:M-1]*F;
sim_fft=abs(fft(sim_ech));

%tracer des courbes
subplot(2,1,1)
plot(tps_cont,sim_cont);
hold on;
plot(tps_ech,sim_ech,'r*');
subplot(2,1,2)
stem(fre_fft,sim_fft);
%fft
grid;