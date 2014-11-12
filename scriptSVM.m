%Trains an SVM from the first half of a data set. Then predicts the flags
%on the second half of the data set. Produces a table called solutionsTable
%containing the predicted answers, actual answers and correctness of each
%prediction

traceLength = 30; %114 worked best for the file from the 16th, and 120 worked best for the 19th

[noFlagData, flags] = svmFormat('C:\Users\Jake\Desktop\nirsbcidata\2014-09-29_019\NIRS-2014-09-29_019', traceLength);
[frames, columns] = size(noFlagData);
channels = columns/2;

%Training
trainingData = noFlagData(1:round(frames/2),:);
trainingFlagData = flags(1:round(frames/2));
SVMModel = fitcsvm(trainingData, trainingFlagData, 'KernelFunction', 'rbf');

%Predicting
predictingData = noFlagData(round(frames/2)+1:frames,:);
[predictedFlags, Score] = predict(SVMModel, predictingData);

actualFlags = flags(round(frames/2)+1:frames);

%solutionsTable has 3 columns: 1) predicted answers 2) actual answers and 3)
%correctness. Each row is a different frame.
solutionsTable = zeros(length(predictedFlags), 3);
solutionsTable(:,1) = predictedFlags;
solutionsTable(:,2) = actualFlags;
solutionsTable(:,3) = solutionsTable(:,1)==solutionsTable(:,2);

nPredictedTargets = sum(predictedFlags);
percentCorrect = sum(solutionsTable(:,3))/length(predictedFlags);

fprintf('Number of frames to be predicted: %f\n', length(predictedFlags))
fprintf('Number of actual targets: %f\n', sum(actualFlags))
fprintf('Number of frames predicted to be targets: %f\n', nPredictedTargets)
fprintf('Percentage of frames correctly predicted: %f\n', percentCorrect)