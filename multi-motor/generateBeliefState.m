function [beliefStates] = generateBeliefState(scene,landmarks,particles)
%% returns the blief state for all landmarks as a combined multi dimensional vector
%% the first element is set to 1 for the bais unit
    beliefStates = zeros(3,length(landmarks));
    
    for i=1:length(landmarks)
        eigenValues = eig(cov(particles(i).positions)).^(1/2) ./ [scene.height;scene.width;] ;
        
        eigenValues = eigenValues*4;
        
        beliefStates(:,i) = [eigenValues' landmarks(i).value];
    end
    
    beliefStates = [1 beliefStates(:)'];
end