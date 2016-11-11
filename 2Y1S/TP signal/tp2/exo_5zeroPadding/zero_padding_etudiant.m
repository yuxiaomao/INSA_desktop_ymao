clear all; 
close all;
clc;

Tf1=0.5;
Tf2=5;%%%%
Fe=100;
f0=10;

Te=1/Fe;
M1=100;
M2=1000;
df1=Fe/M1;
df2=Fe/M2;



temps1=[0:Te:(M1-1)*Te];
temps2=[0:Te:(M2-1)*Te];

signal1=sin([0:2*pi*f0*Te:2*pi*f0*(M1-1)*Te]);
signal2=[signal1,zeros(1,M2-M1)];
plot (temps1, signal1, 'r-');

frequence1= [0:df1:(M1-1)*df1];
frequence2= [0:df2:(M2-1)*df2];

X1=fft(signal1,M1);
X2=fft(signal2,M2);


plot(frequence1,abs(X1),'b');
hold on;
pause;
plot(frequence2,abs(X2),'g*');