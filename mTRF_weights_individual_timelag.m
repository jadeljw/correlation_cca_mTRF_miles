%% sound envelope & EEG mTR for Speaker_listener study
% Li Jiawei:  jx_ljw@163.com
% 2016.12.15
% sound envelope & EEG cca
% for Speaker_listener studysound envelope & EEG correlation for Speaker_listener study


%% band name
band_name = ' 64Hz 10s-35s';
% 2 - 8 Hz for theta analysis

%% load data
% load('E:\DataProcessing\correlation_cca_mTRF\mTRF\mTRF_sound_EEG_result-weights_64Hz_-250ms-500ms.mat')
load('E:\DataProcessing\correlation_cca_mTRF\mTRF\mTRF_sound_EEG_result-weights_cons_64Hz_-250ms-500ms.mat')

% %% time
% t_weights =  -fliplr(t_train_mTRF_attend);

%% initial
% speaker time -5 to 45s
Fs = 64;
start_time = 10;
end_time = 35;


timelag = (-250:500/32:500)/(1000/Fs);
%% load listener data
listener_time_index =  (start_time+5)*Fs+1:(end_time+5)*Fs; % 10 s - 35s
load('E:\DataProcessing\afterICA_data\ISC_all_ref_after_ICA_64Hz.mat')

%% load sound
sound_time_index =  start_time*Fs+1:end_time*Fs; % 10 s - 35s
load('E:\DataProcessing\afterICA_data\SoundResult_0s-35s_64Hz.mat')

%% Channel Index
chn_sel_index= 1:60;

%% attend matrix
load('E:\DataProcessing\ListenA_Or_Not.mat')


