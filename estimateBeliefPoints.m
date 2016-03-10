function [ phi] = estimateBeliefPoints(beliefState,mu,sigma )
    phi = zeros(1,size(mu,1));
    for i=1:size(mu,1)
        distance = sum((beliefState - mu(i,:)).^2);
        phi(i) = exp( -distance / (2*sigma(i)^2) );
    end

end

