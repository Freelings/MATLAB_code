function [c] = angle_add_circle(a,b)
if  a+b > 180
    c = -360 + a+b;
elseif a+b < -180
    c = 360 + a+b;
else
    c = a+b;
end