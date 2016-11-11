function [I,inf,sup]=ExpCarre(n,Binf,Bsup) 
%calcul valeur de intégral de exp(-u²)
I=0;
Val=zeros(n,1);
S=0;
inf=0;
sup=0;
for i=1:n
    tx=Binf+rand*(Bsup-Binf);
    ty=rand;
    if ty<exp(-tx*tx),
        p=1;
    else
        p=0;
    end
    Val(i)=p; 
    I=I+Val(i);
end
I=I/n;%*(Bsup-Binf)pour l'aire;
for i=1:n
   S=S+(Val(i)-I)^2;
end
S=S/n; 
S=(1.96*S^0.5)/(n^0.5)*(Bsup-Binf);
I=I*(Bsup-Binf);
inf=I-S
sup=I+S



end