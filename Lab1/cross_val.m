%function [ accur ] = k_fold(fold, data_train, data_target)

fold = 3;
data_train = X1;
data_target = Xt1;

numBins = 3; % Number of Bins you want to devide your data into
% Number of samples per label per bin, set to inf for max number (total number is numLabels*numSamplesPerBin)
numSamplesPerLabelPerBin = inf; 
selectAtRandom = true; % true = select features at random, false = select the first features

[ Xt, Dt, Lt ] = selectTrainingSamples(X, D, L, numSamplesPerLabelPerBin, numBins, selectAtRandom );


Xt{2}