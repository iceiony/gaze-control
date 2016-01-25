function [landmarks] = drawLandmarks(landmarks)
%generates points representing the landmark 

for landmark = landmarks
    pointColour = getColour(landmark.value);   
    plot(landmark.points(:,1),landmark.points(:,2),'.','color',pointColour,'markersize',60);
end

end

function [colour] = getColour(value)
%value is in range [1,0]
%A high value point is red whilst a low value point is blue
    colour = [value 0 (1 - value)];
end
