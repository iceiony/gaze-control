landmarks = [];
positions = [ 50 50 ; 500 500];
for i = 1:LANDMARK_COUNT
    landmarks(i).x = positions(i,1);
    landmarks(i).y = positions(i,2);
    landmarks(i).value = 0.5;
    landmarks(i).points = positions(i,:);
    landmarks(i).colour = [ .5 .5 .5];
end 

beliefValue = [];
beliefAction = [];
scene = initialise();

particles = generateParticles(scene,landmarks,PARTICLE_COUNT);
drawLandmarks(landmarks);
for i = [500:-100:0 0]

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
    
%     action = exp(phi * W);
%     action = action ./ sum(action);
%     beliefAction(end+1,:) = action;
    beliefAction(end+1,:) = phi*W;
    
    disp(beliefValue(end));
    pause(0.5);
    
    fix = [i i];
    particles = updateParticleFilter(scene,particles,landmarks,fix);
end

figure();
plot(beliefValue);

figure();
plot(beliefAction);

legend('1','2','gaze');
