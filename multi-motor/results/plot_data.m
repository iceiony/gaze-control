figure();
hold on;

learntGazeReward = load('1_learntGaze.txt');
mean_reward = mean(learntGazeReward);
standard_error = std(learntGazeReward);
% shadedErrorBar([],mean_reward,standard_error,'b.',1);
plot(mean_reward,'b.');

% 
randomGazeReward = load('1_randomGaze.txt');
mean_reward = mean(randomGazeReward);
standard_error = std(randomGazeReward);
% shadedErrorBar([],mean_reward,standard_error,'r.',1); 
plot(mean_reward,'r.');

xlabel('time step');
ylabel('reward');
