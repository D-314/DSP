Fpass=5; Fstop=5.5; Fs=20; Apass = -3; Astop = -50; delta = 0.01;
freq=[0 2*Fpass/Fs (2*Fstop/Fs+delta) 1]; %substruction delta is necessary for the proper filter design
mag=[1 1 0 0];
approx2 = @(x) sign(x).*2.^(round(log2(abs(x))));

d = 0:.0001:0.05;
N = 1:350;
K = 1:6;
Bpass_ok = zeros(length(N),length(d),length(k));
Bstop_ok = zeros(length(N),length(d),length(k));
for i = 1:length(N)
    for j = 1:length(d)
        for k = 1:length(K)
            n = N(i); delta = d(j);
            switch k
                case 1
                    f=fir1(n,(2*Fpass/Fs)+delta,gausswin(n+1));
                case 2
                    f=fir1(n,(2*Fpass/Fs)+delta,blackman(n+1));
                case 3
                    f=fir1(n,(2*Fpass/Fs)+delta,chebwin(n+1,50));
                case 4
                    f=fir1(n,(2*Fpass/Fs)+delta,hamming(n+1));
                case 5
                    f=fir1(n,(2*Fpass/Fs)+delta,hann(n+1));
                case 6
                    f=fir1(n,(2*Fpass/Fs)+delta,triang(n+1));
                otherwise
                    gausswin(n+1)
            end
            f1 = approx2(f);
            f2 = f1+approx2(f-f1);
            [h, w] = freqz(f2,1,100*Fs,Fs);
            h_dB = 20*log10(abs(h));
            ind_Bpass = find(w<=Fpass);
            Bpass_ok(i,j,k) = ~sum(h_dB(ind_Bpass) < Apass);
            ind_Bstop = find(w>=Fstop);
            Bstop_ok(i,j,k) = ~sum(h_dB(ind_Bstop) > Astop);
        end
    end
    i
end

sucsess = Bpass_ok & Bstop_ok;
sucsess(end+1,:,:) = 1;

sc = zeros(length(d),length(k));
for j = 1:length(d)
    for k = 1:length(k)
        sc(j,k) = find(sucsess(:,j,k),1,'first');
    end
end
sc(sc==(N(end)+1)) = 0;

min(min(sc))


return



return
%fir2
delta=0.01;
freq=[0 2*Fpass/Fs (2*Fstop/Fs-delta) 1]; %substruction delta is necessary for the proper filter design
mag=[1 1 0 0];
n=210;
f2=fir2(n,freq,mag);
%fvtool(f2);
%firls
freq=[0 2*Fpass/Fs 2*Fstop/Fs 1];
mag=[1 1 0 0];
n=185;
f3=firls(n,freq,mag);
% fvtool(f3);





[h1, w1] = freqz(f2);
[h2, w2] = freqz(approx2(f2));

figure(2); hold on; grid on; grid minor;
plot(w1./1e6, 20*log10(abs(h1)), 'b');
plot(w2./1e6, 20*log10(abs(h2)), 'r');

[h1, w1] = freqz(f3);
[h2, w2] = freqz(approx2(f3));

figure(3); hold on; grid on; grid minor;
plot(w1./1e6, 20*log10(abs(h1)), 'b');
plot(w2./1e6, 20*log10(abs(h2)), 'r');