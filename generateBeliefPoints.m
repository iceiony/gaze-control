function [mu,sigma] = generateBeliefPoints(pointsCount, landmarkCount)
    %take random values to partition possible the space of possible values
    beliefSpace = rand(20^landmarkCount * 40,3 * landmarkCount)*1.2;
    
    [idx,mu,~,d] = kmeans(beliefSpace,pointsCount);
    
    sigma = var(d);
end