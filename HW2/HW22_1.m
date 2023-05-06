Fstop1=3.8; Fpass1=4; Fpass2=5; Fstop2=5.2; Fs=20; Apass = -0.3; Astop = -60;
mag=[0, 0, 1, 1, 0, 0];

d = -(Fstop2-Fpass2):.01:(Fstop2-Fpass2); d(end) = [];
N = 300:500;%N=124;
K = 1:3; LK = length(K);

J = length(d);

Bstop1_ok = nan(3,length(N),length(d),length(d));
Bpass_ok = nan(3,length(N),length(d),length(d));
Bstop2_ok = nan(3,length(N),length(d),length(d));
parfor i = 1:length(N)
    tic; cur = 0;
    for j = 1:J
        for k = 1:J
            for m = 1:3
                switch m
                    case 1, f=fir1(N(i),[(2*(Fpass1-d(j))/Fs) (2*(Fpass2+d(k))/Fs)],gausswin(N(i)+1));
                    case 2, f=fir1(N(i),[(2*(Fpass1-d(j))/Fs) (2*(Fpass2+d(k))/Fs)],blackman(N(i)+1));
                    case 3, f=fir1(N(i),[(2*(Fpass1-d(j))/Fs) (2*(Fpass2+d(k))/Fs)],hamming(N(i)+1));
                end
                [h, w] = freqz(f,1,100*Fs,Fs);
                h_dB = 20*log10(abs(h));
                ind_Bstop1 = find((w <= Fstop1));
                Bstop1_ok(m,i,j,k) = max(h_dB(ind_Bstop1));
                ind_Bpass = find((Fpass1 <= w) & (w <=Fpass2));
                Bpass_ok(m,i,j,k) = min(h_dB(ind_Bpass));
                ind_Bstop2 = find(Fstop2 <= w);
                Bstop2_ok(m,i,j,k) = max(h_dB(ind_Bstop2));
            end
        end
    end
    [N(i) toc]
end

for m = 1:3
    sucsess = (Bstop1_ok < Astop) & (abs(Bpass_ok) < abs(Apass)) & (Bstop2_ok < Astop);
    sucsess(m,end+1,:,:) = 1;
    
    sc = zeros(length(d),length(d));
    [~,~,sz2,sz3] = size(sucsess);
    
    for j = 1:sz2
        for k = 1:sz3
            sc(j,k) = find(sucsess(m,:,j,k),1,'first');
        end
    end
    sc(sc==(length(N)+1)) = nan;
    sc = sc+(N(1)-1);
    
    [M,j] = min(sc);
    [M,k] = min(M);
    j = j(k);
    i = M-N(1)+1;
    
    switch m
        case 1, f=fir1(N(i),[(2*(Fpass1-d(j))/Fs) (2*(Fpass2+d(k))/Fs)],gausswin(N(i)+1));
        case 2, f=fir1(N(i),[(2*(Fpass1-d(j))/Fs) (2*(Fpass2+d(k))/Fs)],blackman(N(i)+1));
        case 3, f=fir1(N(i),[(2*(Fpass1-d(j))/Fs) (2*(Fpass2+d(k))/Fs)],hamming(N(i)+1));
    end
    [h(:,m), w(:,m)] = freqz(f,1,100*Fs,Fs);
end

h_dB = 20*log10(abs(h));

figure(4);hold on;grid on; plot(w,h_dB);
xline(Fpass1);xline(Fstop1);
xline(Fpass2);xline(Fstop2);
yline(Apass);yline(Astop);yline(-Apass);
legend(sprintf('gausswin(%d)',N(p(1,1))),sprintf('blackman(%d)',N(p(2,1))),sprintf('hamming(%d)',N(p(3,1))));
ylabel('Magnitude(dB)'); xlabel('frequency(MHz)');