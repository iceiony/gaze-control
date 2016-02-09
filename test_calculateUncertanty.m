clear all;

%uncertainty value should be higher the closer to particle center
particles = zeros(100,2);
for i = 1:100
    particles(i,:) = mvnrnd([0,0],[200,200]);
end

beliefs = [30 30;
           20 20;
           0   0 ];
certainty = calculateUncertainty(particles,beliefs);

assert(length(certainty)==3);
assert(certainty(1) < certainty(2));
assert(certainty(2) < certainty(3));


%wider particle spread should have worse certainty 
particles = zeros(100,2);
for i = 1:100
    particles(i,:) = mvnrnd([0,0],[400,400]);
end

newCertainty = calculateUncertainty(particles,beliefs);

assert(newCertainty(3) < certainty(3));
