%Project Script

%% Cleaning

%% Fake Data creation

data = randn(63, 2000, 'single');

%% Create Grayscale Figure

data2grayscale(data);

%% Plot specific event
hold on
plot_event(data, 500);

plot_event(data, 550);
