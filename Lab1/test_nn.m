% Caclulate the number of weights
nr_w = length(Xt(1,:)) +1;

%weights
W0 = rand(2,nr_w);



%nn
X = Xt{1};



X_tr = transpose( [ones(length(X),1),transpose(X)] );


pred = W0 * X_tr;




%%%%%%%%%%%%%%
X = Xtraining;
W = W0;

Y = tanh(W * X);


% Calculate classified labels
[~, L] = max(Y,[],1);
L = L(:);


%%
trainingError = nan(numIterations+1,1);
testError = nan(numIterations+1,1);
Yt = Y;
Y_true = Dt{1};
Wout = W0;
Dtest = Dt{2};
Nt = size(Xt,2);
Ntest = size(Xtest,2);
learningRate = 0.005;
%%

Xt = Xtraining;
Y = Wout*Xt;


for n = 1:numIterations
    Y = Wout*Xt;
    
    grad_w =  2 * sum((tanh(Y) - Y_true) * transpose(tanhprim(Y)) * Xt(2:3, :), 2);
    
    Wout = Wout - learningRate*grad_w;
    trainingError(1+n) = sum(sum((Wout*Xt - Y_true).^2))/Nt;
    %testError(1+n) = sum(sum((Wout*Xtest - Dtest).^2))/Ntest;
end

%%

%ask about our runSingleLayer()

grad_w
Wout

%%


