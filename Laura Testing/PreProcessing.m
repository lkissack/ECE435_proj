%% Preprocessing Script for EEG data visualization
% This script requires the function getEvent.m as well as the signal
% processing toolbox which is used for filtering

clear all
clc
%% Load EEG Data
fullpath = input("Enter path of EEG data or type 'Browse' to select it with the file explorer: ", 's');
if fullpath == "browse" || fullpath == "Browse"
    [data, path] = uigetfile("*.mat");
    fullpath = strcat(path,data);
    structname = split(data, '.');
    structname = structname(1);
else
    %Find the name of the struct, since it changes based on participants
    structname = split(fullpath, '\');
    structname = structname(length(structname));
    structname = split(structname, '.');
    structname = structname(1);    
end
%Load data
structname = char(structname);
eeg = load(fullpath);
%store important values with easier to read variables
times = eeg.(structname).times; %stored in milliseconds
data = eeg.(structname).data;
samp_rate = eeg.(structname).srate;
numCH = eeg.(structname).nbchan;
dataPts = eeg.(structname).pnts;
events = eeg.(structname).event;

%% Resample data using spline interpolation from 500Hz to 250Hz
%rstimes and rsdata is the resampled data
rsdat = zeros(length(numCH),dataPts/2);
for i = 1:numCH
    [rsdat(i,:), rstimes] = resample(double(data(i,:)),times,0.25,250,500,"spline");
end

%% Rereference data, this reduces noise present in the ground electrode
%reference electrodes will be the mastoid electrodes M1(TP9) and M2(TP10)
%Good reference for why this is important: 
%https://www.brainproducts.com/files/public/products/brochures_material/pr_articles/1901_Referencing.pdf
TP9 = 63; %Corresponding channels for the electrodes
TP10 = 60;

AverageRef = (rsdat(TP9,:)+rsdat(TP10,:))/2;

rerefdat = zeros(numCH, dataPts/2);
for i = 1:numCH
    rerefdat(i,:) = rsdat(i,:)-AverageRef;
end 

%% Data Filtering (Applies an IIR filter)
% filtfilt function used as it has zero phase distortion on data
%Bandpass IIR
bpFilt = designfilt('bandpassiir','FilterOrder',4, ...
          'HalfPowerFrequency1',0.1,'HalfPowerFrequency2',30, ...
          'SampleRate',samp_rate/2);

BPFiltered = filtfilt(bpFilt, rerefdat(:,:));

%Notch IIR

w0 = 60/(samp_rate/4);
bw = w0/35; %35 is Q factor
[b,a] = iirnotch(w0,bw);
NotchFiltered = filtfilt(b,a, BPFiltered(:,:));

%% Segmentation, Epoched for -1000 ms to 2000 ms 

%Segment data over all markers

numEvents = size(events);
numEvents = numEvents(2);

%Get all event types
types = zeros(numEvents,1);
j = 1;
for i = 1:numEvents
    %if the latency is not 1 (at start of dataset)
    if events(i).latency ~= 1
        %if the type does not yet exist in our types array
        %add it to the array
        if ~ismember(events(i).type, types)
            types(j) = events(i).type;
            j=j+1;
        end
    end
end

%sort types in into increasing order and remove zeros from array
numTypes = 0;
for i = 1:numEvents
    if types(i) ~= 0
        numTypes = numTypes+1;
    end
end
types = types(1:numTypes, 1);
types = sort(types);

%Count number of each event type
numEventTypes = zeros(numTypes,1);

for j = 1:numEvents
    if ismember(events(j).type,types) && events(j).latency ~= 1
        typeIndex = find(types==events(j).type);
        numEventTypes(typeIndex) = numEventTypes(typeIndex) + 1;
    end
end
%Number of events relative to ones which we are interested in
numRelEvents = sum(numEventTypes);
%Correct latencies to resampled times, half the sampling frequency so
%latencies must be divided by 2
latencies = zeros(numRelEvents,1);
for i = 1:numRelEvents
    latencies(i) = round(events(i+(numEvents-numRelEvents)).latency/2);
end

%Epoch the events and store in a data structure related to their type

timeFrame = 3000/4; %3000 ms divided by 4 ms per datapoint at resampled Fs
epochedDat = struct();

%prepare struct for data epoching and allocate data arrays
for i = 1:numTypes
    for j = 1:numEventTypes(i)
        epochedDat.(strcat("T",int2str(types(i)))).( ... 
            strcat("eventNum",int2str(j))) = zeros(numCH,timeFrame);
    end
end

%Epoch the data
eventCount = ones(numTypes,1);
for i = 1:numRelEvents
    epochedDat.(strcat("T",int2str(events(i+(numEvents-numRelEvents)).type))).( ...
        strcat("eventNum",int2str(eventCount(find(types==events(i+(numEvents-numRelEvents)).type)))))...
        = NotchFiltered(:,(latencies(i)-1000/4+1):(latencies(i)+2000/4));
    if eventCount(find(types==events(i+(numEvents-numRelEvents)).type)) >= ... 
            numEventTypes(find(types==events(i+(numEvents-numRelEvents)).type))
        
    else 
        eventCount(find(types==events(i+(numEvents-numRelEvents)).type)) ...
            = eventCount(find(types==events(i+(numEvents-numRelEvents)).type))+1;
    end
end
%% Perform baseline correction on all Epochs

%Average data from -200 ms to 0 ms and subtract average from all epochs
eventCount = ones(numTypes,1);
for i = 1:numRelEvents
    for j = 1:numCH
        epochedDat.(strcat("T",int2str(events(i+(numEvents-numRelEvents)).type))).( ...
            strcat("eventNum",int2str(eventCount(find(types==events(i+(numEvents-numRelEvents)).type)))))(j,:)...
            = epochedDat.(strcat("T",int2str(events(i+(numEvents-numRelEvents)).type))).( ...
            strcat("eventNum",int2str(eventCount(find(types==events(i+(numEvents-numRelEvents)).type)))))(j,:)...
            - mean(NotchFiltered(j,(latencies(i)-200/4+1):latencies(i)));
    end
        if eventCount(find(types==events(i+(numEvents-numRelEvents)).type)) >= ...
                numEventTypes(find(types==events(i+(numEvents-numRelEvents)).type))
            
        else
            eventCount(find(types==events(i+(numEvents-numRelEvents)).type)) ...
                = eventCount(find(types==events(i+(numEvents-numRelEvents)).type))+1;
        end
end


%% Artifact Rejection
% Checks for artifacts based on the variance of the channel and a threshold
% value varCheck as recommended here: https://www.krigolsonlab.com/muse-analysis-matlab.html
% many different approaches can be used to perform artifact rejection,
% however to keep simplicity in this project the variance was used. 

threshold = 200;
artifactRejected = epochedDat;
for i = 1:numRelEvents
    for j = 1:eventCount(find(types==events(i+(numEvents-numRelEvents)).type))
        event = getEvent(artifactRejected, events(i+(numEvents-numRelEvents)).type, j);
        for n = 1:numCH
            varCheck = var(event(n,:));
            if varCheck > threshold
                artifactRejected.( ...
                    strcat("T", int2str(events(i+(numEvents-numRelEvents)).type))).( ...
                    strcat("eventNum", int2str(j)))(n,:) = NaN;
            end
        end
    end
end

%% Save Baseline Corrected and Artifact Rejected data as new data files
%Outputs .mat files for both artifact rejected data and baseline corrected
%data in case one wants to work with data that has not yet been artifact
%rejected.

%Make directories in data folder for processed data.

path = split(fullpath, '\');
path(end) = [];
path = join(path, '\');

%Make folders for both artifact rejected and baseline corrected data
%Note* Artifact rejected has also been baseline corrected
mkdir(strcat(path, " PreProcessed"));
mkdir(strcat(strcat(path, " PreProcessed\"), "Artifact Rejected"));
mkdir(strcat(strcat(path, " PreProcessed\"), "Artifacts Included"));

filename = strcat('\', structname);
%Save structs as .mat files in the appropriate folders
save(strcat(strcat(strcat(path, " PreProcessed"), "\Artifacts Included"),...
    strcat(filename, "NAR.mat")), 'epochedDat');

save(strcat(strcat(strcat(path, " PreProcessed"), "\Artifact Rejected"),...
    strcat(filename, "AR.mat")),'artifactRejected');

%% Plot End Results
% plots results from a single event
plotEvent(epochedDat); %Plots Baseline Corrected Events (Not artifact rejected)
