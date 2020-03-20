function [] = butterfly(data)

[channels, samples] = size(data);
figure('Name', 'Butterfly Plot');
sample_space = 0:1:samples-1;
hold on
for channel = 1: channels
    %plot the data
    data(channel,:);
    plot(sample_space, data(channel,:),'k');
end
title('Butterfly Plot')
ylabel('Amplitude (microV)')
hold off

end

