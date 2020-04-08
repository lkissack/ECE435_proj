function [scale_factors,data_maximum] = data2scalefactors(data)
[channels, measurements] = size(data);

%This should be its own function
scale_factors = ones(channels,1);
%scale each channel by max and min values
% 
% data_maximum = max(max(abs(data)));
% %data_maximum = 32500;

% %use with original scaling - but then plotting at the end is difficult
min(abs(data),[],2)
max(abs(data),[],2)
data_maximum = max(max(abs(data),[],2)-min(abs(data),[],2));

%for some buffer space add an extra 10% to the maximum
data_maximum = 1.1*data_maximum;

for channel = 1:channels

    channel_maximum = max(abs(data(channel,:)))-min(abs(data(channel,:)));
    scale_factors(channel) = channel_maximum/data_maximum;
end
end

