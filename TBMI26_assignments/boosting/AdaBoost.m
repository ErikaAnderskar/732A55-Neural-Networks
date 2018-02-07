% Load face and non-face data and plot a few examples
load faces;
load nonfaces;
faces = double(faces);
nonfaces = double(nonfaces);

figure(1);
colormap gray;
for k=1:25
    subplot(5,5,k), imagesc(faces(:,:,10*k));
    axis image;
    axis off;
end

figure(2);
colormap gray;
for k=1:25
    subplot(5,5,k), imagesc(nonfaces(:,:,10*k));
    axis image;
    axis off;
end

% Generate Haar feature masks
nbrHaarFeatures = 25;
haarFeatureMasks = GenerateHaarFeatureMasks(nbrHaarFeatures);

figure(3);
colormap gray;
for k = 1:25
    subplot(5,5,k),imagesc(haarFeatureMasks(:,:,k),[-1 2]);
    axis image;
    axis off;
end

%%
% Create a training data set with a number of training data examples
% from each class. Non-faces = class label y=-1, faces = class label y=1
nbrTrainExamples = 50;
trainImages = cat(3,faces(:,:,1:nbrTrainExamples),nonfaces(:,:,1:nbrTrainExamples));
xTrain = ExtractHaarFeatures(trainImages,haarFeatureMasks);
yTrain = [ones(1,nbrTrainExamples), -ones(1,nbrTrainExamples)];

%% Implement the AdaBoost training here
%  Use your implementation of WeakClassifier and WeakClassifierError

numIt = 20; %Number of iterations in training

%initilizeing 
train_error = ones(numIt,1);
D = ones(size(xTrain,1),length(xTrain));
res = ones(size(xTrain,1),length(xTrain));
alpha_mat = ones(25,1);

for i = 1:numIt


for row = 1:size(xTrain,1)
 
   
    X = xTrain(row,:);
    Y = yTrain;

    inc = ceil((max(X)-min(X))/1000);
    mini = min(X);
    maxi = max(X);

    Threshold = mini:inc:maxi;
    temp =[];
    n = 0;
    for T=Threshold
        P = 1;
        n=n+1;
        
        
        C = WeakClassifier(X, T, P);
        E = WeakClassifierError(C, D(row,:), Y);
    
        if E >= 0.5
            P = -1;
            C = WeakClassifier(X, T, P);
            E = WeakClassifierError(C, D(row,:), Y);
        end
        temp(n) = E;

    end
    
    [M,I] = min(temp(1));
    T = Threshold(I);
    h_x = WeakClassifier(X, T, P);
    E = WeakClassifierError(h_x, D, Y);
     if E >= 0.5
            P = -1;
            h_x = WeakClassifier(X, T, P);
            E = WeakClassifierError(h_x, D, Y);
        end
   %adaboost
   alpha = 1/2*log((1-E)/E);
    D(row,:) =  D(row,:).*exp(-alpha.*(Y.*h_x)); % update weights
    D(row,:)=D(row,:)/sum(D(row,:)); %normalizzze
    alpha_mat(row) = alpha;
    res(row,:) = h_x;
end



slutres = sum(alpha_mat.*res, 1);
slutres_sign = sign(slutres);
train_error(i) = sum((slutres_sign~=Y))/100;
end

%% Extract test data

nbrTestExamples = 5;

testImages  = cat(3,faces(:,:,(nbrTrainExamples+1):(nbrTrainExamples+nbrTestExamples)),...
                    nonfaces(:,:,(nbrTrainExamples+1):(nbrTrainExamples+nbrTestExamples)));
xTest = ExtractHaarFeatures(testImages,haarFeatureMasks);
yTest = [ones(1,nbrTestExamples), -ones(1,nbrTestExamples)];

%% Evaluate your strong classifier here
%  You can evaluate on the training data if you want, but you CANNOT use
%  this as a performance metric since it is biased. You MUST use the test
%  data to truly evaluate the strong classifier.



%% Plot the error of the strong classifier as  function of the number of weak classifiers.
%  Note: you can find this error without re-training with a different
%  number of weak classifiers.


