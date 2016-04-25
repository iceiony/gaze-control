try 
     
    reward_try = [];
    gazeCount_try = [];
    while true
        trainTimelessGaze;
        file_name = '1_learntGazeTimeless.txt';
        reward_try = load(file_name);
        reward_try(end+1,:) = sum_reward_window;
        save(file_name,'reward_try','-ascii');
        
        file_name = '1_gazeCountLearnt.txt';
        gazeCount_try = load(file_name);
        gazeCount_try(end+1,:) = gaze_count_window;
        save(file_name,'gazeCount_try','-ascii');
  
        disp(fprintf('[learning = %d]      ',size(reward_try,1))); 
        
        if size(reward_try,1) == 20 
            break;
        end
    end
    

    reward_try = [];
    gazeCount_try = [];
    while true
        trainRandomTimelessGaze;
        file_name = '1_randomGazeTimeless.txt';
        reward_try = load(file_name);
        reward_try(end+1,:) = sum_reward_window;
        save(file_name,'reward_try','-ascii');
        
        file_name = '1_gazeCountRandom.txt';
        gazeCount_try = load(file_name);
        gazeCount_try(end+1,:) = gaze_count_window;
        save(file_name,'gazeCount_try','-ascii');
        
        disp(fprintf('[random = %d]      ',size(reward_try,1))); 
        
        if size(reward_try,1) == 20 
            break;
        end
    end
catch exception
    disp(exception)
end
