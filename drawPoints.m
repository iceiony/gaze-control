function drawPoints(points)
    for point = points
        pointColour = getColour(point.value);
        pointSize = getSize(point.value);
        plot(point.x,point.y,'.','color',pointColour,'markersize',pointSize);
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