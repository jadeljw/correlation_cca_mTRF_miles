%% sound envelope & EEG mTR for Speaker_listener study
% Li Jiawei:  jx_ljw@163.com
% 2016.11.28
% sound envelope & EEG cca
% for Speaker_listener studysound envelope & EEG correlation for Speaker_listener study

%
%% band name
band_name = '  ';
% 2 - 8 Hz for theta analysis

%% load Listener data
% speaker time -5 to 45s
% listener_time_index =  2001:8000; % 5s - 35s
listener_time_index =  3001:8000; % 5s - 35s
load('E:\DataProcessing\afterICA_data\ISC_all_ref_after_ICA.mat')
% load('E:\DataProcessing\afterICA_data\ISC_all_ref_after_ICA_2-8Hz.mat')

%% load sound
% sound_time_index =  1001:7000; % 5s - 35s
sound_time_index =  2001:7000; % 10s - 35s
load('E:\DataProcessing\afterICA_data\SoundResult_0s-35s_200Hz.mat')
% load('E:\DataProcessing\afterICA_data\SoundResult_0s-35s_8Hz.mat')

%% Channel Index
chn_sel_index= 1:60;

%% attend matrix
load('E:\DataProcessing\ListenA_Or_Not.mat')

%% timelag
timelag = -200:25:500;
% timelag = 0;
%% Combine data
%
% for listener = 1 : 12
%
%     % initial
%     dataName = strcat('Listener',num2str(listener));
%     %     assignin('base',strcat('eeg_A_',dataName),cell(1,15));
%     %     assignin('base',strcat('eeg_B_',dataName),cell(1,15));
%     %     assignin('base',strcat('audio_A_',dataName),cell(1,15));
%     %     assignin('base',strcat('audio_B_',dataName),cell(1,15));
%
%     eval(strcat('eeg_dual_',dataName,'_total=[];'));
% %     eval(strcat('eeg_B_',dataName,'_total=[];'));
%     eval(strcat('audio_Attend_',dataName,'_total=[];'));
%     eval(strcat('audio_notAttend_',dataName,'_total=[];'));
%
%     % Combine data
%     for i = 1 : 15
%
%         % EEG
%         tempDataA = eval(dataName);
%         EEG_all = tempDataA{i};
%         EEG_all = EEG_all(chn_sel_index,listener_time_index);
%         eval(strcat('eeg_dual_',dataName,'_total=[eeg_dual_',dataName,'_total',' EEG_all]'));
%
%         % audio
%         Sound_envelopeA = YA(i,sound_time_index);
%         Sound_envelopeB = YB(i,sound_time_index);
%         if ListenA_Or_Not(i,listener) == 1 % attend A
%             eval(strcat('audio_Attend_',dataName,'_total=[audio_Attend_',dataName,'_total',' Sound_envelopeA]'));
%             eval(strcat('audio_notAttend_',dataName,'_total=[audio_notAttend_',dataName,'_total',' Sound_envelopeB]'));
%         else
%            eval(strcat('audio_Attend_',dataName,'_total=[audio_Attend_',dataName,'_total',' Sound_envelopeB]'));
%            eval(strcat('audio_notAttend_',dataName,'_total=[audio_notAttend_',dataName,'_total',' Sound_envelopeA]'));
%         end
%
%     end
% end

%% load data
% load('E:\DataProcessing\correlation_cca_mTRF\audio_all_attend_dual_2-8Hz.mat')
% load('E:\DataProcessing\correlation_cca_mTRF\audio_all_unattend_dual_2-8Hz.mat')
% load('E:\DataProcessing\correlation_cca_mTRF\EEG_all_attend_5s-45s_2-8Hz.mat')

load('E:\DataProcessing\correlation_cca_mTRF\audio_all_attend_dual.mat')
load('E:\DataProcessing\correlation_cca_mTRF\audio_all_unattend_dual.mat')
load('E:\DataProcessing\correlation_cca_mTRF\EEG_all_attend_5s-45s.mat')

