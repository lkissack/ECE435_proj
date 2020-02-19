function [display_density] = VoltageHistDens(data)
%read data - very dependent on formulation of data
%[voltages, channels] = size(data);
[channels, voltages] = size(data);
%do this for each channel of the EEG data
data_hist = zeros(256, channels);
for i = 1:channels
    data_hist(:,i) = imhist(data(i,:));
end

%Want 256 levels for the graylevels of the channels
grayscaled_data = zeros(256, channels);

%invert so darker = more
grayscaled_data = 256 - uint8(255*mat2gray(data_hist));

%for each channel of the EEG data generate an image of the distribution
%show this as an image, but scale first, providing an arbitrary number of
%pixels per channel

display_density = imresize(grayscaled_data, [1000, 1000], 'nearest');
imshow(display_density);
%tested seems to work with random data, not sure 
k=2;

end

