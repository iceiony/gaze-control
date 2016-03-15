interval = 1:-.05:0;

values = [];
for k = 1:length(interval)
    beliefState  = [interval(k) interval(k) 1 1 1 0];
    phi = [1 estimateBeliefPoints(beliefState,mu,sigma)];
%     phi = [ 1 beliefState];
    
    action_probability = exp(phi*W);
    values(k,:) = action_probability ./ sum(action_probability);
   
end


plot(values);
legend('grab 1','grab 2','gaze 1' ,'gaze 2');