clear all;
close all; 

DRAW = false;
GRASP_THRESHOLD = 20;
LANDMARK_COUNT = 1;
PARTICLE_COUNT = 200;

scene = initialise();

landmarks = generateLandmarks(scene,LANDMARK_COUNT);
particles = generateParticles(scene,landmarks,PARTICLE_COUNT);

if DRAW
    landmarkPlots = drawLandmarks(landmarks);
    particlePlots = drawParticles(particles);
end

disp('Distributing belief points');
[mu,sigma] = generateBeliefPoints(200,length(landmarks));
v = zeros(size(mu,1)+1,1); %belief value weights
W = zeros(size(mu,1)+1,length(landmarks)+1); %action weights ( last action is perception )
PW = zeros(size(mu,1)+1,length(landmarks)); %perception weights 

reward = zeros(4000,1); %exact reward for each time step
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
   
    valueBelief = phi * v;
    action = selectActionToTake(phi,W);
    
    %action current value for perception
    valueActions = phi * W(:,1:end-1);
    
    switch action
        case size(W,2) % the action is to sample again
            %fixate random position 
            fix = rand(1,2) .* [scene.width scene.height];
            
            %fixate in the middle of all particle sets
%             fix = mean(cat(1,particles.positions));
%             fix = ginput(1);
%             perceptionAction = selectActionToTake(phi,PW);
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
                reward(t) = 40 + target.value * 60;
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
    phi = [1 estimateBeliefPoints(scene,landmarks,particles,mu,sigma)];
    valueNewBelief = phi * v;
    
    td_error = reward(t) + valueNewBelief - valueBelief;
    v = v + 0.0005 * td_error * phi';       

    W(:,action) = W(:,action) + 0.00005 * td_error * phi';
    
    %update perception weights with reward if perception action taken
%     if action == size(W,2)
%         newValueActions = phi*W(:,1:end-1);
%         rewardPerception(t) = max(newValueActions) - max(valueActions);
%         PW(:,perceptionAction) = PW(:,perceptionAction) + ...
%             10^-4  * rewardPerception(t) * phi';
%     end
    
end

figure();
windowSize = 500;
sum_reward_window = conv(reward,ones(1,windowSize));
sum_reward_window = sum_reward_window(windowSize:end-windowSize);
plot(sum_reward_window');
xlabel('time steps')
ylabel('total reward');

