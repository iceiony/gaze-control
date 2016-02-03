
scene = initialise();

landmarks = generateLandmarks(scene,2);
drawLandmarks(landmarks);

particles = generateParticles(scene,landmarks,400);


OBSERVATION_NOISE = [40 40];
PARTICLE_NOISE = [50 50];

particles = addNoise(particles,PARTICLE_NOISE);
particlePlots = drawParticles(particles);

for t=1:20
    %fixate in the middle of all particle sets
%     fix = mean(cat(1,particles.positions));
    fix = ginput(1);
    
    if exist('obs') 
        delete(obs);
    end
    
    obs = plot(fix(1),fix(2),'.g','markersize',20);
    pause(1);
    
    
    for i=1:length(landmarks);
        p = particles(i).positions;
        
        %calculate the relative position to the landmark 
        measure = [landmarks(i).x - fix(1) landmarks(i).y - fix(2)];
        measure = mvnrnd(measure,OBSERVATION_NOISE);
         
        %calculate the probability of each particle
        prob = zeros(length(p),1);
        for j=1:length(p)
            estimate = p(j,:) - fix;      
            
            prob(j) = mvnpdf(measure, estimate, abs(estimate)*5);
        end
        
        weights = prob ./ sum(prob);
        
        %resample
        newPositions = zeros(length(p),2);
        for j=1:length(p);
            newPositions(j,:) = p(find(rand <= cumsum(weights),1),:);
        end
        particles(i).positions = newPositions;
        
        particles(i) = addNoise(particles(i),PARTICLE_NOISE);
        
        %show new particles
        delete(particlePlots(i).particles);
        delete(particlePlots(i).gaussian);
        particlePlots(i) = drawParticles(particles(i));
    end 
end
