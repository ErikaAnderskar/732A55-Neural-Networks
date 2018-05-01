function [ Y, L, H_one ] = runMultiLayer( X, W, V )

H = tanh(W*X);
H_one = [ones(1,length(H)) ; H];

Y = V * H_one; %output for training

Y2 = tanh(V * H_one); %for prediction

% Calculate classified labels
[~, L] = max(Y2,[],1);
L = L(:);

end

