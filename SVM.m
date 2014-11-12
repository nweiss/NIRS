% trains SVM on the first half of data set and uses it to predict the
% values on the second half of the data set

function [nPredictedTargets, percentCorrect, predictedFlags, solutionsTable] = SVM(dataFileBaseName, traceLength)


[noFlagData, flags] = svmFormat(dataFileBaseName, traceLength);
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
nPredictedTargets = sum(predictedFlags);
fprintf('Number of frames to be predicted: %f\n', length(predictedFlags))
fprintf('Number of actual targets: %f\n', sum(actualFlags))
fprintf('Number of frames predicted to be targets: %f\n', nPredictedTargets)
correct(predictedFlags == actualFlags) = 1;
percentCorrect = sum(correct)/length(predictedFlags);
fprintf('Percentage of frames correctly predicted: %f', percentCorrect)

