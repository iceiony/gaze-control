function [particlePlots] = drawParticles(particles)
    for i = 1:length(particles)
        pos = particles(i).positions;
        particlePlots(i).particles = plot(pos(:,1),pos(:,2),'o',...
                               'markersize',4,'color',particles(i).colour...
                          );
                      
        particlePlots(i).gaussian = plot_gaussian_ellipsoid(mean(pos),cov(pos)*9);
        set(particlePlots(i).gaussian,'color','k');
    end
end