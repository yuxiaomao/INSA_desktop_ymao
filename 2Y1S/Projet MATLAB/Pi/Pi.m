function [p] = Pi(n)
s=0;
for i=1:n
a=rand(1,2);
if sum(a.^2)<=1,
    s=s+1;
end 
end
p=4*s/n;



end