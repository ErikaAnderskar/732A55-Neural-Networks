function [Wout, trainingError, testError ] = trainSingleLayer(Xt,Dt,Xtest,Dtest, W0,numIterations, learningRate )

% Initiate variables
trainingError = nan(numIterations+1,1);
testError = nan(numIterations+1,1);
Nt = size(Xt,2);
Ntest = size(Xtest,2);
Wout = W0;

% Calculate initial error
Yt = runSingleLayer(Xt, W0);
Ytest = runSingleLayer(Xtest, W0);
trainingError(1) = sum(sum((Yt - Dt).^2))/Nt;
testError(1) = sum(sum((Ytest - Dtest).^2))/Ntest;

for n = 1:numIterations
    Y = Wout*Xt;
    
    %gradient
    grad_w =  (-2 * (tanh(Y) - Dt) .* tanhprim(Y) * Xt')/Nt;
    
    
    Wout = Wout - learningRate*grad_w;
    trainingError(1+n) = sum(sum((Wout*Xt - Dt).^2))/Nt;
    testError(1+n) = sum(sum((Wout*Xtest - Dtest).^2))/Ntest;
end
end

