function [mu,sigma] = generateGridBeliefPoints(dimSize,precission,sigma)
    if(dimSize==3)
        [x,y,z] = ndgrid(precission ,precission ,precission);
        mu = [x(:) y(:) z(:)];
    end
    
    if(dimSize==6)
        [x,y,z,a,b,c] = ndgrid(precission ,precission ,precission,precission,precission,precission);
        mu = [x(:) y(:) z(:) a(:) b(:) c(:)];
    end
    
    sigma = ones(size(mu,1),1) * sigma;
end