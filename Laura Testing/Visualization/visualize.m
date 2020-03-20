function [] = visualize(data)
%% Determine tile scale factors
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

g = data2grayscale(data);

% display each channel in the correct location
figure('Name', 'Scaled Linear Histogram Display');

% c = g(:,1);
% c_mod = imresize(c,[scale_factors(1)*1000,200],'nearest');
% imshow(c_mod,[]);

%% Scale tiles accordingly
% channel_array = imresize( g(:,1), [1000, 200],'nearest');
tile_size = [256, 200];
%not sure which implementation is better
channel_array = zeros(tile_size(1), tile_size(2)*channels);
channel_matrix = zeros(tile_size(1), tile_size(2), channels);

for channel = 1:channels
   % c_mod = imresize( g(:,channel), [scale_factors(channel)*1000, 200],'nearest');
   %divide the scale factor by two, round, and then multiply to ensure even
   %number
    c_mod = imresize( g(:,channel), [2*round(scale_factors(channel)*tile_size(1)/2), 200],'nearest');
    
    csize = size(c_mod);
    tile = 255*ones(tile_size(1), tile_size(2));
    tile(((tile_size(1)-csize(1))/2): ((tile_size(1) + csize(1))/2 - 1), :) = c_mod;
    
    channel_array(:,1+ 200*(channel-1):200*channel) = tile;
    channel_matrix(:,:,channel) = tile;
   
end

imshow(channel_array,[]);

%% Put tiles in temporal locations
figure('Name','Temporal Map');
%imshow(channel_matrix(:,:,1),[]);

%put histograms in the right locations
%maps channel to temporal location
[map,electrodes] = temporal_location();

temporal_map = zeros(8*tile_size(1),11*tile_size(2));

for tile = 1:channels
    %[row,col] = map(tile);
    row = map(tile,1);
    col = map(tile,2);
    %temporal_map(1+tile_size(1)*(row-1):tile_size(1)*row,1+tile_size(1)*(col-1):tile_size(1)*col) = channel_matrix(:,:,tile);
    temporal_map(1+tile_size(1)*(row-1):tile_size(1)*row,1+tile_size(2)*(col-1):tile_size(2)*col) = channel_matrix(:,:,tile);
       
end
imshow(temporal_map,[]);
%also need to implement locations of th

%% plot instance specific data

% top row of data points
row = 1;
xaxis = tile_size(2)/2 + (find(electrodes(row,:))-1)*tile_size(2);

%




end

function[map,electrode_locations] = temporal_location()

% electrodes = ['af3','af4', 'af7','af8','afz','c1','c2','c3','c4', 'c5','c6',
%                 'cp1','cp2','cp3','cp4','cp5','cp6','cpz','cz','f1','f2',
%                 'f4','f5','f6','f7','f8','fc1','fc2','fc3','fc4','fc5','fc6',
%                 'fcz','fp1','fp2','ft10','ft7','ft8','ft9','fz','o1','o2',
%                 'oz','p1','p2','p3','p4','p5','p6','p7','p8','po3','po4',
%                 'po7','po8','poz','pz','t7','t8','tp10','tp7','tp8','tp9'];
% 
% channels = 1:64;
% 
% m = containers.Map(electrodes, channels);
% %map each alphabetical electrode to [row, col] location
% 
% %currently the two models are incompatible
% 
% %index, corresponding channel
% channel_ind = [0,0,40,0,64,0,0,0,26,38,59,62,51,0,0,3,24,32,10,16,49,0,0,
%                 1,20,28,6,12,45,53,42,5,41,34,19,18,58,57,44,
%                 2,21,29,7,13,46,54,43,36,23,31,9,15,48,56,0,
%                 4,25,33,11,17,50,0,0,0,27,39,60,63,52,0,0,
%                 0,0,37,0,61,0,0,0];

electrode_locations = [0,   0,  3,  1,  4,  5,  6,  2,  7,  0,  0;
                       0,   8,  9,  10, 11, 12, 13, 14, 15, 16, 0;
                       17,  18, 19, 20, 21, 22, 23, 24, 25, 26, 27;
                       0,   28, 29, 30, 31, 32, 33, 34, 35, 36, 0;
                       37,	38,	39,	40,	41,	42,	43,	44,	45,	46,	47;
                       0,   48,	49,	50,	51,	52,	53,	54,	55,	56, 0;
                       0,   0,  0,  57,	58,	59,	60,	61, 0,  0,  0;
                       0,   0,  0,  0,  62, 63, 64,  0, 0,  0,  0;];
                    
map = ones(64,2);

for electrode = 1:64
    %map the index of the channel into a row col location
    
    [row,col] = find(electrode_locations==electrode);
    
    map(electrode,:) = [row,col];
        
end

end