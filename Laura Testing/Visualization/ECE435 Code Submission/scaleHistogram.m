function [channel_matrix] = scaleHistogram(scale_factors,channels,tile_size,grayscale)
channel_array = zeros(tile_size(1), tile_size(2)*channels);
channel_matrix = zeros(tile_size(1), tile_size(2), channels);

for channel = 1:channels
   % c_mod = imresize( g(:,channel), [scale_factors(channel)*1000, 200],'nearest');
   %divide the scale factor by two, round, and then multiply to ensure even
   %number
   
    resize_height = 2*round(scale_factors(channel)*tile_size(1)/2);
    csize = [0,0];
    tile = 255*ones(tile_size(1), tile_size(2));
    %only rescale the image if it is large enough to be scaled
    if resize_height > 0
        c_mod = imresize( grayscale(:,channel), [resize_height, tile_size(2)],'nearest');
        csize = size(c_mod);
        tile(((tile_size(1)-csize(1))/2): ((tile_size(1) + csize(1))/2 - 1), :) = c_mod;
    end
    
    channel_array(:,1+ 200*(channel-1):200*channel) = tile;
    channel_matrix(:,:,channel) = tile;
   
end
 figure('Name', 'Scaled Linear Histogram Display');
 imshow(channel_array,[]);
end

