clear all; 
close all;

GRASP_THRESHOLD = 5;
LANDMARK_COUNT = 2;
PARTICLE_COUNT = 100;

%initialise sceneç 
rng('shuffle');
scene = struct('width',700,'height',500);

landmarks = generateLandmarks(scene,LANDMARK_COUNT);
particles = generateParticles(scene,landmarks,PARTICLE_COUNT);

%grasp system weights 
[mu,sigma] = generateBeliefPoints(60,3,.25);
kernel = @(x) gaussianKernel(x,mu,sigma);
V = zeros(1 + size(mu,1),1);
W = zeros(1 + size(mu,1),2); 

reward = zeros(4000,1); %exact reward for each time step
for t=1:length(reward)
    
    if mod(t,100) == 0
        disp(t);
    end
    
    %---------------GAZING------------------
    for gazeTime = 1:3
        gazeLocation = randi(LANDMARK_COUNT);

        fix = mean(particles(gazeLocation).positions);
        particles = updateParticleFilter(scene,particles,landmarks,fix);   
    end
    
    %--------------GRASPING-----------------
    phiOld = zeros(LANDMARK_COUNT,size(V,1));
    beliefStateOld = zeros(LANDMARK_COUNT,3);
    actionRewards = zeros(2,1);
    actionTaken = zeros(2,1);
    for idx = 1:LANDMARK_COUNT
        actionRewards(idx) = -1;
        
        beliefStateOld(idx,:) = generateBeliefState(scene,landmarks(idx),particles(idx));
        phiOld(idx,:) = [1 kernel(beliefStateOld(idx,:))];
        actionTaken(idx) = selectActionToTake(phiOld(idx,:),W);
        
        if actionTaken(idx) ~= 1
            continue;
        end
        
        targetLandmark  = landmarks(idx);
        targetParticles = particles(idx);

        %grasp succesful object within threshold distance
        distance = mean(targetParticles.positions) - [targetLandmark.x targetLandmark.y];
        distance = sqrt(sum(distance.^2));

        if distance < GRASP_THRESHOLD + targetLandmark.value * 3
            actionRewards(idx) = 15 + targetLandmark.value * 30;
        else
            actionRewards(idx) = -100;
        end  
    end
    
    %begin new trial
    landmarks = generateLandmarks(scene,LANDMARK_COUNT);
    particles = generateParticles(scene,landmarks,PARTICLE_COUNT);

    %update grasp weights
    for idx = 1 : LANDMARK_COUNT
        beliefStateNew = generateBeliefState(scene,landmarks(idx),particles(idx));
        phiNew = [1 kernel(beliefStateNew)];
        
        beliefValues    = phiOld(idx,:) * V;
        beliefValuesNew = phiNew        * V;
        
        td_error = actionRewards(idx) + beliefValuesNew - beliefValues;
        
%         diffs = 2 * (repmat(beliefStateOld(idx,:),size(mu,1),1) - mu) / sigma(1)^2;
%         mu = mu + 2.5 * 10^-9 * td_error * phiOld(idx,:) * V * diffs;        
        
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