for j = 1 : length(timelag)
    %% mTRF
    
    Fs = 200;
    start_time = 0 + timelag(j);
    end_time = 25 + timelag(j);
    % recon_attend_corr = zeros(12,15);
    % recon_unattend_corr = zeros(12,15);
    % p_attend = zeros(12,15);
    % p_unattend = zeros(12,15);
    %
    % MSE_attend = zeros(12,15);
    % MSE_unattend = zeros(12,15);
    
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
    
    % train matrix
    recon_AttendDecoder_attend_corr_train = zeros(14,12,15); % training story numbers, listener, story
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
        
        %     train_mTRF_attend_w_total = zeros(60,15);
        %     train_mTRF_attend_t_total = zeros(60,15);
        %     train_mTRF_attend_con_total = zeros(60,15);
        %
        %     train_mTRF_unattend_w_total = zeros(60,15);
        %     train_mTRF_unattend_t_total = zeros(60,15);
        %     train_mTRF_unattend_con_total = zeros(60,15);
        
        for story = 1 : 15
            % predict data -> predict data
            disp(strcat('Training listener ',num2str(listener),' story ',num2str(story),'...'));
            
            predict_time_index = length(listener_time_index)*(story-1)+1:length(listener_time_index)*story;
            story_predict_EEG = eval(strcat('Listener',num2str(listener),'{story}'));
            story_predict_EEG = story_predict_EEG(chn_sel_index,listener_time_index);
            
            story_predict_audio_A = YA(story,sound_time_index);
            story_predict_audio_B = YB(story,sound_time_index);
            
            % train data
            story_train_EEG = eval(strcat('eeg_dual_Listener',num2str(listener),'_total'));
            story_train_EEG(:,predict_time_index) = [];
            
            story_train_audio_Attend = eval(strcat('audio_Attend_Listener',num2str(listener),'_total'));
            story_train_audio_unAttend = eval(strcat('audio_notAttend_Listener',num2str(listener),'_total'));
            story_train_audio_Attend(:,predict_time_index) = [];
            story_train_audio_unAttend(:,predict_time_index) = [];
            
            
            % mTRF
            [w_train_mTRF_attend,t_train_mTRF_attend,con_train_mTRF_attend] = mTRFtrain(story_train_audio_Attend',story_train_EEG',Fs,1,start_time,end_time,0.1);
            [w_train_mTRF_unattend,t_train_mTRF_unattend,con_train_mTRF_unattend] = mTRFtrain(story_train_audio_unAttend',story_train_EEG',Fs,1,start_time,end_time,0.1);
            
            %         % record into one matrix
            %         train_mTRF_attend_w_total(:,story) = w_train_mTRF_attend;
            %         train_mTRF_attend_t_total(:,story) = t_train_mTRF_attend;
            %         train_mTRF_attend_con_total(:,story) = con_train_mTRF_attend;
            %         train_mTRF_unattend_w_total(:,story) = w_train_mTRF_unattend;
            %         train_mTRF_unattend_t_total(:,story) = t_train_mTRF_unattend;
            %         train_mTRF_unattend_con_total(:,story) = con_train_mTRF_unattend;
            
            % apply to individual data
            cnt_train_story = 1;
            for train_story = 1 : 15
                if train_story ~= story
                    story_train_EEG = eval(strcat('Listener',num2str(listener),'{train_story}'));
                    story_train_EEG = story_train_EEG(chn_sel_index,listener_time_index);
                    story_train_audio_A = YA(train_story,sound_time_index);
                    story_train_audio_B = YB(train_story,sound_time_index);
                    
                    % apply weights to individual story
