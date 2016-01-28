clear all;
close all;

scene = initialise();

for i = 1:2
    landmarks(i) =   generateLandmark(scene);
end

drawLandmarks(landmarks);

pcol = cat(1,landmarks.colour) + repmat([0.2 0.5 0.2],length(landmarks),1);
pcol(find(pcol>1)) = 1;

%generate uniform particle filter for each landmark
particles = rand([length(landmarks),1000,2]);
for i=1:length(landmarks)
particles(i,:,1) = round(particles(i,:,1)*scene.width);
particles(i,:,2) = round(particles(i,:,2)*scene.height);
particlePlot(i) = plot(particles(i,:,1),particles(i,:,2),'o','markersize',4,'color',pcol(i,:));
end

%make a fixation and update each particle filter 
%with the new observations
SENSE_NOISE = [100 100];


for t=1:5
    
    %fixate in the middle of all particle sets
    meanX = mean(mean(particles(:,:,1)));
    meanY = mean(mean(particles(:,:,2)));
    
    fix = [meanX meanY];    
    
    if exist('obs') 
        delete(obs);
    end
    
    obs = plot(fix(1),fix(2),'.g','markersize',20);
    pause(1);
    
    
    for i=1:length(landmarks);
        p = squeeze(particles(i,:,:));
        %calculate the distance from the actual landmark
        measure = [landmarks(i).x - fix(1) landmarks(i).y - fix(2)];
         
        %calculate the probability of each particle
        prob = zeros(length(p),1);
        for j=1:length(p)
            noise = (rand(1,2) .* SENSE_NOISE) - SENSE_NOISE/2;
            estimate = p(j,:) - fix + noise;            
            prob(j) = mvnpdf(measure,estimate,SENSE_NOISE);
        end
        
        weights = prob ./ sum(prob);
        
        %resample
        newParticles = zeros(length(p),2);
        for j=1:length(p);
            newParticles(j,:) = p(find(rand <= cumsum(weights),1),:);
        end
        particles(i,:,:) = newParticles;
        
        %show new particles
        delete(particlePlot(i));
        particlePlot(i) = plot(particles(i,:,1),particles(i,:,2),'o','markersize',4,'color',pcol(i,:));
    end 
end
