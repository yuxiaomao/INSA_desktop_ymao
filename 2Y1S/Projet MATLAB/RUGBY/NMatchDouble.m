function [p,inf,sup]=NMatchDouble(q1,q2,n)
Resultats=zeros(n,1);


S=0;
inf=0;
sup=0;
p=0;
for i=1:n
   Resultats(i)=MatchDouble(q1,q2); 
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