%create scene 
%draw two objects randomly on the scene ( two points of different sizes ) 
%sprea a particles over the scene
%for every particle calcualte the reward if it were chosen as a gausian

scene = initialise();

for i = 1:3
    [x,y,value] = generatePoint(scene);
    landmarks(i).x = x;
    landmarks(i).y = y;
    landmarks(i).value = value;
end

drawLandmarks(landmarks);

%generate uniform particle filter;
particles = rand(100,2);
particles(:,1) = round(particles(:,1)*scene.width);
particles(:,2) = round(particles(:,2)*scene.height);
plot(particles(:,1),particles(:,2),'ro','markersize',3);

%calculate reward for fixating on different locations
rewards = calculateRewards(landmarks,particles);

