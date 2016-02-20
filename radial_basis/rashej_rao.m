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
    
    belief = [0.5 0.5];
    coherence = randi(length(prob_obs));
    state = randi(2);
    for t=1:10   
        value_beilef = estimateValue(belief,v,mu,sigma);
        
        observation = observationProbability(state,prob_obs(coherence));

        belief = beliefUpdate(belief,observation);
        disp(belief);
    end
    disp(state);
    disp(prob_obs(coherence));
    
    
    
%==========================================================================
    function [value] = estimateValue(belief,v,mu,sigma)
        phi = [];
        for i=1:size(mu,1)
            distance = sum((belief - mu(i,:)).^2);
            phi(i) = exp( -distance / (2*sigma^2) );
        end
        value = phi * v; 
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