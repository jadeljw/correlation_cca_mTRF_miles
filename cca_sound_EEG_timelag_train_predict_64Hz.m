%% sound envelope & EEG cca for Speaker_listener study
% Li Jiawei:  jx_ljw@163.com
% 2016.11.28
% sound envelope & EEG cca
% for Speaker_listener studysound envelope & EEG correlation for Speaker_listener study

%
%% band name
band_name = {' broadband 0.1-40Hz'};
% band_name = [{' delta_hilbert'},{' alpha_hilbert'},{' theta_hilbert'},{' beta'}];
% band_name = [{' delta_hilbert'},{' alpha_hilbert'},{' theta_hilbert'}];
% band_name = band_name(4);
% 2 - 8 Hz for theta analysis

for bandName = 1: length(band_name)
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
% load('E:\DataProcessing\afterICA_data\ISC_all_ref_after_ICA_64Hz.mat')
% load('E:\DataProcessing\afterICA_data\ISC_all_ref_after_ICA_2-8Hz.mat')
% ListenerDataName = strcat('E:\DataProcessing\afterICA_data\ISC_all_ref_after_ICA_64Hz_',band_name{bandName}(2:end),'.mat');
% ListenerDataName = strcat('E:\DataProcessing\afterICA_data\ISC_all_ref_after_64Hz_',band_name{bandName}(2:end),'.mat');
% load(ListenerDataName);
load('E:\DataProcessing\afterICA_data\ISC_all_ref_after_ICA_64Hz_0.1-40Hz.mat')

%% load sound
% sound_time_index =  1001:7000; % 5 s - 35s
sound_time_index =  start_time*Fs+1:end_time*Fs; % 10 s - 35s
% sound_time_index =  2001:7000; % 10s - 35s
% sound_time_index =  3001:7000; % 15s - 35s
load('E:\DataProcessing\afterICA_data\SoundResult_0s-35s_64Hz_hilbert_lowpass8Hz.mat')
% load('E:\DataProcessing\afterICA_data\SoundResult_0s-35s_64Hz.mat')
% load('E:\DataProcessing\afterICA_data\SoundResult_0s-35s_8Hz.mat')
% load('E:\DataProcessing\afterICA_data\SoundResult_0s-35s_8Hz.mat')
% load('E:\DataProcessing\correlation_cca_mTRF\audio_all_attend_dual.mat')
% load('E:\DataProcessing\correlation_cca_mTRF\audio_all_unattend_dual.mat')

%% Channel Index
chn_sel_index= 1:60;

%% attend matrix
load('E:\DataProcessing\ListenA_Or_Not.mat')

%% timelag
timelag = (-250:500/32:500)/(1000/Fs); % Fs = 200Hz -> -200ms~500ms
% timelag = 0;
% 1 point = 5 ms

%% topoplot initial
load('E:\DataProcessing\label66.mat');
load('E:\DataProcessing\easycapm1.mat');
chn2chnName= [1:32 34:42 44:59 61:63];

