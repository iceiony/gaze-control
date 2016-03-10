function [beliefState] = generateBeliefState(scene,landmarks,particles)
    beliefState = zeros(3,length(landmarks));
    
    for i=1:length(landmarks)
        eigenValues = eig(cov(particles(i).positions)).^(1/2) ./ [scene.height;scene.width;] ;
        
        eigenValues = eigenValues*4;
        
        beliefState(:,i) = [eigenValues' landmarks(i).value];
    end
    
    beliefState = beliefState(:)';
end