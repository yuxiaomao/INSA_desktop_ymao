function [p,inf,sup]=NMatch(q,n)
Resultats=zeros(n,1);


S=0;
inf=0;
sup=0;
p=0;
for i=1:n
   Resultats(i)=Match(q); 
    p=p+Resultats(i);
end
p=p/n;
for i=1:n
   S=S+(Resultats(i)-p)^2;
end
S=S/n; 
S=(1.96*S^0.5)/(n^0.5);
inf=p-S
sup=p+S

   
end