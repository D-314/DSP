clear all
close all
scale = 100;
changes = 63;
k1 = @(t) log10(t+190)-1.9;
k2 = @(t) ((t-changes+9)./98).^2;
kolya = @(t) scale*((k1(t).*(t<changes))+((k1(changes)+k2(t)-k2(changes)).*(t>=changes)));
dima = @(t) scale*(0.1 + 0.025*sin(t*.1));
emy = @(t) scale*(0.1-0.0006*t);
irn = @(t) scale*(0.2+0.0003*t);
alx = @(t) scale*(0.01+0*t);
smn = @(t) scale*(0+0*t);
t = datetime(2022,09,1,0,0,0):datetime(2023,01,01,0,0,0);
x = 1:123;

fps = 30;
T = 1/fps;
figure(1);hold on;
plot(repmat(t,6,1).',[kolya(x);dima(x);alx(x);emy(x);irn(x);smn(x)].','LineWidth',2);

% подготовка матрицы и градиента
frm = getframe(gcf);
set(gcf,'color','w');
[im,map] = rgb2ind(frm.cdata,16);
im(1,1,1,length(x)) = 0;
for i = 1:123
    clf,hold on;set(gcf,'color','w');
    
    plot(t(1:i),kolya(1:i),'LineWidth',2);
    plot(t(1:i),dima(1:i),'LineWidth',2);
    plot(t(1:i),alx(1:i),'LineWidth',2);
    plot(t(1:i),emy(1:i),'LineWidth',2);
    plot(t(1:i),irn(1:i),'LineWidth',2);
    plot([t(i) t(i)],[0 scale],'k--')
    xlim([t(1) t(123)]); ylim([0, scale]);
    text(t(i),kolya(i),'  Коля');
    text(t(i),dima(i),'  Дима');
    text(t(i),emy(i),'  Эмилия');
    text(t(i),irn(i),'  Ирэна');
    ylabel('Процент гейства')
    
    if i < changes
        plot([t(i) t(i) t(i) t(i) t(i)],[kolya(i) dima(i) alx(i) emy(i) irn(i)],'ko');
        text(t(i),alx(i),'  Лёха');
    else
        plot([t(i) t(i) t(i) t(i) t(i) t(i)],[kolya(i) dima(i) alx(i) smn(i) emy(i) irn(i)],'ko');
        text(t(i),alx(i),['  Лёха' newline '  Семён']);
        text(t(changes),kolya(changes)-1,'\uparrowпоявился Семён');
        plot(t(changes:i),smn(changes:i),'LineWidth',2);
    end
    
    frm = getframe(gcf);
    img = frame2im(frm);
    im(:,:,1,i) = rgb2ind(img,map);
end

imwrite(im,map,'joke.gif','DelayTime',T,'LoopCount',inf)