%                     reconstruction_audio_attend = train_cca_attend_mean(:,story)' *  story_train_EEG;
%                     reconstruction_audio_unattend = train_cca_unattend_mean(:,story)' *  story_train_EEG;
                    
                    %                     if ListenA_Or_Not(train_story,listener) == 1
                    %                         [recon_AttendDecoder_attend_corr_train(cnt_train_story,listener,story),p_recon_AttendDecoder_attend_corr_train(cnt_train_story,listener,story)] =...
                    %                             corr(reconstruction_audio_attend',story_train_audio_A');
                    %                         [recon_AttendDecoder_unattend_corr_train(cnt_train_story,listener,story),p_recon_AttendDecoder_unattend_corr_train(cnt_train_story,listener,story)] = ...
                    %                             corr(reconstruction_audio_attend',story_train_audio_B');
                    %
                    %                         [recon_UnattendDecoder_unattend_corr_train(cnt_train_story,listener,story),p_recon_UnattendDecoder_unattend_corr_train(cnt_train_story,listener,story)] = ...
                    %                             corr(reconstruction_audio_unattend',story_train_audio_B');
                    %
                    %                         [recon_UnattendDecoder_attend_corr_train(cnt_train_story,listener,story),p_recon_UnattendDecoder_attend_corr_train(cnt_train_story,listener,story)] = ...
                    %                             corr(reconstruction_audio_unattend',story_train_audio_A');
                    %                     else
                    %                         [recon_AttendDecoder_attend_corr_train(cnt_train_story,listener,story),p_recon_AttendDecoder_attend_corr_train(cnt_train_story,listener,story)] = ...
                    %                             corr(reconstruction_audio_attend',story_train_audio_B');
                    %
                    %                         [recon_AttendDecoder_unattend_corr_train(cnt_train_story,listener,story),p_recon_AttendDecoder_unattend_corr_train(cnt_train_story,listener,story)] = ...
                    %                             corr(reconstruction_audio_attend',story_train_audio_A');
                    %
                    %                         [recon_UnattendDecoder_unattend_corr_train(cnt_train_story,listener,story),p_recon_UnattendDecoder_unattend_corr_train(cnt_train_story,listener,story)] = ...
                    %                             corr(reconstruction_audio_unattend',story_train_audio_A');
                    %
                    %                         [recon_UnattendDecoder_attend_corr_train(cnt_train_story,listener,story),p_recon_UnattendDecoder_attend_corr_train(cnt_train_story,listener,story)] = ...
                    %                             corr(reconstruction_audio_unattend',story_train_audio_B');
                    %
                    %                     end
                    
                    if ListenA_Or_Not(story,listener) == 1
                        [recon_audio_attend_AttendDecoder_train,recon_AttendDecoder_attend_corr_train(cnt_train_story,listener,story),p_recon_AttendDecoder_attend_corr_train(cnt_train_story,listener,story),MSE_recon_AttendDecoder_attend_corr_train(cnt_train_story,listener,story)] =...
                            mTRFpredict(story_train_audio_A',story_train_EEG',w_train_mTRF_attend,Fs,1,start_time,end_time,con_train_mTRF_attend);
                        
                        [recon_audio_attend_unAttendDecoder_train,recon_AttendDecoder_unattend_corr_train(cnt_train_story,listener,story),p_recon_AttendDecoder_unattend_corr_train(cnt_train_story,listener,story),MSE_recon_AttendDecoder_unattend_corr_train(cnt_train_story,listener,story)] =...
                            mTRFpredict(story_train_audio_A',story_train_EEG',w_train_mTRF_unattend,Fs,1,start_time,end_time,con_train_mTRF_attend);
                        
                        [recon_audio_unattend_unAttendDecoder_train,recon_UnattendDecoder_unattend_corr_train(cnt_train_story,listener,story),p_recon_UnattendDecoder_unattend_corr_train(cnt_train_story,listener,story),MSE_recon_UnattendDecoder_unattend_corr_train(cnt_train_story,listener,story)] =...
                            mTRFpredict(story_train_audio_B',story_train_EEG',w_train_mTRF_unattend,Fs,1,start_time,end_time,con_train_mTRF_unattend);
                        
                        [recon_audio_unattend_AttendDecoder_train,recon_UnattendDecoder_attend_corr_train(cnt_train_story,listener,story),p_recon_UnattendDecoder_attend_corr_train(cnt_train_story,listener,story),MSE_recon_UnattendDecoder_attend_corr_train(cnt_train_story,listener,story)] =...
                            mTRFpredict(story_train_audio_B',story_train_EEG',w_train_mTRF_attend,Fs,1,start_time,end_time,con_train_mTRF_unattend);
                        
                    else
                        [recon_audio_attend_AttendDecoder_train,recon_AttendDecoder_attend_corr_train(cnt_train_story,listener,story),p_recon_AttendDecoder_attend_corr_train(cnt_train_story,listener,story),MSE_recon_AttendDecoder_attend_corr_train(cnt_train_story,listener,story)] =...
                            mTRFpredict(story_train_audio_B',story_train_EEG',w_train_mTRF_attend,Fs,1,start_time,end_time,con_train_mTRF_attend);
                        
                        [recon_audio_attend_unAttendDecoder_train,recon_AttendDecoder_unattend_corr(listener,story),p_recon_AttendDecoder_unattend_corr(listener,story),MSE_recon_AttendDecoder_unattend_corr(listener,story)] =...
                            mTRFpredict(story_train_audio_B',story_train_EEG',w_train_mTRF_unattend,Fs,1,start_time,end_time,con_train_mTRF_attend);
                        
                        [recon_audio_unattend_unAttendDecoder_train,recon_UnattendDecoder_unattend_corr(listener,story),p_recon_UnattendDecoder_unattend_corr(listener,story),MSE_recon_UnattendDecoder_unattend_corr(listener,story)] =...
                            mTRFpredict(story_train_audio_A',story_train_EEG',w_train_mTRF_unattend,Fs,1,start_time,end_time,con_train_mTRF_unattend);
                        
                        [recon_audio_unattend_AttendDecoder_train,recon_UnattendDecoder_attend_corr(listener,story),p_recon_UnattendDecoder_attend_corr(listener,story),MSE_recon_UnattendDecoder_attend_corr(listener,story)] =...
                            mTRFpredict(story_train_audio_A',story_train_EEG',w_train_mTRF_attend,Fs,1,start_time,end_time,con_train_mTRF_unattend);
                        
                    end
                    
                    cnt_train_story = cnt_train_story + 1;
                end
                
            end
            
            
            % predict
            %         [recon,r,p,MSE] = mTRFpredict(stimTest,respTest,g,64,1,0,500,con);
            disp(strcat('Predicting listener ',num2str(listener),' story ',num2str(story),'...'));
            if ListenA_Or_Not(story,listener) == 1
                [recon_audio_attend_AttendDecoder,recon_AttendDecoder_attend_corr(listener,story),p_recon_AttendDecoder_attend_corr(listener,story),MSE_recon_AttendDecoder_attend_corr(listener,story)] =...
                    mTRFpredict(story_predict_audio_A',story_predict_EEG',w_train_mTRF_attend,Fs,1,start_time,end_time,con_train_mTRF_attend);
                
                [recon_audio_attend_unAttendDecoder,recon_AttendDecoder_unattend_corr(listener,story),p_recon_AttendDecoder_unattend_corr(listener,story),MSE_recon_AttendDecoder_unattend_corr(listener,story)] =...
                    mTRFpredict(story_predict_audio_A',story_predict_EEG',w_train_mTRF_unattend,Fs,1,start_time,end_time,con_train_mTRF_attend);
                
                [recon_audio_unattend_unAttendDecoder,recon_UnattendDecoder_unattend_corr(listener,story),p_recon_UnattendDecoder_unattend_corr(listener,story),MSE_recon_UnattendDecoder_unattend_corr(listener,story)] =...
                    mTRFpredict(story_predict_audio_B',story_predict_EEG',w_train_mTRF_unattend,Fs,1,start_time,end_time,con_train_mTRF_unattend);
                
                [recon_audio_unattend_AttendDecoder,recon_UnattendDecoder_attend_corr(listener,story),p_recon_UnattendDecoder_attend_corr(listener,story),MSE_recon_UnattendDecoder_attend_corr(listener,story)] =...
                    mTRFpredict(story_predict_audio_B',story_predict_EEG',w_train_mTRF_attend,Fs,1,start_time,end_time,con_train_mTRF_unattend);
                
            else
                [recon_audio_attend_AttendDecoder,recon_AttendDecoder_attend_corr(listener,story),p_recon_AttendDecoder_attend_corr(listener,story),MSE_recon_AttendDecoder_attend_corr(listener,story)] =...
                    mTRFpredict(story_predict_audio_B',story_predict_EEG',w_train_mTRF_attend,Fs,1,start_time,end_time,con_train_mTRF_attend);
                
                [recon_audio_attend_unAttendDecoder,recon_AttendDecoder_unattend_corr(listener,story),p_recon_AttendDecoder_unattend_corr(listener,story),MSE_recon_AttendDecoder_unattend_corr(listener,story)] =...
                    mTRFpredict(story_predict_audio_B',story_predict_EEG',w_train_mTRF_unattend,Fs,1,start_time,end_time,con_train_mTRF_attend);
                
                [recon_audio_unattend_unAttendDecoder,recon_UnattendDecoder_unattend_corr(listener,story),p_recon_UnattendDecoder_unattend_corr(listener,story),MSE_recon_UnattendDecoder_unattend_corr(listener,story)] =...
                    mTRFpredict(story_predict_audio_A',story_predict_EEG',w_train_mTRF_unattend,Fs,1,start_time,end_time,con_train_mTRF_unattend);
                
                [recon_audio_unattend_AttendDecoder,recon_UnattendDecoder_attend_corr(listener,story),p_recon_UnattendDecoder_attend_corr(listener,story),MSE_recon_UnattendDecoder_attend_corr(listener,story)] =...
                    mTRFpredict(story_predict_audio_A',story_predict_EEG',w_train_mTRF_attend,Fs,1,start_time,end_time,con_train_mTRF_unattend);
                
            end
            
            
            
            
            
        end
    end
    
    %% plot
    % reconstruction accuracy plot attend
    figure; plot(mean(recon_AttendDecoder_attend_corr,2),'r');
    hold on; plot(mean(recon_AttendDecoder_unattend_corr,2),'b');
    xlabel('Subject No.'); ylabel('r value')
    saveName1 = strcat('Reconstruction Accuracy using mTRF method for attend decoder+',num2str(timelag(j)),'ms',band_name,'.jpg');
    title(saveName1(1:end-4));
    legend('Audio attend ','Audio not Attend')
    saveas(gcf,saveName1);
    close
    
    % reconstruction accuracy plot unattend
    figure; plot(mean(recon_UnattendDecoder_attend_corr,2),'r');
    hold on; plot(mean(recon_UnattendDecoder_unattend_corr,2),'b');
    xlabel('Subject No.'); ylabel('r value')
    saveName2 = strcat('Reconstruction Accuracy using mTRF method for unattend decoder+',num2str(timelag(j)),'ms',band_name,'.jpg');
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
    saveName3 = strcat('Decoding accuracy using mTRF method for attend and unattend decoder+',num2str(timelag(j)),'ms',band_name,'.jpg');
    title(saveName3(1:end-4))
    legend('Attend Decoder','Unattend Decoder')
    saveas(gcf,saveName3);
    close
    
    saveName = strcat('mTRF_sound_EEG_result+',num2str(timelag(j)),'ms',band_name,'.mat');
    save(saveName,'recon_AttendDecoder_attend_corr','recon_UnattendDecoder_unattend_corr' ,'recon_AttendDecoder_unattend_corr','recon_UnattendDecoder_attend_corr',...
        'p_recon_AttendDecoder_attend_corr','p_recon_UnattendDecoder_unattend_corr', 'p_recon_AttendDecoder_unattend_corr','p_recon_UnattendDecoder_attend_corr',...
        'MSE_recon_AttendDecoder_attend_corr','MSE_recon_UnattendDecoder_unattend_corr','MSE_recon_AttendDecoder_unattend_corr','MSE_recon_UnattendDecoder_attend_corr',...
        'recon_AttendDecoder_attend_corr_train','recon_UnattendDecoder_unattend_corr_train' ,'recon_AttendDecoder_unattend_corr_train','recon_UnattendDecoder_attend_corr_train',...
        'p_recon_AttendDecoder_attend_corr_train','p_recon_UnattendDecoder_unattend_corr_train', 'p_recon_AttendDecoder_unattend_corr_train','p_recon_UnattendDecoder_attend_corr_train',...
        'MSE_recon_AttendDecoder_attend_corr_train','MSE_recon_UnattendDecoder_unattend_corr_train','MSE_recon_AttendDecoder_unattend_corr_train','MSE_recon_UnattendDecoder_attend_corr_train');
end