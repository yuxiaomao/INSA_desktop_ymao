%% Mise en �vidence de repliement du spectre
%%  autour de la fr�quence de Shannon: Fe/2
clear all; close all;

Fe=300;

tfin=0:1/Fe/100:0.05; %vecteur temps tr�s fin
t=0:1/Fe:0.05;% vecteur temps des �chantillons

figure(1);

subplot(211);
stem(t,sin((150-130)*2*pi*t),'r');
hold on;
plot(tfin,sin((150-130)*2*pi*tfin),'b');
xlabel('temps');
ylabel('sinusoide � 20 Hz');
title('Sinusoide � 150-130 Hz, �chantillonn�e � 300Hz');

subplot(212);
stem(t,sin((150+130)*2*pi*t+pi),'r');
hold on;
plot(tfin,sin((150+130)*2*pi*tfin+pi),'b');
xlabel('temps');
ylabel('sinusoide � 20 Hz');
title('Sinusoide � 150+130 Hz, �chantillonn�e � 300Hz');

figure(2);

subplot(211);
stem(t,sin((150-10)*2*pi*t),'r');
hold on;
plot(tfin,sin((150-10)*2*pi*tfin),'b');
xlabel('temps');
ylabel('sinusoide � 140 Hz');
title('Sinusoide � 150-10 Hz, �chantillonn�e � 300Hz');

subplot(212);
stem(t,sin((150+10)*2*pi*t+pi),'r');
hold on;
plot(tfin,sin((150+10)*2*pi*tfin+pi),'b');
xlabel('temps');
ylabel('sinusoide � 160 Hz');
title('Sinusoide � 150+10 Hz, �chantillonn�e � 300Hz');

