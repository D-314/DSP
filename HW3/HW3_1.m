Fpass = 20; Fstop = 22; Fs = 60; Rp = 0.5; Rs = 70;
n = cheb1ord(2*Fpass/Fs,2*Fstop/Fs,Rp,Rs,'s');
[sb,sa] = cheby1(n,Rp,2*pi*Fpass,'s');    %analog filter
 
 
[zb,za] = impinvar(sb,sa,Fs);     %digital prototype of the analog filter
[r,p] = residue(sb,sa);   %direct term of a Partial Fraction Expansion
 
st = linspace(0,100/Fs,1000);
sh = real(r.'*exp(p.*st)/Fs);     %analog filter impulse response


[zh,zt] = impz(zb,za,[],Fs);  %digital filter impulse invariance

figure(1);hold on;
plot(st,sh)
stem(zt,zh)
legend('Analog filter','Digital filter'),xlim([0 1.5])

figure(2);hold on;grid on;
[zh,zw] = freqz(zb,za);
[sh,sw] = freqs(sb,sa,zw*Fs);
 
h_db = 20*log10(abs(h));
h_an_db = 20*log10(abs(h_an));
 
plot(w/pi*Fs/2,h_an_db,'LineWidth',2);
plot(w/pi*Fs/2,h_db,'LineWidth',1.5);
 
xline(22);yline(-70);legend('Analog filter','Digital filter');
title('Frequency responses of analog and digital filters');
ylabel('Madnitude (dB)'); xlabel('Frequency (MHz)');




