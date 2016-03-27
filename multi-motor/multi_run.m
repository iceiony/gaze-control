
reward_try = [];
for i = 1 : 3
    train;
    file_name = '8_learntGaze.txt';
    reward_try = load(file_name);
    reward_try(end+1,:) = sum_reward_window;
    save(file_name,'reward_try','-ascii');
end
% 

reward_try = [];
for i = 1 : 5
    trainRandom;
    file_name = '8_randomGaze.txt';
    reward_try = load(file_name);
    reward_try(end+1,:) = sum_reward_window;
    save(file_name,'reward_try','-ascii');
end
