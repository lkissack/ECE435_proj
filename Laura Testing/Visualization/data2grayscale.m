function [grayscale_hist, display_density] = data2grayscale(data)

[channels,measurements] = size(data);
hist = zeros(channels, 256);

%might want to make bin widths standardized?

for i= 1:channels
    %f = histogram(data,256);
    dist = histcounts(data(i,:),256);
    %each row represents one channel
    hist(i,:) = dist;    
end
%for testing purposes
%histogram(data(1,:), 256);

%scale by the total number of measurements to get probability
b = hist/measurements;

%transpose the histogram so each column represents a channel
%subtract this value from 256 so histogram is inverted
grayscale_hist = 256 - uint8(255*mat2gray(b'));

%for testing purposes
imshow(grayscale_hist,[]);
%scale the image to a reasonable range.
display_density = imresize(grayscale_hist, [1000, 100*channels], 'nearest');
imshow(display_density,[]);

end

