figure();
hold on;

learntGazeReward = load('18_learntGaze.txt');
% plot(learntGazeReward','b');
mean_reward = mean(learntGazeReward);
standard_error = std(learntGazeReward)/sqrt(size(learntGazeReward,1));
learningPlots = shadedErrorBar([],mean_reward,standard_error,'b',1);
% plot(mean_reward,'b.');

% 
randomGazeReward = load('18_randomGaze.txt');
% plot(randomGazeReward','r');
mean_reward = mean(randomGazeReward);
standard_error = std(randomGazeReward)/sqrt(size(randomGazeReward,1));
randomPlots = shadedErrorBar([],mean_reward,standard_error,'r',1); 
% plot(mean_reward,'r.');

xlabel('time step');
ylabel('reward');
legend([learningPlots.mainLine randomPlots.mainLine],'learnt gaze','random gaze','location','northwest')
