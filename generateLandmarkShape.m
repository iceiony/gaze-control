function [points] = generateLandmarkShape(landmark)
    pointsMu = [landmark.x,landmark.y];%landmark origin
    pointsSigma = round(ones(1,2) * 120 * (1 - landmark.value) );%landmark spread
    density = 120;
    
    points = mvnrnd(pointsMu,pointsSigma,density);
end
