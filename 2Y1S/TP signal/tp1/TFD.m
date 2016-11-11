clear all; 
close all;
clc;

Tf=1;
M=500;
Te=Tf/M;
Fe=1/Te;
Ff=1/Tf;
f0=280

temps=[0:Te:(M-1)*Te];

sinus=sin([0:2*pi*f0*Te:2*pi*f0*(M-1)*Te]);
plot (temps, sinus, 'r-');

frequence= [0:Ff:(M-1)*Ff];

signal=zeros(1,M);
for n=0:M-1
    signal(n+1)=s(1,Tf,n*Te);
end


c=zeros(1,M);
for n=0:M-1
    for k=0:M-1 
       c(n+1)=c(n+1)+sinus(k+1)*exp(-2i*pi*n*k/M);
    end 
    c(n+1)=c(n+1)/M;
end
stem (frequence, abs(c));