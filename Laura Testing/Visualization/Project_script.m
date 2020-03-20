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
g = data2grayscale(data);

%% Scale Region by min/max values
% Create function to generate image plot

visualize(data);

%% Plot specific event
hold on

a = plot_event(data, 500);

b = plot_event(data, 4);

%Added in 2019B
% newcolors = {'red','red','blue','blue'};
% colororder(newcolors);

hold off
figure(4);
plot(1:62,a,'r');
hold on
plot(1:62,b,'b');
c = a -b;

%% Evaluation - Generate Butterfly plot

butterfly(data);