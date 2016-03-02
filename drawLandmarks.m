function [landmarkPlots] = drawLandmarks(landmarks)
%generates points representing the landmark 
for i = 1:length(landmarks)
    landmark = landmarks(i);
    landmarkPlots(i).landmark = plot(landmark.points(:,1),landmark.points(:,2),'.','color',landmark.colour,'markersize',60);
    landmarkPlots(i).marker = plot(landmark.x , landmark.y,'*k');
end

end

