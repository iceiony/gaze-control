function [ phi] = estimateBeliefPoints(scene,landmarks,particles,mu,sigma )
    beliefState = zeros(3,length(landmarks));
    
    for i=1:length(landmarks)
        eigenValues = eig(cov(particles(i).positions)).^(1/2) ./ [scene.height;scene.width;] ;
        
        eigenValues = eigenValues*3;
%         
%         eigenValues(1) = min(eigenValues(1),1);
%         eigenValues(2) = min(eigenValues(2),1);
%         
        beliefState(:,i) = [eigenValues' landmarks(i).value];
    end
    
%     disp(beliefState');
    
    phi = zeros(1,size(mu,1));
    for i=1:size(mu,1)
        distance = sum((beliefState(:)' - mu(i,:)).^2);
        phi(i) = exp( -distance / (2*sigma(i)^2) );
    end

end

