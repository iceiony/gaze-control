try 
%     
    reward_try = [];
    for i = 1 : 100
        train;
        file_name = '17_learntGaze.txt';
        reward_try = load(file_name);
        reward_try(end+1,:) = sum_reward_window;
        save(file_name,'reward_try','-ascii');
    end
    

    reward_try = [];
    for i = 1 : 100
        
        trainRandom;
        file_name = '17_randomGaze.txt';
        
        reward_try = load(file_name);
        reward_try(end+1,:) = sum_reward_window;
        save(file_name,'reward_try','-ascii');
    end
catch exception
    disp(e)
end
    
load handel
sound(y,Fs)