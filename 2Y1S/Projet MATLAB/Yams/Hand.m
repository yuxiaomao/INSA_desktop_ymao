function [p]=Hand
X=Lancer(5);
for n=1:2
    [O,I]=OccuMax(X);
    for i=1:O 
        X(i)=I ;
    end
    for i=O+1:5 
        X(i)=Lancer(1);
    end
end
J=OccuMax(X);
if J(1)==5
    p=1;
else
    p=0;
end
end


    


