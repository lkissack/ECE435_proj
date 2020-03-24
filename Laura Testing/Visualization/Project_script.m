%Project Script

%% Cleaning
clear
close all
%% Fake Data creation

% rdata = randn(63, 2000, 'single');
% data= rdata;

%% Load first 2000 sample data
tdata = load('test2000.mat');
data = tdata.d;

%% Create Grayscale Figure
close all;
grayscale = data2grayscale(data);
%% Scale Region by min/max values
% Create function to generate image plot
[channels, measurements] = size(data);
% 
% %This should be its own function
% scale_factors = ones(channels,1);
% %scale each channel by max and min values
% 
% %have not tested this line
% data_maximum = max(max(abs(data)));
% data_maximum = 35000;
% 
% for channel = 1:channels
%     %determine the scale factor that should be applied ot the channel
% %     maximum = max(data(channel,:));
% %     minimum = min(data(channel,:));
% %     scale = (maximum - minimum)/7;
% 
%     channel_maximum = max(abs(data(channel,:)));
%     scale_factors(channel) = channel_maximum/data_maximum;
%     %assuming the absolute max of the data is 3.5 microv 
% end
[scale_factors, data_maximum] = data2scalefactors(data);

%% Scale Histogram tiles
% tile size chosen arbitrarily
tile_size = [256, 200];
%not sure which implementation is better
channel_array = zeros(tile_size(1), tile_size(2)*channels);
channel_matrix = zeros(tile_size(1), tile_size(2), channels);

for channel = 1:channels
   % c_mod = imresize( g(:,channel), [scale_factors(channel)*1000, 200],'nearest');
   %divide the scale factor by two, round, and then multiply to ensure even
   %number
    c_mod = imresize( grayscale(:,channel), [2*round(scale_factors(channel)*tile_size(1)/2), tile_size(2)],'nearest');
    
    csize = size(c_mod);
    tile = 255*ones(tile_size(1), tile_size(2));
    tile(((tile_size(1)-csize(1))/2): ((tile_size(1) + csize(1))/2 - 1), :) = c_mod;
    
    channel_array(:,1+ 200*(channel-1):200*channel) = tile;
    channel_matrix(:,:,channel) = tile;
   
end
figure('Name', 'Scaled Linear Histogram Display');
imshow(channel_array,[]);

%% Put tiles in temporal locations
figure('Name','Temporal Map');
%imshow(channel_matrix(:,:,1),[]);

%put histograms in the right locations
%maps channel to temporal location
[map,electrodes] = temporal_location();

%map shape is dependent on the 
temporal_map = zeros(8*tile_size(1),11*tile_size(2));

for tile = 1:channels
    %[row,col] = map(tile);
    row = map(tile,1);
    col = map(tile,2);
    %temporal_map(1+tile_size(1)*(row-1):tile_size(1)*row,1+tile_size(1)*(col-1):tile_size(1)*col) = channel_matrix(:,:,tile);
    temporal_map(1+tile_size(1)*(row-1):tile_size(1)*row,1+tile_size(2)*(col-1):tile_size(2)*col) = channel_matrix(:,:,tile);
       
end
hold on
imshow(temporal_map,[]);
%% Plot instance specific data

instances = [250,1888];
colour = ['r','b'];
[rows, cols] = size(electrodes);
mv_scale = 128/data_maximum;
for i = 1:length(instances)
    for row = 1:rows-1
        nonzero = find(electrodes(row,:));
        electrodes(row,nonzero)
        y = data(electrodes(row,nonzero),instances(i))
        y = mv_scale*y
        offset = tile_size(1)/2 + (row-1)*tile_size(1);
        y = y + offset;
        %still need to scale this
        xaxis = tile_size(2)/2 + tile_size(2)*(nonzero -1);
        hold on
        plot(xaxis, y,colour(i));
    end
end
hold off

%% Visualize function
% visualize(data);
% 
% %% Plot specific event
% hold on
% 
% a = plot_event(data, 500);
% 
% b = plot_event(data, 4);
% 
% %Added in 2019B
% % newcolors = {'red','red','blue','blue'};
% % colororder(newcolors);
% 
% hold off
% figure(4);
% plot(1:62,a,'r');
% hold on
% plot(1:62,b,'b');
% c = a -b;

%% Evaluation - Generate Butterfly plot

butterfly(data);
