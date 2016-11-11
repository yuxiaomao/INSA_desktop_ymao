function [z]=Strategie(q)
a=rand;
if a>q ,
    z=0;
    %pénalité
else
    z=1;
    %essai
end
end

    