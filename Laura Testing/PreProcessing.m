clear all
clc
%Load EEG Data
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

%Resample data using spline interpolation from 500Hz to 250Hz
%rstimes and rsdata is the resampled data
rsdat = zeros(length(numCH),dataPts/2);
for i = 1:numCH
    [rsdat(i,:), rstimes] = resample(double(data(i,:)),times,0.25,250,500,"spline");
end

%Rereference data, this reduces noise present in the ground electrode
%reference electrodes will be the mastoid electrodes M1(TP9) and M2(TP10)
%Good reference for why this is important: 
%https://www.brainproducts.com/files/public/products/brochures_material/pr_articles/1901_Referencing.pdf
TP9 = 10; %Corresponding channels for the electrodes
TP10 = 21;

AverageRef = (rsdat(TP9,:)+rsdat(TP10,:))/2;

rerefdat = zeros(numCH, dataPts/2);
for i = 1:numCH
    rerefdat(i,:) = rsdat(i,:)-AverageRef;
end 

%Data Filtering (Applies an IIR filter) --TODO
%Bandpass IIR

%Notch IIR

