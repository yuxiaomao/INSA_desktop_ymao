clear all; close all; clc;


T0=1;
Te=T0/1000;
M=5*T0/Te;
Tf=5*T0;
Tau=0.05;


temps=[0:Te:(M-1)*Te];
frequence=[0:1/Tf:(M-1)*1/Tf];

x=zeros(1,M);
for n=0:M-1
    x(n+1)=s(1,T0,n*Te);
end
plot(temps,x,'r');
hold on;

y=zeros(1,M);
y(1)=0;
for k=2:M
    y(k)=Tau*y(k-1)/(Te+Tau)+Te*x(k)/(Te+Tau);
end
plot(temps,y,'g');