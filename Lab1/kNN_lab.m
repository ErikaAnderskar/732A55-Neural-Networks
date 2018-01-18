function [ labelsOut ] = kNN(X, k, Xt, Lt)

matr = ones(1000, 1000);

k = k;

pred_labels = [];
for i = 1:1000
    dist = sqrt(sum(Xt - X(:,i)) .^2); %eucledian
    matr(i, :) = dist;
    [M, I] = sort(matr(i, :));
    ind = I(1:k); %taking out the lables of the minimum distance
    
    %because we have sorted the distances, the smallest distance wil be first
    %mode() will take the first value if labels 1 and 2 are the same amount
    label = mode(Lt(ind)); %classified label
    pred_labels(i) = label;
end

labelsOut  = pred_labels;

end

