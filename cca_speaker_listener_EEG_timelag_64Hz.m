%% Speaker EEG & listener EEG cca for Speaker_listener study
% Li Jiawei:  jx_ljw@163.com
% 2016.12.6
% sound envelope & EEG cca
% for Speaker_listener studysound envelope & EEG correlation for Speaker_listener study

%
%% band name
band_name = ' 64Hz bp 0.5-40Hz';


%% initial
Fs = 64;
start_time = 10;
end_time = 35;

%% load Listener data
listener_time_index =  (start_time+5)*Fs+1:(end_time+5)*Fs; % 10 s - 35s
% load('E:\DataProcessing\afterICA_data\ISC_all_ref_after_ICA_64Hz_bandpass_2-8Hz.mat')
load('E:\DataProcessing\afterICA_data\ISC_all_ref_after_ICA_64Hz.mat')
% load('E:\DataProcessing\afterICA_data\ISC_all_ref_after_ICA_2-8Hz.mat')
% load('E:\DataProcessing\afterICA_data\ISC_all_ref_after_ICA_64Hz_0.1-40Hz.mat')

%% load speaker data
speaker_time_index =  (start_time+5)*Fs+1:(end_time+5)*Fs; % 10s - 35s
load('E:\DataProcessing\afterICA_data\data_speaker_64Hz.mat')
% % load('E:\DataProcessing\afterICA_data\SoundResult_0s-35s_64Hz_hilbert_lowpass8Hz.mat')

% load('E:\DataProcessing\afterICA_data\data_speaker_64Hz_bp_0.1-40Hz.mat')


%% Channel Index
listener_chn= 1:60;
speaker_chn = [1:32 34:42 44:59 61:63];

%% attend matrix
load('E:\DataProcessing\ListenA_Or_Not.mat')

%% timelag
% timelag = 0;
% timelag = -250:500/32:500;
timelag = 375/(1000/Fs);


