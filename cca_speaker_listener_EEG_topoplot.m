%% Speaker EEG & listener EEG cca topoplot for Speaker_listener study
% Li Jiawei:  jx_ljw@163.com
% 2016.12.28
% for computering listener EEG & speaker EEG cca

%% initial
Fs = 64;
start_time = 10;
end_time = 35;

zlim = 3;

%% load Listener data
listener_time_index =  (start_time+5)*Fs+1:(end_time+5)*Fs; % 10 s - 35s
% load('E:\DataProcessing\afterICA_data\ISC_all_ref_after_ICA_64Hz_bandpass_2-8Hz.mat')
% load('E:\DataProcessing\afterICA_data\ISC_all_ref_after_ICA_64Hz.mat')
% load('E:\DataProcessing\afterICA_data\ISC_all_ref_after_ICA_2-8Hz.mat')
load('E:\DataProcessing\afterICA_data\ISC_all_ref_after_ICA_64Hz_0.1-40Hz.mat')

%% load speaker data
speaker_time_index =  (start_time+5)*Fs+1:(end_time+5)*Fs; % 10s - 35s
% load('E:\DataProcessing\afterICA_data\data_speaker_64Hz.mat')
% % load('E:\DataProcessing\afterICA_data\SoundResult_0s-35s_64Hz_hilbert_lowpass8Hz.mat')
load('E:\DataProcessing\afterICA_data\data_speaker_64Hz_bp_0.1-40Hz.mat')
%% Channel Index
listener_chn= 1:60;
speaker_chn = [1:32 34:42 44:59 61:63];

%% attend matrix
load('E:\DataProcessing\ListenA_Or_Not.mat')

%% timelag
% timelag = 0;
timelag = (-250:500/32:500)/(1000/Fs);
timelag = timelag(7);
% timelag = 250/(1000/Fs);

%% topoplot initial
load('E:\DataProcessing\label66.mat');
load('E:\DataProcessing\easycapm1.mat');
chn2chnName= [1:32 34:42 44:59 61:63];


for r = 6
    %% band name
    band_name = strcat(' 0.1-40Hz r rank',num2str(r));
    
    for j = 1: length(timelag)
        % %% Combine data
        %
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
                    eval(strcat('speaker_notAttend_',dataName,'_total(:,cnt:cnt+length(speaker_time_index)-1)=SpeakerA;'));
                end
                cnt = cnt + length(listener_time_index);
            end
            
            
            disp('done');
            toc
            
        end
        
        
        %% correlation
        
        % weights matrix
        train_cca_attend_listener_w_total = cell(1,15);
        train_cca_attend_speaker_w_total = cell(1,15);
        train_cca_unattend_listener_w_total = cell(1,15);
        train_cca_unattend_speaker_w_total = cell(1,15);
        
        for listener = 1 : 12
            
            train_cca_attend_listener_w_mean = zeros(60,15);
            train_cca_attend_speaker_w_mean = zeros(60,15);
            %             train_cca_attend_r = zeros(60,15);
            
            train_cca_unattend_listener_w_mean = zeros(60,15);
            train_cca_unattend_speaker_w_mean = zeros(60,15);
            %             train_cca_unattend_r = zeros(60,15);
            
            
            % train data
            story_train_listener_EEG = eval(strcat('eeg_dual_Listener',num2str(listener),'_total'));
            story_train_speaker_Attend = eval(strcat('Speaker_Attend_Listener',num2str(listener),'_total'));
            story_train_speaker_unAttend = eval(strcat('Speaker_notAttend_Listener',num2str(listener),'_total'));
            
            
            
            % cca
            [train_cca_attend_listener_w,train_cca_attend_speaker_w,train_cca_attend_r] = canoncorr(story_train_listener_EEG',story_train_speaker_Attend');
            [train_cca_unattend_listener_w,train_cca_unattend_speaker_w,train_cca_unattend_r] = canoncorr(story_train_listener_EEG',story_train_speaker_unAttend');
            
            % listener attended  decoder plot
            save_nameA = strcat('CCA S-L method Listener weights attended decoder Listener',num2str(listener),'+',num2str(1000/Fs*timelag(j)),'ms',band_name,'.jpg');
            title(save_nameA(1:end-4))
            %             U_topoplot(abs(zscore(train_cca_attend_listener_w)), 'easycapm1.lay', label66(chn2chnName),[],zlim);
            U_topoplot(zscore(train_cca_attend_listener_w), 'easycapm1.lay', label66(chn2chnName),[],zlim);
            saveas(gcf,save_nameA);
            
            % listener unattended decoder plot
            save_nameB = strcat('CCA S-L method Listener weights unattended decoder Listener',num2str(listener),'+',num2str(1000/Fs*timelag(j)),'ms',band_name,'.jpg');
            title(save_nameB(1:end-4))
            %             U_topoplot(abs(zscore(train_cca_unattend_listener_w)), 'easycapm1.lay', label66(chn2chnName),[],zlim);
            U_topoplot(zscore(train_cca_unattend_listener_w), 'easycapm1.lay', label66(chn2chnName),[],zlim);
            saveas(gcf,save_nameB);
            
            
            % speaker attended decoder plot
            save_nameC = strcat('CCA S-L method Speaker weights attended decoder Listener',num2str(listener),'+',num2str(1000/Fs*timelag(j)),'ms',band_name,'.jpg');
            title(save_nameC(1:end-4))
            %             U_topoplot(abs(zscore(train_cca_attend_speaker_w)), 'easycapm1.lay', label66(chn2chnName),[],zlim);
            U_topoplot(zscore(train_cca_attend_speaker_w), 'easycapm1.lay', label66(chn2chnName),[],zlim);
            saveas(gcf,save_nameC);
            
            % speaker unattended decoder plot
            save_nameD = strcat('CCA S-L method Speaker weights unattended decoder Listener',num2str(listener),'+',num2str(1000/Fs*timelag(j)),'ms',band_name,'.jpg');
            title(save_nameD(1:end-4))
            %             U_topoplot(abs(zscore(train_cca_unattend_speaker_w)), 'easycapm1.lay', label66(chn2chnName),[],zlim);
            U_topoplot(zscore(train_cca_unattend_speaker_w), 'easycapm1.lay', label66(chn2chnName),[],zlim);
            saveas(gcf,save_nameD);
            
            
            close all
            train_cca_attend_listener_w_total{listener} = train_cca_attend_listener_w(:,r);
            train_cca_unattend_listener_w_total{listener} = train_cca_attend_speaker_w(:,r);
            train_cca_attend_speaker_w_total{listener} = train_cca_unattend_listener_w(:,r);
            train_cca_unattend_speaker_w_total{listener} = train_cca_unattend_speaker_w(:,r);
            
        end
        
        %% save data
        
        saveName = strcat('cca_S-L_EEG_result+',num2str((1000/Fs)*timelag(j)),'ms',band_name,'.mat');
        save(saveName,'train_cca_attend_listener_w_total','train_cca_unattend_listener_w_total','train_cca_attend_speaker_w_total','train_cca_unattend_speaker_w_total');
        
        
        
    end
end