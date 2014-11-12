%takes an array, indicesStart, and a traceLength, and returns a matrix 
%containing the elements of indicesStart through indicesStart+traceLength.

%For Example a = [3 17 42], traceLength = 2 will return
% windows = [3, 4, 17, 18, 42, 43]

function windows = getWindows(indicesStart, traceLength)

tempOnes = ones(length(indicesStart), traceLength);
tempOnes(:,1) = indicesStart;
indicesMat = cumsum(tempOnes,2);
windows = reshape(indicesMat, numel(indicesMat), 1);
windows = sort(windows);

%windowIndices = reshape(indicesMat', [1, numel(indicesMat)]);
%windows = matrix(windowIndices);