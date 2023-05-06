Fpass=5; Fstop=5.5; Fs=20; Apass = -1.5; Astop = -24;
approx2 = @(x) sign(x).*2.^(round(log2(abs(x))));
mag=[1, 1, 0, 0];

d = 0:.01:(Fstop-Fpass); d(end) = [];
N = 64:191;
J = length(d);

Bpass_ok = nan(length(N),length(d),length(d));
Bstop_ok = nan(length(N),length(d),length(d));
sucsess = nan(length(N),length(d),length(d));

parfor i = 1:length(N)
    tic; cur = 0;
    for j = 1:J
        for k = 1:J
            if (Fpass+d(j) >= Fstop-d(k)); continue; end
            freq=[0, Fpass+d(j), Fstop-d(k), Fs/2]./(Fs/2);
            
            f=fir2(N(i),freq,mag);
            f1 = approx2(f);
            
            [h, w] = freqz(f1,1,100*Fs,Fs);
            
            h_dB = 20*log10(abs(h));
            ind_Bpass = find(w<=Fpass);
            Bpass_ok(i,j,k) = min(h_dB(ind_Bpass));
            ind_Bstop = find(w>=Fstop);
            Bstop_ok(i,j,k) = max(h_dB(ind_Bstop));
        end
    end
    [N(i) toc]
end

%plot and anim.

fps = 30;
T = 1/fps;
figure(1);colorbar;colormap spring(32);caxis([N(1) N(end)]);view(2);set(gcf,'color','w');
frm = getframe(gcf);
x = 0:-0.1:-26;
[im,map] = rgb2ind(frm.cdata,64);
im(1,1,1,length(x)) = 0;
for i = 1:length(x)
    clf
%        i = 1;
    
    sucsess = (Bstop_ok < x(i)) & (Bpass_ok > -1.5);
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
    
    surf(d,d,sc,'LineStyle','none');xlim([0 d(end)]);ylim([0 d(end)]);
    view(2);
    colorbar;colormap spring(32);caxis([N(1) N(end)]);view(2);set(gcf,'color','w');
    xlabel('Dpass (X)');ylabel('Dstop (Y)');zlabel('Ntaps (Z)');
    title(sprintf('fir2(Z,[0 %0.2f+X %0.2f-Y 1]/Fn,[1 1 0 0]); Att=%0.1fdB',Fpass/(Fs/2),Fstop/(Fs/2),x(i)));
    
    frm = getframe(gcf);
    img = frame2im(frm);
    im(:,:,1,i) = rgb2ind(img,map);
end

imwrite(im,map,'Bpass_prs_n256.gif','DelayTime',T,'LoopCount',inf)


freq1=[0, Fpass+0.177, Fstop-0.305, Fs/2]./(Fs/2);
f1=fir2(91,freq1,mag);
f1 = approx2(f1);

freq2=[0, Fpass+0.175, Fstop-0.228, Fs/2]./(Fs/2);
f2=fir2(99,freq2,mag);
f2 = approx2(f2);

f = conv(f1,f2);
fvtool(f,1,f2n,1,'Fs',Fs)

%normal fir
freq=[0, Fpass+0.05, Fstop-0.34, Fs/2]./(Fs/2);
f2n=fir2(83,freq,mag);
fvtool(f,1,f2n,1,'Fs',Fs)