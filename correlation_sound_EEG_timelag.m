%% sound envelope & EEG correlation for Speaker_listener study
% Li Jiawei:  jx_ljw@163.com
% 2016.11.28
% sound envelope & EEG correlation for Speaker_listener studysound envelope & EEG correlation for Speaker_listener study

%

%% band name 
band_name = ' theta';
% 2 - 8 Hz for theta analysis
%% load Listener data
% speaker time -5 to 45s
listener_time_index =  2001:8000; % 5s - 35s
% load('E:\DataProcessing\afterICA_data\ISC_all_ref_after_ICA.mat') % boradband
load('E:\DataProcessing\afterICA_data\ISC_all_ref_after_ICA_2-8Hz.mat') % 2-8Hz
%% load sound
sound_time_index =  1001:7000; % 5s - 35s
% load('E:\DataProcessing\afterICA_data\SoundResult_0s-35s_200Hz.mat')
load('E:\DataProcessing\afterICA_data\SoundResult_0s-35s_8Hz.mat') % lowpass 8 Hz

%% Channel Index
chn_sel_index= 1:60;

%% attend matrix
load('E:\DataProcessing\ListenA_Or_Not.mat')

%% timelag
timelag = 0:5:100; % Fs = 200Hz 
% 1 point = 5 ms 


for j = 1 : length(timelag)
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
            story_predict_EEG = story_predict_EEG(chn_sel_index,listener_time_index+timelag(j));
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
                    story_train_EEG = story_train_EEG(chn_sel_index,listener_time_index+timelag(j));
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
    
    
    %% plot
    % reconstruction accuracy plot attend
    figure; plot(mean(recon_AttendDecoder_attend_corr,2),'r');
    hold on; plot(mean(recon_AttendDecoder_unattend_corr,2),'b');
    xlabel('Subject No.'); ylabel('r value')
    saveName1 = strcat('Reconstruction Accuracy using correlation method for attend decoder+',num2str(5*timelag(j)),'ms',band_name,'.jpg');
    title(saveName1(1:end-4));
    legend('Audio attend ','Audio not Attend')
    saveas(gcf,saveName1);
    close
    
    % reconstruction accuracy plot unattend
    figure; plot(mean(recon_UnattendDecoder_attend_corr,2),'r');
    hold on; plot(mean(recon_UnattendDecoder_unattend_corr,2),'b');
    xlabel('Subject No.'); ylabel('r value')
    saveName2 = strcat('Reconstruction Accuracy using correlation method for unattend decoder+',num2str(5*timelag(j)),'ms',band_name,'.jpg');
    title(saveName2(1:end-4));
    legend('Audio attend ','Audio not Attend')
    saveas(gcf,saveName2);
    close
    
    % Decoding accuracy plot attend
    Decoding_result_attend_decoder = recon_AttendDecoder_attend_corr-recon_AttendDecoder_unattend_corr;
    Individual_subjects_result_attend = sum(Decoding_result_attend_decoder>0,2)/15;
    mean(Individual_subjects_result_attend)
    Decoding_result_unattend_decoder = recon_UnattendDecoder_unattend_corr-recon_UnattendDecoder_attend_corr;
    Individual_subjects_result_unattend = sum(Decoding_result_unattend_decoder>0,2)/15;
    mean(Individual_subjects_result_unattend)
    figure; plot(Individual_subjects_result_attend*100,'r');
    hold on; plot(Individual_subjects_result_unattend*100,'b');
    xlabel('Subject No.'); ylabel('Decoding Accuarcy %');ylim([0,100]);
    saveName3 = strcat('Decoding accuracy using correlation method for attend and unattend decoder+',num2str(5*timelag(j)),'ms',band_name,'.jpg');
    title(saveName3(1:end-4))
    legend('Attend Decoder','Unattend Decoder')
    saveas(gcf,saveName3);
    close
    
    saveName = strcat('Corr_sound_EEG_result+',num2str(5*timelag(j)),'ms',band_name,'.mat');
    save(saveName,'recon_AttendDecoder_attend_corr','recon_UnattendDecoder_unattend_corr' ,'recon_AttendDecoder_unattend_corr','recon_UnattendDecoder_attend_corr',...
            'p_recon_AttendDecoder_attend_corr','p_recon_UnattendDecoder_unattend_corr', 'p_recon_AttendDecoder_unattend_corr','p_recon_UnattendDecoder_attend_corr');
    
end