%% Combine data
for j =  1 : length(timelag)
    for listener = 1 : 12
        
        % initial
        dataName = strcat('Listener',num2str(listener));
        %     assignin('base',strcat('eeg_A_',dataName),cell(1,15));
        %     assignin('base',strcat('eeg_B_',dataName),cell(1,15));
        %     assignin('base',strcat('audio_A_',dataName),cell(1,15));
        %     assignin('base',strcat('audio_B_',dataName),cell(1,15));
        
        disp('combining data ...');
        tic;
        eval(strcat('eeg_dual_',dataName,'_total=zeros(60,15*length(listener_time_index));'));
        %     eval(strcat('eeg_B_',dataName,'_total=[];'));
        eval(strcat('audio_Attend_',dataName,'_total=zeros(1,15*length(sound_time_index));'));
        eval(strcat('audio_notAttend_',dataName,'_total=zeros(1,15*length(sound_time_index));'));
        
        % Combine data
        cnt = 1;
        for i = 1 : 15
            
            % EEG
            tempDataA = eval(dataName);
            EEG_all = tempDataA{i};
            EEG_all = EEG_all(chn_sel_index,listener_time_index+timelag(j));
            eval(strcat('eeg_dual_',dataName,'_total(:,cnt:cnt+length(listener_time_index)-1)= EEG_all;'));
            
            % audio
            Sound_envelopeA = YA(i,sound_time_index);
            Sound_envelopeB = YB(i,sound_time_index);
            if ListenA_Or_Not(i,listener) == 1 % attend A
                %                 eval(strcat('audio_Attend_',dataName,'_total=[audio_Attend_',dataName,'_total',' Sound_envelopeA]'));
                %                 eval(strcat('audio_notAttend_',dataName,'_total=[audio_notAttend_',dataName,'_total',' Sound_envelopeB]'));
                eval(strcat('audio_Attend_',dataName,'_total(:,cnt:cnt+length(sound_time_index)-1) = Sound_envelopeA;'));
                eval(strcat('audio_notAttend_',dataName,'_total(:,cnt:cnt+length(sound_time_index)-1) = Sound_envelopeB;'));
            else
                %                 eval(strcat('audio_Attend_',dataName,'_total=[audio_Attend_',dataName,'_total',' Sound_envelopeB]'));
                %                 eval(strcat('audio_notAttend_',dataName,'_total=[audio_notAttend_',dataName,'_total',' Sound_envelopeA]'));
                eval(strcat('audio_Attend_',dataName,'_total(:,cnt:cnt+length(sound_time_index)-1)=Sound_envelopeB;'));
                eval(strcat('audio_notAttend_',dataName,'_total(:,cnt:cnt+length(sound_time_index)-1)=Sound_envelopeA;'));
            end
            cnt = cnt + length(listener_time_index);
        end
        
    end
    disp('done');
    toc
    % load('E:\DataProcessing\correlation_cca_mTRF\EEG_all_attend_5s-45s.mat')
    
    
    %% correlation
    recon_AttendDecoder_attend_cca = zeros(12,15);
    recon_UnattendDecoder_unattend_cca = zeros(12,15);
    recon_AttendDecoder_unattend_cca = zeros(12,15);
    recon_UnattendDecoder_attend_cca = zeros(12,15);
    
    p_recon_AttendDecoder_attend_cca = zeros(12,15);
    p_recon_UnattendDecoder_unattend_cca = zeros(12,15);
    p_recon_AttendDecoder_unattend_cca = zeros(12,15);
    p_recon_UnattendDecoder_attend_cca = zeros(12,15);
    
    
    recon_AttendDecoder_attend_total = zeros(1,length(timelag));
    recon_AttendDecoder_unattend_total = zeros(1,length(timelag));
    recon_UnattendDecoder_attend_total = zeros(1,length(timelag));
    recon_UnattendDecoder_unattend_total = zeros(1,length(timelag));
    decoding_acc_attended = zeros(1,length(timelag));
    decoding_acc_unattended = zeros(1,length(timelag));
    
    % train matrix
    recon_AttendDecoder_attend_cca_train = zeros(14,12,15); % training story numbers, listener, story
    recon_UnattendDecoder_unattend_cca_train = zeros(14,12,15);
    recon_AttendDecoder_unattend_cca_train = zeros(14,12,15);
    recon_UnattendDecoder_attend_cca_train = zeros(14,12,15);
    
    p_recon_AttendDecoder_attend_cca_train = zeros(14,12,15);
    p_recon_UnattendDecoder_unattend_cca_train = zeros(14,12,15);
    p_recon_AttendDecoder_unattend_cca_train = zeros(14,12,15);
    p_recon_UnattendDecoder_attend_cca_train = zeros(14,12,15);
    
    for listener = 1 : 12
        
        train_cca_attend_mean = zeros(60,15);
        train_cca_attend_r = zeros(60,15);
        train_cca_unattend_mean = zeros(60,15);
        train_cca_unattend_r = zeros(60,15);
        
        for story = 1 : 15
            
            disp(strcat('Training listener ',num2str(listener),' story ',num2str(story),'...'));
            % predict data -> predict data
            predict_time_index = length(listener_time_index)*(story-1)+1:length(listener_time_index)*story;
            story_predict_EEG = eval(strcat('Listener',num2str(listener),'{story}'));
            story_predict_EEG = story_predict_EEG(chn_sel_index,listener_time_index+timelag(j));
            
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
            
            
            % apply weights to each story as training sample
            cnt_train_story = 1;
            for train_story = 1 : 15
                
                
                if train_story ~= story
                    story_train_EEG = eval(strcat('Listener',num2str(listener),'{train_story}'));
                    story_train_EEG = story_train_EEG(chn_sel_index,listener_time_index+timelag(j));
                    story_train_audio_A = YA(train_story,sound_time_index);
                    story_train_audio_B = YB(train_story,sound_time_index);
                    
                    % apply weights to individual story
                    reconstruction_audio_attend = train_cca_attend_mean(:,story)' *  story_train_EEG;
                    reconstruction_audio_unattend = train_cca_unattend_mean(:,story)' *  story_train_EEG;
                    
                    if ListenA_Or_Not(train_story,listener) == 1
                        [recon_AttendDecoder_attend_cca_train(cnt_train_story,listener,story),p_recon_AttendDecoder_attend_cca_train(cnt_train_story,listener,story)] =...
                            corr(reconstruction_audio_attend',story_train_audio_A');
                        [recon_AttendDecoder_unattend_cca_train(cnt_train_story,listener,story),p_recon_AttendDecoder_unattend_cca_train(cnt_train_story,listener,story)] = ...
                            corr(reconstruction_audio_attend',story_train_audio_B');
                        
                        [recon_UnattendDecoder_unattend_cca_train(cnt_train_story,listener,story),p_recon_UnattendDecoder_unattend_cca_train(cnt_train_story,listener,story)] = ...
                            corr(reconstruction_audio_unattend',story_train_audio_B');
                        
                        [recon_UnattendDecoder_attend_cca_train(cnt_train_story,listener,story),p_recon_UnattendDecoder_attend_cca_train(cnt_train_story,listener,story)] = ...
                            corr(reconstruction_audio_unattend',story_train_audio_A');
                    else
                        [recon_AttendDecoder_attend_cca_train(cnt_train_story,listener,story),p_recon_AttendDecoder_attend_cca_train(cnt_train_story,listener,story)] = ...
                            corr(reconstruction_audio_attend',story_train_audio_B');
                        
                        [recon_AttendDecoder_unattend_cca_train(cnt_train_story,listener,story),p_recon_AttendDecoder_unattend_cca_train(cnt_train_story,listener,story)] = ...
                            corr(reconstruction_audio_attend',story_train_audio_A');
                        
                        [recon_UnattendDecoder_unattend_cca_train(cnt_train_story,listener,story),p_recon_UnattendDecoder_unattend_cca_train(cnt_train_story,listener,story)] = ...
                            corr(reconstruction_audio_unattend',story_train_audio_A');
                        
                        [recon_UnattendDecoder_attend_cca_train(cnt_train_story,listener,story),p_recon_UnattendDecoder_attend_cca_train(cnt_train_story,listener,story)] = ...
                            corr(reconstruction_audio_unattend',story_train_audio_B');
                        
                        
                    end
                    
                    
                    cnt_train_story = cnt_train_story + 1;
                    
                end
                
                
            end
            
            
            
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
    
    % save
    saveName = strcat('cca_sound_EEG_result+',num2str((1000/Fs)*timelag(j)),'ms',band_name{bandName},'.mat');
    save(saveName,'recon_AttendDecoder_attend_cca','recon_UnattendDecoder_unattend_cca' ,'recon_AttendDecoder_unattend_cca','recon_UnattendDecoder_attend_cca',...
        'p_recon_AttendDecoder_attend_cca','p_recon_UnattendDecoder_unattend_cca', 'p_recon_AttendDecoder_unattend_cca','p_recon_UnattendDecoder_attend_cca',...
        'recon_AttendDecoder_attend_cca_train','recon_UnattendDecoder_unattend_cca_train' ,'recon_AttendDecoder_unattend_cca_train','recon_UnattendDecoder_attend_cca_train',...
        'p_recon_AttendDecoder_attend_cca_train','p_recon_UnattendDecoder_unattend_cca_train', 'p_recon_AttendDecoder_unattend_cca_train','p_recon_UnattendDecoder_attend_cca_train');
    
    %plot
    % reconstruction accuracy plot attend
    figure; plot(mean(recon_AttendDecoder_attend_cca,2),'r');
    hold on; plot(mean(recon_AttendDecoder_unattend_cca,2),'b');
    xlabel('Subject No.'); ylabel('r value')
    title('Reconstruction Accuracy using cca method for attend decoder');
    legend('Audio attend ','Audio not Attend')
    saveName1 = strcat('Reconstruction Accuracy using cca method for attend decoder+',num2str((1000/Fs)*timelag(j)),'ms',band_name{bandName},'.jpg');
    title(saveName1(1:end-4));
    legend('Audio attend ','Audio not Attend')
    saveas(gcf,saveName1);
    close
    
    % reconstruction accuracy plot unattend
    figure; plot(mean(recon_UnattendDecoder_attend_cca,2),'r');
    hold on; plot(mean(recon_UnattendDecoder_unattend_cca,2),'b');
    xlabel('Subject No.'); ylabel('r value')
    saveName2 = strcat('Reconstruction Accuracy using cca method for unattend decoder+',num2str((1000/Fs)*timelag(j)),'ms',band_name{bandName},'.jpg');
    title(saveName2(1:end-4));
    legend('Audio attend ','Audio not Attend')
    
    saveas(gcf,saveName2);
    close
    
    % Decoding accuracy plot attend
    Decoding_result_attend_decoder = recon_AttendDecoder_attend_cca-recon_AttendDecoder_unattend_cca;
    Individual_subjects_result_attend = sum(Decoding_result_attend_decoder>0,2)/15;
    mean(Individual_subjects_result_attend)
    Decoding_result_unattend_decoder = recon_UnattendDecoder_unattend_cca-recon_UnattendDecoder_attend_cca;
    Individual_subjects_result_unattend = sum(Decoding_result_unattend_decoder>0,2)/15;
    mean(Individual_subjects_result_unattend)
    figure; plot(Individual_subjects_result_attend*100,'r');
    hold on; plot(Individual_subjects_result_unattend*100,'b');
    xlabel('Subject No.'); ylabel('Decoding Accuarcy %');ylim([0,100]);
    saveName3 = strcat('Decoding accuracy using cca method for attend and unattend decoder+',num2str((1000/Fs)*timelag(j)),'ms',band_name{bandName},'.jpg');
    title(saveName3(1:end-4))
    legend('Attend Decoder','Unattend Decoder')
    saveas(gcf,saveName3);
    close
    
    
    %reconstruction accuracy
    recon_AttendDecoder_attend_total(j) =  mean(mean(recon_AttendDecoder_attend_cca));
    recon_AttendDecoder_unattend_total(j) =  mean(mean(recon_AttendDecoder_unattend_cca));
    recon_UnattendDecoder_attend_total(j) = mean(mean(recon_UnattendDecoder_attend_cca));
    recon_UnattendDecoder_unattend_total(j) = mean(mean(recon_UnattendDecoder_unattend_cca));
    
    %decoding accuracy
    Decoding_result_attend_decoder = recon_AttendDecoder_attend_cca-recon_AttendDecoder_unattend_cca;
    Individual_subjects_result_attend = sum(Decoding_result_attend_decoder>0,2)/15;
    decoding_acc_attended(j)= mean(Individual_subjects_result_attend);
    
    Decoding_result_unattend_decoder = recon_UnattendDecoder_unattend_cca-recon_UnattendDecoder_attend_cca;
    Individual_subjects_result_unattend = sum(Decoding_result_unattend_decoder>0,2)/15;
    decoding_acc_unattended(j) = mean(Individual_subjects_result_unattend);
    
    
