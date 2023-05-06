close all
x = zeros(1025,1);
threshold = 470;
x(1:threshold) = 1./sinc(linspace(0,threshold/1024,threshold));
x(1025:-1:(1025-threshold+1)) = 1./sinc(linspace(0,threshold/1024,threshold));
x(1025) = [];
figure(1);plot(x);
imp_har = ifft(x);
figure(2);plot(imp_har);
Nf = 64; %length of filter
imphar = circshift(imp_har,Nf);
plot(imphar),hold on;
imphar = imphar(1:(2*Nf+1));
plot(imphar)
fvtool(imphar)