%% This script will help you test out your kNN code

%% Select which data to use:

% 1 = dot cloud 1
% 2 = dot cloud 2Change this to load new data 

% 3 = dot cloud 3
% 4 = OCR data

dataSetNr = 4; % 
[X, D, L] = loadDataSet( dataSetNr );

% You can plot and study dataset 1 to 3 by running:
plotCase(X,D)
%% Select a subset of the training features


numBins = 3; % Number of Bins you want to devide your data into
numSamplesPerLabelPerBin = 100; % Number of samples per label per bin, set to inf for max number (total number is numLabels*numSamplesPerBin)
selectAtRandom = true; % true = select features at random, false = select the first features

[ Xt, Dt, Lt ] = selectTrainingSamples(X, D, L, numSamplesPerLabelPerBin, numBins, selectAtRandom );

% Note: Xt, Dt, Lt will be cell arrays, to extract a bin from them use i.e.
XBin1 = Xt{1};
XBin2 = Xt{2};
XBin3 = Xt{3};
%% Use kNN to classify data
% Note: you have to modify the kNN() function yourselfs.

% Set the number of neighbors
k = 3;

LkNN = kNN(Xt{2}, k, Xt{1}, Lt{1});

%% Calculate The Confusion Matrix and the Accuracy
% Note: you have to modify the calcConfusionMatrix() function yourselfs.

% The confucionMatrix
cM = calcConfusionMatrix(LkNN', Lt{2});

% The accuracy
acc = calcAccuracy(cM)


%% Cross-validation to find optimal k

%Create an empty list to store accuracys for different k-values
list_of_k = [];
%Creates a matrix with indices to be used to loop train/test folds
fold = [2 1; 3 2;1 3]


for index = 1:10 %loops over possible k-values (1:10)
    acc = []; %Create a empty list to store accuracys for the current k 
    for j = 1:3  
        m = fold(j,1); %index for train set
        n = fold(j,2); %index for test set
        LkNN = kNN(Xt{m}, index, Xt{n}, Lt{n}); % Calculate the KNN
        cM = calcConfusionMatrix(LkNN', Lt{m}); %Calculate the confusion matrix
        acc(j) = calcAccuracy(cM); %store the current accuracy
    end
    list_of_k(index) = mean(acc); % The average of the accuracy values for the current k value is stores
    
end

[M,I]=max(list_of_k);

%Väljer den optimala k är indexet för den maximala accuracyn
optimal_k = I;

k = optimal_k

%%
LkNN = kNN(Xt{2}, k, Xt{1}, Lt{1});


% The confucionMatrix
cM = calcConfusionMatrix(LkNN', Lt{2})

% The accuracy
acc = calcAccuracy(cM)


%% Plot classifications
% Note: You do not need to change this code.
if dataSetNr < 4
    plotkNNResultDots(Xt{2},LkNN',k,Lt{2},Xt{1},Lt{1});
else
    plotResultsOCR( Xt{2}, Lt{2}, LkNN' )
end
