n =1e5;
x = randn(1,n);
Px = pwelch(x);
figure(1), hold on;
% plot(Px);

%% LPF from lab4
threshold = 470;
imphar = zeros(1025,1); imphar(1:threshold) = 1./sinc(linspace(0,threshold/1024,threshold));
imphar(1025:-1:(1025-threshold+1)) = 1./sinc(linspace(0,threshold/1024,threshold)); imphar(1025) = [];
imphar = ifft(imphar); Nf = 64; imphar = circshift(imphar,Nf); imphar = imphar(1:(2*Nf+1));
%%
y = conv(x,imphar);
[r,lags] = xcorr(x,y);
r = r./n;
Px = pwelch(filtered);
figure(1), hold on;
plot(lags,r);
plot(imphar);