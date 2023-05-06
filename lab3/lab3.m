close all
a = H;
aa = sum(abs(a),2).^2;
b = sort(aa,'descend');
figure(1);hold on,plot(aa),figure(2);hold on,semilogy(b)

dft = dftmtx(64)/sqrt(64);
a = dft*H;
aa = sum(abs(a),2).^2;
b = sort(aa,'descend');
figure(1);hold on,plot(aa),figure(2);hold on,semilogy(b)

sig_los_db = 10*log10(sum(b(1:16))/sum(b))
noise_los_db = 10*log10(16/64)
SNR_adj = sig_los_db - noise_los_db