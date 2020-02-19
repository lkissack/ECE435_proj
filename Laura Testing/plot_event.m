function [] = plot_event(data, time)
channel = 1:100:6300;
channel = channel + 50;
%data being squished into 256 values, then strecthed to 1000

scatter(channel,data(:, time),'*');
line(channel, data(:, time));
end

