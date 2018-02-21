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
nbrHaarFeatures = 700;
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
nbrTrainExamples = 1000;
trainImages = cat(3,faces(:,:,1:nbrTrainExamples),nonfaces(:,:,1:nbrTrainExamples));
xTrain = ExtractHaarFeatures(trainImages,haarFeatureMasks);
yTrain = [ones(1,nbrTrainExamples), -ones(1,nbrTrainExamples)];

%% Implement the AdaBoost training here
%  Use your implementation of WeakClassifier and WeakClassifierError

%initilizeing 
D = 1/length(xTrain) *ones(size(xTrain,1),size(xTrain,2)); %weight matr
res = ones(size(xTrain,1), size(xTrain,2)); %the end matrix wtith alpha*h_x
alpha_mat = ones(size(xTrain,1),1); %store alphas
h_x_matr = ones(size(xTrain,1),size(xTrain,2)); %store h_x values
Threshold_matr = ones(size(xTrain,1),1); %save the thresholds


for row=1:size(xTrain,1)


X = xTrain(row,:); %take out the haar feature
Y = yTrain;

inc = ceil((max(X)-min(X))/100);
mini = min(X);
maxi = max(X);

Threshold = mini:inc:maxi; %testing different tau

temp =[];
%find h(x)_t
n = 0;
for T=Threshold
        P = 1;
        n=n+1;
        
        C = WeakClassifier(X, T, P);
        E = WeakClassifierError(C, D(row,:), Y);
    
        if E > 0.5
            P = -1;
            C = WeakClassifier(X, T, P);
            E = WeakClassifierError(C, D(row,:), Y);
            temp(n) = E;
        else
           temp(n) = E;
        end
       %E = min(E,1-E);
        %temp(n) = E;

end
[M,I] = min(temp);
T = Threshold(I); %optimal threshold
Threshold_matr(row, :) = T;

h_x = WeakClassifier(X, T, P);
E_t = WeakClassifierError(h_x, D(1,:), Y);
h_x_matr(row,:) = h_x;

alpha = 1/2*log((1-E_t)/E_t);
alpha_mat(row, :) = alpha;

D(row,:) =  D(row,:).*exp(-alpha.*(Y.*h_x)); %update weights
D(row,:)=D(row,:)/sum(D(row,:)); %nomalize weights

end

%final classificiation
for i=1:row
    res(i, :) = alpha_mat(i,:) * h_x_matr(i, :); 
end
pred = sum(res, 1);
pred = sign(pred);

sum(Y ~= pred)/length(pred) %error


%%
C = (P*X >= P*T)*2-1
E = WeakClassifierError(C, D(25,:), Y)



%% Extract test data

nbrTestExamples = 100;

testImages  = cat(3,faces(:,:,(nbrTrainExamples+1):(nbrTrainExamples+nbrTestExamples)),...
                    nonfaces(:,:,(nbrTrainExamples+1):(nbrTrainExamples+nbrTestExamples)));
xTest = ExtractHaarFeatures(testImages,haarFeatureMasks);
yTest = [ones(1,nbrTestExamples), -ones(1,nbrTestExamples)];

%% Evaluate your strong classifier here
%  You can evaluate on the training data if you want, but you CANNOT use
%  this as a performance metric since it is biased. You MUST use the test
%  data to truly evaluate the strong classifier.

for test=1:length(Threshold_matr)

    X_tst = xTest(test,:);
    Y_tst = yTest;
    
    h_x_test = WeakClassifier(X_tst, T, P); %REMEMBER TO SAVE POLARTITIESSSSSS
    
    
end



WeakClassifier(X, T, P)


Threshold_matr


%% Plot the error of the strong classifier as  function of the number of weak classifiers.
%  Note: you can find this error without re-training with a different
%  number of weak classifiers.


