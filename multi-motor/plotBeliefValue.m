interval = 0:0.05:1;
values = zeros(length(interval));

for k = 1:length(interval)
    for j = 1:length(interval) 
        beliefState = [ interval(k) interval(j) 0];
        phi = [ 1 kernel(beliefState)];

        values(k,j) =  phi * W(:,1);
    end
end

figure();
hold on;
mesh(interval,interval,values);
