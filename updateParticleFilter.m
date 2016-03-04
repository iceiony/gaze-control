function [particles] = updateParticleFilter(scene,particles,landmarks,fix)
SYSTEM_NOISE = [60 60];

    for i=1:length(landmarks);
        p = particles(i).positions;
        
        %calculate the relative position to the landmark 
        measure = [landmarks(i).x - fix(1) landmarks(i).y - fix(2)];
        
        %noise levels decrease the closer we are to the to object
        measureNoise = SYSTEM_NOISE .* abs(measure) ./ [scene.width scene.height];
        measure = mvnrnd(measure,measureNoise);
        
         
        %calculate the probability of each particle 
        %and proportional noise levels
        prob = zeros(length(p),1);
        noise = zeros(length(p),2);
        for j=1:length(p)
            estimate = p(j,:) - fix;    
                  
            sigma = buildCovariance(estimate);
            
            noise(j,:) = abs(estimate) + SYSTEM_NOISE/2;
            prob(j) = mvnpdf(measure, estimate, sigma);
        end
        
        weights = prob ./ sum(prob);
        
        %resample
        newPositions = zeros(length(p),2);
        for j=1:length(p);
            newPositions(j,:) = p(find(rand <= cumsum(weights),1),:);
        end
        particles(i).positions = newPositions;
        
        particles(i) = addNoise(particles(i),noise);
    end 
end
