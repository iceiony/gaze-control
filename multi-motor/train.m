clear all;
close all;

GRASP_THRESHOLD = 5;
LANDMARK_COUNT = 2;
PARTICLE_COUNT = 200;

%initialise scene 
rng('shuffle');
scene = struct('width',700,'height',500);

landmarks = generateLandmarks(scene,LANDMARK_COUNT);
particles = generateParticles(scene,landmarks,PARTICLE_COUNT);

%grasp system weights 
[mu,sigma] = generateBeliefPoints(25,3);
kernel = @(x) gaussianKernel(x,mu,sigma);
V = zeros(1 + size(mu,1),1);
W = zeros(1 + size(mu,1),2); 

%gaze system weights
[muP,sigmaP] = generateBeliefPoints(50,3*LANDMARK_COUNT);
kernelP = @(x) gaussianKernel(x,muP,sigmaP);
VP = zeros(1+size(muP,1),1);
WP = zeros(1+size(muP,1),2);

reward = zeros(4000,1); %exact reward for each time step
for t=1:length(reward)
    
    if mod(t,100) == 0
        disp(t);
    end
    
    %---------------GAZING------------------
    gazeBeliefState = generateBeliefState(scene,landmarks,particles);
    phi = [1 kernelP(gazeBeliefState)];
   
%     gazeLocation = randi(LANDMARK_COUNT);
    gazeLocation = selectActionToTake(phi,WP);

    fix = mean(particles(gazeLocation).positions);
    particlesNew = updateParticleFilter(scene,particles,landmarks,fix);
    
    %update gaze weights
    gazeReward = 0 ;
    for idx = 1:LANDMARK_COUNT
        beliefStateOld = generateBeliefState(scene,landmarks(idx),particles(idx));
        phiOld = [1 kernel(beliefStateOld)];
        
        beliefStateNew = generateBeliefState(scene,landmarks(idx),particlesNew(idx));
        phiNew = [1 kernel(beliefStateNew)];
        
        gazeReward = sum(phiNew * W(:,1) - phiOld * W(:,1));
    end
    
    gazeValue = phi * VP;
    VP = VP + 0.2 * phi' * (gazeReward - gazeValue) ;
    
    WP(:,gazeLocation) = WP(:,gazeLocation) + 0.1 * phi' * (gazeReward - gazeValue);
    
    particles = particlesNew; 
    
    %--------------GRASPING-----------------
    phiOld = zeros(2,size(V,1));
    actionRewards = zeros(2,1);
    actionTaken = zeros(2,1);
    for idx = 1:LANDMARK_COUNT
        actionRewards(idx) = -1;
        
        beliefStateOld = generateBeliefState(scene,landmarks(idx),particles(idx));
        phiOld(idx,:) = [1 kernel(beliefStateOld)];
        actionTaken(idx) = selectActionToTake(phiOld(idx,:),W);
        
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
        beliefStateNew = generateBeliefState(scene,landmarks(idx),particles(idx));
        phiNew = [1 kernel(beliefStateNew)];
        
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