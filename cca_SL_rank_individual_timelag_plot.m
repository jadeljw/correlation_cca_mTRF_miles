%% cca Speaker-listener different r rank individual timelag plot

for bandName = 1 : 10
    
    % data Name
    file_name = strcat(' 64Hz r rank',num2str(bandName));
    data_name = strcat(' 0.5Hz-40Hz 64Hz r rank',num2str(bandName));
    %% timelag
    
    % timelag = -200:25:500;
    Fs = 64;
    
    timelag = (-250:500/32:500)/(1000/Fs);
    
    recon_AttendDecoder_attend_total = zeros(1,length(timelag));
    recon_AttendDecoder_unattend_total = zeros(1,length(timelag));
    recon_UnattendDecoder_attend_total = zeros(1,length(timelag));
    recon_UnattendDecoder_unattend_total = zeros(1,length(timelag));
    decoding_acc_attended = zeros(1,length(timelag));
    decoding_acc_unattended = zeros(1,length(timelag));
    Decoding_acc_attend_ttest_result = zeros(1,length(timelag));
    Decoding_acc_unattend_ttest_result = zeros(1,length(timelag));
    
    
    %%  CCA speaker listener plot
    p = 'E:\DataProcessing\correlation_cca_mTRF';
    category = 'CCA_speaker_listener_EEG';
    
    for  j = 1 : length(timelag)
        % load data
        datapath = strcat(p,'\',category,'\','0.5-40Hz\',file_name(2:end));
        %     dataName = strcat('cca_speaker_listener_EEG_result+',num2str(timelag(j)),'ms',bandName,'.mat');
        dataName = strcat('cca_S-L_EEG_result+',num2str((1000/Fs)*timelag(j)),'ms',data_name,'.mat');
        load(strcat(datapath,'\',dataName));
        
        %reconstruction accuracy
        recon_AttendDecoder_attend_total(j) =  mean(mean(recon_AttendDecoder_attend_cca));
        recon_AttendDecoder_unattend_total(j) =  mean(mean(recon_AttendDecoder_unattend_cca));
        recon_UnattendDecoder_attend_total(j) = mean(mean(recon_UnattendDecoder_attend_cca));
        recon_UnattendDecoder_unattend_total(j) = mean(mean(recon_UnattendDecoder_unattend_cca));
        
        %decoding accuracy
        Decoding_result_attend_decoder = recon_AttendDecoder_attend_cca-recon_AttendDecoder_unattend_cca;
        Individual_subjects_result_attend = sum(Decoding_result_attend_decoder>0,2)/15;
        % ttest
        Decoding_acc_attend_ttest_result(j) = ttest(Individual_subjects_result_attend,0.5);
        decoding_acc_attended(j)= mean(Individual_subjects_result_attend);
        
        Decoding_result_unattend_decoder = recon_UnattendDecoder_unattend_cca-recon_UnattendDecoder_attend_cca;
        % ttest
        Individual_subjects_result_unattend = sum(Decoding_result_unattend_decoder>0,2)/15;
        Decoding_acc_unattend_ttest_result(j) = ttest(Individual_subjects_result_unattend,0.5);
        decoding_acc_unattended(j) = mean(Individual_subjects_result_unattend);
        
    end
    
    
    
    figure; plot((1000/Fs)*timelag,recon_AttendDecoder_attend_total,'r');
    hold on; plot((1000/Fs)*timelag,recon_AttendDecoder_unattend_total,'b');
    xlabel('Times(ms)'); ylabel('r-value')
    saveName1 = strcat('Attended decoder Reconstruction-Acc using CCA S-L EEG method',data_name,'.jpg');
    title(saveName1(1:end-4));
    legend('r Attended ','r unAttended');
    %     ylim([-0.05,0.05]);
    saveas(gcf,saveName1);
    close
    
    figure; plot((1000/Fs)*timelag,recon_UnattendDecoder_attend_total,'r');
    hold on; plot((1000/Fs)*timelag,recon_UnattendDecoder_unattend_total,'b');
    xlabel('Times(ms)'); ylabel('r-value')
    saveName2 = strcat('Unattended decoder Reconstruction-Acc using CCA S-L EEG method',data_name,'.jpg');
    title(saveName2(1:end-4));
    legend('r Attended ','r unAttended');
    %     ylim([-0.05,0.05]);
    saveas(gcf,saveName2);
    close
    
    figure; plot((1000/Fs)*timelag,decoding_acc_attended*100,'r');
    hold on;plot((1000/Fs)*timelag(Decoding_acc_attend_ttest_result>0),decoding_acc_attended(Decoding_acc_attend_ttest_result>0)*100,'r*');
    hold on; plot((1000/Fs)*timelag,decoding_acc_unattended*100,'b');
    hold on;plot((1000/Fs)*timelag(Decoding_acc_unattend_ttest_result>0),decoding_acc_unattended(Decoding_acc_unattend_ttest_result>0)*100,'b*');
    xlabel('Times(ms)'); ylabel('Decoding accuracy(%)')
    saveName3 = strcat('Decoding-Acc across all time-lags using S-L EEG method',data_name,'.jpg');
    title(saveName3(1:end-4));
    if sum(Decoding_acc_attend_ttest_result>0) == 0 && sum(Decoding_acc_unattend_ttest_result>0) == 0
        legend('Attended decoder','Unattended decoder');
    elseif sum(Decoding_acc_attend_ttest_result>0) == 0
        legend('Attended decoder','Unattended decoder','significant 』 50%');
    elseif sum(Decoding_acc_unattend_ttest_result>0) == 0
        legend('Attended decoder','significant 』 50%','Unattended decoder');
    else
        legend('Attended decoder','significant 』 50%','Unattended decoder','significant 』 50%');
    end
    ylim([30,100]);
    saveas(gcf,saveName3);
    close
    
end
