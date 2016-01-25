function [x,y,value] = generatePoint(scene)    
value = rand();
x = randi(scene.width-50)+25;
y = randi(scene.height-50)+25;
end