Fpass=5; Fstop=5.5; Fs=20; Apass = -3; Astop = -50;
approx2 = @(x) sign(x).*2.^(round(log2(abs(x))));
mag=[1, 1, 0, 0];

d = 0:.01:(Fstop-Fpass); d(end) = [];
N = 10:100;%N=124;
% K = 60:130;

J = length(d);

% Bpass_ok = zeros(length(N),length(d),length(d),length(d),length(d),'logical');
Bpass_ok = nan(length(N),length(d),length(d));
Bstop_ok = nan(length(N),length(d),length(d));
% figure;hold on;
parfor i = 1:length(N)
    tic; cur = 0;
    for j = 1:J
        for k = 1:J
            if (Fpass+d(j) >= Fstop-d(k)); continue; end
            freq=[0, Fpass+d(j), Fstop-d(k), Fs/2]./(Fs/2);
            
            f=fir2(N(i),freq,mag);
            
            [h, w] = freqz(f,1,100*Fs,Fs);
            
            h_dB = 20*log10(abs(h));
            ind_Bpass = find(w<=Fpass);
            Bpass_ok(i,j,k) = min(h_dB(ind_Bpass));
            ind_Bstop = find(w>=Fstop);
            Bstop_ok(i,j,k) = max(h_dB(ind_Bstop));
        end
    end
    [N(i) toc]
end

sucsess = (Bstop_ok < Astop) & (Bpass_ok > Apass);
sucsess(end+1,:,:) = 1;

sc = zeros(length(d),length(d));
[sz1,sz2,sz3] = size(sucsess);
for j = 1:sz2
    for k = 1:sz3
        sc(j,k) = find(sucsess(:,j,k),1,'first');
    end
end
sc(sc==(length(N)+1)) = nan;
sc = sc+(N(1)-1);

[M,j] = min(sc);
[M,k] = min(M);
j = j(k);
i = M-N(1)+1;
[i,j,k]
freq=[0, Fpass+d(j), Fstop-d(k), Fs/2]./(Fs/2);
n2 = N(i);
f2n=fir2(N(i),freq,mag);
fvtool(f2,'Fs',Fs)