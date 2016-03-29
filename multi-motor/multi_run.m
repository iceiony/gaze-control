try 
    
    reward_try = [];
    for i = 1 : 5
        train;
        file_name = '13_learntGaze.txt';
        reward_try = load(file_name);
        reward_try(end+1,:) = sum_reward_window;
        save(file_name,'reward_try','-ascii');
    end
    

    reward_try = [];
    for i = 1 : 2
        
        trainRandom;
        file_name = '13_randomGaze.txt';
        
        
        reward_try = load(file_name);
        reward_try(end+1,:) = sum_reward_window;
        save(file_name,'reward_try','-ascii');
    end
catch exception
end
    
load handel
sound(y,Fs)