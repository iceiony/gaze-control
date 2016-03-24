% reward_try = [];
% for i = 1 : 10
%     train;
%     reward_try = load('4_learntGaze.txt');
%     reward_try(end+1,:) = sum_reward_window;
%     save('4_learntGaze.txt','reward_try','-ascii');
% end


reward_try = [];
for i = 1 : 10
    trainRandom;
    reward_try = load('4_randomGaze.txt');
    reward_try(end+1,:) = sum_reward_window;
    save('4_randomGaze.txt','reward_try','-ascii');
end
