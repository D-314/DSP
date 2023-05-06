Fpass=1; Fstop=1.1; Fs=5; Apass = -3; Astop = -50;

NFFT = 4096;
Fpass_norm = ceil((Fpass/Fs)*NFFT);
f = (1:Fpass_norm).*(Fs/NFFT);
Hpass = exp(-f./10);
Hstop = zeros(1, NFFT-2*Fpass_norm+1);
H = [Hpass, Hstop, flip(Hpass(2:end))];

figure(1); subplot(121);
area(f_axis, abs(H));
xlabel('f, MHz'); ylabel('Amplitude');
title('Ideal resp in freq domain')

shift = NFFT/4;
imphar = circshift((ifft(H)), shift);
Nwin = 128;
imphar = imphar((shift+1-Nwin/2):(shift+Nwin/2));
win = gausswin(Nwin).';
imphar_win = imphar.*win;

subplot(122); hold on;
plot(imphar_win); plot(win.*max(imphar_win));
xlabel('Samples'); ylabel('Amplitude');
title('Time response windowed'); 

fvtool(imphar_win,'Fs',Fs)
