clear all
close all
f = @(x) (1-abs(x)).*(abs(x)<1);
fs = 100; ts = 1/fs; t_0 = -2;
t_x = t_0:ts:2;
y = f(t_x);
t_c = -4:ts:4;
corr_data = xcorr(y,'normalized');
figure(2);hold on;
plot(t_x,y);plot(t_c,corr_data);
xlim([-2 2])

cr = @(t) corr_data(round((t-(t_0*2))*fs+1));

fps = 60;
T = 1/fps;
figure(1);hold on;

% подготовка матрицы и градиента
frm = getframe(gcf);
set(gcf,'color','w');
[im,map] = rgb2ind(frm.cdata,16);
im(1,1,1,length(t_x)) = 0;
map = [double(de2bi(0:7)); 1 0.5 0.5; 0.5 0 0; 1 1 0.5; 0.5 0.5 0; 0.5 0.5 1; 0 0 0.5; 0.5 1 0.5; 0 0.5 0;];
start = tic;
frame = tic;
for tau = (2*t_0):2*ts:(-2*t_0)
    clf,hold on;set(gcf,'color','w');
    t = t_0:ts:tau;
    i = round((tau-(2*t_0))*(fs/2)+1);
    
    if and(-2<=tau,tau<=-1)
        % yellow
        lim = -1:ts:(tau+1+(ts/2));
        area(lim,max(f(lim),f(lim-tau)),'LineStyle','none','FaceColor','#FFFF80');
        area(lim,min(f(lim),f(lim-tau)),'LineStyle','none','FaceColor','#808000');
    end
    
    if and(-1<=tau,tau<=0)
        % red
        lim = -1:ts:(tau+(ts/2));
        area(lim,max(f(lim),f(lim-tau)),'LineStyle','none','FaceColor','#FF8080');
        area(lim,min(f(lim),f(lim-tau)),'LineStyle','none','FaceColor','#800000');
        % yellow
        lim = tau:ts:(0+(ts/2));
        area(lim,max(f(lim),f(lim-tau)),'LineStyle','none','FaceColor','#FFFF80');
        area(lim,min(f(lim),f(lim-tau)),'LineStyle','none','FaceColor','#808000');
        % blue 
        lim = 0:ts:(tau+1+(ts/2));
        area(lim,max(f(lim),f(lim-tau)),'LineStyle','none','FaceColor','#8080FF');
        area(lim,min(f(lim),f(lim-tau)),'LineStyle','none','FaceColor','#000080');
    end
    
    if and(0<=tau,tau<=1)
        % red
        lim = (tau-1):ts:(0+(ts/2));
        area(lim,max(f(lim),f(lim-tau)),'LineStyle','none','FaceColor','#FF8080');
        area(lim,min(f(lim),f(lim-tau)),'LineStyle','none','FaceColor','#800000');
        % green
        lim = 0:ts:(tau+(ts/2));
        area(lim,max(f(lim),f(lim-tau)),'LineStyle','none','FaceColor','#80FF80');
        area(lim,min(f(lim),f(lim-tau)),'LineStyle','none','FaceColor','#008000');
        % blue 
        lim = tau:ts:(1+(ts/2));
        area(lim,max(f(lim),f(lim-tau)),'LineStyle','none','FaceColor','#8080FF');
        area(lim,min(f(lim),f(lim-tau)),'LineStyle','none','FaceColor','#000080');
    end
    
    if and(1<=tau,tau<=2)
        % green
        lim = (tau-1):ts:(1+(ts/2));
        area(lim,max(f(lim),f(lim-tau)),'LineStyle','none','FaceColor','#80FF80');
        area(lim,min(f(lim),f(lim-tau)),'LineStyle','none','FaceColor','#008000');
    end

         
    plot(t_x,f(t_x),'k','LineWidth',1,'DisplayName','triangular func.');
    plot([tau tau],[0 1],'k--');plot(tau,cr(tau),'ko');
    plot(t_x+tau,f(t_x),'k','LineWidth',1);
    plot([0 0],[0 1],'k--');
    plot(t,cr(t),'m','LineWidth',2,'DisplayName','autocorrelation func.');
    xlim([-2 2])
    ylim([0 1])
    
    time = toc(frame);
    frame = tic;
%     pause(T-time);
    frm = getframe(gcf);
    img = frame2im(frm);
    im(:,:,1,i) = rgb2ind(img,map);
%     delete (ar);
%     delete (point);
end
im(:,:,1,1) = rgb2ind(img,map);

imwrite(im,map,'exp_4.gif','DelayTime',T,'LoopCount',inf)

% avg_fps = length(x)/toc(start)

