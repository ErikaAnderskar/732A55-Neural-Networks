function [Wout,Vout, trainingError, testError ] = trainMultiLayer(Xtraining,Dtraining,Xtest,Dtest, W0, V0,numIterations, learningRate )

% Initiate variables
trainingError = nan(numIterations+1,1);
testError = nan(numIterations+1,1);
numTraining = size(Xtraining,2);
numTest = size(Xtest,2);
numClasses = size(Dtraining,1) - 1;
Wout = W0;
Vout = V0;

% Calculate initial error
Ytraining = runMultiLayer(Xtraining, W0, V0);
Ytest = runMultiLayer(Xtest, W0, V0);
trainingError(1) = sum(sum((Ytraining - Dtraining).^2))/(numTraining*numClasses);
testError(1) = sum(sum((Ytest - Dtest).^2))/(numTest*numClasses);

for n = 1:numIterations
    [Y, L , H_one] = runMultiLayer(Xtraining, Wout, Vout);

    grad_v = 2/numTraining * ((tanh(Y) - Dtraining) .* tanhprim(Y)) * H_one'; %Gradient for the output layer
    grad_w = 2/numTraining * (Vout(:, 2:end)' * ((tanh(Y) - Dtraining) .* tanhprim(Vout * H_one)) .* tanhprim(Wout * Xtraining) * Xtraining'); %Gradient for the hidden layer.



    Wout = Wout - learningRate * grad_w; %Take the learning step.
    Vout = Vout - learningRate * grad_v; %Take the learning step.

    Ytraining = runMultiLayer(Xtraining, Wout, Vout);
    Ytest = runMultiLayer(Xtest, Wout, Vout);

    trainingError(1+n) = sum(sum((tanh(Y) - Dtraining).^2))/(numTraining*numClasses);
    testError(1+n) = sum(sum((tanh(Ytest) - Dtest).^2))/(numTest*numClasses);
    
end

end
