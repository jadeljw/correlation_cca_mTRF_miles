%% cca - correlation - mTRF individual timelag plot

%% timelag

% timelag = -200:25:500;
Fs = 64;

% timelag = (-3000:500/32:3000)/(1000/Fs);
timelag = (-250:500/32:500)/(1000/Fs);
% timelag= timelag(33:40);
% timelag = (0:500/32:500)/(1000/Fs);
recon_AttendDecoder_attend_total = zeros(1,length(timelag));
recon_AttendDecoder_unattend_total = zeros(1,length(timelag));
recon_UnattendDecoder_attend_total = zeros(1,length(timelag));
recon_UnattendDecoder_unattend_total = zeros(1,length(timelag));
decoding_acc_attended = zeros(1,length(timelag));
decoding_acc_unattended = zeros(1,length(timelag));
Decoding_acc_attend_ttest_result = zeros(1,length(timelag));
Decoding_acc_unattend_ttest_result = zeros(1,length(timelag));

mean_acc_AttendDecoder_train_mean = zeros(1,length(timelag));
mean_acc_AttendDecoder_train_ttest_result = zeros(1,length(timelag));
mean_acc_UnattendDecoder_train_mean = zeros(1,length(timelag));
mean_acc_UnattendDecoder_train_ttest_result = zeros(1,length(timelag));

acc_AttendDecoder_train = zeros(12,15);
acc_AttendDecoder_test = zeros(12,15);
acc_UnattendDecoder_train = zeros(12,15);
acc_UnattendDecoder_test = zeros(12,15);

bandName = ' 64Hz 2-8Hz lambda 4096';

%%  mTRF plot
% p = pwd;
p = 'E:\DataProcessing\correlation_cca_mTRF';
% category = 'mTRF';
category = 'mTRF_single_trial\M1M2';

