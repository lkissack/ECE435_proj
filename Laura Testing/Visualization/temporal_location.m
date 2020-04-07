function[map,electrode_locations] = temporal_location()
%Only the first 63 channels are being used as the ground channel is left
%out, the number and mapping of the channels can be modified by altering
%the electrodes location data structure and the number of electrodes

electrode_locations = [0,   0,  3,  1,  4,  5,  6,  2,  7,  0,  0;
                       0,   8,  9,  10, 11, 12, 13, 14, 15, 16, 0;
                       17,  18, 19, 20, 21, 22, 23, 24, 25, 26, 27;
                       0,   28, 29, 30, 31, 32, 33, 34, 35, 36, 0;
                       37,	38,	39,	40,	41,	42,	43,	44,	45,	46,	47;
                       0,   48,	49,	50,	51,	52,	53,	54,	55,	56, 0;
                       0,   0,  0,  57,	58,	59,	60,	61, 0,  0,  0;
                       0,   0,  0,  0,  62, 63, 0,  0, 0,  0,  0;];
% 63, 64 removed from row next to 62
                    
map = ones(63,2);

for electrode = 1:63
    %map the index of the channel into a row col location
    
    [row,col] = find(electrode_locations==electrode);
    
    map(electrode,:) = [row,col];
        
end

end

