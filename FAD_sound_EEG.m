%% FDA for sound evenlope and listener EEG
% first,use CCA attended/unattended decoder and mTRF attended/unattended decoder
% to use EEG to predict sound envelope
% (ref: CCA_sound_EEG.m/mTRF_sound_EEG.m)
% then, compute the correlation between predict sound envelope and origil
% sound evelope, and use r for training

%% initial
bandName = ' 64Hz 10s-35s';
Fs = 64;
% timelag = (-250:500/32:500)/(1000/Fs);
timelag = 0;

%% attend matrix
load('E:\DataProcessing\ListenA_Or_Not.mat')

%%
for j = 1 : length(timelag)
    
    %% CCA data
    p = 'E:\DataProcessing\correlation_cca_mTRF';
    category_cca = 'CCA';
    datapath_cca = strcat(p,'\',category_cca,'\',bandName(2:end));
    dataName_cca = strcat('cca_sound_EEG_result+',num2str((1000/Fs)*timelag(j)),'ms',bandName,'.mat');
    load(strcat(datapath_cca,'\',dataName_cca));
    % train
    cca_AttendDecoder_attend_r_train =recon_AttendDecoder_attend_cca_train;
    cca_AttendDecoder_unattend_r_train =recon_AttendDecoder_unattend_cca_train;
    cca_UnattendDecoder_attend_r_train =recon_UnattendDecoder_attend_cca_train;
    cca_UnattendDecoder_unattend_r_train =recon_UnattendDecoder_unattend_cca_train;
    
    % predict
    cca_AttendDecoder_attend_r =recon_AttendDecoder_attend_cca;
    cca_AttendDecoder_unattend_r =recon_AttendDecoder_unattend_cca;
    cca_UnattendDecoder_attend_r =recon_UnattendDecoder_attend_cca;
    cca_UnattendDecoder_unattend_r =recon_UnattendDecoder_unattend_cca;
    
    
    %% CCA speaker-listener data
    category_cca_S_L = 'CCA_speaker_listener_EEG';
    datapath_cca_S_L = strcat(p,'\',category_cca_S_L,'\',bandName(2:end));
    %     dataName = strcat('cca_speaker_listener_EEG_result+',num2str(timelag(j)),'ms',bandName,'.mat');
    dataName_cca_S_L = strcat('cca_S-L_EEG_result+',num2str((1000/Fs)*timelag(j)),'ms',bandName,'.mat');
    load(strcat(datapath_cca_S_L,'\',dataName_cca_S_L));
    
    % train
    cca_S_L_AttendDecoder_attend_r_train =recon_AttendDecoder_attend_cca_train;
    cca_S_L_AttendDecoder_unattend_r_train =recon_AttendDecoder_attend_cca_train;
    cca_S_L_UnattendDecoder_attend_r_train =recon_UnattendDecoder_attend_cca_train;
    cca_S_L_UnattendDecoder_unattend_r_train =recon_UnattendDecoder_unattend_cca_train;
    
    % predict
    cca_S_L_AttendDecoder_attend_r =recon_AttendDecoder_attend_cca;
    cca_S_L_AttendDecoder_unattend_r =recon_AttendDecoder_attend_cca;
    cca_S_L_UnattendDecoder_attend_r =recon_UnattendDecoder_attend_cca;
    cca_S_L_UnattendDecoder_unattend_r =recon_UnattendDecoder_unattend_cca;
    
    predict_result = zeros(15,12); % story = 15; listener = 12;
    
    for listener = 1 : 12
        for story = 1 : 15
%             train_temp =[];
            train_data_temp = [cca_AttendDecoder_attend_r_train(:,listener,story)';cca_AttendDecoder_unattend_r_train(:,listener,story)';...
                cca_UnattendDecoder_attend_r_train(:,listener,story)';cca_UnattendDecoder_unattend_r_train(:,listener,story)';...
                cca_S_L_AttendDecoder_attend_r_train(:,listener,story)';cca_S_L_AttendDecoder_unattend_r_train(:,listener,story)';...
                cca_S_LUnattendDecoder_attend_r_train(:,listener,story)';cca_S_L_UnattendDecoder_unattend_r_train(:,listener,story)'];
            train_labels_temp = 
            
            
        end
    end

    
end