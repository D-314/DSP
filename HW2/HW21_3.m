Fpass=4; Fstop=5; Fs=30; Apass = -3; Astop = -50;

f = [Fpass, Fstop];
a = [1, 0];
rp = 3;
rs = 100;
dev = [(10^(rp/20)-1)/(10^(rp/20)+1) 10^(-rs/20)]; 
[npm,fo,ao,w] = firpmord(f,a,dev,Fs);

fpm = firpm(npm,fo,ao);
fvtool(fpm,'Fs',Fs)

[h1, w1] = freqz(f1,1,100*Fs,Fs);
[h2, w2] = freqz(f2,1,100*Fs,Fs);
[h3, w3] = freqz(fpm,1,100*Fs,Fs);
h1_dB = 20*log10(abs(h1));
h2_dB = 20*log10(abs(h2));
h3_dB = 20*log10(abs(h3));
figure,hold on;grid on;
plot(w1,h1_dB,'DisplayName',sprintf('fir1(%d)',n1));
plot(w2,h2_dB,'DisplayName',sprintf('fir2(%d)',n2));
plot(w3,h3_dB,'DisplayName',sprintf('firpm(%d)',npm));
xline(Fpass);xline(Fstop);yline(Apass);yline(Astop);
legend(sprintf('fir1(%d)',n1),sprintf('fir2(%d)',n2),sprintf('firpm(%d)',npm));
 ylabel('Magnitude(dB)'); xlabel('frequency(MHz)');

