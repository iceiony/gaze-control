function [mu,sigma] = generateBeliefPoints(pointsCount, landmarkCount)
    precission = 0:0.05:1;
    tollerant = 0:0.1:1;
    [x,y,z] = ndgrid(precission ,precission ,tollerant);
    
    beliefSpace = repmat([x(:) y(:) z(:)],1,landmarkCount);
    
    [idx,mu,~,d] = kmeans(beliefSpace,pointsCount);
    
    sigma = var(d).^-9;
end