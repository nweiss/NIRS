%Use an SVM to analyze the raw NIRStar data

traceLength = 100;
[svmData, noFlagData, flags] = svmFormat('C:\Users\Jake\Desktop\nirsbcidata\2014-09-29_016\NIRS-2014-09-29_016', traceLength);
[frames, columns] = size(svmData);
channels = (columns-1)/2; %channels is calculated both in the script and in the function. Must be better way.

predictingData = noFlagData(round(frames/2)+1:frames,:);
[predictedFlags, Score] = predict(SVMModel, predictingData);
actualFlags = flags(round(frames/2)+1:frames);

correct(predictedFlags == actualFlags) = 1;
percentCorrect = sum(correct)/length(predictedFlags);
nPredictedTargets = sum(predictedFlags);

%in solutionsTable, the first column is the actual flags, the second column
%is the predicted flags, and the third column is a flag indicating whether
%or not the computer was correct.
solutionsTable = zeroes(length(predictedFlags), 3);
solutionsTable(:,1) = 