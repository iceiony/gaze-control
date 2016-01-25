clear all;
close all;

assert(isempty(calculateRewards()),'Should be empty for no input');


%
landmarks.x = 100;
landmarks.y = 100;
landmarks.value = 0.5;
particles = [ 0 0 ; 100 100];

res = calculateRewards(landmarks,particles);
assert(res(1) == 0 , 'Points far from landmark shold not receive reward');
assert(res(1) == 0.5 , 'Points exactly on landmark shold have the maximum reward');