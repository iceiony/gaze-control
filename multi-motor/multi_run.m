try 
%     
    reward_try = [];
    while true
        train;
        file_name = '17_learntGaze.txt';
        reward_try = load(file_name);
        reward_try(end+1,:) = sum_reward_window;
        save(file_name,'reward_try','-ascii');
  
        disp(fprintf('[learning = %d]      ',size(reward_try,1))); 
        
        if size(reward_try,1) == 100 
            break;
        end
    end
    

    reward_try = [];
    while true
        trainRandom;
        file_name = '17_randomGaze.txt';
        
        reward_try = load(file_name);
        reward_try(end+1,:) = sum_reward_window;
        save(file_name,'reward_try','-ascii');
        
        disp(fprintf('[random = %d]      ',size(reward_try,1))); 
        
        if size(reward_try,1) == 100 
            break;
        end
    end
catch exception
    disp(e)
end
    
load handel
sound(y,Fs)