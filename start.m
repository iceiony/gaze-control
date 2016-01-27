scene = initialise();

for i = 1:3
    [x,y,value] = generateLandmark(scene);
    landmarks(i).x = x;
    landmarks(i).y = y;
    landmarks(i).value = value;
    landmarks(i).points = generateLandmarkShape(landmarks(i));
end

drawLandmarks(landmarks);

%generate uniform particle filter;
% particles = rand(500,2);
% particles(:,1) = round(particles(:,1)*scene.width);
% particles(:,2) = round(particles(:,2)*scene.height);
[p,q] = meshgrid(1:20:scene.width,1:20:scene.height);
particles = [p(:) q(:)];
for i = 1:length(particles)
    particles(i,1) = particles(i,1)+10*mod((particles(i,2)-1) /  20 ,2); 
end

plot(particles(:,1),particles(:,2),'ro','markersize',3);

%calculate reward for fixating on different locations
rewards = calculateRewards(landmarks,particles);
for i = 1:length(particles)
    prt = particles(i,:);
    plot([prt(1) prt(1)],[prt(2) prt(2)+rewards(i)],'k','linewidth',1);
end
