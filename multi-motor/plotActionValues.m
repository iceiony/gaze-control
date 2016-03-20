figure();
hold on;

interval = 1:-.05:0;


values = [];
for k = 1:length(interval)
    beliefState  = [ interval(k) interval(k) 1];
    phi = [1 kernel(beliefState)];
    
    values(k,:) = phi * W;
end
plot(1-interval,values);


values = [];
for k = 1:length(interval)
    beliefState  = [ interval(k) interval(k) 0];
%     phi = [1 estimateBeliefPoints(beliefState,mu,sigma)];
    phi = [1 kernel(beliefState)];
    
    values(k,:) = phi * W;
end
plot(1-interval,values);


legend('grab','not grab','grab','not grab');
