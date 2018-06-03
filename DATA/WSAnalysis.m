outputsRbm = transpose(negdata);

for m = 1:18
    outputsRbmDat = horzcat(outputsRbm, masterY(:,m));
    shuffledOutputsRbm = outputsRbmDat(randperm(size(outputsRbmDat,1)),:);
    
    X = shuffledOutputsRbm(:,end-1);
    Y = shuffledOutputsRbm(:,end);
    
    trainX = outputsRbm([1:37],:);
    testX = outputsRbm([38:end],:);
    
    trainY = Y([1:37],:);
    testY = Y([38:end],:);
    
    sampleModel = fitcsvm(trainX, trainY);
    labels = predict(sampleModel, testX);
    overallError = loss(sampleModel, testX, testY);
    
    fprintf (1, '%6.1f  \n', overallError);
end
