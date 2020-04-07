function event = getEvent(epochedDat, typeNum, eventNum, channels)
%getEvent retrieves the event data based on event type, the event number
%(how many times that event has happened), and the channels you would like
%to retrieve from 1 to 63, this can be an array, default will be all.

if nargin > 3
    defaultChannels = channels;
else
    defaultChannels = 1:63;
end

event = epochedDat.(strcat("T",int2str(typeNum))).( ...
    strcat("eventNum", int2str(eventNum)))(defaultChannels,:);
end

