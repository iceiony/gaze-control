figure();
hold on;

interval = 1:-.05:0;
values = [];
for k = 1:length(interval)
    beliefState  = [ interval(k) interval(k) 1 interval(k) interval(k) 0];
    out{1} = [1 sigmoid(beliefState, WP{1})];
    out{2} = [1 sigmoid(out{1}, WP{2})];
    
    action_probability = exp(out{2}*WP{3});
    values(k,:) = action_probability ./ sum(action_probability);
    
%     values(k,:) = out{2}*WP{3};
end

plot(1-interval,values);
axis([0 1 0 1]);


values = [];
for k = 1:length(interval)
    beliefState  = [ interval(k) interval(k) 0 interval(k) interval(k) 1];
    out{1} = [1 sigmoid(beliefState, WP{1})];
    out{2} = [1 sigmoid(out{1}, WP{2})];
    
    action_probability = exp(out{2}*WP{3});
    values(k,:) = action_probability ./ sum(action_probability);

%     values(k,:) = out{2}*WP{3};
end

plot(1-interval,values,'--');

legend('high','low','low','high');
