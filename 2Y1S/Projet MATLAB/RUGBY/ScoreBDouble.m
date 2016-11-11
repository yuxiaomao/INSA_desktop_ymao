function [s1,s2]=ScoreBDouble(q1,q2)
s1=0;
s2=0; 
for i=1:12
    if rand<0.4,   
    s=StratDouble(q1,q2);
    if s==2, 
        if Essai==1,
            s1=s1+7; 
            s2=s2+7; 
        end
    elseif s==1,
        s1=s1+3;
        if Essai==1, 
            s2=s2+7; 
        end
    else
        s1=s1+3; 
        s2=s2+3; 
    end 
    end 
end 
end 

            