for j = 1: length(timelag)
    % %% Combine data
    %
    for listener = 1 : 12
        %
        % %     initial
        %     dataName = strcat('Listener',num2str(listener));
        %     assignin('base',strcat('eeg_A_',dataName),cell(1,15));
        %     assignin('base',strcat('eeg_B_',dataName),cell(1,15));
        %     assignin('base',strcat('audio_A_',dataName),cell(1,15));
        %     assignin('base',strcat('audio_B_',dataName),cell(1,15));
        %
        %     eval(strcat('eeg_dual_',dataName,'_total=[];'));
        %     eval(strcat('eeg_B_',dataName,'_total=[];'));
        %     eval(strcat('Speaker_Attend_',dataName,'_total=[];'));
        %     eval(strcat('Speaker_notAttend_',dataName,'_total=[];'));
        %
        % %     Combine data
        %     for i = 1 : 15
        %
        % %         EEG
        %         tempDataA = eval(dataName);
        %         EEG_all = tempDataA{i};
        %         EEG_all = EEG_all(listener_chn,listener_time_index);
        %         eval(strcat('eeg_dual_',dataName,'_total=[eeg_dual_',dataName,'_total',' EEG_all]'));
        %
        % %         audio
        %         SpeakerA = data_speakerA{i}(speaker_chn,speaker_time_index);
        %         SpeakerB = data_speakerB{i}(speaker_chn,speaker_time_index);
        %         if ListenA_Or_Not(i,listener) == 1 % attend A
        %             eval(strcat('Speaker_Attend_',dataName,'_total=[Speaker_Attend_',dataName,'_total',' SpeakerA ]'));
        %             eval(strcat('Speaker_notAttend_',dataName,'_total=[Speaker_notAttend_',dataName,'_total',' SpeakerB]'));
        %         else
        %             eval(strcat('Speaker_Attend_',dataName,'_total=[Speaker_Attend_',dataName,'_total',' SpeakerA ]'));
        %             eval(strcat('Speaker_notAttend_',dataName,'_total=[Speaker_notAttend_',dataName,'_total',' SpeakerB]'));
        %         end
        %
        %     end
        % end
        
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
        eval(strcat('Speaker_Attend_',dataName,'_total=zeros(60,15*length(speaker_time_index));'));
        eval(strcat('Speaker_notAttend_',dataName,'_total=zeros(60,15*length(speaker_time_index));'));
        
        % Combine data
        cnt = 1;
        for i = 1 : 15
            
            % EEG
            tempDataA = eval(dataName);
            EEG_all = tempDataA{i};
            EEG_all = EEG_all(listener_chn,listener_time_index+timelag(j));
            eval(strcat('eeg_dual_',dataName,'_total(:,cnt:cnt+length(listener_time_index)-1)= EEG_all;'));
            
            % audio
            SpeakerA = data_speakerA{i}(speaker_chn,speaker_time_index);
            SpeakerB = data_speakerB{i}(speaker_chn,speaker_time_index);
            if ListenA_Or_Not(i,listener) == 1 % attend A
                %                 eval(strcat('audio_Attend_',dataName,'_total=[audio_Attend_',dataName,'_total',' Sound_envelopeA]'));
                %                 eval(strcat('audio_notAttend_',dataName,'_total=[audio_notAttend_',dataName,'_total',' Sound_envelopeB]'));
                eval(strcat('Speaker_Attend_',dataName,'_total(:,cnt:cnt+length(speaker_time_index)-1) = SpeakerA;'));
                eval(strcat('Speaker_notAttend_',dataName,'_total(:,cnt:cnt+length(speaker_time_index)-1) = SpeakerB;'));
            else
                %                 eval(strcat('audio_Attend_',dataName,'_total=[audio_Attend_',dataName,'_total',' Sound_envelopeB]'));
                %                 eval(strcat('audio_notAttend_',dataName,'_total=[audio_notAttend_',dataName,'_total',' Sound_envelopeA]'));
                eval(strcat('Speaker_Attend_',dataName,'_total(:,cnt:cnt+length(speaker_time_index)-1)=SpeakerB;'));
                eval(strcat('Speaker_notAttend_',dataName,'_total(:,cnt:cnt+length(speaker_time_index)-1)=SpeakerA;'));
            end
            cnt = cnt + length(listener_time_index);
        end
        
        
        disp('done');
        toc
        
    end
    
    
    %% correlation
    recon_AttendDecoder_attend_cca = zeros(12,15);
    recon_UnattendDecoder_unattend_cca = zeros(12,15);
    recon_AttendDecoder_unattend_cca = zeros(12,15);
    recon_UnattendDecoder_attend_cca = zeros(12,15);
    
    p_recon_AttendDecoder_attend_cca = zeros(12,15);
    p_recon_UnattendDecoder_unattend_cca = zeros(12,15);
    p_recon_AttendDecoder_unattend_cca = zeros(12,15);
    p_recon_UnattendDecoder_attend_cca = zeros(12,15);
    
    
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
        
        train_cca_attend_listener_w_mean = zeros(60,15);
        train_cca_attend_speaker_w_mean = zeros(60,15);
        train_cca_attend_r = zeros(60,15);
        
        train_cca_unattend_listener_w_mean = zeros(60,15);
        train_cca_unattend_speaker_w_mean = zeros(60,15);
        train_cca_unattend_r = zeros(60,15);
        
        for story = 1 : 15
            
            disp(strcat('Training listener ',num2str(listener),' story ',num2str(story),'...'));
            % predict data -> predict data
            predict_time_index = length(listener_time_index)*(story-1)+1:length(listener_time_index)*story;
            story_predict_listener_EEG = eval(strcat('Listener',num2str(listener),'{story}'));
            story_predict_listener_EEG = story_predict_listener_EEG(listener_chn,listener_time_index+timelag(j));
            
            story_predict_speaker_A = data_speakerA{story}(speaker_chn,speaker_time_index);
            story_predict_speaker_B = data_speakerB{story}(speaker_chn,speaker_time_index);
            
            % train data
            story_train_listener_EEG = eval(strcat('eeg_dual_Listener',num2str(listener),'_total'));
            story_train_listener_EEG(:,predict_time_index) = [];
            
            story_train_speaker_Attend = eval(strcat('Speaker_Attend_Listener',num2str(listener),'_total'));
            story_train_speaker_unAttend = eval(strcat('Speaker_notAttend_Listener',num2str(listener),'_total'));
            story_train_speaker_Attend(:,predict_time_index) = [];
            story_train_speaker_unAttend(:,predict_time_index) = [];
            
            
            % cca
            [train_cca_attend_listener_w,train_cca_attend_speaker_w,train_cca_attend_r] = canoncorr(story_train_listener_EEG',story_train_speaker_Attend');
            [train_cca_unattend_listener_w,train_cca_unattend_speaker_w,train_cca_unattend_r] = canoncorr(story_train_listener_EEG',story_train_speaker_unAttend');
            
            % record into one matrix
            train_cca_attend_listener_w_mean(:,story) = train_cca_attend_listener_w(:,1);
            train_cca_attend_speaker_w_mean(:,story) = train_cca_attend_speaker_w(:,1);
            train_cca_attend_r(:,story) = train_cca_attend_r(1);
            train_cca_unattend_listener_w_mean(:,story) = train_cca_unattend_listener_w(:,1);
            train_cca_unattend_speaker_w_mean(:,story) = train_cca_unattend_speaker_w(:,1);
            train_cca_unattend_r(:,story) = train_cca_unattend_r(1);
            
            % apply weights to each story as training sample
            cnt_train_story = 1;
            for train_story = 1 : 15
                
                
                if train_story ~= story
                    story_train_EEG = eval(strcat('Listener',num2str(listener),'{train_story}'));
                    story_train_EEG = story_train_EEG(listener_chn,listener_time_index+timelag(j));
                    story_train_speaker_A = data_speakerA{train_story}(speaker_chn,speaker_time_index);
                    story_train_speaker_B = data_speakerB{train_story}(speaker_chn,speaker_time_index);
                    
                    
                    % apply weights to individual story
                    % speaker
                    reconstruction_speakerA_attend_train = train_cca_attend_speaker_w_mean(:,story)' *  story_train_speaker_A;
                    reconstruction_speakerB_attend_train = train_cca_attend_speaker_w_mean(:,story)' *  story_train_speaker_B;
                    reconstruction_speakerA_unattend_train = train_cca_unattend_speaker_w_mean(:,story)' *  story_train_speaker_A;
                    reconstruction_speakerB_unattend_train = train_cca_unattend_speaker_w_mean(:,story)' *  story_train_speaker_B;
                    
                    % listener
                    reconstruction_listener_attend_train = train_cca_attend_listener_w_mean(:,story)' *  story_predict_listener_EEG;
                    reconstruction_listener_unattend_train = train_cca_unattend_listener_w_mean(:,story)' *  story_predict_listener_EEG;
                    
                    
                    if ListenA_Or_Not(train_story,listener) == 1
                        [recon_AttendDecoder_attend_cca_train(cnt_train_story,listener,story),p_recon_AttendDecoder_attend_cca(listener,story)] =...
                            corr(reconstruction_listener_attend_train',reconstruction_speakerA_attend_train');
                        [recon_AttendDecoder_unattend_cca_train(cnt_train_story,listener,story),p_recon_AttendDecoder_unattend_cca(listener,story)] = ...
                            corr(reconstruction_listener_attend_train',reconstruction_speakerB_attend_train');
                        
                        [recon_UnattendDecoder_unattend_cca_train(cnt_train_story,listener,story),p_recon_UnattendDecoder_unattend_cca(listener,story)] = ...
                            corr(reconstruction_listener_unattend_train',reconstruction_speakerB_unattend_train');
                        
                        [recon_UnattendDecoder_attend_cca_train(cnt_train_story,listener,story),p_recon_UnattendDecoder_attend_cca(listener,story)] = ...
                            corr(reconstruction_listener_unattend_train',reconstruction_speakerA_unattend_train');
                    else
                        [recon_AttendDecoder_attend_cca_train(cnt_train_story,listener,story),p_recon_AttendDecoder_attend_cca(listener,story)] = ...
                            corr(reconstruction_listener_attend_train',reconstruction_speakerB_attend_train');
                        
                        [recon_AttendDecoder_unattend_cca_train(cnt_train_story,listener,story),p_recon_AttendDecoder_unattend_cca(listener,story)] = ...
                            corr(reconstruction_listener_attend_train',reconstruction_speakerA_attend_train');
                        
                        [recon_UnattendDecoder_unattend_cca_train(cnt_train_story,listener,story),p_recon_UnattendDecoder_unattend_cca(listener,story)] = ...
                            corr(reconstruction_listener_unattend_train',reconstruction_speakerA_unattend_train');
                        
                        [recon_UnattendDecoder_attend_cca_train(cnt_train_story,listener,story),p_recon_UnattendDecoder_attend_cca(listener,story)] = ...
                            corr(reconstruction_listener_unattend_train',reconstruction_speakerB_unattend_train');
                    end
                    
                    
                    cnt_train_story = cnt_train_story + 1;
                    
                end
                
                
            end
            
            
            % predict
            disp(strcat('Predicting listener ',num2str(listener),' story ',num2str(story),'...'));
            % listener
            reconstruction_listener_attend = train_cca_attend_listener_w_mean(:,story)' *  story_predict_listener_EEG;
            reconstruction_listener_unattend = train_cca_unattend_listener_w_mean(:,story)' *  story_predict_listener_EEG;
            
            % speaker
            reconstruction_speakerA_attend = train_cca_attend_speaker_w_mean(:,story)' *  story_predict_speaker_A;
            reconstruction_speakerB_attend = train_cca_attend_speaker_w_mean(:,story)' *  story_predict_speaker_B;
            reconstruction_speakerA_unattend = train_cca_unattend_speaker_w_mean(:,story)' *  story_predict_speaker_A;
            reconstruction_speakerB_unattend = train_cca_unattend_speaker_w_mean(:,story)' *  story_predict_speaker_B;
            
            
            if ListenA_Or_Not(story,listener) == 1
                [recon_AttendDecoder_attend_cca(listener,story),p_recon_AttendDecoder_attend_cca(listener,story)] =...
                    corr(reconstruction_listener_attend',reconstruction_speakerA_attend');
                [recon_AttendDecoder_unattend_cca(listener,story),p_recon_AttendDecoder_unattend_cca(listener,story)] = ...
                    corr(reconstruction_listener_attend',reconstruction_speakerB_attend');
                
                [recon_UnattendDecoder_unattend_cca(listener,story),p_recon_UnattendDecoder_unattend_cca(listener,story)] = ...
                    corr(reconstruction_listener_unattend',reconstruction_speakerB_unattend');
                
                [recon_UnattendDecoder_attend_cca(listener,story),p_recon_UnattendDecoder_attend_cca(listener,story)] = ...
                    corr(reconstruction_listener_unattend',reconstruction_speakerA_unattend');
            else
                [recon_AttendDecoder_attend_cca(listener,story),p_recon_AttendDecoder_attend_cca(listener,story)] = ...
                    corr(reconstruction_listener_attend',reconstruction_speakerB_attend');
                
                [recon_AttendDecoder_unattend_cca(listener,story),p_recon_AttendDecoder_unattend_cca(listener,story)] = ...
                    corr(reconstruction_listener_attend',reconstruction_speakerA_attend');
                
                [recon_UnattendDecoder_unattend_cca(listener,story),p_recon_UnattendDecoder_unattend_cca(listener,story)] = ...
                    corr(reconstruction_listener_unattend',reconstruction_speakerA_unattend');
                
                [recon_UnattendDecoder_attend_cca(listener,story),p_recon_UnattendDecoder_attend_cca(listener,story)] = ...
                    corr(reconstruction_listener_unattend',reconstruction_speakerB_unattend');
            end
            
            
        end
    end
    
    %% plot
    %     % reconstruction accuracy plot attend
    %     figure; plot(mean(recon_AttendDecoder_attend_cca,2),'r');
    %     hold on; plot(mean(recon_AttendDecoder_unattend_cca,2),'b');
    %     xlabel('Subject No.'); ylabel('r value')
    %     title('Speaker-listener correlation using CCA method for attend decoder theta');
    %     legend('Speaker attended ','Speaker unAttended')
    %     saveas(gcf,'Speaker-listener correlation using CCA method for attend decoder.jpg')
    %
    %     % reconstruction accuracy plot unattend
    %     figure; plot(mean(recon_UnattendDecoder_attend_cca,2),'r');
    %     hold on; plot(mean(recon_UnattendDecoder_unattend_cca,2),'b');
    %     xlabel('Subject No.'); ylabel('r value')
    %     title('Speaker-listener correlation using CCA method for unattend decoder theta');
    %     legend('Speaker attended ','Speaker unAttended')
    %     saveas(gcf,'Speaker-listener correlation using CCA method for unattend decoder theta.jpg')
    %
    %     % Decoding accuracy plot attend
    %     Decoding_result_attend_decoder = recon_AttendDecoder_attend_cca-recon_AttendDecoder_unattend_cca;
    %     Individual_subjects_result_attend = sum(Decoding_result_attend_decoder>0,2)/15;
    %     mean(Individual_subjects_result_attend)
    %     Decoding_result_unattend_decoder = recon_UnattendDecoder_unattend_cca-recon_UnattendDecoder_attend_cca;
    %     Individual_subjects_result_unattend = sum(Decoding_result_unattend_decoder>0,2)/15;
    %     mean(Individual_subjects_result_unattend)
    %     figure; plot(Individual_subjects_result_attend*100,'r');
    %     hold on; plot(Individual_subjects_result_unattend*100,'b');
    %     xlabel('Subject No.'); ylabel('Decoding Accuarcy %');ylim([0,100]);
    %     title('Decoding accuracy using cca method for Speaker and listener theta')
    %     legend('Attended Decoder','Unattended Decoder')
    %     saveas(gcf,'Decoding accuracy using cca method for Speaker and listener theta.jpg')
    % save
    saveName = strcat('cca_S-L_EEG_result+',num2str(timelag(j)),'ms',band_name,'.mat');
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
    saveName1 = strcat('Reconstruction Accuracy using S-L cca method for attend decoder+',num2str(timelag(j)),'ms',band_name,'.jpg');
    title(saveName1(1:end-4));
    legend('Audio attend ','Audio not Attend')
    saveas(gcf,saveName1);
    close
    
    % reconstruction accuracy plot unattend
    figure; plot(mean(recon_UnattendDecoder_attend_cca,2),'r');
    hold on; plot(mean(recon_UnattendDecoder_unattend_cca,2),'b');
    xlabel('Subject No.'); ylabel('r value')
    saveName2 = strcat('Reconstruction Accuracy using S-L cca method for unattend decoder+',num2str(timelag(j)),'ms',band_name,'.jpg');
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
    saveName3 = strcat('Decoding accuracy using S-L cca method for attend and unattend decoder+',num2str(timelag(j)),'ms',band_name,'.jpg');
    title(saveName3(1:end-4))
    legend('Attend Decoder','Unattend Decoder')
    saveas(gcf,saveName3);
    close
    
end