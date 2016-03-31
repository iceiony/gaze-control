function [mu,sigma] = generateBeliefPoints(pointsCount, dimSize,sigma )
    %take random values to partition possible the space of possible values
    beliefSpace = rand(20^(dimSize/3) * 20, dimSize )*2 - .5;
    
    distributed = floor(pointsCount*2/3);
    [idx,mu,~,d] = kmeans(beliefSpace,distributed,'MaxIter',200);
    
    mu = [mu ; rand(pointsCount-distributed,dimSize)*2 - .5];
    
    sigma = ones(pointsCount) * sigma;
%     sigma = var(d).^(1/2) / 5; 
end