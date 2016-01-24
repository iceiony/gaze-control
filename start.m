%create scene 
%draw two objects randomly on the scene ( two points of different sizes ) 
%sprea a particles over the scene
%for every particle calcualte the reward if it were chosen as a gausian

scene = initialise();

for i = 1:3
    [x,y,value] = generatePoint(scene);
    points(i).x = x;
    points(i).y = y;
    points(i).value = value;
end


drawPoints(points);