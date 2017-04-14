%% sound envelope & EEG correlation for Speaker_listener study
% Li Jiawei:  jx_ljw@163.com
% 2016.11.28
% sound envelope & EEG correlation for Speaker_listener studysound envelope & EEG correlation for Speaker_listener study

%

%% band name 
band_name = '_theta';
% 2 - 8 Hz for theta analysis
%% load Listener data
% speaker time -5 to 45s
listener_time_index =  2001:8000; % 5s - 35s
load('E:\DataProcessing\afterICA_data\ISC_all_ref_after_ICA_2-8Hz.mat')

%% load sound
sound_time_index =  1001:7000; % 5s - 35s
load('E:\DataProcessing\afterICA_data\SoundResult_0s-35s_8Hz.mat')

%% Channel Index
chn_sel_index= 1:60;

%% attend matrix
load('E:\DataProcessing\ListenA_Or_Not.mat')

%% timelag
timelag = 0;

%% correlation
recon_AttendDecoder_attend_corr = zeros(12,15);
recon_UnattendDecoder_unattend_corr = zeros(12,15);
recon_AttendDecoder_unattend_corr = zeros(12,15);
recon_UnattendDecoder_attend_corr = zeros(12,15);
p_recon_AttendDecoder_attend_corr = zeros(12,15);
p_recon_UnattendDecoder_unattend_corr = zeros(12,15);
p_recon_AttendDecoder_unattend_corr = zeros(12,15);
p_recon_UnattendDecoder_attend_corr = zeros(12,15);

for listener = 1 : 12
    
    train_corr_attend_mean = zeros(60,15);
    train_corr_unattend_mean = zeros(60,15);
    
    for story = 1 : 15
        disp(strcat('Training listener ',num2str(listener),' story ',num2str(story),'...'));
        
        % predict data -> predict data
        story_predict_EEG = eval(strcat('Listener',num2str(listener),'{story}'));
        story_predict_EEG = story_predict_EEG(chn_sel_index,listener_time_index);
        story_predict_audio_A = YA(story,sound_time_index);
        story_predict_audio_B = YB(story,sound_time_index);
        
        % train data
        train_corr_attend = zeros(60,14);
        train_corr_unattend = zeros(60,14);
        temp_index = 0;
        
        for train_story = 1 : 15
             
            if train_story ~= story
                temp_index = temp_index + 1;
                story_train_EEG = eval(strcat('Listener',num2str(listener),'{train_story}'));
                story_train_EEG = story_train_EEG(chn_sel_index,listener_time_index);
                story_train_audio_A = YA(train_story,sound_time_index);
                story_train_audio_B = YB(train_story,sound_time_index);
                
                
                corr_attend_temp = zeros(60,1);
                corr_unattend_temp = zeros(60,1);
                
                % correlation for every chnnal
                for chn = 1:60
                    
                    if ListenA_Or_Not(train_story,listener) == 1
                        corr_attend_temp(chn) = corr(story_train_EEG(chn,:)',story_train_audio_A');
                        corr_unattend_temp(chn)  = corr(story_train_EEG(chn,:)',story_train_audio_B');
                    else
                        corr_attend_temp(chn)  = corr(story_train_EEG(chn,:)',story_train_audio_B');
                        corr_unattend_temp(chn)  = corr(story_train_EEG(chn,:)',story_train_audio_A');
                    end
                    
                    train_corr_attend(chn,temp_index) = corr_attend_temp(chn);
                    train_corr_unattend(chn,temp_index) = corr_unattend_temp(chn);
                    
                end
            end
            
            % average
            train_corr_attend_mean(:,story) = mean(train_corr_attend,2);
            train_corr_unattend_mean(:,story) = mean(train_corr_unattend,2);
                
        end
        
        % predict
        disp(strcat('Predicting listener ',num2str(listener),' story ',num2str(story),'...'));
        reconstruction_audio_attend = train_corr_attend_mean(:,story)' *  story_predict_EEG;
        reconstruction_audio_unattend = train_corr_unattend_mean(:,story)' *  story_predict_EEG;
        
        if ListenA_Or_Not(story,listener) == 1
            [recon_AttendDecoder_attend_corr(listener,story),p_recon_AttendDecoder_attend_corr(listener,story)] =...
            corr(reconstruction_audio_attend',story_predict_audio_A');
            [recon_AttendDecoder_unattend_corr(listener,story),p_recon_AttendDecoder_unattend_corr(listener,story)] = ...
            corr(reconstruction_audio_attend',story_predict_audio_B');
        
            [recon_UnattendDecoder_unattend_corr(listener,story),p_recon_UnattendDecoder_unattend_corr(listener,story)] = ...
            corr(reconstruction_audio_unattend',story_predict_audio_B');
        
            [recon_UnattendDecoder_attend_corr(listener,story),p_recon_UnattendDecoder_attend_corr(listener,story)] = ...
            corr(reconstruction_audio_unattend',story_predict_audio_A');
        else
            [recon_AttendDecoder_attend_corr(listener,story),p_recon_AttendDecoder_attend_corr(listener,story)] = ...
            corr(reconstruction_audio_attend',story_predict_audio_B');
        
            [recon_AttendDecoder_unattend_corr(listener,story),p_recon_AttendDecoder_unattend_corr(listener,story)] = ...
            corr(reconstruction_audio_attend',story_predict_audio_A');
        
            [recon_UnattendDecoder_unattend_corr(listener,story),p_recon_UnattendDecoder_unattend_corr(listener,story)] = ...
            corr(reconstruction_audio_unattend',story_predict_audio_A');
        
            [recon_UnattendDecoder_attend_corr(listener,story),p_recon_UnattendDecoder_attend_corr(listener,story)] = ...
            corr(reconstruction_audio_unattend',story_predict_audio_B');
        end
        
        
    end
end