for  j = 1 : length(timelag)
    % load data
    %     datapath = strcat(p,'\',category);
    %     dataName = strcat('mTRF_sound_EEG_result+',num2str(timelag(j)),'ms.mat');
    %     datapath = strcat(p,'\',category,'\-200ms_500ms_64Hz');
    datapath = strcat(p,'\',category,'\',bandName(2:end));
    %     dataName = strcat('mTRF_sound_EEG_result+',num2str((1000/Fs)*timelag(j)),'ms.mat');
    dataName = strcat('mTRF_sound_EEG_result+',num2str((1000/Fs)*timelag(j)),'ms',bandName,'.mat');
%     band_name = strcat(' broadband 0.1-40Hz lambda',num2str(lambda(j)));
%     dataName = strcat('mTRF_sound_EEG_result -200~500 ms',band_name,'.mat');
    load(strcat(datapath,'\',dataName));
    
    for listener = 1 : 12
        for story = 1 : 15
            % train acc
            acc_AttendDecoder_train(listener,story) = length(find(squeeze(recon_AttendDecoder_attend_corr_train(:,listener,story))>squeeze(recon_AttendDecoder_unattend_corr_train(:,listener,story))));
            acc_AttendDecoder_test(listener,story) = recon_AttendDecoder_attend_corr(listener,story)>recon_AttendDecoder_unattend_corr(listener,story);
            acc_UnattendDecoder_train(listener,story) = length(find(squeeze(recon_UnattendDecoder_unattend_corr_train(:,listener,story))>squeeze(recon_UnattendDecoder_attend_corr_train(:,listener,story))));
            acc_UnattendDecoder_test(listener,story) = recon_UnattendDecoder_unattend_corr(listener,story)>recon_UnattendDecoder_attend_corr(listener,story);
        end
    end
    
    %reconstruction accuracy
    recon_AttendDecoder_attend_total(j) =  mean(mean(recon_AttendDecoder_attend_corr));
    recon_AttendDecoder_unattend_total(j) =  mean(mean(recon_AttendDecoder_unattend_corr));
    recon_UnattendDecoder_attend_total(j) = mean(mean(recon_UnattendDecoder_attend_corr));
    recon_UnattendDecoder_unattend_total(j) = mean(mean(recon_UnattendDecoder_unattend_corr));
    
    %decoding accuracy
    Decoding_result_attend_decoder = recon_AttendDecoder_attend_corr-recon_AttendDecoder_unattend_corr;
    Individual_subjects_result_attend = sum(Decoding_result_attend_decoder>0,2)/15;
    % ttest
    Decoding_acc_attend_ttest_result(j) = ttest(Individual_subjects_result_attend,0.5);
    decoding_acc_attended(j)= mean(Individual_subjects_result_attend);
    
    Decoding_result_unattend_decoder = recon_UnattendDecoder_unattend_corr-recon_UnattendDecoder_attend_corr;
    Individual_subjects_result_unattend = sum(Decoding_result_unattend_decoder>0,2)/15;
    % ttest
    Decoding_acc_unattend_ttest_result(j) = ttest(Individual_subjects_result_unattend,0.5);
    decoding_acc_unattended(j) = mean(Individual_subjects_result_unattend);
    
    %decoding accuracy for train data
    mean_acc_AttendDecoder_train = mean(acc_AttendDecoder_train./14,2);
    mean_acc_AttendDecoder_train_mean(j) = mean(mean(acc_AttendDecoder_train./14,2));
    mean_acc_AttendDecoder_train_ttest_result(j) = ttest(mean_acc_AttendDecoder_train,0.5);
    
    mean_acc_UnattendDecoder_train = mean(acc_UnattendDecoder_train./14,2);
    mean_acc_UnattendDecoder_train_mean(j) = mean(mean(acc_UnattendDecoder_train./14,2));
    mean_acc_UnattendDecoder_train_ttest_result(j) = ttest(mean_acc_UnattendDecoder_train,0.5);
    
end


% recon r for attended decoder
figure; plot((1000/Fs)*timelag,recon_AttendDecoder_attend_total,'r');
hold on; plot((1000/Fs)*timelag,recon_AttendDecoder_unattend_total,'b');
xlabel('Times(ms)'); 
ylabel('r-value')
saveName1 = strcat( 'Attended decoder Reconstruction-Acc across all time-lags using mTRF method',bandName,'.jpg');
% saveName1 = strcat( 'Attended decoder Reconstruction-Acc across all time-lags using mTRF method',band_name,'.jpg');
title(saveName1(1:end-4));
legend('r Attended ','r unAttended','Location','northeast');
% ylim([-0.03,0.03]);
saveas(gcf,saveName1);
close


% recon r for unattended decoder
figure; plot((1000/Fs)*timelag,recon_UnattendDecoder_attend_total,'r');
hold on; plot((1000/Fs)*timelag,recon_UnattendDecoder_unattend_total,'b');
xlabel('Times(ms)'); 
ylabel('r-value')
saveName2 = strcat('Unattended decoder Reconstruction-Acc across all time-lags using mTRF method',bandName,'.jpg');
% saveName2 = strcat('Unattended decoder Reconstruction-Acc across all time-lags using mTRF method',band_name,'.jpg');
title(saveName2(1:end-4));
legend('r Attended ','r unAttended','Location','northeast');
% ylim([-0.03,0.03]);
saveas(gcf,saveName2);
close


% decoding acc for testing data
figure; plot((1000/Fs)*timelag,decoding_acc_attended*100,'r');
hold on;plot((1000/Fs)*timelag(Decoding_acc_attend_ttest_result>0),decoding_acc_attended(Decoding_acc_attend_ttest_result>0)*100,'r*');
hold on; plot((1000/Fs)*timelag,decoding_acc_unattended*100,'b');
hold on;plot((1000/Fs)*timelag(Decoding_acc_unattend_ttest_result>0),decoding_acc_unattended(Decoding_acc_unattend_ttest_result>0)*100,'b*');
xlabel('Times(ms)'); 
ylabel('Decoding accuracy(%)')
saveName3 =strcat('Test Data Decoding-Acc across all time-lags using mTRF method',bandName,'.jpg');
% saveName3 =strcat('Decoding-Accuracy across all time-lags using mTRF method',band_name,'.jpg');
title(saveName3(1:end-4));
legend('Attended decoder','significant 』 50%','Unattended decoder','significant 』 50%','Location','northeast');ylim([30,100]);
saveas(gcf,saveName3);
close

% decoding acc for train data
figure; plot((1000/Fs)*timelag,mean_acc_AttendDecoder_train_mean*100,'r');
hold on;plot((1000/Fs)*timelag(mean_acc_AttendDecoder_train_ttest_result>0),mean_acc_AttendDecoder_train_mean(mean_acc_AttendDecoder_train_ttest_result>0)*100,'r*');
hold on; plot((1000/Fs)*timelag,mean_acc_UnattendDecoder_train_mean*100,'b');
hold on;plot((1000/Fs)*timelag(mean_acc_UnattendDecoder_train_ttest_result>0),mean_acc_UnattendDecoder_train_mean(mean_acc_UnattendDecoder_train_ttest_result>0)*100,'b*');
xlabel('Times(ms)'); 
ylabel('Decoding accuracy(%)')
saveName3 =strcat('Train data Decoding-Acc across all time-lags using mTRF method',bandName,'.jpg');
% saveName3 =strcat('Decoding-Accuracy across all time-lags using mTRF method',band_name,'.jpg');
title(saveName3(1:end-4));
legend('Attended decoder','significant 』 50%','Unattended decoder','significant 』 50%','Location','northeast');ylim([30,100]);
saveas(gcf,saveName3);
close

