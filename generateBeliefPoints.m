function [mu,sigma] = generateBeliefPoints(pointsCount, landmarkCount)
    %take random values to partition possible the space of possible values
    beliefSpace = rand(20^landmarkCount * 80,3 * landmarkCount);
    
    [idx,mu,~,d] = kmeans(beliefSpace,pointsCount);
    
    sigma = var(d);
end