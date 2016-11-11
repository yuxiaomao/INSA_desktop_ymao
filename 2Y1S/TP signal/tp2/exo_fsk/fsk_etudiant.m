%% Simulation d'une démodulation hors ligne d'un signal modul� par 
%% d�placement de fr�quence FSK
%% Attention demandez au prof de venir g�n�rer un signal cod� pour vous! 

%% Ne pas oublier de faire clear_matlab ! tha genrate fsk_brut.mat
%% pascal.acco@insa-toulouse.fr

close all;
clear all;

%% On charge le signal modul� et bruit�
load('fsk_brut.mat');
% signal : contient le signal
% L : le nombre d'�chantillons
% t : le vecteur temps
% Fe : la fr�quence d'�chantillonnage
plot(t,signal,'r');

fft_cor=coupe(fft(signal),2500,22000,Fe);
plot(t,real(ifft(fft_cor)));

%% Entrez ici le code que vous avez trouv� � l'oeil
code=[1;0;0;0;1;1;0;0];    
verif_code(code)









