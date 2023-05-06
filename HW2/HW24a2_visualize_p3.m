Fpass=5; Fstop=5.5; Fs=20; Apass = -1.5; Astop = -24;
% d = 0:.001:(Fstop-Fpass); d(end) = [];
% N = 60:130;%N=124;
% load('fir2.mat')

fps = 30;
T = 1/fps;
figure(1);colorbar;colormap spring(32);caxis([0 256]);view(2);set(gcf,'color','w');
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
    colorbar;colormap spring(32);caxis([0 256]);view(2);set(gcf,'color','w');
    xlabel('Dpass (X)');ylabel('Dstop (Y)');zlabel('Ntaps (Z)');
    title(sprintf('fir2(Z,[0 %0.2f+X %0.2f-Y 1]/Fn,[1 1 0 0]); Att=%0.1fdB',Fpass/(Fs/2),Fstop/(Fs/2),x(i)));
    
    frm = getframe(gcf);
    img = frame2im(frm);
    im(:,:,1,i) = rgb2ind(img,map);
end

imwrite(im,map,'Bpass_prs_n256.gif','DelayTime',T,'LoopCount',inf)


freq1=[0, Fpass+d(178), Fstop-d(306), Fs/2]./(Fs/2);
f1=fir2(91,freq1,mag);
f1 = approx2(f1);

freq2=[0, Fpass+d(176), Fstop-d(229), Fs/2]./(Fs/2);
f2=fir2(99,freq2,mag);
f2 = approx2(f2);

f = conv(f1,f2);
fvtool(f1,1,f2,1,f,1,'Fs',Fs)