figure();
hold on;

interval = 1:-.05:0;


values = [];
for k = 1:length(interval)
    beliefState  = [ interval(k) interval(k) 1 interval(k) interval(k) 0];
    phi = [ 1 kernelP(beliefState)];
    
    values(k,:) = phi*WP;
end

plot(1-interval,values);


values = [];
for k = 1:length(interval)
    beliefState  = [ interval(k) interval(k) 0 interval(k) interval(k) 1];

    phi = [ 1 kernelP(beliefState)];
    
    values(k,:) = phi*WP;
end

plot(1-interval,values,'--');

legend('gaze 1','gaze 2','gaze 1','gaze 2');


xlabel('certainty');
ylabel('probability');