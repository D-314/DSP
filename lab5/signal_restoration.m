data = load("samples.mat");
plot(0:length(data.x_sampled)-1, data.x_sampled); hold on;
plot(0:length(data.x)-1, data.x); hold on;
restored = conv(data.x_sampled, data.h);
restored = 16*restored(200:end);
%plot(0:length(restored)-1, restored);