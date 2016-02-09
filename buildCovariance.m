function [covariance] = buildCovariance(estimate)
%returns a rotated covariance matrix for the given x,y estimate
%the rotation makes the gaussian point to the observation
    dist = sqrt(sum(estimate.^2));
    x = abs(estimate(1));
    y = abs(estimate(2));
    
    angle = asin(y / dist);
    
    r = [cos(angle) -sin(angle)  
         sin(angle) cos(angle) ];
     
    covariance = r * [x   0 
                      0   y] * r';
end