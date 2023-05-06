clear all;
t=1:10^6;
N_DFT=2048;
Ntaps=53;
h=fir1(Ntaps,0.05);
A=conv(randn(1,length(t)),h);
A=A( (Ntaps-1)/2+1:length(t)+(Ntaps-1)/2 );



%%%%%%%%%%%%%% interpolate signal x by the factor of 4 %%%%%%
%%%%%%%%%%%%%% for that use (upsampling + LPF)
x=A.*sin(2*pi*t/4);
x2 = downsample(x, 2);
x3 = upsample(x, 2);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%S=pwelch(x,N_DFT,[],'twosided');
S=periodogram(x,[],N_DFT,'twosided');
S2 = periodogram(x2,[],N_DFT,'twosided');
S3 = periodogram(x3,[],N_DFT,'twosided');

figure(1)
semilogy(1:N_DFT,S);
axis([1 N_DFT 10^-8 1]);
set(gca,'xtick',0:N_DFT/8:N_DFT);
grid on;

figure(2)
semilogy(1:N_DFT,S2);
axis([1 N_DFT 10^-8 1]);
set(gca,'xtick',0:N_DFT/8:N_DFT);
grid on;

figure(3)
semilogy(1:N_DFT,S3);
axis([1 N_DFT 10^-8 1]);
set(gca,'xtick',0:N_DFT/8:N_DFT);
grid on;


%% Problem 5
% rng default;
% NumSamples = 100;
% T = 5;
% 
% x = randn(1, NumSamples);
% b = fir1(50, 0.2);
% x_lpf = conv(x, b, 'same');
% 
% x_dec = x_lpf(1:T:end);
% x_dis = [upsample(x_dec, T)];
% soh_resp = [zeros(1,4), ones(1,T)];
% foh_resp = triang(T*2-1).';
% SOH = conv(x_dis, soh_resp, 'same');
% FOH = conv(x_dis, foh_resp, 'same');
% 
% 
% figure(1); 
% subplot(211); hold on; grid on; grid minor;
% plot(x_lpf, 'b');
% stem(SOH, 'r');
% stem(x_dis, 'b+');
% title('Sample and Hold'); 
% 
% subplot(212); hold on; grid on; grid minor;
% plot(x_lpf, 'b');
% stem(FOH, 'r');
% stem(x_dis, 'b+');
% title('First order Hold'); 
% 
% figure(2); 
% subplot(211); hold on; grid on; grid minor;
% plot( abs(fft(soh_resp, NumSamples)), 'b');
% title('Sample and Hold'); 
% 
% subplot(212); hold on; grid on; grid minor;
% plot( abs(fft(foh_resp, NumSamples)), 'b');
% title('First order Hold');