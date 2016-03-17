GRASP_THRESHOLD = 5;
LANDMARK_COUNT = 2;
PARTICLE_COUNT = 200;

%initialise scene 
rng('shuffle');
scene = struct('width',700,'height',500);

landmarks = generateLandmarks(scene,LANDMARK_COUNT);
particles = generateParticles(scene,landmarks,PARTICLE_COUNT);

%value function for each object ( one per grasping motor system )
V = zeros(3*length(landmarks)+1,2);

%action weights for each motor system ( Left , Right and Gaze ) 
WL = zeros(3*length(landmarks)+1,2);
WR = zeros(3*length(landmarks)+1,2);
WG = zeros(3*length(landmarks)+1,2);

reward = zeros(8000,1); %exact reward for each time step
for t=1:length(reward)
    
    if mod(t,10) == 0
        disp(t);
    end
    
    %execute gaze
    beliefState = generateBeliefState(scene,landmarks,particles);
    gazeLocation = selectActionToTake(beliefState,WG);
    
    fix = mean(particles(gazeLocation).positions);
    particles = updateParticleFilter(scene,particles,landmarks,fix);
    
    %decide to grasp or not    
    motorLeftAction = selectActionToTake(beliefState,WL);
    motorRightAction = selectActionToTake(beliefState,WR);
    
    shouldGrasp = [motorLeftAction == 1 , motorRightAction == 1]; 
    actionRewards = zeros(size(shouldGrasp));
    for idx = 1:length(shouldGrasp)
        actionRewards(idx) = -1;
        
        if ~shouldGrasp(idx) 
            continue;
        end
        
        target = landmarks(idx);
        targetParticles = particles(idx);

        %grasp succesful object within threshold distance
        distance = mean(targetParticles.positions) - [target.x target.y];
        distance = sqrt(sum(distance.^2));

        if distance < GRASP_THRESHOLD 
            actionRewards(idx) = 15 + target.value * 10;
        else
            actionRewards(idx) = -100;
        end
        
    end
    
    if any(shouldGrasp) 
        %begin new trial
        landmarks = generateLandmarks(scene,LANDMARK_COUNT);
        particles = generateParticles(scene,landmarks,PARTICLE_COUNT);
    end
    
    %update weights
    beliefStateNew = generateBeliefState(scene,landmarks,particles);
    
    gazeReward = (beliefStateNew - beliefState) * (WL(:,1) + WR(:,1));
    currentGazeValue = beliefState * WG(:,gazeLocation);
    WG(:,gazeLocation) = WG(:,gazeLocation) + 0.00005 * (gazeReward - currentGazeValue) * beliefState';
    
    beliefValues = beliefState * V;
    beliefValuesNew = beliefStateNew * V;
    td_error = actionRewards + beliefValuesNew - beliefValues;
    V = V + 0.0005 * beliefState' * td_error;   
    WL(:,motorLeftAction) = WL(:,motorLeftAction) + 0.00005 * beliefState' * td_error(1);
    WR(:,motorRightAction) = WR(:,motorRightAction) + 0.00005 * beliefState' * td_error(2);
    
    reward(t) = sum(actionRewards);
    
    
    
%     WG(
    
%     graspIndex = action - LANDMARK_COUNT;
%     W(:,action) = W(:,action) + ...
%         0.00005 * (actionNewValues(graspIndex) - actionValues(graspIndex) - actionValues(action)) * phi';

    
end

figure();
windowSize = 500;
sum_reward_window = conv(reward,ones(1,windowSize));
sum_reward_window = sum_reward_window(windowSize:end-windowSize);
plot(sum_reward_window);
xlabel('time steps')
ylabel('total reward');

