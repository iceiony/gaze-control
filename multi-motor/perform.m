landmarks = generateLandmarks(scene,LANDMARK_COUNT);
particles = generateParticles(scene,landmarks,PARTICLE_COUNT);

reward = zeros(3000,1); %exact reward for each time step
gazeLocations = zeros(size(reward));
for t=1:length(reward)
    
    if mod(t,100) == 0
        disp(t);
    end
    
    %execute gaze
%     phi = [1 generateBeliefState(scene,landmarks,particles)];
%     gazeLocation = selectActionToTake(phi,WP);
    gazeLocation = randi(LANDMARK_COUNT);
    
    fix = mean(particles(gazeLocation).positions);
    particles = updateParticleFilter(scene,particles,landmarks,fix);
  
    %decide to grasp or not    
    actionRewards = zeros(2,1);
    actionTaken = zeros(2,1);
    for idx = 1:LANDMARK_COUNT
        actionRewards(idx) = -1;
        
        phi = [1 generateBeliefState(scene,landmarks(idx),particles(idx))];
        actionTaken = selectActionToTake(phi,W);
        
        if actionTaken ~= 1
            continue;
        end
        
        targetLandmark  = landmarks(idx);
        targetParticles = particles(idx);

        %grasp succesful object within threshold distance
        distance = mean(targetParticles.positions) - [targetLandmark.x targetLandmark.y];
        distance = sqrt(sum(distance.^2));

        if distance < GRASP_THRESHOLD + targetLandmark.value * 10
            actionRewards(idx) = 15 + targetLandmark.value * 30;
        else
            actionRewards(idx) = -100;
        end  
    end
    
    if any(actionTaken == 1) 
        %begin new trial
        landmarks = generateLandmarks(scene,LANDMARK_COUNT);
        particles = generateParticles(scene,landmarks,PARTICLE_COUNT);
    end
    
    reward(t) = sum(actionRewards);
end

figure();
windowSize = 500;
sum_reward_window = conv(reward,ones(1,windowSize));
sum_reward_window = sum_reward_window(windowSize:end-windowSize);
plot(sum_reward_window);
xlabel('time steps')
ylabel('total reward');
 
hold on;
plot(load('randFixationLinear.txt'));
