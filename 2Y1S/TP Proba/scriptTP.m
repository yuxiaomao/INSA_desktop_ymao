%% EXERCICE 1

%Question 2 (utilisez la fonction "rand")
N = 100;
p = 0.3;
X= rand(1,N);
Y= X<p;


%Question 3 (utiliser la fonction "sum")
N=100;
n=10;
p=0.3;
X= rand(n,N);
Y= X<p;
Z=  sum(Y,1);

%Question 4 (utilisez "mean" et "var")
mean(Z);
var(Z);

%Question 5 (utilisez la fonction "nchoosek" pour calculer les probabilit�s
%th�oriques) 

%Calcul des probabilit�s d'une loi binomiale
for k=1:(n+1)
    pb(k)= nchoosek(n,k-1)*(p^(k-1))*((1-p)^(n-k+1));
end
%Tracer de l'histogramme
H=hist(Z,0:1:n);
bar(0:1:n,H/N)
hold on
stem(0:1:n,pb,'r')
title('Comparaison des histogrammes ')

%% EXERCICE 2
N=100;
lambda=2;

%N r�alisations d'une loi Exp(2)
X= -log(1-rand(1,N))/lambda;
%comparaison entre moyenne empirique et esp�rance
mean(X);
var(X);


%% EXERCICE 3
% Question 1
n=100;
p=0.5;
%Calcul des proba pour une loi binomiale
for k=1:(n+1)
    pb1(k)= nchoosek(n,k-1)*(p^(k-1))*((1-p)^(n-k+1));
end
x=0:0.001:n;
m= n*p;
sigma2=n*p*(1-p);
%Calcul des valeurs de la densit� d'une loi N(m,sigma2)
y= (1/sqrt(sigma2*2*pi))*exp(-((x-m).^2)/(2*sigma2));
%Representation graphique
figure
stem(0:1:n,pb1,'r')
hold on
plot(x,y,'b')
title(['n = ' num2str(n) ' et p = ' num2str(p)])

% Question 2
n=20;
p=0.05;
%Calcul des proba pour une loi binomiale
for k=1:(n+1)
    pb2(k)=nchoosek(n,k-1)*(p^(k-1))*((1-p)^(n-k+1)); 
end
%Parametre de la loi de Poisson
lambda= n*p;
%Calcul des proba pour une loi de Poisson
for k=1:(n+1)
    pois(k)=(lambda^(k-1)*exp(-lambda))/gamma(k);
end
%Representation graphique
figure
stem(0:1:n,pb2,'r')
hold on
stem([0:1:n]+0.1,pois,'b')

%% Exercice 4
%Question 1 et 2 (utilisez la fonction "randn" etla fonction "mean")
N=100; %N=10, N=1000
m=4;
sigma=1.5;
X= sigma*randn(1,N)+m ;
mean (X);

%
Xn=(1/N)*sum(X);


%Question 3 - 4
N=1000; 
E=1000;
m=4;
sigma=1.5;
%simulation des �chantillons
X=sigma*randn(E,N)+m;

Xn=(1/N)*sum(X,2);

%IC avec variance connue
IC=[Xn-sigma*1.96/sqrt(N) Xn+sigma*1.96/sqrt(N)];
sum(IC(:,1)<m & IC(:,2)>m);

%IC variance inconnue
Sn=sqrt((1/(N-1))*(sum(X.^2,2)-N*(Xn.^2)));
IC=[ Xn-Sn*(tinv(0.975,N-1))/sqrt(N) Xn+Sn*(tinv(0.975,N-1))/sqrt(N)];
sum(IC(:,1)<m & IC(:,2)>m)

%% EXERCICE 5
N=1000;
theta=2;
E=1000;
%simulation des �chantillons
X= -theta * log(1-rand(E,N));
Xn= (1/N)*sum(X,2);
%IC asymptotiques pour theta
IC=[Xn/((1.96/sqrt(N))+1) Xn/((-1.96/sqrt(N))+1)]
sum(IC(:,1)<theta & IC(:,2)>theta)









