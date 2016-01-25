function [rewards] = calculateRewards(landmarks,locations)
    
GAZE_ACUITY = [100 100]; %gaze acuity as a normal distribution

if ~exist('locations')
    rewards = [];
    return;
end

rewards = zeros(length(locations),1);
for idx = 1:length(locations);
    location = locations(idx,:);
    for landmark = landmarks
        rewards(idx) = rewards(idx) + sum(mvnpdf(landmark.points,location,GAZE_ACUITY));
    end
end

rewards = rewards * 100;

end