function [particlePlots] = drawParticles(particles)
    for i = 1:length(particles)
        particlePlots(i) = plot(particles(i).positions(:,1),particles(i).positions(:,2),'o',...
                               'markersize',4,'color',particles(i).colour...
                          );
    end
end