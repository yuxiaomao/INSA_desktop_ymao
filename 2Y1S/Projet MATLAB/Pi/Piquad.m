function [p]=Piquad(n)
s=0;
for a=0:n
    for b=0:n
        if (a/n)*(a/n) + (b/n)*(b/n) <=1,
            s=s+1;
        end
    end
end
p=4*s/((n+1)^2);
end
