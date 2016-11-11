function [Occu,Indice] = OccuMax(t)
n=[0,0,0,0,0,0];
for i=1:5
    n(1,t(1,i))= n(1,t(1,i))+1;
end

Occu=0;
Indice=1;
for i=1:6
    if n(1,i)>Occu 
        Occu=n(1,i);
        Indice=i;
    end
end

if Occu==2 ,
    if rand < 0.5, 
        for i=Indice+1:6
            if n(1,i)==2, 
                Indice=i; 
            end 
        end 
    end
end 

    %%%% code pour 2 
    %%%%% traiter 1 dans Hand !
    
end
