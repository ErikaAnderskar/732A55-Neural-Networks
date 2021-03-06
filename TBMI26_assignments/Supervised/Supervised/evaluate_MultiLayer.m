%% This script will help you test out your single layer neural network code

%% Select which data to use:

% 1 = dot cloud 1
% 2 = dot cloud 2
% 3 = dot cloud 3
% 4 = OCR data

dataSetNr = 3; % Change this to load new data 

[X, D, L] = loadDataSet( dataSetNr );

%% Select a subset of the training features

numBins = 2; % Number of Bins you want to devide your data into
numSamplesPerLabelPerBin = 50; % Number of samples per label per bin, set to inf for max number (total number is numLabels*numSamplesPerBin)
selectAtRandom = true; % true = select features at random, false = select the first features

[ Xt, Dt, Lt ] = selectTrainingSamples(X, D, L, numSamplesPerLabelPerBin, numBins, selectAtRandom );

% Note: Xt, Dt, Lt will be cell arrays, to extract a bin from them use i.e.
XBin1 = Xt{1};
%% Modify the X Matrices so that a bias is added

% The Training Data
h = ones(1,length(XBin1));
Xtraining = [h; XBin1];

% The Test Data
a = ones(1,length(Xt{2}));
Xtest = [a; Xt{2}];


%% Train your single layer network
% Note: You nned to modify trainSingleLayer() in order to train the network
%rng(1234);
numHidden = 50; % Change this, Number of hidde neurons 
numIterations = 5000; % Change this, Numner of iterations (Epochs)
learningRate = 0.01; % Change this, Your learningrate
W0 = unifrnd(-0.1, 0.1*ones(numHidden ,size(Xtraining,1))); % Change this, Initiate your weight matrix W
V0 = unifrnd(-0.1, 0.1*ones(size(Dt{1}, 1) , numHidden +1)); % Change this, Initiate your weight matrix V
%W0(:, 1) = abs(W0(:, 1)); %Positive biases
%V0(:, 1) = abs(V0(:, 1)); %Positive biases

%%
tic
[W,V, trainingError, testError ] = trainMultiLayer(Xtraining,Dt{1},Xtest,Dt{2}, W0,V0,numIterations, learningRate );
trainingTime = toc;
% Plot errors
figure(1101)
clf
[mErr, mErrInd] = min(testError);
plot(trainingError,'k','linewidth',1.5)
hold on
plot(testError,'r','linewidth',1.5)
plot(mErrInd,mErr,'bo','linewidth',1.5)
hold off
title('Training and Test Errors, Multi-Layer')
legend('Training Error','Test Error','Min Test Error')

%% Calculate The Confusion Matrix and the Accuracy of the Evaluation Data
% Note: you have to modify the calcConfusionMatrix() function yourselfs.

[ Y, LMultiLayerTraining ] = runMultiLayer(Xtraining, W, V);
tic
[ Y, LMultiLayerTest ] = runMultiLayer(Xtest, W,V);
classificationTime = toc/length(Xtest);
% The confucionMatrix
cM = calcConfusionMatrix( LMultiLayerTest, Lt{2});
cM2 = calcConfusionMatrix( LMultiLayerTraining, Lt{2});
% The accuracy
acc = calcAccuracy(cM);
acc2 = calcAccuracy(cM2)



display(['Time spent training: ' num2str(trainingTime) ' sec'])
display(['Time spent calssifying 1 feature vector: ' num2str(classificationTime) ' sec'])
display(['Accuracy: ' num2str(acc)])

%% Plot classifications
% Note: You do not need to change this code.

if dataSetNr < 4
    plotResultMultiLayer(W,V,Xtraining,Lt{1},LMultiLayerTraining,Xtest,Lt{2},LMultiLayerTest)
else
    plotResultsOCR( Xtest, Lt{2}, LMultiLayerTest )
end
