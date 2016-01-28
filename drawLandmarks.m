function [landmarks] = drawLandmarks(landmarks)
%generates points representing the landmark 
for landmark = landmarks
    plot(landmark.points(:,1),landmark.points(:,2),'.','color',landmark.colour,'markersize',60);
end

end

