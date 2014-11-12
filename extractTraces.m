function [targetTraces, distractorTraces] = extractTraces(dataFileBaseName, traceLength)
    
    distractorEventIndex = 7;
    Fs = 3.4722;
    passband = [.1, .5 ];
    
    [filter_b, filter_a] = butter(2, passband./Fs);
    
    eventData = load([dataFileBaseName '.evt']);
    waveLength1 = filter(filter_b, filter_a, load([dataFileBaseName '.wl1']));
    waveLength2 = filter(filter_b, filter_a, load([dataFileBaseName '.wl2']));
    figure(13);
    plot(waveLength1);
    figure(14);
    plot(waveLength2);
    
    
    %Extract the list of frames when the event file notes a distractor
    distractorEvents = eventData(eventData(:,distractorEventIndex) == 1,1);
    targetEvents = eventData(eventData(:,distractorEventIndex) == 0,1);
    startFrames = [];
    endFrames = [];
    
    targetEventsTemp = [];
    
    for i = 1:length(targetEvents) - 1
        if targetEvents(i+1,1) - targetEvents(i,1) < traceLength
            startFrames = [startFrames; targetEvents(i,1)];
            endFrames = [endFrames; targetEvents(i+1,1)];
        else
            targetEventsTemp = [targetEventsTemp; targetEvents(i,1)];            
        end    
    end

    targetEvents = targetEventsTemp;
    
    remove = [];
    for i = 1:length(startFrames)
        temp = find(distractorEvents < endFrames(i) & distractorEvents > startFrames(i));
        remove = [remove temp'];
    end
    
    distractorEvents(remove) = [];

    %Extract the target traces from both wavelength files
    targetTracesW1 = {};
    targetTracesW2 = {};
    for i = 1:length(targetEvents) - 3
%         if ~(targetEvents(i+1) - traceLength < targetEvents(i))
            targetTracesW1{end + 1} = waveLength1(targetEvents(i):targetEvents(i) + traceLength,:);
            targetTracesW2{end + 1} = waveLength2(targetEvents(i):targetEvents(i) + traceLength,:);
%         end
    end
    targetTraces = {targetTracesW1, targetTracesW2};
    
    distractorTracesW1 = {};
    distractorTracesW2 = {};    

    for i = 1:length(distractorEvents) - 3        
        distractorTracesW1{end + 1} = waveLength1(distractorEvents(i):distractorEvents(i) + traceLength,:);
        distractorTracesW2{end + 1} = waveLength2(distractorEvents(i):distractorEvents(i) + traceLength,:);
    end
    
%     while i < length(distractorEvents) - 3
% %         if 
%         distractorTracesW1{end + 1} = waveLength1(distractorEvents(i):distractorEvents(i) + traceLength,:);
%         distractorTracesW2{end + 1} = waveLength2(distractorEvents(i):distractorEvents(i) + traceLength,:);
%         i = i+1;
%     end
    
    distractorTraces = {distractorTracesW1, distractorTracesW2};        
end