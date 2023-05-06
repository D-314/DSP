close all
clear all
fss = 15e3;  % sampling frequency for modeling
fs = 15;     % sampling frequency
f_signal = 6;  % signal frequency
w =2*pi*f_signal;  % signal angular frequency
Num_of_periods = 60;  % number of periods of signal
t = Num_of_periods/f_signal;  % modeling time: 0..t
time_signal = 0:(1/fss):t;  % time counts for modeling
time_sampled = 0:(1/fs):t;  % time counts for discretization
signal = sin(w*time_signal);  % raw signal
discrete = sin(w*time_sampled);  % sample counts

figure(1);plot(time_signal,signal);
hold on;
% plot(time_sampled,discrete,'ks')
stem(time_sampled,discrete,'ks--');

% попытка восстановить сигнал с использованием синков
tt = (-t:(1/fss):t);  % time counts for filter (based on modeling frequency)
Nyquist_filter = sinc(fs*tt);  % Nyquist filter in time domain
% plot(tt,Nyquist_filter);
upsampled = upsample(discrete,fss/fs);  % upsample discrete signal to the modeling frequency (new samples is equal to zero)
upsampled(end+1-(fss/fs-1):end) = [];  % remove last unused zeros: S000S000S[000] (S = sample)

restored = conv(upsampled,Nyquist_filter,'same');  % restored signal: signal -> sample -> filter

ttt = linspace(0,t,length(restored));
figure(2);hold on;
plot(ttt,restored);stem(time_sampled,discrete);plot(time_signal,signal);
legend('restored','sampled','original');


figure(4);hold on;

fft_restored = abs(fft(restored)/length(restored));
plot(linspace(0,fss,length(restored)),fft_restored)

fft_sampled = abs(fft(upsampled)/length(upsampled)).*fss/fs; %energy loss compensation
plot(linspace(0,fss,length(upsampled)),fft_sampled)

fft_signal = abs(fft(signal)/length(signal));
plot(linspace(0,fss,length(signal)),fft_signal)

legend('restored','sampled','original');xlim([0, 2*fs]);set(gca, 'YScale', 'log')

% return

[rId, cId] = find(upsampled);
figure(3);hold on;
plot(ttt,restored);stem(time_sampled,discrete);
for i = cId
    plot(tt+((i-1)*1/fss),upsampled(i)*Nyquist_filter,'b--');
end
xlim([0 t]);