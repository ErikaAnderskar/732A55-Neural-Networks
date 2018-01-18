function [ labelsOut ] = kNN(X, k, Xt, Lt)

pred_labels = [];
for i = 1:length(X)
    dist = sqrt(sum(Xt - X(:,i)) .^2); %eucledian
    %matr(i, :) = dist;
    [M, I] = sort(dist);
    inden = I(1:k); %taking out the lables of the minimum distance
    
    %because we have sorted the distances, the smallest distance wil be first
    %mode() will take the first value if labels 1 and 2 are the same amount
    label = mode(Lt(inden)); %classified label
    pred_labels(i) = label;
end

labelsOut  = pred_labels;

end
