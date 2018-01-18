function [ cM ] = calcConfusionMatrix( Lclass, Ltrue )


classes = unique(Ltrue);
numClasses = length(classes);
cM = zeros(numClasses);


for k = 1:numClasses
    for j=1:numClasses
    cM(k,j) = sum(Lclass==classes(j) & Ltrue==classes(k));
end
end




end

