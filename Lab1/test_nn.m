% Caclulate the number of weights
nr_w = size(Xt, 1);

%weights
%W0 = rand(2,nr_w);



%%%%%%%%%%%%%%
X = Xtraining;
W = W0;


%Y = runSingleLayer(X, W)
Y = tanh(W * X);


% Calculate classified labels
[~, L] = max(Y,[],1);
L = L(:);


%%
numHidden = 3; % Change this, Number of hidde neurons 
numIterations = 800; % Change this, Numner of iterations (Epochs)
learningRate = 0.001; % Change this, Your learningrate
W0 = unifrnd(-1, ones(numHidden ,size(Xtraining,1))); % Change this, Initiate your weight matrix W
V0 = unifrnd(-1, ones(size(Dt{1}, 1) , numHidden +1)); % Change this, Initiate your weight matrix V
Wout = W0;
Vout = V0;
Y_true = Dt{1};
Dtest = Dt{2};
Nt = size(Xt,2);
Ntest = size(Xtest,2);
learningRate = 0.0001;
%%

Xt = Xtraining;
Y = Wout*Xt;

for n = 1:numIterations
    Y = Wout*Xt;
     
    grad_w =  (-2 * (tanh(Y) - Y_true) .* tanhprim(Y) * Xt')/Nt;
    
    Wout = Wout - learningRate*grad_w;
    trainingError(1+n) = sum(sum((Wout*Xt - Y_true).^2))/Nt;
    testError(1+n) = sum(sum((Wout*Xtest - Dtest).^2))/Ntest;
end

%%

%ask about our runSingleLayer()
Wout

%% multi layer

Xt = Xtraining;
Wout = W0;
Vout = V0;

Ytraining = runMultiLayer(Xtraining, W0, V0);
%%

for n = 1:numIterations
    [Y, L , H_one] = runMultiLayer(Xtraining, Wout, Vout);

    grad_v = -2 * (tanh(Y) - Y_true) .* tanhprim(Y) * H_one'; %Gradient for the output layer
    grad_w = V(:, 2:end)' * (Y - Y_true) .* tanhprim(Wout * Xt) * Xt'; %Gradient for the hidden layer.



    Wout = Wout - learningRate * grad_w; %Take the learning step.
    Vout = Vout - learningRate * grad_v; %Take the learning step.

    Ytraining = runMultiLayer(Xtraining, Wout, Vout);
    Ytest = runMultiLayer(Xtest, Wout, Vout);

    %trainingError(1+n) = sum(sum((Ytraining - Dtraining).^2))/(numTraining*numClasses);
    %testError(1+n) = sum(sum((Ytest - Dtest).^2))/(numTest*numClasses);
end

%%


grad_w = V(:, 2:end)' * (Ytraining - Y_true) .* tanhprim(Wout * Xt) * Xt';

H = tanh(W*Xt);
H_one = [ones(1,length(H)) ; H];

V' * tanhprim(V * H_one) ;

grad_w



%%

rng(1234)
rand(4)







