% Version 1.000
%
% Code provided by Ruslan Salakhutdinov and Geoff Hinton  
%
% Permission is granted for anyone to copy, use, modify, or distribute this
% program and accompanying programs and documents for any purpose, provided
% this copyright notice is retained and prominently displayed, along with
% a note saying that the original programs are available from our 
% web page. 
% The programs and documents are distributed without any warranty, express or
% implied.  As the programs were written for research purposes only, they have
% not been tested to the degree that would be advisable in any important
% application.  All use of these programs is entirely at the user's own risk.


% This program pretrains a deep autoencoder for MNIST dataset
% You can set the maximum number of epochs for pretraining each layer
% and you can set the architecture of the multilayer net.

trainX = transpose(trainX);
trainY = transpose(trainY);
testX = transpose(testX);
testY = transpose(testY);

% FUNCTION THAT TO INSERT INTO LAYERS

[numcases numdims numbatches]=size(trainX);

close all

maxepoch=20; 
numhid=50; 
numpen=5; 
numpen2=20; 

fprintf(1,'Pretraining Layer 1 with RBM: %d-%d \n',226,50);
;
hidrecbiases=hidbiases; 
save mnistvhclassify vishid hidrecbiases visbiases;

% COMBINE RBM + SM + CLSF

layers = [
    % insert rbm function here
    rbm
    softmaxlayer
    classificationLayer];

