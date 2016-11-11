clear all
close all
clc

T0=1;
Te=T0/1000;
M=5*T0/Te;
A=1;


temps=[0:Te:(M-1)*Te];


signal=zeros(1,M);
for n=0:M-1
    signal(n+1)=s(A,T0,n*Te);
end


plot(temps,signal,'r*');
grid;
xlabel('temps');
ylabel ('signal');
hold on;


a0=sum(signal.*Te)/(5*T0);
c0=a0;
%sig=zeros(1,M)+a0; %à cause du a0 choisi, ne fait pas a0/2
sigc=zeros(1,M)+c0;
for n=1:7
    varint=temps*n*2*pi/T0;
    a(1,n)=(2/(5*T0))*sum(signal.*cos(varint)*Te);
    b(1,n)=(2/(5*T0))*sum(signal.*sin(varint)*Te);
    cp(1,n)=(1/(5*T0))*sum(signal.*exp(-1i*(varint))*Te);%c positif
    cn(1,n)=(1/(5*T0))*sum(signal.*exp(1i*(varint))*Te); %c negatif
    %sig=sig+a(n)*cos(temps.*2*pi*n/T0)+b(n)*sin(temps.*2*pi*n/T0);
    sigc=sigc+cp(n).*exp(varint.*1i)+ cn(n).*exp(varint.*(-1i));
    plot (temps, sigc, 'g-');
    %plot(temps,sig,'b-');
    %pause;
    
    
end







for n=1:8
    if n==1,
        Ro(n)=a0;
    else
        Ro(n)=sqrt((a(n-1)^2)+(b(n-1)^2));
    end
end
hold off;

