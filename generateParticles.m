function [particles] = generateParticles(scene,landmarks,nr)
    %generate uniform particle filter for each landmark

    for i=1:length(landmarks)
        particles(i).positions = rand([nr,2]) .* repmat([scene.width scene.height],nr,1);
        particles(i).colour = landmarks(i).colour + [.2 .5 .2];
        particles(i).colour(particles(i).colour > 1) = 1;
    end

end