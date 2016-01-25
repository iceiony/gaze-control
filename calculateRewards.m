function [rewards] = calculateRewards(landmarks,locations)
GAZE_ACUITY = [300 300]; %gaze acuity as a normal distribution

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

%flatten reward closer to landmark
rewards = log2(rewards) + 30 ;
rewards(rewards<0) = 0;
end