end

% figure; plot(timelag,recon_AttendDecoder_attend_total,'r');
% hold on; plot(timelag,recon_AttendDecoder_unattend_total,'b');
% xlabel('Times(ms)'); ylabel('r-value')
% saveName1 = 'Attended decoder Reconstruction-Acc across all time-lags using CCA method.jpg';
% title(saveName1(1:end-4));
% legend('r Attended ','r unAttended');ylim([-0.03,0.03]);
% saveas(gcf,saveName1);
% close
%
% figure; plot(timelag,recon_UnattendDecoder_attend_total,'r');
% hold on; plot(timelag,recon_UnattendDecoder_unattend_total,'b');
% xlabel('Times(ms)'); ylabel('r-value')
% saveName2 = 'Unattended decoder Reconstruction-Acc across all time-lags using CCA method.jpg';
% title(saveName2(1:end-4));
% legend('r Attended ','r unAttended');ylim([-0.03,0.03]);
% saveas(gcf,saveName2);
% close
%
% figure; plot(timelag,decoding_acc_attended*100,'r');
% hold on; plot(timelag,decoding_acc_unattended*100,'b');
% xlabel('Times(ms)'); ylabel('Decoding accuracy(%)')
% saveName3 = 'Decoding-Accuracy across all time-lags using CCA method.jpg';
% title(saveName3(1:end-4));
% legend('Attended decoder','Unattended decoder');ylim([30,100]);
% saveas(gcf,saveName3);
% close

end