%% sound envelope & EEG mTRF for Speaker_listener study
% Li Jiawei:  jx_ljw@163.com
% for Speaker_listener studysound envelope & EEG correlation for Speaker_listener study
% mTRF weights comes from 15 trials means

% updated 4.12 fixed the training set predict problem
%
%% band name
lambda = 2^5;
band_name = strcat(' 64Hz 2-8Hz lambda',num2str(lambda),' long');
% band_name = strcat(' 64Hz 2-8Hz M1M2 lambda',num2str(lambda));
% 2 - 8 Hz for theta analysis


%% topoplot initial
load('E:\DataProcessing\label66.mat');
load('E:\DataProcessing\easycapm1.mat');
chn2chnName= [1:32 34:42 44:59 61:63];
zlim = 3;



%% load Listener data
% speaker time -5 to 45s
Fs = 64;
start_time = 10;
end_time = 35;
% listener_time_index =  2001:8000; % 5 s - 35s
listener_time_index =  (start_time+5)*Fs+1:(end_time+5)*Fs; % 10 s - 35s

% listener_time_index =  3001:8000; % 5s - 35s
% listener_time_index =  4001:8000;% `5s - 35s
% load('E:\DataProcessing\afterICA_data\ISC_all_ref_after_ICA_64Hz_bandpass_2-8Hz.mat')
% ListenerDataName = strcat('E:\DataProcessing\afterICA_data\ISC_all_ref_after_ICA_64Hz_',band_name(2:end),'.mat');
load('E:\DataProcessing\afterICA_data\ISC_M1M2_ref_after_64Hz_bp_2-8Hz.mat')
% load(ListenerDataName);
% load('E:\DataProcessing\afterICA_data\ISC_all_ref_after_ICA_64Hz.mat')
% load('E:\DataProcessing\afterICA_data\ISC_all_ref_after_ICA_64Hz_0.1-40Hz.mat')

%% load sound
% sound_time_index =  1001:7000; % 5 s - 35s
sound_time_index =  start_time*Fs+1:end_time*Fs; % 10 s - 35s
% sound_time_index =  2001:7000; % 10s - 35s
% sound_time_index =  3001:7000; % 15s - 35s
load('E:\DataProcessing\afterICA_data\SoundResult_0s-35s_64Hz_hilbert_lowpass8Hz.mat')
% load('E:\DataProcessing\afterICA_data\SoundResult_0s-35s_64Hz.mat')

%% Channel Index
chn_sel_index= 1:60;

%% attend matrix
load('E:\DataProcessing\ListenA_Or_Not.mat')

%% timelag
% timelag = -250:500/32:500;
% timelag = -250:(1000/Fs):500;
% timelag = timelag(33);
timelag = 0;

%% Combine data
% %
% for listener = 1 : 12
%
%     % initial
%     dataName = strcat('Listener',num2str(listener));
%     %     assignin('base',strcat('eeg_A_',dataName),cell(1,15));
%     %     assignin('base',strcat('eeg_B_',dataName),cell(1,15));
%     %     assignin('base',strcat('audio_A_',dataName),cell(1,15));
%     %     assignin('base',strcat('audio_B_',dataName),cell(1,15));
%
%     disp('combining data ...');
%     tic;
%     eval(strcat('eeg_dual_',dataName,'_total=zeros(60,15*length(listener_time_index));'));
%     %     eval(strcat('eeg_B_',dataName,'_total=[];'));
%     eval(strcat('audio_Attend_',dataName,'_total=zeros(1,15*length(sound_time_index));'));
%     eval(strcat('audio_notAttend_',dataName,'_total=zeros(1,15*length(sound_time_index));'));
%
%     % Combine data
%     cnt = 1;
%     for i = 1 : 15
%
%         % EEG
%         tempDataA = eval(dataName);
%         EEG_all = tempDataA{i};
%         EEG_all = EEG_all(chn_sel_index,listener_time_index);
%         eval(strcat('eeg_dual_',dataName,'_total(:,cnt:cnt+length(listener_time_index)-1)= EEG_all;'));
%
%         % audio
%         Sound_envelopeA = YA(i,sound_time_index);
%         Sound_envelopeB = YB(i,sound_time_index);
%         if ListenA_Or_Not(i,listener) == 1 % attend A
%             %                 eval(strcat('audio_Attend_',dataName,'_total=[audio_Attend_',dataName,'_total',' Sound_envelopeA]'));
%             %                 eval(strcat('audio_notAttend_',dataName,'_total=[audio_notAttend_',dataName,'_total',' Sound_envelopeB]'));
%             eval(strcat('audio_Attend_',dataName,'_total(:,cnt:cnt+length(sound_time_index)-1) = Sound_envelopeA;'));
%             eval(strcat('audio_notAttend_',dataName,'_total(:,cnt:cnt+length(sound_time_index)-1) = Sound_envelopeB;'));
%         else
%             %                 eval(strcat('audio_Attend_',dataName,'_total=[audio_Attend_',dataName,'_total',' Sound_envelopeB]'));
%             %                 eval(strcat('audio_notAttend_',dataName,'_total=[audio_notAttend_',dataName,'_total',' Sound_envelopeA]'));
%             eval(strcat('audio_Attend_',dataName,'_total(:,cnt:cnt+length(sound_time_index)-1)=Sound_envelopeB;'));
%             eval(strcat('audio_notAttend_',dataName,'_total(:,cnt:cnt+length(sound_time_index)-1)=Sound_envelopeA;'));
%         end
%         cnt = cnt + length(listener_time_index);
%     end
%
% end
% disp('done');
% toc

%% load data
% load('E:\DataProcessing\correlation_cca_mTRF\audio_all_attend_dual_64Hz.mat')
% load('E:\DataProcessing\correlation_cca_mTRF\audio_all_unattend_dual_64Hz.mat')
% load('E:\DataProcessing\correlation_cca_mTRF\EEG_all_attend_10s-35s_64Hz.mat')

% load('E:\DataProcessing\correlation_cca_mTRF\audio_all_attend_dual_64Hz_lowpass_8Hz.mat')
% load('E:\DataProcessing\correlation_cca_mTRF\audio_all_unattend_dual_64Hz_lowpass_8Hz.mat')
% load('E:\DataProcessing\correlation_cca_mTRF\EEG_all_attend_10s-35s_64Hz_bandpass_2-8Hz.mat')

for j = 1 : length(timelag)
    %% mTRF
    
    Fs = 64;
    start_time = -250 + timelag(j);
    end_time = 500 + timelag(j);
    %     start_time = 0 + timelag(j);
    %     end_time = 0 + timelag(j);
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
    
    train_mTRF_attend_w_total = zeros(60,(end_time-start_time)/(1000/Fs)+1,14);
    train_mTRF_unattend_w_total = zeros(60,(end_time-start_time)/(1000/Fs)+1,14);
    train_mTRF_attend_con_total = zeros(60,1,14);
    train_mTRF_unattend_con_total = zeros(60,1,14);
    %
    %     train_mTRF_attend_t_total = zeros(60,14);
    %     train_mTRF_unattend_t_total = zeros(60,14);
    
    train_mTRF_attend_w_train_all_listener = cell(12,15);
    train_mTRF_unattend_w_train_all_listener = cell(12,15);
    train_mTRF_attend_w_all_listener = cell(12,15);
    train_mTRF_unattend_w_all_listener = cell(12,15);
    
    
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
            
            %             % train data
            %             story_train_EEG = eval(strcat('eeg_dual_Listener',num2str(listener),'_total'));
            %             story_train_EEG(:,predict_time_index) = [];
            %
            %             story_train_audio_Attend = eval(strcat('audio_Attend_Listener',num2str(listener),'_total'));
            %             story_train_audio_unAttend = eval(strcat('audio_notAttend_Listener',num2str(listener),'_total'));
            %             story_train_audio_Attend(:,predict_time_index) = [];
            %             story_train_audio_unAttend(:,predict_time_index) = [];
            %
            %
            %             % mTRF
            %             [w_train_mTRF_attend,t_train_mTRF_attend,con_train_mTRF_attend] = mTRFtrain(zscore(story_train_audio_Attend'),zscore(story_train_EEG'),Fs,1,start_time,end_time,lambda);
            %             [w_train_mTRF_unattend,t_train_mTRF_unattend,con_train_mTRF_unattend] = mTRFtrain(zscore(story_train_audio_unAttend'),zscore(story_train_EEG'),Fs,1,start_time,end_time,lambda);
            %
            %             %         % record into one matrix
            %             train_mTRF_attend_w_total{listener,story} = w_train_mTRF_attend;
            %             train_mTRF_attend_con_total{listener,story} = con_train_mTRF_attend;
            %             %             train_mTRF_attend_t_total(:,story) = t_train_mTRF_attend;
            %             %             train_mTRF_attend_con_total(:,story) = con_train_mTRF_attend;
            %             train_mTRF_unattend_w_total{listener,story} = w_train_mTRF_unattend;
            %             train_mTRF_unattend_con_total{listener,story} = con_train_mTRF_unattend;
            %             %             train_mTRF_unattend_t_total(:,story) = t_train_mTRF_unattend;
            %             %             train_mTRF_unattend_con_total(:,story) = con_train_mTRF_unattend;
            
            % individual data training
            cnt_train_story = 1;
            for train_story = 1 : 15
                if train_story ~= story
                    story_train_EEG = eval(strcat('Listener',num2str(listener),'{train_story}'));
                    story_train_EEG = story_train_EEG(chn_sel_index,listener_time_index);
                    story_train_audio_A = YA(train_story,sound_time_index);
                    story_train_audio_B = YB(train_story,sound_time_index);
                    
                    % mTRF
                    if ListenA_Or_Not(train_story,listener) == 1
                        % train
                        [w_train_mTRF_attend,t_train_mTRF_attend,con_train_mTRF_attend] = mTRFtrain(zscore(story_train_audio_A'),zscore(story_train_EEG'),Fs,-1,start_time,end_time,lambda);
                        [w_train_mTRF_unattend,t_train_mTRF_unattend,con_train_mTRF_unattend] = mTRFtrain(zscore(story_train_audio_B'),zscore(story_train_EEG'),Fs,-1,start_time,end_time,lambda);
                        
                    else
                        [w_train_mTRF_attend,t_train_mTRF_attend,con_train_mTRF_attend] = mTRFtrain(zscore(story_train_audio_B'),zscore(story_train_EEG'),Fs,-1,start_time,end_time,lambda);
                        [w_train_mTRF_unattend,t_train_mTRF_unattend,con_train_mTRF_unattend] = mTRFtrain(zscore(story_train_audio_A'),zscore(story_train_EEG'),Fs,-1,start_time,end_time,lambda);
                        
                    end
                    
                    % record all weights into one matrix
                    train_mTRF_attend_w_total(:,:,cnt_train_story) = w_train_mTRF_attend;
                    train_mTRF_attend_con_total(:,:,cnt_train_story) = con_train_mTRF_attend;

                    train_mTRF_unattend_w_total(:,:,cnt_train_story) = w_train_mTRF_unattend;
                    train_mTRF_unattend_con_total(:,:,cnt_train_story) = con_train_mTRF_unattend;

                    train_mTRF_attend_w_train_all_listener{listener,story}= train_mTRF_attend_w_total;
                    train_mTRF_unattend_w_train_all_listener{listener,story} = train_mTRF_unattend_w_total;
                    
                    cnt_train_story = cnt_train_story + 1;
                end
                
                % mean of weights
                train_mTRF_attend_w_mean = mean(train_mTRF_attend_w_total,3);
                train_mTRF_attend_con_mean = mean(train_mTRF_attend_con_total,3);
                train_mTRF_unattend_w_mean = mean(train_mTRF_unattend_w_total,3);
                train_mTRF_unattend_con_mean = mean(train_mTRF_unattend_con_total,3);
                train_mTRF_attend_w_all_listener{listener,story} = train_mTRF_attend_w_mean;
                train_mTRF_unattend_w_all_listener{listener,story} = train_mTRF_unattend_w_mean;
            end
            
            
            
            % predict
            %         [recon,r,p,MSE] = mTRFpredict(stimTest,respTest,g,64,1,0,500,con);
            disp(strcat('Predicting listener ',num2str(listener),' story ',num2str(story),'...'));
            if ListenA_Or_Not(story,listener) == 1
                [recon_audio_attend_AttendDecoder,recon_AttendDecoder_attend_corr(listener,story),p_recon_AttendDecoder_attend_corr(listener,story),MSE_recon_AttendDecoder_attend_corr(listener,story)] =...
                    mTRFpredict(zscore(story_predict_audio_A'),zscore(story_predict_EEG'),train_mTRF_attend_w_mean,Fs,-1,start_time,end_time,train_mTRF_attend_con_mean);
                
                [recon_audio_unattend_AttendDecoder,recon_AttendDecoder_unattend_corr(listener,story),p_recon_AttendDecoder_unattend_corr(listener,story),MSE_recon_AttendDecoder_unattend_corr(listener,story)] =...
                    mTRFpredict(zscore(story_predict_audio_B'),zscore(story_predict_EEG'),train_mTRF_attend_w_mean,Fs,-1,start_time,end_time,train_mTRF_attend_con_mean);
                
                [recon_audio_unattend_unAttendDecoder,recon_UnattendDecoder_unattend_corr(listener,story),p_recon_UnattendDecoder_unattend_corr(listener,story),MSE_recon_UnattendDecoder_unattend_corr(listener,story)] =...
                    mTRFpredict(zscore(story_predict_audio_B'),zscore(story_predict_EEG'),train_mTRF_unattend_w_mean,Fs,-1,start_time,end_time,train_mTRF_unattend_con_mean);
                
                [recon_audio_attend_unAttendDecoder,recon_UnattendDecoder_attend_corr(listener,story),p_recon_UnattendDecoder_attend_corr(listener,story),MSE_recon_UnattendDecoder_attend_corr(listener,story)] =...
                    mTRFpredict(zscore(story_predict_audio_A'),zscore(story_predict_EEG'),train_mTRF_unattend_w_mean,Fs,-1,start_time,end_time,train_mTRF_unattend_con_mean);
                
            else
                [recon_audio_attend_AttendDecoder,recon_AttendDecoder_attend_corr(listener,story),p_recon_AttendDecoder_attend_corr(listener,story),MSE_recon_AttendDecoder_attend_corr(listener,story)] =...
                    mTRFpredict(zscore(story_predict_audio_B'),zscore(story_predict_EEG'),train_mTRF_attend_w_mean,Fs,-1,start_time,end_time,train_mTRF_attend_con_mean);
                
                [recon_audio_unattend_AttendDecoder,recon_AttendDecoder_unattend_corr(listener,story),p_recon_AttendDecoder_unattend_corr(listener,story),MSE_recon_AttendDecoder_unattend_corr(listener,story)] =...
                    mTRFpredict(zscore(story_predict_audio_A'),zscore(story_predict_EEG'),train_mTRF_attend_w_mean,Fs,-1,start_time,end_time,train_mTRF_attend_con_mean);
                
                [recon_audio_unattend_unAttendDecoder,recon_UnattendDecoder_unattend_corr(listener,story),p_recon_UnattendDecoder_unattend_corr(listener,story),MSE_recon_UnattendDecoder_unattend_corr(listener,story)] =...
                    mTRFpredict(zscore(story_predict_audio_A'),zscore(story_predict_EEG'),train_mTRF_unattend_w_mean,Fs,-1,start_time,end_time,train_mTRF_unattend_con_mean);
                
                [recon_audio_attend_unAttendDecoder,recon_UnattendDecoder_attend_corr(listener,story),p_recon_UnattendDecoder_attend_corr(listener,story),MSE_recon_UnattendDecoder_attend_corr(listener,story)] =...
                    mTRFpredict(zscore(story_predict_audio_B'),zscore(story_predict_EEG'),train_mTRF_unattend_w_mean,Fs,-1,start_time,end_time,train_mTRF_unattend_con_mean);
                
            end
            
            cnt_train_story = 1;
            for train_story = 1 : 15
                story_train_EEG = eval(strcat('Listener',num2str(listener),'{train_story}'));
                story_train_EEG = story_train_EEG(chn_sel_index,listener_time_index);
                story_train_audio_A = YA(train_story,sound_time_index);
                story_train_audio_B = YB(train_story,sound_time_index);
                % apply weights to individual story
                
                if ListenA_Or_Not(train_story,listener) == 1
                    [recon_audio_attend_AttendDecoder_train,recon_AttendDecoder_attend_corr_train(cnt_train_story,listener,story),p_recon_AttendDecoder_attend_corr_train(cnt_train_story,listener,story),MSE_recon_AttendDecoder_attend_corr_train(cnt_train_story,listener,story)] =...
                        mTRFpredict(zscore(story_train_audio_A'),zscore(story_train_EEG'),train_mTRF_attend_w_mean,Fs,-1,start_time,end_time,con_train_mTRF_attend);
                    
                    [recon_audio_unattend_AttendDecoder_train,recon_AttendDecoder_unattend_corr_train(cnt_train_story,listener,story),p_recon_AttendDecoder_unattend_corr_train(cnt_train_story,listener,story),MSE_recon_AttendDecoder_unattend_corr_train(cnt_train_story,listener,story)] =...
                        mTRFpredict(zscore(story_train_audio_B'),zscore(story_train_EEG'),train_mTRF_attend_w_mean,Fs,-1,start_time,end_time,con_train_mTRF_attend);
                    
                    [recon_audio_unattend_unAttendDecoder_train,recon_UnattendDecoder_unattend_corr_train(cnt_train_story,listener,story),p_recon_UnattendDecoder_unattend_corr_train(cnt_train_story,listener,story),MSE_recon_UnattendDecoder_unattend_corr_train(cnt_train_story,listener,story)] =...
                        mTRFpredict(zscore(story_train_audio_B'),zscore(story_train_EEG'),train_mTRF_unattend_w_mean,Fs,-1,start_time,end_time,con_train_mTRF_unattend);
                    
                    [recon_audio_attend_unAttendDecoder_train,recon_UnattendDecoder_attend_corr_train(cnt_train_story,listener,story),p_recon_UnattendDecoder_attend_corr_train(cnt_train_story,listener,story),MSE_recon_UnattendDecoder_attend_corr_train(cnt_train_story,listener,story)] =...
                        mTRFpredict(zscore(story_train_audio_A'),zscore(story_train_EEG'),train_mTRF_unattend_w_mean,Fs,-1,start_time,end_time,con_train_mTRF_unattend);
                    
                else
                    [recon_audio_attend_AttendDecoder_train,recon_AttendDecoder_attend_corr_train(cnt_train_story,listener,story),p_recon_AttendDecoder_attend_corr_train(cnt_train_story,listener,story),MSE_recon_AttendDecoder_attend_corr_train(cnt_train_story,listener,story)] =...
                        mTRFpredict(zscore(story_train_audio_B'),zscore(story_train_EEG'),train_mTRF_attend_w_mean,Fs,-1,start_time,end_time,con_train_mTRF_attend);
                    
                    [recon_audio_unattend_AttendDecoder_train,recon_AttendDecoder_unattend_corr_train(cnt_train_story,listener,story),p_recon_AttendDecoder_unattend_corr_train(cnt_train_story,listener,story),MSE_recon_AttendDecoder_unattend_corr_train(cnt_train_story,listener,story)] =...
                        mTRFpredict(zscore(story_train_audio_A'),zscore(story_train_EEG'),train_mTRF_attend_w_mean,Fs,-1,start_time,end_time,con_train_mTRF_attend);
                    
                    [recon_audio_unattend_unAttendDecoder_train,recon_UnattendDecoder_unattend_corr_train(cnt_train_story,listener,story),p_recon_UnattendDecoder_unattend_corr_train(cnt_train_story,listener,story),MSE_recon_UnattendDecoder_unattend_corr_train(cnt_train_story,listener,story)] =...
                        mTRFpredict(zscore(story_train_audio_A'),zscore(story_train_EEG'),train_mTRF_unattend_w_mean,Fs,-1,start_time,end_time,con_train_mTRF_unattend);
                    
                    [recon_audio_attend_unAttendDecoder_train,recon_UnattendDecoder_attend_corr_train(cnt_train_story,listener,story),p_recon_UnattendDecoder_attend_corr_train(cnt_train_story,listener,story),MSE_recon_UnattendDecoder_attend_corr_train(cnt_train_story,listener,story)] =...
                        mTRFpredict(zscore(story_train_audio_B'),zscore(story_train_EEG'),train_mTRF_unattend_w_mean,Fs,-1,start_time,end_time,con_train_mTRF_unattend);
                    
                end
                
                cnt_train_story = cnt_train_story + 1;
            end
            
            
            
            
        end
        
        %         % weights topoplot
        %         % listener attended  decoder plot
        %         save_nameA = strcat('Single trial mTRF method Listener weights attended decoder Listener',num2str(listener),'+',num2str(timelag(j)),'ms',band_name,'.jpg');
        %         title(save_nameA(1:end-4))
        %         %             U_topoplot(abs(zscore(train_corr_attend_listener_w)), 'easycapm1.lay', label66(chn2chnName),[],zlim);
        %         U_topoplot(zscore(train_mTRF_attend_w_mean), 'easycapm1.lay', label66(chn2chnName),[],zlim);
        %         saveas(gcf,save_nameA);
        %
        %         % listener unattended decoder plot
        %         save_nameB = strcat('Single trial mTRF method Listener weights unattended decoder Listener',num2str(listener),'+',num2str(timelag(j)),'ms',band_name,'.jpg');
        %         title(save_nameB(1:end-4))
        %         %             U_topoplot(abs(zscore(train_corr_unattend_listener_w)), 'easycapm1.lay', label66(chn2chnName),[],zlim);
        %         U_topoplot(zscore(train_mTRF_unattend_w_mean), 'easycapm1.lay', label66(chn2chnName),[],zlim);
        %         saveas(gcf,save_nameB);
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
        'MSE_recon_AttendDecoder_attend_corr_train','MSE_recon_UnattendDecoder_unattend_corr_train','MSE_recon_AttendDecoder_unattend_corr_train','MSE_recon_UnattendDecoder_attend_corr_train',...
        'train_mTRF_attend_w_total','train_mTRF_unattend_w_total');
end