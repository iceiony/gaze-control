function [particles] = addNoise(particles,noise)
    for i=1:length(particles)
        aux = repmat(noise,length(particles(i).positions),1);
        particles(i).noise = randn(length(particles(i).positions),2) .* aux;
        particles(i).positions = particles(i).positions + particles(i).noise;
    end
end