function [y,i,g] = YamsE(n)
y=0;
Valeur=zeros(n,1);
S=0;
i=0;
g=0;
for i=1:n
   Valeur(i)=Hand; 
    y=y+Valeur(i);
end
y=y/n;
for i=1:n
   S=S+(Valeur(i)-y)^2;
end
S=S/n;
S=(1.96*S^0.5)/(n^0.5);
i=y-S;
g=y+S;
i=i*6
g=g*6
y=y*6;    
end


    