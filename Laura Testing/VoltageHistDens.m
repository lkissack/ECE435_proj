function [display_density] = VoltageHistDens(data)
%read data - very dependent on formulation of data
[voltages, channels] = size(data);
%do this for each channel of the EEG data
data_hist = zeros(256, channels);
for i = 1:channels
    data_hist(:,i) = imhist(data(:,i));
end

%determined using an image, not EEG data - might change
grayscaled_data = zeros(voltages, channels);

%invert so darker = more
grayscaled_data = 255 - uint8(255*mat2gray(data_hist));

%for each channel of the EEG data generate an image of the distribution
%show this as an image, but scale first, providing an arbitrary number of
%pixels per channel

display_density = imresize(grayscaled_data, [1000, 1000], 'nearest');
imshow(display_density);
%tested seems to work with random data, not sure 

end

