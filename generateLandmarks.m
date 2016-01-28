function [landmarks] = generateLandmarks(scene,nr)    
    for i=1:nr
        landmarks(i) = generateSingleLandmark(scene);
    end
end

function [landmark] = generateSingleLandmark(scene)
    landmark.x = randi(scene.width-50)+25;
    landmark.y = randi(scene.height-50)+25;
    landmark.value = rand();
    landmark.points = generateLandmarkShape(landmark);
    landmark.colour = getColour(landmark.value);
end

function [points] = generateLandmarkShape(landmark)
    pointsMu = [landmark.x,landmark.y];%landmark origin
    pointsSigma = round(ones(1,2) * 120 * (1 - landmark.value) );%landmark spread
    density = 120;
    
    points = mvnrnd(pointsMu,pointsSigma,density);
end

function [colour] = getColour(value)
%value is in range [1,0]
%A high value point is red whilst a low value point is blue
    colour = [value 0 (1 - value)];
end
