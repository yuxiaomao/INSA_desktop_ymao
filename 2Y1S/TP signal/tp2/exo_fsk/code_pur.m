%% Simulation d'une démodulation hors ligne d'un signal modulé par 
%% déplacement de fréquence FSK
% génère une figure utilisée pour le poly

close all;
clear all;

Fe=100000;
Ft=100; %Fréquence de transmission des bits
tl=0:1/Fe:1/Ft; %Vecteur temps d'une période de FSK
wb=400; %Frequence correspondant au zero
wh=800; %Fréquence du un
sin_bas=sin(wb*2*pi*tl); %signal signifiant 0
sin_haut=sin(wh*2*pi*tl); %   "       "     1

code=[1;0;1;0;0]; % Le code que doit trouver l'étudiant

%% construction du signal modulé
sig_fsk=[];
for l=1:length(code)
    sig_fsk=[sig_fsk (1-code(l))*sin_bas+code(l)*sin_haut];
end 

%constantes pour affichage
L=length(sig_fsk);
t=0:1/Fe:(L-1)/Fe;
freq=0:Fe/L:Fe-Fe/L;

plot(t,sig_fsk)

subplot(211);
plot(t,sig_fsk)
ylabel('Signal temporel')
xlabel('temps')
%%% On recommence pour la fft


Fe=44000;
Ft=100; %Fréquence de transmission des bits
tl=0:1/Fe:1/Ft; %Vecteur temps d'une période de FSK
wb=8000; %Frequence correspondant au zero
wh=12000; %Fréquence du un
sin_bas=sin(wb*2*pi*tl); %signal signifiant 0
sin_haut=sin(wh*2*pi*tl); %   "       "     1

code=[1;0;1;0;0]; % Le code que doit trouver l'étudiant

%% construction du signal modulé
sig_fsk=[];
for l=1:length(code)
    sig_fsk=[sig_fsk (1-code(l))*sin_bas+code(l)*sin_haut];
end 

%constantes pour affichage
L=length(sig_fsk);
t=0:1/Fe:(L-1)/Fe;
freq=0:Fe/L:Fe-Fe/L;

subplot(212);
plot(freq/1000,abs(fft(sig_fsk)));
ylabel('Signal fréquentiel')
xlabel('Fréquence en KHz')

     subplot(211);
title('Exemple de signal FSK codant 10100')



