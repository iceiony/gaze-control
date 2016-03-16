interval = 0:0.05:1;
values = zeros(length(interval));

for k = 1:length(interval)
    for j = 1:length(interval)
        
        beliefState = [  1 1 0 interval(k) interval(j) 1  ];
%         phi = [1 estimateBeliefPoints(beliefState,mu,sigma)];
        phi = [ 1 beliefState];

        values(k,j) =  phi * W(:,1);
    end
end

figure();
hold on;
mesh(interval,interval,values,'facecolor','red');



for k = 1:length(interval)
    for j = 1:length(interval)
        
        beliefState = [  1 1 0 interval(k) interval(j) 1  ];
%         phi = [1 estimateBeliefPoints(beliefState,mu,sigma)];
        phi = [ 1 beliefState];

        values(k,j) =  phi * W(:,2);
    end
end

mesh(interval,interval,values,'facecolor','blue');