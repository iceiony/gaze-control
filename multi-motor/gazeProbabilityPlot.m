figure();
hold on;

interval = 1:-.05:0;
values = [];
for k = 1:length(interval)
    beliefState  = [ interval(k) interval(k) 1 1 1 1];
    
    phi = [ 1 beliefState];
    
    action_probability = exp(phi*WP);
    values(k,:) = action_probability ./ sum(action_probability);
%     values(k,:) = xphi*WP;
end

plot(values);
% 
% values = [];
% for k = 1:length(interval)
%     beliefState  = [ interval(k) interval(k) 0 1 1 1];
%     
%     phi = [1 beliefState];
%     values(k,:) = phi * WP;
% end
% 
% 
% plot(values);
% legend('high value obj' , 'low value obj','low','high');