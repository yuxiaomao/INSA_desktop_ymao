clear all
close all
clc

T0=1;
Te=T0/100;
M=5*T0/Te;
A=1;


temps=[0:Te:(M-1)*Te];


signal=zeros(1,M);
for n=0:M-1
    signal(n+1)=s(A,T0,n*Te);
end


plot(temps,signal,'r-');
grid;
xlabel('temps');
ylabel ('signal');



