x = zeros(1,16); x(4) = 1;
y = zeros(1,16);
for n = 4:16
    y(n) = x(n-2)+x(n-3)-y(n-1)-2*y(n-2)-2*y(n-3);
end
figure(1);stem(0:12,y(4:end))
xlim([0 12]);ylim([-16 16]);

b = [0 0 1 1] ;
a = [1 1 2 2] ;
[h,t] = impz(b,a);
figure(1);stem(t,h)
xlim([0 12]);ylim([-16 16]);

[h,w] = freqz(b,a);
figure(2); plot(w/2pi,20*log10(abs(h)))
title('Frequency response of the linear system')
ylabel('Madnitude (dB)')
xlabel('Normalized frequency(x\pi rad)')


