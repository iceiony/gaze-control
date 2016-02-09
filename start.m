
scene = initialise();

landmarks = generateLandmarks(scene,2);
drawLandmarks(landmarks);

particles = generateParticles(scene,landmarks,400);
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
    
    particles = updateParticleFilter(particles,landmarks,fix);
    
    %show new particles
    for i=1:length(particlePlots)
        delete(particlePlots(i).particles);
        delete(particlePlots(i).gaussian);
    end
    particlePlots = drawParticles(particles);
end
