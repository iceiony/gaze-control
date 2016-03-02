function [covariance] = buildCovariance(estimate)
%returns a rotated covariance matrix for the given x,y estimate
%the rotation makes the gaussian point to the observation
    dist = sqrt(sum(estimate.^2));
    x = estimate(1);
    y = estimate(2);

%     covariance = [ abs(x) 0 
%                     0     abs(y)];
    angle = asin(y / dist);
    
    r = [cos(angle) -sin(angle)  
         sin(angle) cos(angle) ];
     
    covariance = r * [abs(x)   0 
                      0        abs(y)] * r';
end