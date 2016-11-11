function [l,six] = Lancer(n)
six=0; 
v=zeros(1,n); 
for k=1:n
    a=rand;
    if a<0.1, 
        v(k)=1; 
    elseif a<0.2, 
        v(k)=2;
    elseif a<0.3, 
        v(k)=3; 
    elseif a<0.4, 
        v(k)=4; 
    elseif a<0.5, 
        v(k)=5;
    else 
        v(k)=6; 
        six=six+1; 
    end
end 
l=v;
end