%% mTRF predict
for j = 1 : length(t_train_mTRF_attend)
    
    mTRF_start_time = -t_train_mTRF_attend(j);
    mTRF_end_time = -t_train_mTRF_attend(j);

    
    
    recon_AttendDecoder_attend_corr = zeros(12,15);
    recon_UnattendDecoder_unattend_corr = zeros(12,15);
    recon_AttendDecoder_unattend_corr = zeros(12,15);
    recon_UnattendDecoder_attend_corr = zeros(12,15);
    
    p_recon_AttendDecoder_attend_corr = zeros(12,15);
    p_recon_UnattendDecoder_unattend_corr = zeros(12,15);
    p_recon_AttendDecoder_unattend_corr = zeros(12,15);
    p_recon_UnattendDecoder_attend_corr = zeros(12,15);
    
    MSE_recon_AttendDecoder_attend_corr = zeros(12,15);
    MSE_recon_UnattendDecoder_unattend_corr = zeros(12,15);
    MSE_recon_AttendDecoder_unattend_corr = zeros(12,15);
    MSE_recon_UnattendDecoder_attend_corr = zeros(12,15);
    
    recon_AttendDecoder_attend_corr_train = zeros(14,12,15);
    recon_UnattendDecoder_unattend_corr_train = zeros(14,12,15);
    recon_AttendDecoder_unattend_corr_train = zeros(14,12,15);
    recon_UnattendDecoder_attend_corr_train = zeros(14,12,15);
    
    p_recon_AttendDecoder_attend_corr_train = zeros(14,12,15);
    p_recon_UnattendDecoder_unattend_corr_train = zeros(14,12,15);
    p_recon_AttendDecoder_unattend_corr_train = zeros(14,12,15);
    p_recon_UnattendDecoder_attend_corr_train = zeros(14,12,15);
    
    MSE_recon_AttendDecoder_attend_corr_train = zeros(14,12,15);
    MSE_recon_UnattendDecoder_unattend_corr_train = zeros(14,12,15);
    MSE_recon_AttendDecoder_unattend_corr_train = zeros(14,12,15);
    MSE_recon_UnattendDecoder_attend_corr_train = zeros(14,12,15);
    
    
    for listener = 1 : 12
        for story = 1 : 15
            w_attend_temp = train_mTRF_attend_w_total{listener,story}(:,j);
            w_unattend_temp = train_mTRF_unattend_w_total{listener,story}(:,j);
            con_attend_temp = train_mTRF_attend_con_total{listener,story};
            con_unattend_temp = train_mTRF_unattend_con_total{listener,story};
            
            % Train story
            disp(strcat('Training listener ',num2str(listener),' story ',num2str(story),'...'));
            
            cnt_train_story = 1;
            for train_story = 1 : 15
                if train_story ~= story
                    story_train_EEG = eval(strcat('Listener',num2str(listener),'{train_story}'));
                    story_train_EEG = story_train_EEG(chn_sel_index,listener_time_index);
                    story_train_audio_A = YA(train_story,sound_time_index);
                    story_train_audio_B = YB(train_story,sound_time_index);
                    
                    % apply weights to individual story
                    
                    if ListenA_Or_Not(train_story,listener) == 1
                        [recon_audio_attend_AttendDecoder_train,recon_AttendDecoder_attend_corr_train(cnt_train_story,listener,story),p_recon_AttendDecoder_attend_corr_train(cnt_train_story,listener,story),MSE_recon_AttendDecoder_attend_corr_train(cnt_train_story,listener,story)] =...
                            mTRFpredict(story_train_audio_A',story_train_EEG',w_attend_temp,Fs,1,mTRF_start_time,mTRF_end_time,con_attend_temp);
                        
                        [recon_audio_attend_unAttendDecoder_train,recon_AttendDecoder_unattend_corr_train(cnt_train_story,listener,story),p_recon_AttendDecoder_unattend_corr_train(cnt_train_story,listener,story),MSE_recon_AttendDecoder_unattend_corr_train(cnt_train_story,listener,story)] =...
                            mTRFpredict(story_train_audio_A',story_train_EEG',w_unattend_temp,Fs,1,mTRF_start_time,mTRF_end_time,con_attend_temp);
                        
                        [recon_audio_unattend_unAttendDecoder_train,recon_UnattendDecoder_unattend_corr_train(cnt_train_story,listener,story),p_recon_UnattendDecoder_unattend_corr_train(cnt_train_story,listener,story),MSE_recon_UnattendDecoder_unattend_corr_train(cnt_train_story,listener,story)] =...
                            mTRFpredict(story_train_audio_B',story_train_EEG',w_unattend_temp,Fs,1,mTRF_start_time,mTRF_end_time,con_unattend_temp);
                        
                        [recon_audio_unattend_AttendDecoder_train,recon_UnattendDecoder_attend_corr_train(cnt_train_story,listener,story),p_recon_UnattendDecoder_attend_corr_train(cnt_train_story,listener,story),MSE_recon_UnattendDecoder_attend_corr_train(cnt_train_story,listener,story)] =...
                            mTRFpredict(story_train_audio_B',story_train_EEG',w_attend_temp,Fs,1,mTRF_start_time,mTRF_end_time,con_unattend_temp);
                        
                    else
                        [recon_audio_attend_AttendDecoder_train,recon_AttendDecoder_attend_corr_train(cnt_train_story,listener,story),p_recon_AttendDecoder_attend_corr_train(cnt_train_story,listener,story),MSE_recon_AttendDecoder_attend_corr_train(cnt_train_story,listener,story)] =...
                            mTRFpredict(story_train_audio_B',story_train_EEG',w_attend_temp,Fs,1,mTRF_start_time,mTRF_end_time,con_attend_temp);
                        
                        [recon_audio_attend_unAttendDecoder_train,recon_AttendDecoder_unattend_corr_train(cnt_train_story,listener,story),p_recon_AttendDecoder_unattend_corr(listener,story),MSE_recon_AttendDecoder_unattend_corr(listener,story)] =...
                            mTRFpredict(story_train_audio_B',story_train_EEG',w_unattend_temp,Fs,1,mTRF_start_time,mTRF_end_time,con_attend_temp);
                        
                        [recon_audio_unattend_unAttendDecoder_train,recon_UnattendDecoder_unattend_corr_train(cnt_train_story,listener,story),p_recon_UnattendDecoder_unattend_corr(listener,story),MSE_recon_UnattendDecoder_unattend_corr(listener,story)] =...
                            mTRFpredict(story_train_audio_A',story_train_EEG',w_unattend_temp,Fs,1,mTRF_start_time,mTRF_end_time,con_unattend_temp);
                        
                        [recon_audio_unattend_AttendDecoder_train,recon_UnattendDecoder_attend_corr_train(cnt_train_story,listener,story),p_recon_UnattendDecoder_attend_corr(listener,story),MSE_recon_UnattendDecoder_attend_corr(listener,story)] =...
                            mTRFpredict(story_train_audio_A',story_train_EEG',w_attend_temp,Fs,1,mTRF_start_time,mTRF_end_time,con_unattend_temp);
                        
                    end
                    
                    cnt_train_story = cnt_train_story + 1;
                end
                
            end
            
            % Predict story
            
            disp(strcat('Predicting listener ',num2str(listener),' story ',num2str(story),'...'));
            predict_time_index = length(listener_time_index)*(story-1)+1:length(listener_time_index)*story;
            story_predict_EEG = eval(strcat('Listener',num2str(listener),'{story}'));
            story_predict_EEG = story_predict_EEG(chn_sel_index,listener_time_index);
            
            story_predict_audio_A = YA(story,sound_time_index);
            story_predict_audio_B = YB(story,sound_time_index);
            if ListenA_Or_Not(story,listener) == 1
                [recon_audio_attend_AttendDecoder,recon_AttendDecoder_attend_corr(listener,story),p_recon_AttendDecoder_attend_corr(listener,story),MSE_recon_AttendDecoder_attend_corr(listener,story)] =...
                    mTRFpredict(story_predict_audio_A',story_predict_EEG',w_attend_temp,Fs,1,mTRF_start_time,mTRF_end_time,con_attend_temp);
                
                [recon_audio_attend_unAttendDecoder,recon_AttendDecoder_unattend_corr(listener,story),p_recon_AttendDecoder_unattend_corr(listener,story),MSE_recon_AttendDecoder_unattend_corr(listener,story)] =...
                    mTRFpredict(story_predict_audio_A',story_predict_EEG',w_unattend_temp,Fs,1,mTRF_start_time,mTRF_end_time,con_attend_temp);
                
                [recon_audio_unattend_unAttendDecoder,recon_UnattendDecoder_unattend_corr(listener,story),p_recon_UnattendDecoder_unattend_corr(listener,story),MSE_recon_UnattendDecoder_unattend_corr(listener,story)] =...
                    mTRFpredict(story_predict_audio_B',story_predict_EEG',w_unattend_temp,Fs,1,mTRF_start_time,mTRF_end_time,con_unattend_temp);
                
                [recon_audio_unattend_AttendDecoder,recon_UnattendDecoder_attend_corr(listener,story),p_recon_UnattendDecoder_attend_corr(listener,story),MSE_recon_UnattendDecoder_attend_corr(listener,story)] =...
                    mTRFpredict(story_predict_audio_B',story_predict_EEG',w_attend_temp,Fs,1,mTRF_start_time,mTRF_end_time,con_unattend_temp);
                
            else
                [recon_audio_attend_AttendDecoder,recon_AttendDecoder_attend_corr(listener,story),p_recon_AttendDecoder_attend_corr(listener,story),MSE_recon_AttendDecoder_attend_corr(listener,story)] =...
                    mTRFpredict(story_predict_audio_B',story_predict_EEG',w_attend_temp,Fs,1,mTRF_start_time,mTRF_end_time,con_attend_temp);
                
                [recon_audio_attend_unAttendDecoder,recon_AttendDecoder_unattend_corr(listener,story),p_recon_AttendDecoder_unattend_corr(listener,story),MSE_recon_AttendDecoder_unattend_corr(listener,story)] =...
                    mTRFpredict(story_predict_audio_B',story_predict_EEG',w_unattend_temp,Fs,1,mTRF_start_time,mTRF_end_time,con_attend_temp);
                
                [recon_audio_unattend_unAttendDecoder,recon_UnattendDecoder_unattend_corr(listener,story),p_recon_UnattendDecoder_unattend_corr(listener,story),MSE_recon_UnattendDecoder_unattend_corr(listener,story)] =...
                    mTRFpredict(story_predict_audio_A',story_predict_EEG',w_unattend_temp,Fs,1,mTRF_start_time,mTRF_end_time,con_unattend_temp);
                
                [recon_audio_unattend_AttendDecoder,recon_UnattendDecoder_attend_corr(listener,story),p_recon_UnattendDecoder_attend_corr(listener,story),MSE_recon_UnattendDecoder_attend_corr(listener,story)] =...
                    mTRFpredict(story_predict_audio_A',story_predict_EEG',w_attend_temp,Fs,1,mTRF_start_time,mTRF_end_time,con_unattend_temp);
                
            end
            
        end
    end
    
    % save
    saveName = strcat('mTRF_sound_EEG_result+',num2str(-t_train_mTRF_attend(j)),'ms',band_name,'.mat');
    save(saveName,'recon_AttendDecoder_attend_corr','recon_UnattendDecoder_unattend_corr' ,'recon_AttendDecoder_unattend_corr','recon_UnattendDecoder_attend_corr',...
        'p_recon_AttendDecoder_attend_corr','p_recon_UnattendDecoder_unattend_corr', 'p_recon_AttendDecoder_unattend_corr','p_recon_UnattendDecoder_attend_corr',...
        'recon_AttendDecoder_attend_corr_train','recon_UnattendDecoder_unattend_corr_train' ,'recon_AttendDecoder_unattend_corr_train','recon_UnattendDecoder_attend_corr_train',...
        'p_recon_AttendDecoder_attend_corr_train','p_recon_UnattendDecoder_unattend_corr_train', 'p_recon_AttendDecoder_unattend_corr_train','p_recon_UnattendDecoder_attend_corr_train');
    
    %plot
    % reconstruction accuracy plot attend
    figure; plot(mean(recon_AttendDecoder_attend_corr,2),'r');
    hold on; plot(mean(recon_AttendDecoder_unattend_corr,2),'b');
    xlabel('Subject No.'); ylabel('r value')
    title('Reconstruction Accuracy using corr method for attend decoder');
    legend('Audio attend ','Audio not Attend')
    saveName1 = strcat('Reconstruction Accuracy using mTRF method for attend decoder+',num2str(-t_train_mTRF_attend(j)),'ms',band_name,'.jpg');
    title(saveName1(1:end-4));
    legend('Audio attend ','Audio not Attend')
    saveas(gcf,saveName1);
    close
    
    % reconstruction accuracy plot unattend
    figure; plot(mean(recon_UnattendDecoder_attend_corr,2),'r');
    hold on; plot(mean(recon_UnattendDecoder_unattend_corr,2),'b');
    xlabel('Subject No.'); ylabel('r value')
    saveName2 = strcat('Reconstruction Accuracy using mTRF method for unattend decoder+',num2str(-t_train_mTRF_attend(j)),'ms',band_name,'.jpg');
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
    saveName3 = strcat('Decoding accuracy using mTRF method for attend and unattend decoder+',num2str(-t_train_mTRF_attend(j)),'ms',band_name,'.jpg');
    title(saveName3(1:end-4))
    legend('Attend Decoder','Unattend Decoder')
    saveas(gcf,saveName3);
    close
    
    
%     %reconstruction accuracy
%     recon_AttendDecoder_attend_total(j) =  mean(mean(recon_AttendDecoder_attend_corr));
%     recon_AttendDecoder_unattend_total(j) =  mean(mean(recon_AttendDecoder_unattend_corr));
%     recon_UnattendDecoder_attend_total(j) = mean(mean(recon_UnattendDecoder_attend_corr));
%     recon_UnattendDecoder_unattend_total(j) = mean(mean(recon_UnattendDecoder_unattend_corr));
%     
%     %decoding accuracy
%     Decoding_result_attend_decoder = recon_AttendDecoder_attend_corr-recon_AttendDecoder_unattend_corr;
%     Individual_subjects_result_attend = sum(Decoding_result_attend_decoder>0,2)/15;
%     decoding_acc_attended(j)= mean(Individual_subjects_result_attend);
%     
%     Decoding_result_unattend_decoder = recon_UnattendDecoder_unattend_corr-recon_UnattendDecoder_attend_corr;
%     Individual_subjects_result_unattend = sum(Decoding_result_unattend_decoder>0,2)/15;
%     decoding_acc_unattended(j) = mean(Individual_subjects_result_unattend);
%     
    
    
    
end



