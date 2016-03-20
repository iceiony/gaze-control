function [mu,sigma] = generateBeliefPoints(pointsCount, dimSize )
    %take random values to partition possible the space of possible values
    beliefSpace = rand(20^(dimSize/3) * 10, dimSize )*2 - .5;
    
    [idx,mu,~,d] = kmeans(beliefSpace,pointsCount);
    
    sigma = ones(size(d))* 0.25;
end