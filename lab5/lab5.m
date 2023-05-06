close all
x = zeros(1025,1);
threshold = 470;
x(1:threshold) = 1./sinc(linspace(0,threshold/1024,threshold));
x(1025:-1:(1025-threshold+1)) = 1./sinc(linspace(0,threshold/1024,threshold));
x(1025) = [];
% figure(1);plot(x);
imp_har = ifft(x);
% figure(2);plot(imp_har);
Nf = 64; %length of filter
imphar = circshift(imp_har,Nf);
% plot(imphar),hold on;
imphar = imphar(1:(2*Nf+1));
N = 2*Nf+1;
w4  = hamming(N);
imphar = imphar.*w4;
% plot(imphar)
fvtool(imphar)

f = [0 0.89 0.945 1];
a = [1 1.5 0 0];
b = firls(2*Nf,f,a);
fvtool(b)

ts = 16;
samples = x_sampled(1:ts:end);
xx = reshape(repmat(samples,ts,1),1,[]);
figure;hold on;
plot(x_sampled);
plot(xx);