function [mu,sigma] = generateBeliefPoints(pointsCount, landmarkCount)
    %take random values to partition possible the space of possible values
    beliefSpace = rand(20^landmarkCount * 10,3 * landmarkCount)*1.6 - 0.3;
    
    [idx,mu,~,d] = kmeans(beliefSpace,pointsCount);
    
    sigma = ones(size(d))* 0.5;
end