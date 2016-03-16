    function [action] = selectActionToTake(phi,W)
        action_probability = exp(phi*W);
        action_probability = action_probability ./ sum(action_probability);
        
%         disp(phi*W);
%         disp(action_probability);
        action = find(cumsum(action_probability) >= rand(1));
        action = action(1);
    end