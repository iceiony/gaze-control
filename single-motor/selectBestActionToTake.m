    function [action] = selectBestActionToTake(phi,W)
        action_probability = exp(phi*W);
        action_probability = action_probability ./ sum(action_probability);
        disp(action_probability);
        [~,action] = max(action_probability);
    end