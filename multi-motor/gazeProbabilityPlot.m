figure();
hold on;

interval = 1:-.05:0;
values = [];
for k = 1:length(interval)
    beliefState  = [ interval(k) interval(k) 1 ];
    
    phi = [ 1 beliefState];
    
    values(k,:) = phi * WP;
end

plot(values);

values = [];
for k = 1:length(interval)
    beliefState  = [ interval(k) interval(k) 0 ];
    
    phi = [1 beliefState];
    values(k,:) = phi * WP;
end


plot(values);
legend('high value obj' , 'low value obj');