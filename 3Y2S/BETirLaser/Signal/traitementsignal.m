clear all
close all

%declaration des paramètres
F=5000;
Fe=320000;
T=1/F;
Te=1/Fe;
M=Fe/F;
Tsim=T-Te;
F1=85005.9;
F2=90000;
F3=94986.8;
F4=100000;
F5=115015.9;
F6=120000;



%simulation
sim('traitementsimu')

%i = 0;
%for i = 1:20
%  sim_ech(i)=0;
%end

G=tf([1],[1.7483*10^(-23),7.6663*10^(-18),1.162*10^(-11),3.0332*10^(-6),1]);
figure(1);
bode(G);

%calcul fft
fre_fft=[0:M-1]*F;
sim_fft=(abs(fft(sim_ech)));

%tracer des courbes
figure(2);
subplot(2,1,1)
plot(tps_cont,sim_cont);
hold on;
plot(tps_ech,sim_ech,'k*');
plot(tps_cont,sim_cont1,'r');
%figure(3);
subplot(2,1,2)
stem(fre_fft,sim_fft);
%fft
grid;