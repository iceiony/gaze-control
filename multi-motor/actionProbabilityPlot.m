interval = 1:-.05:0;

values = [];
for k = 1:length(interval)
    beliefState  = [ interval(k) interval(k) 1 1 1 0];
%     beliefState  = [ 1 1 0 interval(k) interval(k) 1];
%     phi = [1 estimateBeliefPoints(beliefState,mu,sigma)];
    phi = [ 1 beliefState];
    
    action_probability = exp(phi*WG);
    values(k,:) = action_probability ./ sum(action_probability);
%     values(k,:) = phi*WG;

end

figure();
plot(values);
legend('grab','not grab');