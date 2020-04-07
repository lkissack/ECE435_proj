%Project Script

%% Cleaning
clear
close all
%% Fake Data creation

% rdata = randn(64, 2000, 'single');
% data= rdata;

%% Load selected data
% tdata = load('test2000.mat');
% data2000 = tdata.d;
% data40000 = load('test40000.mat');
% data = data40000.test40000(:,1500:2000);
% data = data - mean(data,2);

d = load('T10E52.mat');
data = d.data;
% test = load('participant1NAR.mat');
% data = test.epochedDat.T10.eventNum52;

%% Create Grayscale Figure
close all;
grayscale = data2grayscale(data);

%% Scale Region by min/max values
% Create function to generate image plot
[channels, measurements] = size(data);
[scale_factors, data_maximum] = data2scalefactors(data);

%% Scale Histogram tiles
% tile size chosen arbitrarily
tile_size = [256, 200];
channel_matrix = scaleHistogram(scale_factors,channels,tile_size,grayscale);

%% Put tiles in temporal locations
[map,electrodes] = temporal_location();
[temporal_map] = temporalPlotting(channel_matrix,map,channels,tile_size);

%% Plot instance specific data
hold on
timePlotting(data,scale_factors,electrodes,tile_size);
hold off
%% Evaluation - Generate Butterfly plot

butterfly(data);
