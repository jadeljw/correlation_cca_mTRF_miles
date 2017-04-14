%% Speaker EEG & listener EEG corr topoplot for Speaker_listener study
% Li Jiawei:  jx_ljw@163.com
% 2016.12.28
% for computering listener EEG & speaker EEG corr

%% initial
Fs = 64;
start_time = 10;
end_time = 35;

zlim = 3;


%% band name
band_name = ' broadband 0.1-40Hz lambda4096';
% 2 - 8 Hz for theta analysis
lambda = 2^12;

%% load Listener data
listener_time_index =  (start_time+5)*Fs+1:(end_time+5)*Fs; % 10 s - 35s
% load('E:\DataProcessing\afterICA_data\ISC_all_ref_after_ICA_64Hz_bandpass_2-8Hz.mat')
load('E:\DataProcessing\afterICA_data\ISC_all_ref_after_ICA_64Hz.mat')
% load('E:\DataProcessing\afterICA_data\ISC_all_ref_after_ICA_2-8Hz.mat')
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
speaker_chn = [1:32 34:42 44:59 61:63];

%% attend matrix
load('E:\DataProcessing\ListenA_Or_Not.mat')

%% timelag
% timelag = 0;
timelag = (-250:500/32:500)/(1000/Fs);
timelag = timelag(33);
% timelag = 250/(1000/Fs);

%% topoplot initial
load('E:\DataProcessing\label66.mat');
load('E:\DataProcessing\easycapm1.mat');
chn2chnName= [1:32 34:42 44:59 61:63];


%% Combine data
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
    eval(strcat('audio_Attend_',dataName,'_total=zeros(1,15*length(sound_time_index));'));
    eval(strcat('audio_notAttend_',dataName,'_total=zeros(1,15*length(sound_time_index));'));
    
    % Combine data
    cnt = 1;
    for i = 1 : 15
        
        % EEG
        tempDataA = eval(dataName);
        EEG_all = tempDataA{i};
        EEG_all = EEG_all(chn_sel_index,listener_time_index);
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


for j = 1: length(timelag)
    
    %% initial
    Fs = 64;
    start_time = 0 + timelag(j);
    end_time = 0 + timelag(j);
    
    %% correlation
    
    % weights matrix
    train_corr_attend_listener_w_total = cell(1,15);
    train_corr_attend_speaker_w_total = cell(1,15);
    train_corr_unattend_listener_w_total = cell(1,15);
    train_corr_unattend_speaker_w_total = cell(1,15);
    
    for listener = 1 : 12
        
        train_corr_attend_listener_w_mean = zeros(60,15);
        train_corr_attend_speaker_w_mean = zeros(60,15);
        %             train_corr_attend_r = zeros(60,15);
        
        train_corr_unattend_listener_w_mean = zeros(60,15);
        train_corr_unattend_speaker_w_mean = zeros(60,15);
        %             train_corr_unattend_r = zeros(60,15);
        
        
        %% train data
        story_train_EEG = eval(strcat('eeg_dual_Listener',num2str(listener),'_total'));
        story_train_audio_Attend = eval(strcat('audio_Attend_Listener',num2str(listener),'_total'));
        story_train_audio_unAttend = eval(strcat('audio_notAttend_Listener',num2str(listener),'_total'));
        
        % mTRF
            [w_train_mTRF_attend,t_train_mTRF_attend,con_train_mTRF_attend] = mTRFtrain(zscore(story_train_audio_Attend'),zscore(story_train_EEG'),Fs,1,start_time,end_time,lambda);
            [w_train_mTRF_unattend,t_train_mTRF_unattend,con_train_mTRF_unattend] = mTRFtrain(zscore(story_train_audio_unAttend'),zscore(story_train_EEG'),Fs,1,start_time,end_time,lambda);
        
        % listener attended  decoder plot
        save_nameA = strcat('mTRF method Listener weights attended decoder Listener',num2str(listener),'+',num2str(1000/Fs*timelag(j)),'ms',band_name,'.jpg');
        title(save_nameA(1:end-4))
        %             U_topoplot(abs(zscore(train_corr_attend_listener_w)), 'easycapm1.lay', label66(chn2chnName),[],zlim);
        U_topoplot(zscore(w_train_mTRF_attend), 'easycapm1.lay', label66(chn2chnName),[],zlim);
        saveas(gcf,save_nameA);
        
        % listener unattended decoder plot
        save_nameB = strcat('mTRF method Listener weights unattended decoder Listener',num2str(listener),'+',num2str(1000/Fs*timelag(j)),'ms',band_name,'.jpg');
        title(save_nameB(1:end-4))
        %             U_topoplot(abs(zscore(train_corr_unattend_listener_w)), 'easycapm1.lay', label66(chn2chnName),[],zlim);
        U_topoplot(zscore(w_train_mTRF_unattend), 'easycapm1.lay', label66(chn2chnName),[],zlim);
        saveas(gcf,save_nameB);
        
        
        close all
        train_corr_attend_listener_w_total{listener} = w_train_mTRF_attend;
        train_corr_unattend_listener_w_total{listener} = w_train_mTRF_unattend;
        %         train_corr_attend_speaker_w_total{listener} = train_corr_unattend_listener_w(:,r);
        %         train_corr_unattend_speaker_w_total{listener} = train_corr_unattend_speaker_w(:,r);
        
    end
    
    %% save data
    
    saveName = strcat('mTRF_result+',num2str((1000/Fs)*timelag(j)),'ms',band_name,'.mat');
    save(saveName,'train_corr_attend_listener_w_total','train_corr_unattend_listener_w_total','train_corr_attend_speaker_w_total','train_corr_unattend_speaker_w_total');
    
    
    
end

