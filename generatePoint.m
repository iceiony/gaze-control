function [x,y,value] = generatePoint(scene)    
value = rand();
x = randi(scene.width);
y = randi(scene.height);
end