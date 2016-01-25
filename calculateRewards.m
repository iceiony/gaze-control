function [rewards] = calculateRewards(landmarks,locations)
    
GAZE_ACUITY = [100 100]; %gaze acuity as a normal distribution

if ~exist('locations')
    rewards = [];
    return;
end

rewards = zeros(length(locations));
for location = locations

end

end