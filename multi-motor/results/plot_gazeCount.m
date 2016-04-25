figure();
hold on;

learntGazeCount = load('1_gazeCountLearnt.txt');
% plot(learntGazeReward','b');x
mean_reward = mean(learntGazeCount);
standard_error = std(learntGazeCount)/sqrt(size(learntGazeCount,1));
learningPlots = shadedErrorBar([],mean_reward,standard_error,'b',1);
% plot(mean_reward,'b.');

% 
randomGazeCount = load('1_gazeCountRandom.txt');
% plot(randomGazeReward','r');
mean_reward = mean(randomGazeCount);
standard_error = std(randomGazeCount)/sqrt(size(randomGazeCount,1));
randomPlots = shadedErrorBar([],mean_reward,standard_error,'r',1); 
% plot(mean_reward,'r.');

xlabel('time step');
ylabel('gaze count');
legend([learningPlots.mainLine randomPlots.mainLine],'learnt gaze','random gaze','location','northwest')
