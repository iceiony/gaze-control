figure();
hold on;

learntGazeReward = load('8_learntGaze.txt');
% plot(learntGazeReward','b');
mean_reward = mean(learntGazeReward);
standard_error = std(learntGazeReward)/sqrt(size(learntGazeReward,1));
shadedErrorBar([],mean_reward,standard_error,'b',1);
% plot(mean_reward,'b.');

% 
randomGazeReward = load('8_randomGaze.txt');
% plot(randomGazeReward','r');
mean_reward = mean(randomGazeReward);
standard_error = std(randomGazeReward)/sqrt(size(randomGazeReward,1));
shadedErrorBar([],mean_reward,standard_error,'r',1); 
% plot(mean_reward,'r.');

xlabel('time step');
ylabel('reward');
