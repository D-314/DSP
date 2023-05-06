Fpass=5; Fstop=5.5; Fs=20; Apass = -3; Astop = -50; delta = 0.01;
approx2 = @(x) sign(x).*2.^(round(log2(abs(x))));
rp = 1;           % Passband ripple
rs = 90;          % Stopband ripple
fs = Fs;        % Sampling frequency
f = [Fpass Fstop];    % Cutoff frequencies
a = [1 0];        % Desired amplitudes
dev = [(10^(rp/20)-1)/(10^(rp/20)+1)  10^(-rs/20)]; 
[n,fo,ao,w] = firpmord(f,a,dev,fs);
b = firpm(n,fo,ao,w);
f1 = approx2(b);
fvtool(b,1,f1,1,'Fs',fs)
