figure();
hold on;
 
interval = 1:-.05:0;

values = [];
for k = 1:length(interval)
    beliefState  = [ interval(k) interval(k) 0 interval(k) interval(k)  1];
    phi = [ 1 kernelP(beliefState)];
    
    action_probability = exp(phi*WP);
    values(k,:) = action_probability ./ sum(action_probability);
end

plot(1-interval,values);

values = [];
for k = 1:length(interval)
    beliefState  = [ interval(k) interval(k) 1 interval(k) interval(k)  0];
    phi = [ 1 kernelP(beliefState)];
    
    action_probability = exp(phi*WP);
    values(k,:) = action_probability ./ sum(action_probability);
end

plot(1-interval,values,'--');

legend('Gaze Low Value','Gaze High Value','Gaze High Value','Gaze Low Value');

axis([0 1 0 1]);

xlabel('certainty');
ylabel('probability');