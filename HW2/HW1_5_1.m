close all
clear all
Fss = 10e3;  % sampling frequency for modeling
Fs = 10e2;     % sampling frequency
t = 10;              % modeling time: 0..t
n =  t*Fss;        %num samples
x = randn(1,n);     % white noise
Fpass = Fs/5 ; % signal frequency
filter=fir1(Fss,2*Fpass/Fss,'low');
signal =conv(x,filter,'same');%filtering white noise

sampled = reshape(signal,10,[]); sampled(2:end,:) = 0;
spl = sampled(1,:);
sampled = reshape(sampled,1,[]);

rt = ones(Fss/Fs,1);
tr = triang(2*Fss/Fs-1);

SAH = conv(sampled,rt,'same');
FOH = conv(sampled,tr,'same');

figure(1); subplot(211), hold on;
plot(signal),stem(1:Fss/Fs:length(sampled),spl,'b');
plot(SAH,'r'),xlim([0 Fs/8]);
legend('Signal','Sampled','Sample and hold')
subplot(212), hold on;
plot(signal),stem(1:Fss/Fs:length(sampled),spl,'b');
plot(FOH,'r'),xlim([0 Fs/8]);
legend('Signal','Sampled','First Order Hold')

% fvtool(rt,1,tr,1,'Fs',Fss)

[hSAH, w] = freqz(rt,1,100*Fss,Fss);
[hFOH, w] = freqz(tr,1,100*Fss,Fss);

f = linspace(0,Fss,length(x));
figure(2); subplot(211), hold on; title('Sample and Hold'); 
plot(f,abs(fft(signal))/100); plot(f,abs(fft(sampled))/10);
plot(f,abs(fft(SAH))/100);plot(w,abs(hSAH));
plot(f,abs(fft(signal))/100,'b');
xlim([0,2*Fs]);set(gca, 'YScale', 'log');ylim([1e-3 1e2]);
legend('Signal','Sampled','Sample and hold','SAH freq. resp')
subplot(212), hold on; title('First Order Hold'); 
plot(f,abs(fft(signal))/100); plot(f,abs(fft(sampled))/10);
plot(f,abs(fft(FOH))/100);plot(w,abs(hFOH));
plot(f,abs(fft(signal))/100,'b');
xlim([0,2*Fs]);set(gca, 'YScale', 'log');ylim([1e-3 1e2]);
legend('Signal','Sampled','First Order Hold','FOH freq. resp')

figure(3);hold;stem(0:9,rt);stem(-9:9,tr);
xlim([-10 10]);ylim([-0.1 1.1]);
legend('Sample and hold','First Order Hold');