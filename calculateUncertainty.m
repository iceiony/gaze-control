function [certainty] = calculateUncertainty(particles,beliefs)
    INFLUENCE = [40 40];
    
    certainty = zeros(size(beliefs,1),1);
    for i = 1:length(certainty)
        certainty(i) = sum(mvnpdf(particles,beliefs(i,:),INFLUENCE));
    end
    
end