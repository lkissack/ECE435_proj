function [d] = plot_event(data, time)
%x axis is streched by 100 per sample
%y axis is stretched to -500, 500, then moved to 500;
[channels, time_intervals] = size(data);
channel = 1:100:100*channels;
channel = channel + 50;
%data being squished into 256 values, then stretched to 1000
adjusted_data = 142.85*data(:, time)/10000+500;
% samples = [channel,data(:, time)];
d = adjusted_data;
scatter(channel,adjusted_data','*red');
plot(channel, adjusted_data', 'red');

xlabel('Channels at time sample');
ylabel('EEG signal level');
end

