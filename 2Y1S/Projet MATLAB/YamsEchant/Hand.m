function [sortie]=Hand
p=0; 
Six=0; 
NonSix=0; 
[X, Six]=Lancer(5);
NonSix=5-Six; 
for n=1:2
    SixInt=0; 
    [O,I]=OccuMax(X);
    if O==1,
        [X,SixInt]=Lancer(5); 
        Six=Six+SixInt;
        NonSix=NonSix+5-SixInt ;
    else 
    for i=1:O 
        X(i)=I ;
    end
    for i=O+1:5 
        [X(i),SixInt]=Lancer(1);
        Six=Six+SixInt;
        NonSix=NonSix+1-SixInt;
    end
    end
end
[O,I]=OccuMax(X);
if O==5 && I==6, 
    p=(((0.5*6)^(Six))*((0.5*6/5)^(NonSix))); 
    sortie=1/p; 
else
    sortie=0;
end

end


    


