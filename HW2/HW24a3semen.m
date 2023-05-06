Fs = 20;
Att = 50; % dB
Fpass = 5.0; 
Fstop = 5.5;
F_Nyquist = 0.5*Fs;
NFFT = 4096;
approx2 = @(x) sign(x).*2.^(round(log2(abs(x))));

% FIR 1
n1 = 127;
n2 = 121;
b_1 = fir2(n1,[0, Fpass*1.011, Fstop*0.96, F_Nyquist]./F_Nyquist, [1,1,0,0]);
b_2 = fir2(n2,[0, Fpass*1.011, Fstop*0.99, F_Nyquist]./F_Nyquist, [1,1,0,0]);

b_1mf = approx2(b_1);
b_2mf = approx2(b_2);
b_1mf_cascade = conv(b_1mf, b_2mf);
[h_1, w_1] = freqz(b_1, 1, NFFT, Fs);
[h_1mf, w_1mf] = freqz( b_1mf_cascade, 1, NFFT, Fs);

% FIR 2
n3 = 90;
a_1 = fir2(n3, [0, Fpass, Fstop.*0.99, F_Nyquist]./F_Nyquist, [1, 1,0,0]).*rectwin(n3+1).';
% b_2 = fir2(n2, [0, Fpass*1.011, Fstop*0.99, F_Nyquist]./F_Nyquist, [1, 1,0,0]).*rectwin(n2+1).';

a_1mf = 2.^round(log2(abs(a_1))).*sign(a_1);
a_2mf = a_1mf+2.^round(log2(abs(a_1-a_1mf))).*sign(a_1-a_1mf);
a_2mf = conv(a_2mf, a_2mf);
% b_2mf = 2.^round(log2(abs(b_2))).*sign(b_2);
[h_2mf, w_2mf] = freqz( a_1mf, 1, NFFT, Fs);
[h_3mf, w_3mf] = freqz( a_2mf, 1, NFFT, Fs);

figure(1); hold on; grid on; grid minor;
%plot(w_2mf, 20*log10(abs(h_2mf)), 'b');
plot(w_3mf, 20*log10(abs(h_3mf)), 'k');
plot(w_1mf, 20*log10(abs(h_1mf)), 'r');
xline(Fstop, 'k-.', 'LineWidth', 2);
yline(-Att, 'k-.', 'LineWidth', 2);
legend('2-Cascade multiplier free'); xlabel('f, Hz'); ylabel('Magnitude, dB'); axis tight;
ylim([-80, 3]);