clear all; close all; clc;

[y,Fs]=wavread('signal_la.wav');
%variabl=audioplayer(y,Fs);
%play(variabl);
%fs=44100;
%x=wavread('nomdefichier.wav');
%sound(x.fd);

fft_cor=coupe(fft(y),1000,22000,Fs);
x=real(ifft(fft_cor));
play(audioplayer(x,Fs));
sound(x,Fs);