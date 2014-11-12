%extracts data from NIRStar .evt, .wl1, and .wl2 files to save them in a
%single array called scmData, which that Matlab can analyze with an SVM.

%svmData has 25 columns. The first 12 columns are the wl1 channels. The 
%next 12 channels are the wl2 channels. The final column is a flag which is
%1 for a target frame or 0 for a distractor frame. Target frames last from
%the cue onset until traceLength frames pass.
% [wl1 data] [wl2 data] [flag]


function [noFlagData, flags] = svmFormat(dataFileBaseName, traceLength)
    
    distractorEventIndex = 7;
    goodChannels = 6; %only 6 of the 12 channels were anatomically close to the DLPFC
    
    eventData = load([dataFileBaseName '.evt']);
    waveLength1 = load([dataFileBaseName '.wl1']); %file has 12 columns and one row for each frame
    waveLength2 = load([dataFileBaseName '.wl2']); %file has 12 columns and one row for each frame
    
    %Throw out channels 7-12 because they are the sensors from the bottom
    %of the forhead, not anatomically close to the DLPFC
    
    waveLength1Top = waveLength1(:, 1:goodChannels);
    waveLength2Top = waveLength2(:, 1:goodChannels);
    
    %Extract the list of frames when the event file notes a distractor. 
    distractorEvents = eventData(eventData(:,distractorEventIndex) == 1,1);
    %Extract the list of frames when the event file notes a target. The
    %second column is a flag indicating that these are all targets.
    targetEvents = eventData(eventData(:,distractorEventIndex) == 0,1);
    
    %import target event wavelength 1 data
    [frames, channels] = size(waveLength1Top);
    svmData = zeros(frames, 2*channels+1);
    
    svmData(:, 1:channels) = waveLength1;
    svmData(:, channels+1:2*channels) = waveLength2;
  
    %the last column of svmData carries the labels for each frame. Label
    %the frame 1 if it lies between a distractor event and the end of
    %traceLength from that event
    
    %we need to batch the frames and flag the batches.
    
    % The second column is a flag indicating that these are all distractors. 
    targetWindows = ones(length(targetEvents), 2);
    targetWindows(:,1) = getWindows(targetEvents, traceLength);
    distractorWindows = zeros(length(distractorEvents), 2);
    distractorWindows (:,1) = getWindows(distractorEvents, traceLength);
    
    %%% STOPPED HERE. NEED TO CONCATENATE targetWindows and
    %%% distractorWindows and sort them according to the frames, but sort
    %%% the column of flags next to them along with the frames so that each
    %%% frame retains its label.
    windows = sort(cat(1, targetWindows, distractorWindows));
    
    svmWindowData = svmData(windows,:);
    batchData = reshape(svmWindowData, length(targetWindows)+length(distractorWindows), []);
    
    batches = length(targetEvents)+length(distractorEvents);
    
    
    noFlagData = svmData(:, 1:2*channels);
    flags = boolean(svmData(:, 2*channels+1));