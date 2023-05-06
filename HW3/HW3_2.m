Fs = 20;
bs = [1 2.5];     bz = [85    10      -75  ]/3408;
as = [1 2.5 4];     az = [3408	-6384	3008]/3408;

figure(1);hold on;
[r,p] = residue(bs,as);   %direct term of a Partial Fraction Expansion
 
t = linspace(0,100/Fs,1000);
h = real(r.'*exp(p.*t)/Fs);     %analog filter impulse response
plot(t,h,'LineWidth',2)
impz(bz,az,[],Fs);  %digital filter impulse invariance

legend('Analog filter','Digital filter'),xlim([0 3])
 
figure(2);hold on;grid on;
[h,w] = freqz(bz,az);
[h_an] = freqs(bs,as,w*Fs);
 
h_db = 20*log10(abs(h));
h_an_db = 20*log10(abs(h_an));
 
plot(w/pi*Fs/2,h_an_db,'LineWidth',2);
plot(w/pi*Fs/2,h_db,'LineWidth',1.5);

%%compare to MATLAB
[bz,az] = bilinear(bs,as,Fs);     %digital prototype of the analog filter
[h,w] = freqz(bz,az);
h_db = 20*log10(abs(h));
plot(w/pi*Fs/2,h_db,'g--','LineWidth',1.5);

legend('Analog filter','Digital filter (By hands)','Digital filter (bilinear func)');
title('Frequency responses of analog and digital filters');
ylabel('Madnitude (dB)'); xlabel('Frequency (Hz)');