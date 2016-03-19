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

%grasp system weights 
V = zeros(4,1);
W = zeros(4,2); 

%gaze system weights
hiddenSize = [20,30];
WP{1} = rand(3*LANDMARK_COUNT,hiddenSize(1)) - .5; 
WP{2} = rand(1 + hiddenSize(1),hiddenSize(2)) - .5;
WP{3} = rand(1 + hiddenSize(2), 2);
sigmoid = @(in,W) 1 ./ ( 1 + exp(-in*W)) - .5;

reward = zeros(4000,1); %exact reward for each time step
for t=1:length(reward)
    
    if mod(t,100) == 0
        disp(t);
    end
    
    %---------------GAZING------------------
    gazeBeliefState = generateBeliefState(scene,landmarks,particles);
    out{1} = [1 sigmoid(gazeBeliefState, WP{1})];
    out{2} = [1 sigmoid(out{1}, WP{2})];
   
    gazeLocation = selectActionToTake(out{2},WP{3});

    fix = mean(particles(gazeLocation).positions);
    particlesNew = updateParticleFilter(scene,particles,landmarks,fix);
    
    %update gaze weights
    gazeReward = 0 ;
    for idx = 1:LANDMARK_COUNT
        phiOld = [1 generateBeliefState(scene,landmarks(idx),particles(idx))];
        phiNew = [1 generateBeliefState(scene,landmarks(idx),particlesNew(idx))];
        gazeReward = gazeReward + sum(phiNew * W(:,1) - phiOld * W(:,1));
    end
    
    gazeValue = out{2}*WP{3}(:,gazeLocation);
    
    
    hiddDiff2 = ( WP{3}(:,gazeLocation) * (gazeReward - gazeValue) )' .*  out{2} .* ( 1 - out{2}) ;
    hiddDiff1 = ( WP{2} *  hiddDiff2(2:end)' )' .*  out{1} .* ( 1 - out{1}) ;
    
    WP{1} = WP{1} + 0.001 * gazeBeliefState' * hiddDiff1(2:end);
    WP{2} = WP{2} + 0.001 * out{1}' * hiddDiff2(2:end);
    WP{3}(:,gazeLocation) = WP{3}(:,gazeLocation) + 0.001 * out{2}' * (gazeReward - gazeValue) ;
    
    particles = particlesNew; 
    
    %--------------GRASPING-----------------
    phiOld = zeros(2,4);
    actionRewards = zeros(2,1);
    actionTaken = zeros(2,1);
    for idx = 1:LANDMARK_COUNT
        actionRewards(idx) = -1;
        
        phiOld(idx,:) = [1 generateBeliefState(scene,landmarks(idx),particles(idx))];
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
