function [p]=HandCond
X=Lancer(5);
[O,I]=OccuMax(X);

for i=1:O 
X(i)=I ;
end
for i=O+1:5 
X(i)=Lancer(1);
end

J=OccuMax(X);

p=(1/6)^(5-J(1)); 

end


    


