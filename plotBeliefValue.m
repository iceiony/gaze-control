landmarks = [];
for i = 1:LANDMARK_COUNT
    landmarks(i).x = 50*(i-1);
    landmarks(i).y = 50*(i-1);
    landmarks(i).value = 0.5;
    landmarks(i).points = [50*(i-1) 50*(i-1)];
    landmarks(i).colour = [ .5 .5 .5];
end 

beliefValue = [];
beliefAction = [];
scene = initialise();

particles = generateParticles(scene,landmarks,PARTICLE_COUNT);
drawLandmarks(landmarks);
for i = [600:-200:0 0]

    %show new particles
    if exist('particlePlots')
        clearPlots(particlePlots);
    end
    particlePlots = drawParticles(particles);

%     if exist('obs') 
%         delete(obs);
%     end

    obs = plot(fix(1),fix(2),'.g','markersize',20);
    
    phi = [1 estimateBeliefPoints(scene,landmarks,particles,mu,sigma)];
    
    beliefValue(end+1) = phi * v;
    
    action = exp(phi * W);
    action = action ./ sum(action);
    beliefAction(end+1,:) = action;
%     beliefAction(end+1,:) = phi*W;
    
    disp(beliefValue(end));
    pause(0.5);
    
    fix = [landmarks(1).x+i landmarks(1).y+i];
    particles = updateParticleFilter(scene,particles,landmarks,fix);
end

figure();
plot(beliefValue);

figure();
plot(beliefAction);

