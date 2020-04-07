%% ECE 435 Final Project Code - EEG Data Visualization Project
% by Laura Kissack (V00844693) and Tanner Oleksuik (V00867082)

preProcessing;


%% Specify data for visualization
%arbitrarily chosen 
d = load('T10E52.mat');
data = d.data;
% test = load('participant1NAR.mat');
% data = test.epochedDat.T10.eventNum52;
close all;
%% Step 1 - Create Grayscale Figure
grayscale = data2grayscale(data);

%% Step 2a - Determine Scale Factors
% Create function to generate image plot
[channels, measurements] = size(data);
[scale_factors, data_maximum] = data2scalefactors(data);

%% Step 2b - Scale Histogram tiles
% tile size chosen arbitrarily
tile_size = [256, 200];
channel_matrix = scaleHistogram(scale_factors,channels,tile_size,grayscale);

%% Step 3 - Put tiles in temporal locations
[map,electrodes] = temporal_location();
[temporal_map] = temporalPlotting(channel_matrix,map,channels,tile_size);

%% Step 4 - Plot instance specific data
hold on
timePlotting(data,scale_factors,electrodes,tile_size);
hold off

%% Evaluation - Generate Butterfly plot
butterfly(data);