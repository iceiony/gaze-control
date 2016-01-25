clear all;
close all;

%empty imput should return empty output
assert(isempty(calculateRewards()),'Should be empty for no input');


%particles outside the reward should not have a reward
landmarks.x = 300;
landmarks.y = 300;
landmarks.value = 0.5;
landmarks.points = generateLandmarkShape(landmarks);
close all;
particles = [ 0 0 ; 300 300];

res = calculateRewards(landmarks,particles);
assert(res(1) < 10^-4, 'Particles far from landmark shold not receive reward');
assert(res(2) > res(1), 'Particles on the landmark should have a reward');


%particles with the landmark closer to the center of view should have a
%higher reward
landmarks.x = 300;
landmarks.y = 300;
landmarks.value = 0.5;
landmarks.points = generateLandmarkShape(landmarks);
particles = [ 225 300 ; 275 300];

res = calculateRewards(landmarks,particles);
assert(res(1) < res(2) , 'Particles closer to landmark center should have more reward');

%particles with the landmark closer to the center of view should have a
%higher reward
landmarks(1).x = 400;
landmarks(1).y = 400;
landmarks(1).value = 0.2;
landmarks(1).points = generateLandmarkShape(landmarks(1));
landmarks(2).x = 200;
landmarks(2).y = 200;
landmarks(2).value = 0.8;
landmarks(2).points = generateLandmarkShape(landmarks(2));
particles = [ 390 390 ; 190 190];

res = calculateRewards(landmarks,particles);
assert(res(1) < res(2) , 'Particles closer to landmark center should have more reward');