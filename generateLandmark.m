function [x,y,value] = generateLandmark(scene)    
value = rand();
x = randi(scene.width-50)+25;
y = randi(scene.height-50)+25;
end