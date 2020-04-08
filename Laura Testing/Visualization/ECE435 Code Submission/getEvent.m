function event = getEvent(dataSet, types, eventCount)
%getEvent retrieves the event data based on user input, requires the types
%of events and eventCount as inputs

%Prompt which event user would like to retrieve
fprintf("\nPlease enter the event type (value must be between [%i,%i]): ",min(types),max(types));
typeNum = input("");
typeIndex = find(typeNum==types);
fprintf("\nPlease enter the event number (value must be between [1,%i]: ",eventCount(typeIndex));
eventNum = input("");
channels = input("\nPlease enter the channels to retrieve (value can be array between [1:63]): ");

event = dataSet.(strcat("T",int2str(typeNum))).( ...
    strcat("eventNum", int2str(eventNum)))(channels,:);
end

