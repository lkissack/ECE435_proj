function plotOut = plotEvent(dataSet)
%Plots events from a given dataset
newPlot = "yes";
timeFrame = -996:4:2000;
while newPlot == 'yes' | newPlot == 'Yes' | newPlot == 'y' | newPlot == 'Y'
    typeNum = input("\nWhich event type would you like to plot? Enter a value between [1,#]: ");
    eventNum = input("\nWhat event number would you like to plot? Enter a value between [1,]: ");
    channels = input("\nWhich channels would you like to plot? Enter the channels in array format: ");
    data = getEvent(dataSet,typeNum,eventNum,channels);
    plotOut = plot(timeFrame, data);
    newPlot = input("\nWould you like to plot another event? (Y/N): ", 's');
end
end

