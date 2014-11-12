%Use an SVM to analyze the raw NIRStar data

traceLength = 100;
[svmData, noFlagData, flags] = svmFormat('C:\Users\Jake\Desktop\nirsbcidata\2014-09-29_016\NIRS-2014-09-29_016', traceLength);
[frames, columns] = size(svmData);
channels = (columns-1)/2; %channels is calculated both in the script and in the function. Must be better way.

%SVMModel = fitcsvm(noFlagData, flags, 'KernelFunction', 'rbf', 'Standardize', true);
trainingData = noFlagData(1:round(frames/2),:);
trainingFlagData = flags(1:round(frames/2));
SVMModel = fitcsvm(trainingData, trainingFlagData, 'KernelFunction', 'rbf');