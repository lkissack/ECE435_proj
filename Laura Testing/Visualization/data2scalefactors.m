function [scale_factors,data_maximum] = data2scalefactors(data)
[channels, measurements] = size(data);

%This should be its own function
scale_factors = ones(channels,1);
%scale each channel by max and min values

%have not tested this line
data_maximum = max(max(abs(data)));
data_maximum = 35000;

for channel = 1:channels
    %determine the scale factor that should be applied ot the channel
%     maximum = max(data(channel,:));
%     minimum = min(data(channel,:));
%     scale = (maximum - minimum)/7;

    channel_maximum = max(abs(data(channel,:)));
    scale_factors(channel) = channel_maximum/data_maximum;
    %assuming the absolute max of the data is 3.5 microv 
end
end

