function [display_density] = data2grayscale(data,scale_factor)

[channels,measurements] = size(data);
hist = zeros(channels, 256);

for i= 1:channels
    %f = histogram(data,256);
    dist = histcounts(data(i,:),256);
    hist(i,:) = dist;    
end
histogram(data(1,:), 256);
%each row represents one channel

b = hist/2000;
grayscale_hist = 256 - uint8(255*mat2gray(b'));
imshow(grayscale_hist,[]);
display_density = imresize(grayscale_hist, [1000, 100*channels], 'nearest');
imshow(display_density,[]);

end

