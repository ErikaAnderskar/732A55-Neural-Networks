function [ cM ] = calcConfusionMatrix( Lclass, Ltrue )
classes = unique(Ltrue);
numClasses = length(classes);
cM = zeros(numClasses);

for len = 1:length(Ltrue)
    
    i = Ltrue(len);
    k = Lclass(len);
    
    cM(k, i) = cM(k, i) + 1;

end


end
