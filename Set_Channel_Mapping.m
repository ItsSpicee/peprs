% 0 = Select, 1 = None, 2 = Channel 1, 3 = Channel 2
function Set_Channel_Mapping(iChannel,qChannel)
    channelMap = [0 0; 0 0];
    load(".\Measurement Data\RX Calibration Parameters\RX.mat") 
    if iChannel == 1
        channelMap(1,:) = 1;
    elseif iChannel == 2
        channelMap(1,1) = 1;
    elseif iChannel == 3
        channelMap(2,1) = 1;
    end
    if qChannel == 1
        channelMap(2,:) = 1;
    elseif qChannel == 2
        channelMap(1,2) = 1;
    elseif qChannel == 3
        channelMap(2,2) = 1;
    end  
    RX.channelVec = channelMap;
    save(".\Measurement Data\RX Calibration Parameters\RX.mat","RX")
end