function [particles] = addNoise(particles,noise)
    for j = 1: length(particles.positions)
        particles.positions(j,:) = mvnrnd(particles.positions(j,:),noise(j,:));
    end
end