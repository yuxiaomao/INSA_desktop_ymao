function [s]=StratDouble(q1,q2)
%q1<q2
a=rand;
if a<q1,
    s=2; 
    %les deux essais
elseif a<q2,
    s=1;
    %equipe 1 pen/equipe 2 essai
else
    s=0;
    %les 2 pénalités
end
end

    