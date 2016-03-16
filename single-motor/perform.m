DRAW = true;

scene = initialise();

landmarks = generateLandmarks(scene,LANDMARK_COUNT);
particles = generateParticles(scene,landmarks,PARTICLE_COUNT);

if DRAW
    landmarkPlots = drawLandmarks(landmarks);
    particlePlots = drawParticles(particles);
end

reward = zeros(2000,1); 
rewardPerception = zeros(length(reward),1);
for t=1:length(reward)
    
    if mod(t,10) == 0
        disp(t);
    end
    
%     if t == length(reward)-50
%         DRAW = true;
%         landmarkPlots = drawLandmarks(landmarks);
%         particlePlots = drawParticles(particles);
%     end
    
    phi = [1 estimateBeliefPoints(scene,landmarks,particles,mu,sigma)];
   
    action = selectBestActionToTake(phi,W);
    
    switch action
        case size(W,2) % the action is to sample again
            %fixate random position 
            fix = rand(1,2) .* [scene.width scene.height];
            
            %fixate in the middle of all particle sets
%             fix = mean(cat(1,particles.positions));
%             fix = ginput(1);
%             perceptionAction = selectBestActionToTake(phi,PW);
%             fix = mean(particles(perceptionAction).positions);

            reward(t) = -1;
            particles = updateParticleFilter(scene,particles,landmarks,fix);

            if DRAW
                %show new particles
                clearPlots(particlePlots);
                particlePlots = drawParticles(particles);
                
                if exist('obs') 
                    delete(obs);
                end

                obs = plot(fix(1),fix(2),'.g','markersize',20);
                
                pause(0.1);
            end
        otherwise % the action was to pick an object with a certain uncertainty
            target = landmarks(action);
            targetParticles = particles(action);
            
            %grasp considered succesful when the particle center is within
            %object threshold distance 
            distance = mean(targetParticles.positions) - [target.x target.y];
            distance = sqrt(sum(distance.^2));
            
            if distance < GRASP_THRESHOLD 
                reward(t) = 10 + target.value * 10;
            else
                reward(t) = -100;
            end
            
            if DRAW
                target = mean(targetParticles.positions);
                target_plot = plot(target(1),target(2),'.k','markersize',20);
                
                input(sprintf('Current reward : %d',reward(t)));

                if exist('target_plot')
                    delete(target_plot);
                end
            end
            
            %begin new trial

            landmarks = generateLandmarks(scene,LANDMARK_COUNT);
            particles = generateParticles(scene,landmarks,PARTICLE_COUNT);

            if DRAW
                clearPlots(particlePlots,landmarkPlots);
                landmarkPlots = drawLandmarks(landmarks);
                particlePlots = drawParticles(particles);
            end
    end
end

figure();
windowSize = 500;
sum_reward_window = conv(reward,ones(1,windowSize));
sum_reward_window = sum_reward_window(windowSize:end-windowSize);
plot(sum_reward_window');
xlabel('time steps')
ylabel('total reward');