function rashej_rao()
    %fixed probability for observation depending on random coherence values
    prob_obs = 0.5 + rand(100,1) / 2;

    %define actions
    a.left = 1;
    a.right = 2;
    a.sample = 3;

    %define states
    s.left = 1;
    s.right = 2;

    %define the transition probabilities for each action and states
    prob_trans = transitionProbabilities();

    %train the network
    mu = initialiseRandomBeliefCentres(11);
    sigma = sqrt(0.05);
    v = zeros(11,1);
    W = zeros(11,3);
    
    %setup start trial
    belief = [0.5 0.5];
    coherence = randi(length(prob_obs));
    state = randi(2);
    
    %when a new trial starts, do a free sample observation
    observation = observationProbability(state,prob_obs(coherence));
    belief = beliefUpdate(belief,observation);
    
    %rememeber reward for plotting
    reward = zeros(14000,1);
    for t=1:length(reward)   
        %phi is g(b_t) from Rashej Rao paper 2010 paper
        phi = estimateBeliefPoints(belief,mu,sigma); 
        value_beilef = phi * v; 

        action = selectActionToTake(phi,W);
        
        switch action
            case a.sample
                reward(t) = -1;
                observation = observationProbability(state,prob_obs(coherence));
                belief = beliefUpdate(belief,observation);
            otherwise 
                %give rewards if correct action taken
                if action == a.left && state == s.left
                    reward(t) = 20;
                elseif action == a.right && state == s.right
                    reward(t) = 20;
                else
                    reward(t) = -400;
                end
                
                %start a new trial
                belief = [0.5 0.5];
                coherence = randi(length(prob_obs));
                state = randi(2);
                
                %when a new trial starts, do a free sample observation
                observation = observationProbability(state,prob_obs(coherence));
                belief = beliefUpdate(belief,observation);
        end
        
        %compute next belief estimate
        value_new_belief = estimateBeliefPoints(belief,mu,sigma) * v;
        
        %update belief centers and output weights V and W 
        td_error = reward(t) + value_new_belief - value_beilef;
        
        diffs = repmat(belief,size(mu,1),1) - mu;
        mu = mu + 0.0005 * td_error * phi * v * 2 * diffs / sigma^2;
        v = v + 0.0005 * td_error * phi';       
        
        W(:,action) = 2.5 * 10^-7 * td_error * phi;
    end
%     
%     moving_window = ones(1,500);
%     sum_reward_window = conv(reward,moving_window);
%     sum_reward_window = sum_reward_window(500:end-500);
%     plot(1:length(sum_reward_window),sum_reward_window);
%     hold on;
%     value = [];
%     for t = 0:0.1:1
%         belief = [t 1-t];
%         phi = estimateBeliefPoints(belief,mu,sigma); 
%         value(end+1) = phi * v; 
%     end
%     plot(0:0.1:1,value);
    
    
%==========================================================================
    function [action] = selectActionToTake(phi,W)
        action_probability = exp(phi*W);
        action_probability = action_probability ./ sum(action_probability);
        action = find(cumsum(action_probability) >= rand(1));
        action = action(1);
    end

    function [phi] = estimateBeliefPoints(belief,mu,sigma)
        phi = zeros(1,size(mu,1));
        for i=1:size(mu,1)
            distance = sum((belief - mu(i,:)).^2);
            phi(i) = exp( -distance / (2*sigma^2) );
        end
    end

    function [observation] = observationProbability(state,prob_obs)
        if state == s.left
            observation(s.left)  = prob_obs;
            observation(s.right) = 1-prob_obs;
        else
            observation(s.left)  = 1 - prob_obs;
            observation(s.right) = prob_obs;
        end
    end

    function [belief] = beliefUpdate(belief,observation)
        belief(s.right) = observation(s.right) ...
              *( belief(s.right) * prob_trans(s.right,a.sample,s.right) ...
              +  belief(s.left)  * prob_trans(s.right,a.sample,s.left));

        belief(s.left) = observation(s.left) ...
                      *( belief(s.right) * prob_trans(s.left,a.sample,s.right) ...
                      +  belief(s.left)  * prob_trans(s.left,a.sample,s.left));

        belief = belief ./ sum(belief);
    end

    function [prob_trans] = transitionProbabilities()
        prob_trans = ones(12 ,3)*0.5;

        prob_trans(s.left,a.sample,s.left) = 1;
        prob_trans(s.right,a.sample,s.right) = 1;

        prob_trans(s.left,a.sample,s.right) = 0;
        prob_trans(s.right,a.sample,s.left) = 0;
    end

    function [mu] = initialiseRandomBeliefCentres(number)      
        [x,y] = meshgrid(0:0.1:1,0:0.1:1);
        X = [y(:) x(:)];

        % train the gaussians weights
        [idx,mu,~,~] = kmeans(X,number);
    end
end