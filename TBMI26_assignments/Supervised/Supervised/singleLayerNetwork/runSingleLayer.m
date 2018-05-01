function [ Y, L ] = runSingleLayer(X, W)
%W needs to be 2x3 matrix and X needs to be 3xn
Y = tanh(W * X);


% Calculate classified labels
[~, L] = max(Y,[],1);
L = L(:);
end

