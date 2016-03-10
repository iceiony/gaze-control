interval = 0:0.05:1;
values = zeros(length(interval));

for k = 1:length(interval)
    for j = 1:length(interval)
        
        beliefState = [interval(k) interval(j) 0.5];
        
        phi = zeros(1,size(mu,1));
        for i=1:size(mu,1)
            distance = sum((beliefState(:)' - mu(i,:)).^2);
            phi(i) = exp( -distance / (2*sigma(i)^2) );
        end
        
        phi = [1 phi];

        values(k,j) =  phi * v;
    end
end

figure();
mesh(interval,interval,values);