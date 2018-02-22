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
nbrHaarFeatures = 100; %här har jag ändrat
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

nr_weak = 58; %number of weak classifiers

D = 1/length(xTrain) *ones(nr_weak,size(xTrain,2)); 
save_pred = ones(nr_weak, size(xTrain,2));
alpha_matr = ones(nr_weak, 1);
optim_weak = ones(nr_weak, 2);
save_train_error = ones(1, nr_weak);


Threshold = -500:5:500;
save_temp = ones(length(Threshold), nbrHaarFeatures);


for weak=1:nr_weak
        
    
    for feat=1:nbrHaarFeatures %exctract the best feature and threshold
        
        X = xTrain(feat, :);
        Y = yTrain;
        
        n = 0;
        for T=Threshold
            P = 1;
            n=n+1;
        
            C = WeakClassifier(X, T, P);
            E = WeakClassifierError(C, D(weak,:), Y);
    
            if E >= 0.5
                P = -1;
                C = WeakClassifier(X, T, P);
                E = WeakClassifierError(C, D(weak,:), Y);
            end
            save_temp(n,feat) = E;
        end
        
    end
    
    [M, I] = min(save_temp); % best threshold pos = I

    [M2, I2] = min(M); % best feature pos = I2

    optim_T = Threshold(I(I2));
    optim_feat = xTrain(I2, :);
    
    optim_weak(weak, 1) = optim_T; %save for test
    optim_weak(weak, 2) = I2; %save for test

    C_t = WeakClassifier(optim_feat, optim_T, P);
    E_t = WeakClassifierError(C_t, D(weak,:), Y);
    
    %save_train_error(weak) =  sum(sign(C_t) ~= Y)/length(Y); %save the test error
    save_train_error(weak) =  E_t; %save the test error
    
    alpha = 1/2*log((1-E_t)/E_t);
    alpha_matr(weak,:) = alpha; %save for test

    
    D(weak+1,:) = D(weak,:).*exp(-alpha.*(Y.*C_t)); %update weights
    D(weak+1,:) = D(weak+1,:)/sum(D(weak+1,:)); %nomalize weights
    
    save_pred(weak, :) = alpha * C_t;
    
end

H_X = sign(sum(save_pred))

sum(H_X == Y)/length(Y) %accuracy

%%

CumuVel_train = zeros(1, nr_weak);  % Pre-allocation!!!
for k = 1:nr_weak;
  CumuVel_train(k) = mean(save_train_error(1:k));
end




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

%alpha_matr

final_save = ones(nr_weak, length(xTest));
save_test_error = ones(1, nr_weak);

for test=1:nr_weak
    
    T = optim_weak(test, 1);
    feat = optim_weak(test, 2);
    
    test_h_x = WeakClassifier(xTest(feat,:), T, 1);
    
    save_test_error(test) =  sum(sign(test_h_x) ~= yTest)/length(yTest); %save the test error
    
    final_save(test, :) =  (alpha_matr(test,:) * test_h_x);
end

CumuVel = zeros(1, nr_weak);  % Pre-allocation!!!
for k = 1:nr_weak;
  CumuVel(k) = mean(save_test_error(1:k));
end



PRED = sign(sum(final_save));

sum(PRED == yTest)/length(yTest)


%% Plot the error of the strong classifier as  function of the number of weak classifiers.
%  Note: you can find this error without re-training with a different
%  number of weak classifiers.

%plot(1:nr_weak, CumuVel)
plot(1:nr_weak, CumuVel_train)






