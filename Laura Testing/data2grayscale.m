function [display_density] = data2grayscale(data)

[channels,measurements] = size(data);
hist = zeros(channels, 256);

for i= 1:channels
    %f = histogram(data,256);
    dist = histcounts(data(i,:),256);
    hist(i,:) = dist;    
end

grayscale_hist = 256 - uint8(255*mat2gray(hist'));
imshow(grayscale_hist);
display_density = imresize(grayscale_hist, [1000, 6300], 'nearest');
imshow(display_density);

end

