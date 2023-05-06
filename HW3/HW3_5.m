% CORDIC MATLAB code
clear all
j = 0:9; tn = 2.^(-j);
a = [45 26.6 14 7.1 3.6 1.8 0.9 0.4 0.2 0.1];
k = 0.60725235;
x(1) = 2.2; y(1) = 3.3; z(1) = 0;
for i = 1:10
    d = -sign(y(i));
    x(i+1) = x(i) - d * tn(i) *y(i);
    y(i+1) = y(i) + d * tn(i) *x(i);
    z(i+1) = z(i) - d * a(i);
end
[z(11) atand(y(1)/x(1))]
[x(11)*k abs([x(1)+y(1)*1i])]