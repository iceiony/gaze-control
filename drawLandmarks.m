function drawLandmarks(landmarks)

for landmark = landmarks
    pointColour = getColour(landmark.value);
    pointSize = getSize(landmark.value);
    plot(landmark.x,landmark.y,'.','color',pointColour,'markersize',pointSize);
end

end

function [colour] = getColour(value)
%value is in range [1,0]
%A high value point is red whilst a low value point is blue
    colour = [value 0 (1 - value)];
end

function [pointSize] = getSize(value)
%value is in range [1,0]
%A high value point is smaller
    pointSize = 30 + (1-value) * 100;
end