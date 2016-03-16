clear all;
close all; 

DRAW = false;
GRASP_THRESHOLD = 20;
LANDMARK_COUNT = 2;
PARTICLE_COUNT = 200;

scene = initialise();

landmarks = generateLandmarks(scene,LANDMARK_COUNT);
particles = generateParticles(scene,landmarks,PARTICLE_COUNT);

if DRAW
    landmarkPlots = drawLandmarks(landmarks);
    particlePlots = drawParticles(particles);
end

disp('Distributing belief points');

% [mu,sigma] = generateBeliefPoints(50,length(landmarks));
% v = zeros(size(mu,1)+1,1); %belief value weights
% W = zeros(size(mu,1)+1,length(landmarks)*2); %action weights ( last action is perception )

v = zeros(3*length(landmarks)+1,1);
W = zeros(3*length(landmarks)+1,length(landmarks)*2);

reward = zeros(8000,1); %exact reward for each time step
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
    
    beliefState = generateBeliefState(scene,landmarks,particles);
%     phi = [1 estimateBeliefPoints(beliefState,mu,sigma)];
    phi = [1 beliefState];
    
    valueBelief = phi * v;
    action = selectActionToTake(phi,W);
    
    %action current value for perception
    actionValues = phi * W;
    
    if action > LANDMARK_COUNT
        target = action - LANDMARK_COUNT;
        fix = mean(particles(target).positions);

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
    else
        % the action was to pick an object with a certain uncertainty
        target = landmarks(action);
        targetParticles = particles(action);

        %grasp considered succesful when the particle center is within
        %object threshold distance 
        distance = mean(targetParticles.positions) - [target.x target.y];
        distance = sqrt(sum(distance.^2));

        if distance < GRASP_THRESHOLD 
            reward(t) = 15 + target.value * 10;
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
    

    
    %update the weights with the new reward
    beliefState = generateBeliefState(scene,landmarks,particles);
%     newPhi = [1 estimateBeliefPoints(beliefState,mu,sigma)];
    newPhi = [ 1 beliefState ];
    valueNewBelief = newPhi * v;
    
    td_error = reward(t) + valueNewBelief - valueBelief;
    v = v + 0.0005 * td_error * newPhi';   
    
    actionNewValues = newPhi * W;
    
    if action > LANDMARK_COUNT
        graspIndex = action - LANDMARK_COUNT;
        W(:,action) = W(:,action) + ...
            0.00005 * (actionNewValues(graspIndex) - actionValues(graspIndex) - actionValues(action)) * phi';
%         W(:,action) = W(:,action) + 0.0005 * td_error * phi';
    else
        W(:,action) = W(:,action) + 0.0005 * td_error * phi';
    end
    
end

figure();
windowSize = 500;
sum_reward_window = conv(reward,ones(1,windowSize));
sum_reward_window = sum_reward_window(windowSize:end-windowSize);
plot(sum_reward_window);
xlabel('time steps')
ylabel('total reward');


beliefValuePlot;
