function [] = visualize(data)

[channels, measurements] = size(data);

%This should be its own function
scale_factors = ones(channels,1);
%scale each channel by max and min values

for channel = 1:channels
    %determine the scale factor that should be applied ot the channel
%     maximum = max(data(channel,:));
%     minimum = min(data(channel,:));
%     scale = (maximum - minimum)/7;

    maximum = max(abs(data(channel,:)));
    scale_factors(channel) = 2*maximum/70000;
    %assuming the absolute max of the data is 3.5 mv 
end

scale_factors;

g = data2grayscale(data);

% display each channel in the correct location
figure(2);

% c = g(:,1);
% c_mod = imresize(c,[scale_factors(1)*1000,200],'nearest');
% imshow(c_mod,[]);


% channel_array = imresize( g(:,1), [1000, 200],'nearest');
tile_size = [1000, 200];
channel_array = zeros(tile_size(1), tile_size(2)*channels);

for channel = 1:channels
   % c_mod = imresize( g(:,channel), [scale_factors(channel)*1000, 200],'nearest');
   %divide the scale factor by two, round, and then multiply to ensure even
   %number
    c_mod = imresize( g(:,channel), [2*round(scale_factors(channel)*500), 200],'nearest');
    
    csize = size(c_mod);
    tile = 255*ones(tile_size(1), tile_size(2));
    tile((500 - csize(1)/2): (500 + csize(1)/2 - 1), :) = c_mod;
    
    channel_array(:,1+ 200*(channel-1):200*channel) = tile;
   
end

imshow(channel_array,[]);

figure(3);
channel_matrix = zeros(11*tile_size(2), 6*tile_size(1));

%9 in row 1
   %11 in row two
   %9 in row 3
   %11
   %11
   %7

%subplot(11, 6, 2)
%Assumes channel data is sorted based on temporal location
%probably not the case - last elements added falsely so that there are 64
%spots, otherwise there are only 58
% fake = [1, 11, 56, 57, 65, 66];
% channel_locations = [2:1:10,12:1:22, 24:1:32, 34:1:44, 45:1:55, 58:1:64, fake ];
% imshow(c_mod,[]);

end

