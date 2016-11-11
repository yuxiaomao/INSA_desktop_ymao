function [b]=Match(q)
%if b=1 then b gagné
A=ScoreA; 
B=ScoreB(q); 
    r=rand; 
if A>B, 
    b=0; 
elseif A==B,
    if r>0.5, 
        b=1;
    else
        b=0;
    end 
else
    b=1; 
end 
end 

    
    

