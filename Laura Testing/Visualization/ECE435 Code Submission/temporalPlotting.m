function [temporal_map] = temporalPlotting(channel_matrix,map,channels, tile_size)
%put histograms in the right locations
%maps channel to temporal location
temporal_map = zeros(8*tile_size(1),11*tile_size(2));

for tile = 1:channels
    %[row,col] = map(tile);
    row = map(tile,1);
    col = map(tile,2);
    %temporal_map(1+tile_size(1)*(row-1):tile_size(1)*row,1+tile_size(1)*(col-1):tile_size(1)*col) = channel_matrix(:,:,tile);
    temporal_map(1+tile_size(1)*(row-1):tile_size(1)*row,1+tile_size(2)*(col-1):tile_size(2)*col) = channel_matrix(:,:,tile);
       
end
figure('Name','Temporal Map');
imshow(temporal_map,[]);
end

