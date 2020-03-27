function [grayscale_hist, display_density] = data2grayscale(data)

[channels,measurements] = size(data);
hist = zeros(channels, 256);

%might want to make bin widths standardized?

for i= 1:channels
    % forcing distribution to be centralized around 0 - not the right way
    % to do this
%     channel_max = max(abs(data(i,:)));
%     edges = -channel_max - 1:(channel_max +1)/128:channel_max + 1
%     dist = histcounts(data(i,:),edges,'Normalization','probability');
    
    %original code
    dist = histcounts(data(i,:),256,'Normalization','probability');
    %each row represents one channel
    hist(i,:) = dist;
end
%for testing purposes
%histogram(data(1,:), 256);

%Take the transpose so each horizontal level represents a voltage
%Flip so larger voltages are above lower voltages
b = flip(hist');

%transpose the histogram so each column represents a channel
%subtract this value from 256 so histogram is inverted
grayscale_hist = 256 - uint8(255*mat2gray(b));

%for testing purposes
figure('Name', 'Linear Histogram Display');
imshow(grayscale_hist,[]);
%scale the image to a reasonable range.
display_density = imresize(grayscale_hist, [1000, 100*channels], 'nearest');
imshow(display_density,[]);

end

