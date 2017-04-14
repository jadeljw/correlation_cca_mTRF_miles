%% sound envelope & EEG cca for Speaker_listener study
% Li Jiawei:  jx_ljw@163.com
% 2016.11.28
% sound envelope & EEG cca
% for Speaker_listener studysound envelope & EEG correlation for Speaker_listener study

%
%% load Listener data
% speaker time -5 to 45s
listener_time_index =  2001:8000; % 5s - 35s
load('E:\DataProcessing\afterICA_data\ISC_all_ref_after_ICA.mat')

%% load sound
sound_time_index =  1001:7000; % 5s - 35s
load('E:\DataProcessing\afterICA_data\SoundResult_0s-35s_200Hz.mat')

%% Channel Index
chn_sel_index= 1:60;

%% attend matrix
load('E:\DataProcessing\ListenA_Or_Not.mat')

%% timelag
timelag = 0:25:500;

% Combine data

for listener = 1 : 12

    % initial
    dataName = strcat('Listener',num2str(listener));
    %     assignin('base',strcat('eeg_A_',dataName),cell(1,15));
    %     assignin('base',strcat('eeg_B_',dataName),cell(1,15));
    %     assignin('base',strcat('audio_A_',dataName),cell(1,15));
    %     assignin('base',strcat('audio_B_',dataName),cell(1,15));

    eval(strcat('eeg_dual_',dataName,'_total=[];'));
%     eval(strcat('eeg_B_',dataName,'_total=[];'));
    eval(strcat('audio_Attend_',dataName,'_total=[];'));
    eval(strcat('audio_notAttend_',dataName,'_total=[];'));

    % Combine data
    for i = 1 : 15

        % EEG
        tempDataA = eval(dataName);
        EEG_all = tempDataA{i};
        EEG_all = EEG_all(chn_sel_index,listener_time_index);
        eval(strcat('eeg_dual_',dataName,'_total=[eeg_dual_',dataName,'_total',' EEG_all]'));

        % audio
        Sound_envelopeA = YA(i,sound_time_index);
        Sound_envelopeB = YB(i,sound_time_index);
        if ListenA_Or_Not(i,listener) == 1 % attend A
            eval(strcat('audio_Attend_',dataName,'_total=[audio_Attend_',dataName,'_total',' Sound_envelopeA]'));
            eval(strcat('audio_notAttend_',dataName,'_total=[audio_notAttend_',dataName,'_total',' Sound_envelopeB]'));
        else
           eval(strcat('audio_Attend_',dataName,'_total=[audio_Attend_',dataName,'_total',' Sound_envelopeB]'));
           eval(strcat('audio_notAttend_',dataName,'_total=[audio_notAttend_',dataName,'_total',' Sound_envelopeA]'));
        end

    end
end

%% load data
load('E:\DataProcessing\correlation_cca_mTRF\audio_all_attend_dual.mat')
load('E:\DataProcessing\correlation_cca_mTRF\audio_all_unattend_dual.mat')
% load('E:\DataProcessing\correlation_cca_mTRF\EEG_all_attend_5s-45s.mat')

