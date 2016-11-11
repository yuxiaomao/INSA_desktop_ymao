%% permet de couper directement dans le spectre ffte.
%% les coeffs sont annulés entre les fréquences fmin et fmax
%% mais aussi entre Fe-Fmax et Fe-Fmin
function fft_cor=coupe(ffte,fmin,fmax,Fe)
L=length(ffte);
imin=round(fmin/Fe*L)+1;
imax=round(fmax/Fe*L);
fft_cor=ffte;
fft_cor(imin:imax)=fft_cor(imin:imax)*0;
fft_cor(L-imax:L-imin)=fft_cor(L-imax:L-imin)*0;
