function [val]=s(A,T0,t)
if t<=T0/2 && t>=0,
    val=A;
elseif t>T0/2 && t<T0,
    val=0;
elseif t<0,
    val=s(A,T0,t+T0);
else
    val=s(A,T0,t-T0);
end
end
