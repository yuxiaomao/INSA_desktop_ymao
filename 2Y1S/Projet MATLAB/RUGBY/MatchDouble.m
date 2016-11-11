function [p]=MatchDouble(q1,q2) 
%p=0 si meme resultat, 1 si B2 reussi mais pas B1, -1 si inverse
a=ScoreA; 
[b1,b2]=ScoreBDouble(q1,q2); 
if b1==a && b2==a, 
    p=0; 
elseif b1<a && b2<a, 
    p=0; 
elseif b1>a && b2>a, 
    p=0; 
elseif b1<a && b2>a, 
    p=1;
elseif b2<a && b1>a, 
    p=-1; 
elseif b1==a && b2>a, 
    if Tirage==1,
        p=0; 
    else
        p=1; 
    end 
elseif b2==a && b1>a, 
    if Tirage==1, 
        p=0; 
    else
        p=-1;
    end 
elseif b1==a && b2<a, 
    if Tirage==1, 
        p=-1; 
    else 
        p=0; 
    end 
elseif b2==a && b1<a, 
    if Tirage==1,
        p=1; 
    else 
        p=0;
    end 
end
end 
        
        
    
