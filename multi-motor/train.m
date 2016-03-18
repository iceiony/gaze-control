clear all;
close all;

GRASP_THRESHOLD = 10;
LANDMARK_COUNT = 2;
PARTICLE_COUNT = 200;

%initialise scene 
rng('shuffle');
scene = struct('width',700,'height',500);

landmarks = generateLandmarks(scene,LANDMARK_COUNT);
particles = generateParticles(scene,landmarks,PARTICLE_COUNT);

%value function for each object ( one per grasping motor system )
V = zeros(4,1);
W = zeros(4,2); 
WP = zeros(1 + 3*LANDMARK_COUNT,2); 

reward = zeros(4000,1); %exact reward for each time step
for t=1:length(reward)
    
    if mod(t,100) == 0
        disp(t);
    end
    
    %execute gaze
    phiOld = zeros(2,4);
    for idx = 1:LANDMARK_COUNT
        phiOld(idx,:) = [1 generateBeliefState(scene,landmarks(idx),particles(idx))];
    end
    
    phi = [1 generateBeliefState(scene,landmarks,particles)];
%     gazeLocation = selectActionToTake(phi,WP);

    gazeLocation = randi(LANDMARK_COUNT);
    
    fix = mean(particles(gazeLocation).positions);
    particles = updateParticleFilter(scene,particles,landmarks,fix);
    
    %update gaze weights
    gazeReward = 0 ;
    for idx = 1:LANDMARK_COUNT
        phiNew = [1 generateBeliefState(scene,landmarks(idx),particles(idx))];
        gazeReward = gazeReward + sum(phiNew * W - phiOld(idx,:) * W);
    end
    WP(:,gazeLocation) = WP(:,gazeLocation) + 0.0005 * gazeReward * phi';
    
    %decide to grasp or not    
    phiOld = zeros(2,4);
    actionRewards = zeros(2,1);
    actionTaken = zeros(2,1);
    for idx = 1:LANDMARK_COUNT
        actionRewards(idx) = -1;
        
        phi = [1 generateBeliefState(scene,landmarks(idx),particles(idx))];
        actionTaken(idx) = selectActionToTake(phi,W);
        
        phiOld(idx,:) = phi;
        
        if actionTaken(idx) ~= 1
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
    
    %update grasp weights
    for idx = 1 : LANDMARK_COUNT
        phiNew = [1 generateBeliefState(scene,landmarks(idx),particles(idx))];
        
        beliefValues    = phiOld(idx,:) * V;
        beliefValuesNew = phiNew        * V;
        
        td_error = actionRewards(idx) + beliefValuesNew - beliefValues;
        V = V + 0.001 * phiOld(idx,:)' * td_error;   
        W(:,actionTaken(idx)) = W(:,actionTaken(idx)) + 0.0005 * phiOld(idx,:)' * td_error;
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

% pause(0.1);
% perform;