for i =  1 : length(timelag)
    %% correlation
    recon_AttendDecoder_attend_cca = zeros(12,15);
    recon_UnattendDecoder_unattend_cca = zeros(12,15);
    recon_AttendDecoder_unattend_cca = zeros(12,15);
    recon_UnattendDecoder_attend_cca = zeros(12,15);
    
    p_recon_AttendDecoder_attend_cca = zeros(12,15);
    p_recon_UnattendDecoder_unattend_cca = zeros(12,15);
    p_recon_AttendDecoder_unattend_cca = zeros(12,15);
    p_recon_UnattendDecoder_attend_cca = zeros(12,15);
    
    for listener = 1 : 12
        
        train_cca_attend_mean = zeros(60,15);
        train_cca_attend_r = zeros(60,15);
        train_cca_unattend_mean = zeros(60,15);
        train_cca_unattend_r = zeros(60,15);
        
        for story = 1 : 15
            
            disp(strcat('Training listener ',num2str(listener),' story ',num2str(story),'...'));
            % predict data -> predict data
            predict_time_index = 6000*(story-1)+1:6000*story;
            story_predict_EEG = eval(strcat('Listener',num2str(listener),'{story}'));
            story_predict_EEG = story_predict_EEG(chn_sel_index,listener_time_index+timelag);
            
            story_predict_audio_A = YA(story,sound_time_index);
            story_predict_audio_B = YB(story,sound_time_index);
            
            % train data
            story_train_EEG = eval(strcat('eeg_dual_Listener',num2str(listener),'_total'));
            story_train_EEG(:,predict_time_index) = [];
            
            story_train_audio_Attend = eval(strcat('audio_Attend_Listener',num2str(listener),'_total'));
            story_train_audio_unAttend = eval(strcat('audio_notAttend_Listener',num2str(listener),'_total'));
            story_train_audio_Attend(:,predict_time_index) = [];
            story_train_audio_unAttend(:,predict_time_index) = [];
            
            
            % cca
            [train_cca_attend_w1,train_cca_attend_w2,train_cca_attend_r] = canoncorr(story_train_EEG',story_train_audio_Attend');
            [train_cca_unattend_w1,train_cca_unattend_w2,train_cca_unattend_r] = canoncorr(story_train_EEG',story_train_audio_unAttend');
            
            % record into one matrix
            train_cca_attend_mean(:,story) = train_cca_attend_w1;
            train_cca_attend_r(:,story) = train_cca_attend_r;
            train_cca_unattend_mean(:,story) = train_cca_unattend_w1;
            train_cca_unattend_r(:,story) = train_cca_unattend_r;
            
            
            
            % predict
            disp(strcat('Predicting listener ',num2str(listener),' story ',num2str(story),'...'));
            reconstruction_audio_attend = train_cca_attend_mean(:,story)' *  story_predict_EEG;
            reconstruction_audio_unattend = train_cca_unattend_mean(:,story)' *  story_predict_EEG;
            
            if ListenA_Or_Not(story,listener) == 1
                [recon_AttendDecoder_attend_cca(listener,story),p_recon_AttendDecoder_attend_cca(listener,story)] =...
                    corr(reconstruction_audio_attend',story_predict_audio_A');
                [recon_AttendDecoder_unattend_cca(listener,story),p_recon_AttendDecoder_unattend_cca(listener,story)] = ...
                    corr(reconstruction_audio_attend',story_predict_audio_B');
                
                [recon_UnattendDecoder_unattend_cca(listener,story),p_recon_UnattendDecoder_unattend_cca(listener,story)] = ...
                    corr(reconstruction_audio_unattend',story_predict_audio_B');
                
                [recon_UnattendDecoder_attend_cca(listener,story),p_recon_UnattendDecoder_attend_cca(listener,story)] = ...
                    corr(reconstruction_audio_unattend',story_predict_audio_A');
            else
                [recon_AttendDecoder_attend_cca(listener,story),p_recon_AttendDecoder_attend_cca(listener,story)] = ...
                    corr(reconstruction_audio_attend',story_predict_audio_B');
                
                [recon_AttendDecoder_unattend_cca(listener,story),p_recon_AttendDecoder_unattend_cca(listener,story)] = ...
                    corr(reconstruction_audio_attend',story_predict_audio_A');
                
                [recon_UnattendDecoder_unattend_cca(listener,story),p_recon_UnattendDecoder_unattend_cca(listener,story)] = ...
                    corr(reconstruction_audio_unattend',story_predict_audio_A');
                
                [recon_UnattendDecoder_attend_cca(listener,story),p_recon_UnattendDecoder_attend_cca(listener,story)] = ...
                    corr(reconstruction_audio_unattend',story_predict_audio_B');
            end
            
            
        end
    end
end