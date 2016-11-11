% Avec ce nom je pense que personne ira 
%  voir dans le fichier ;-)
% Sinon c'est pas immédiat de retrouver le code en 
%  trichant
function []=clear_matlab()
delta=400;
Fe=44000;
Ft=200; %Fréquence de transmission des bits
tl=0:1/Fe:1/Ft; %Vecteur temps d une période de FSK
wb=1000; %Frequence correspondant au zero
wh=2000; %Fréquence du un
sin_bas=sin(wb*2*pi*tl); %signal signifiant 0
sin_haut=sin(wh*2*pi*tl); %   "       "     1

code=(randn(8,1)>0);
masque=[0;1;0;1;1;0;1;0]; % Le code que doit trouver l'étudiant
cypher=xor(code,masque);
save('.backup','cypher');
%% construction du signal modulé
sig_fsk=[];
for l=1:length(code)
    sig_fsk=[sig_fsk (1-code(l))*sin_bas+code(l)*sin_haut];
end 

%constantes pour affichage
L=length(sig_fsk);
t=0:1/Fe:(L-1)/Fe;

%%construction du bruit
bruit=rand(1,L)-0.5; % bruit blanc
 %construction d'un bruit HF plus important
 % il démarre de wh+delta à wh-delta pour ne pas trop
 % perturber la modulation: on triche un peu quoi ;-)

%freq=0:Fe/L:Fe-Fe/L;
fft_bruit=fft(bruit);
%subplot(311);
%plot(freq,abs(fft(sig_fsk)));
fft_bruit=coupe(fft_bruit,0,wh+delta,Fe);
hbruit=(real(ifft(fft_bruit)));% le bruit HF

% le signal c'est le FSK + bruit blanc +bruit HF
signal=4*bruit+6*hbruit + sig_fsk;
save('fsk_brut.mat','signal','t','L','Fe');
%subplot(312);
%plot(freq,abs(fft(bruit)));
%subplot(313);
%plot(freq,abs(fft(signal)));
%figure;





