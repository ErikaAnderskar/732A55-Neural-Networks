function [ Y, L, H_one ] = runMultiLayer( X, W, V )

H = tanh(W*X);
H_one = [ones(1,length(H)) ; H];

Y = V * H_one; %output

% Calculate classified labels
[~, L] = max(Y,[],1);
L = L(:);

end

