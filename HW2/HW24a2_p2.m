Fpass=5; Fstop=5.5; Fs=20; Apass = -1.5; Astop = -24;
approx2 = @(x) sign(x).*2.^(round(log2(abs(x))));
mag=[1, 1, 0, 0];

d = 0:.001:(Fstop-Fpass); d(end) = [];
N = 60:130;%N=124;
K = 60:130;

freq1=[0, Fpass+0.177, Fstop-0.305, Fs/2]./(Fs/2);
f1=fir2(91,freq1,mag);
f1 = approx2(f1);

freq2=[0, Fpass+0.175, Fstop-0.228, Fs/2]./(Fs/2);
f2=fir2(99,freq2,mag);
f2 = approx2(f2);

f = conv(f1,f2);
fvtool(f,1,f2n,1,'Fs',Fs)