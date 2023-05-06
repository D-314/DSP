Fpass=4; Fstop=5; Fs=30; Apass = -3; Astop = -50;
approx2 = @(x) sign(x).*2.^(round(log2(abs(x))));
mag=[1, 1, 0, 0];

d = 0:.001:(Fstop-Fpass); d(end) = [];
N = 10:100;%N=124;
K = 1:6; LK = length(K);

J = length(d);

Bpass_ok = nan(length(N),length(d),length(K));
Bstop_ok = nan(length(N),length(d),length(K));
parfor i = 1:length(N)
    tic; cur = 0;
    for j = 1:J
        for k = 1:LK
            n = N(i); delta = d(j);
            switch k
                case 1
                    f=fir1(N(i),(2*(Fpass+d(j))/Fs),gausswin(N(i)+1));
                case 2
                    f=fir1(N(i),(2*(Fpass+d(j))/Fs),blackman(N(i)+1));
                case 3
                    f=fir1(N(i),(2*(Fpass+d(j))/Fs),chebwin(N(i)+1,50));
                case 4
                    f=fir1(N(i),(2*(Fpass+d(j))/Fs),hamming(N(i)+1));
                case 5
                    f=fir1(N(i),(2*(Fpass+d(j))/Fs),hann(N(i)+1));
                case 6
                    f=fir1(N(i),(2*(Fpass+d(j))/Fs),triang(N(i)+1));
                otherwise
                    gausswin(n+1)
            end
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

sc = zeros(length(d),length(K));
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
switch k
    case 1
        f1=fir1(N(i),(2*(Fpass+d(j))/Fs),gausswin(N(i)+1));
    case 2
        f1=fir1(N(i),(2*(Fpass+d(j))/Fs),blackman(N(i)+1));
    case 3
        f1=fir1(N(i),(2*(Fpass+d(j))/Fs),chebwin(N(i)+1,50));
    case 4
        f1=fir1(N(i),(2*(Fpass+d(j))/Fs),hamming(N(i)+1));
    case 5
        f1=fir1(N(i),(2*(Fpass+d(j))/Fs),hann(N(i)+1));
    case 6
        f1=fir1(N(i),(2*(Fpass+d(j))/Fs),triang(N(i)+1));
    otherwise
        gausswin(n+1)
end
n1 = N(i);
fvtool(f1,'Fs',Fs)