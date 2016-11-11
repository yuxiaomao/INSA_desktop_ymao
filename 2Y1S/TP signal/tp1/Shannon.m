%% Mise en évidence de repliement du spectre
%%  autour de la fréquence de Shannon: Fe/2
clear all; close all;

Fe=300;

tfin=0:1/Fe/100:0.05; %vecteur temps trés fin
t=0:1/Fe:0.05;% vecteur temps des échantillons

figure(1);

subplot(211);
stem(t,sin((150-130)*2*pi*t),'r');
hold on;
plot(tfin,sin((150-130)*2*pi*tfin),'b');
xlabel('temps');
ylabel('sinusoide à 20 Hz');
title('Sinusoide à 150-130 Hz, échantillonnée à 300Hz');

subplot(212);
stem(t,sin((150+130)*2*pi*t+pi),'r');
hold on;
plot(tfin,sin((150+130)*2*pi*tfin+pi),'b');
xlabel('temps');
ylabel('sinusoide à 20 Hz');
title('Sinusoide à 150+130 Hz, échantillonnée à 300Hz');

figure(2);

subplot(211);
stem(t,sin((150-10)*2*pi*t),'r');
hold on;
plot(tfin,sin((150-10)*2*pi*tfin),'b');
xlabel('temps');
ylabel('sinusoide à 140 Hz');
title('Sinusoide à 150-10 Hz, échantillonnée à 300Hz');

subplot(212);
stem(t,sin((150+10)*2*pi*t+pi),'r');
hold on;
plot(tfin,sin((150+10)*2*pi*tfin+pi),'b');
xlabel('temps');
ylabel('sinusoide à 160 Hz');
title('Sinusoide à 150+10 Hz, échantillonnée à 300Hz');

