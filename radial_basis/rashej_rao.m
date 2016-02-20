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
    belief = [0.5 0.5];
    coherence = randi(length(prob_obs));
    state = randi(2);
    
    for t=1:10   

        observation = observationProbability(state,prob_obs(coherence));

        belief = beliefUpdate(belief,observation);
        disp(belief);
    end
    disp(state);
    disp(prob_obs(coherence));
    
    
    
%==========================================================================

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
end