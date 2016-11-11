%% Effets du fenetrage sur la fft
%un signal inconnu est stocke dans le fichier signal
%apres l avoir charge, vous devrez analyser ce signal frequentiellement
%vous utiliserez pour cela les fenetres rectangulaires et de hanning


clear all;
close all;
clc;


%Lecture du signal et des parametres (fonction load) dans le fichier signal
load('signal.mat');
%vous r�cup�rez ainsi un vecteur signal
% Fs est la fr�quence d'�chantillonnage
%

Fe=Fs;

%% Ne pas toucher � cette ligne l�
FUMER_TUE=zeros(size(signal));

%% Changez tout les FUMER_TUE qui suivent par du code matlab qui fait
%quelquechose d'int�ressant.


%calcul de la fft avec fenetre naturelle (help fft fftshift)
fft_sig=fft(signal,81)/81;
dsp=(abs(fft_sig)).^2; %% Dsp = Densit� Spectrale de Puissance
%% il faut calculer la puissance des composantes de chaque
%% fr�quence. Voir le cours ;-)


%calcul de la fft avec fenetre de hanning  (help hanning)
sig_han=[signal zeros(1,119)].*(hanning(200).'); 
%%ajouter zeros et puis *hanning §§ok pour 2pic

%sig_han=signal.*(hanning(81).');  
%%hanning direct puis zeros §§ok pour pic 30

figure
plot(signal,'r--');
hold on;
plot(sig_han);

fft_sig_han=fft(sig_han,200);
dsp_han=(abs(fft_sig_han)).^2;


%tracer la premiere dsp et la deuxieme dsp en echelle lineaire et en echelle semi logarithmique 
M=length(fft_sig);%longueur de la dsp
freq=0:Fe/(M-1):Fe;%axe des frequences
freq2=0:Fe/(200-1):Fe;




figure;%ouverture d'une fenetre 1
subplot(211);%on se place dans la premiere sous fenetre
plot(freq,dsp);%premiere dsp en echelle lineaire
hold on;
plot(freq2,dsp_han,'r');%deuxieme dsp en echelle lineaire
xlabel('FUMER_TUE');%legende en abcisse
title('dsp avec fenetrage echelle lineaire');%titre

subplot(212);%on se place dans la seconde sous fenetre
semilogy(freq,dsp+1E-5);%premiere dsp en enchelle semi logarithmique 
hold on;
semilogy(freq2,dsp_han+1E-5,'r');%deuxieme dsp en enchelle semi logarithmique 

xlabel('FUMER_TUE');%legende en abcisse
title('dsp avec fenetrage:echelle Log');%titre

