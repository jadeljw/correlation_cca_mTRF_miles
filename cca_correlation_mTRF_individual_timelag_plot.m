%% cca - correlation - mTRF individual timelag plot

%% timelag

% timelag = -200:25:500;
Fs = 64;
timelag = -250:(1000/Fs):500;

% timelag = (-3000:500/32:3000)/(1000/Fs);
% timelag = (-250:500/32:500)/(1000/Fs);
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

lambda = 2^20;
% band_name = strcat(' 64Hz 2-8Hz lambda',num2str(lambda),' long');
bandName = strcat(' 64Hz 2-8Hz M1M2 lambda',num2str(lambda));
% bandName = ' 2-8Hz 64Hz';




%%  ISC plot
p = 'E:\DataProcessing\correlation_cca_mTRF';
category = 'ISC';

for  j = 1 : length(timelag)
    % load data
    %     datapath = strcat(p,'\',category);
    %     dataName = strcat('Corr_sound_EEG_result+',num2str(timelag(j)),'ms.mat')
    datapath = strcat(p,'\',category,'\',bandName(2:end));
    dataName = strcat('ISC_S-L_EEG_result+',num2str((1000/Fs)*timelag(j)),'ms',bandName,'.mat');
    load(strcat(datapath,'\',dataName));
    
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
    Decoding_acc_attend_ttest_result(j) = ttest(Individual_subjects_result_attend,0.5);
    decoding_acc_unattended(j) = mean(Individual_subjects_result_unattend);
    
end

figure; plot((1000/Fs)*timelag,recon_AttendDecoder_attend_total,'r');
hold on; plot((1000/Fs)*timelag,recon_AttendDecoder_unattend_total,'b');
xlabel('Times(ms)'); ylabel('r-value')
% saveName1 = strcat('Attended decoder Reconstruction-Acc across all time-lags using corr method',bandName,'.jpg');
saveName1 = strcat('Attended decoder Reconstruction-Acc across all time-lags using ISC method',bandName,'.jpg');
title(saveName1(1:end-4));
legend('r Attended ','r unAttended');ylim([-0.03,0.03]);
saveas(gcf,saveName1);
close

figure; plot((1000/Fs)*timelag,recon_UnattendDecoder_attend_total,'r');
hold on; plot((1000/Fs)*timelag,recon_UnattendDecoder_unattend_total,'b');
xlabel('Times(ms)'); ylabel('r-value')
% saveName2 = strcat('Unattended decoder Reconstruction-Acc across all time-lags using corr method',bandName,'.jpg');
saveName2 = strcat('Unattended decoder Reconstruction-Acc across all time-lags using ISC method',bandName,'.jpg');
title(saveName2(1:end-4));
legend('r Attended ','r unAttended');ylim([-0.03,0.03]);
saveas(gcf,saveName2);
close

figure; plot((1000/Fs)*timelag,decoding_acc_attended*100,'r');
hold on;plot((1000/Fs)*timelag(Decoding_acc_attend_ttest_result>0),decoding_acc_attended(Decoding_acc_attend_ttest_result>0)*100,'r*');
hold on; plot((1000/Fs)*timelag,decoding_acc_unattended*100,'b');
hold on;plot((1000/Fs)*timelag(Decoding_acc_unattend_ttest_result>0),decoding_acc_unattended(Decoding_acc_unattend_ttest_result>0)*100,'b*');
xlabel('Times(ms)'); ylabel('Decoding accuracy(%)')
% saveName3 = strcat('Decoding-Accuracy across all time-lags using Corr method',bandName,'.jpg');
saveName3 = strcat('Decoding-Accuracy across all time-lags using ISC method',bandName,'.jpg');
title(saveName3(1:end-4));
legend('Attended decoder','significant 』 50%','Unattended decoder','significant 』 50%');ylim([30,100]);
saveas(gcf,saveName3);
close


%%  CCA plot
p =  'E:\DataProcessing\correlation_cca_mTRF';
category = 'CCA';

for  j = 1 : length(timelag)
    % load data
    %     datapath = strcat(p,'\',category);
    %     dataName = strcat('cca_sound_EEG_result+',num2str(timelag(j)),'ms.mat')
    datapath = strcat(p,'\',category,'\',bandName(2:end));
    dataName = strcat('cca_sound_EEG_result+',num2str((1000/Fs)*timelag(j)),'ms',bandName,'.mat');
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
    Individual_subjects_result_unattend = sum(Decoding_result_unattend_decoder>0,2)/15;
    % ttest
    Decoding_acc_attend_ttest_result(j) = ttest(Individual_subjects_result_attend,0.5);
    decoding_acc_unattended(j) = mean(Individual_subjects_result_unattend);
    
end

figure; plot((1000/Fs)*timelag,recon_AttendDecoder_attend_total,'r');
hold on; plot((1000/Fs)*timelag,recon_AttendDecoder_unattend_total,'b');
xlabel('Times(ms)'); ylabel('r-value')
saveName1 = strcat('Attended decoder Reconstruction-Acc across all time-lags using cca method',bandName,'.jpg');
title(saveName1(1:end-4));
legend('r Attended ','r unAttended');ylim([-0.03,0.03]);
saveas(gcf,saveName1);
close

figure; plot((1000/Fs)*timelag,recon_UnattendDecoder_attend_total,'r');
hold on; plot((1000/Fs)*timelag,recon_UnattendDecoder_unattend_total,'b');
xlabel('Times(ms)'); ylabel('r-value')
saveName2 = strcat('Unattended decoder Reconstruction-Acc across all time-lags using cca method',bandName,'.jpg');
title(saveName2(1:end-4));
legend('r Attended ','r unAttended');ylim([-0.03,0.03]);
saveas(gcf,saveName2);
close

figure; plot((1000/Fs)*timelag,decoding_acc_attended*100,'r');
hold on;plot((1000/Fs)*timelag(Decoding_acc_attend_ttest_result>0),decoding_acc_attended(Decoding_acc_attend_ttest_result>0)*100,'r*');
hold on; plot((1000/Fs)*timelag,decoding_acc_unattended*100,'b');
hold on;plot((1000/Fs)*timelag(Decoding_acc_unattend_ttest_result>0),decoding_acc_unattended(Decoding_acc_unattend_ttest_result>0)*100,'b*');
xlabel('Times(ms)'); ylabel('Decoding accuracy(%)')
saveName3 = strcat('Decoding-Accuracy across all time-lags using cca method',bandName,'.jpg');
title(saveName3(1:end-4));
legend('Attended decoder','significant 』 50%','Unattended decoder','significant 』 50%');ylim([30,100]);
saveas(gcf,saveName3);
close

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
%     dataName = strcat('mTRF_sound_EEG_result+',num2str((1000/Fs)*timelag(j)),'ms',bandName,'.mat');
    dataName = strcat('mTRF_sound_EEG_result+',num2str(timelag(j)),'ms',bandName,'.mat');
%     band_name = strcat(' broadband 0.1-40Hz lambda',num2str(lambda(j)));
%     dataName = strcat('mTRF_sound_EEG_result -200~500 ms',band_name,'.mat');
    load(strcat(datapath,'\',dataName));
    
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
    
end

% figure; plot((1000/Fs)*timelag,recon_AttendDecoder_attend_total,'r');
% hold on; plot((1000/Fs)*timelag,recon_AttendDecoder_unattend_total,'b');
figure; plot(timelag,recon_AttendDecoder_attend_total,'r');
hold on; plot(timelag,recon_AttendDecoder_unattend_total,'b');
xlabel('Times(ms)'); 
ylabel('r-value')
saveName1 = strcat( 'Attended decoder Reconstruction-Acc across all time-lags using mTRF method',bandName,'.jpg');
% saveName1 = strcat( 'Attended decoder Reconstruction-Acc across all time-lags using mTRF method',band_name,'.jpg');
title(saveName1(1:end-4));
legend('r Attended ','r unAttended','Location','northeast');
% ylim([-0.03,0.03]);
saveas(gcf,saveName1);
close

% figure; plot((1000/Fs)*timelag,recon_UnattendDecoder_attend_total,'r');
% hold on; plot((1000/Fs)*timelag,recon_UnattendDecoder_unattend_total,'b');
figure; plot(timelag,recon_UnattendDecoder_attend_total,'r');
hold on; plot(timelag,recon_UnattendDecoder_unattend_total,'b');
xlabel('Times(ms)'); 
ylabel('r-value')
saveName2 = strcat('Unattended decoder Reconstruction-Acc across all time-lags using mTRF method',bandName,'.jpg');
% saveName2 = strcat('Unattended decoder Reconstruction-Acc across all time-lags using mTRF method',band_name,'.jpg');
title(saveName2(1:end-4));
legend('r Attended ','r unAttended','Location','northeast');
% ylim([-0.03,0.03]);
saveas(gcf,saveName2);
close

% figure; plot((1000/Fs)*timelag,decoding_acc_attended*100,'r');
% hold on;plot((1000/Fs)*timelag(Decoding_acc_attend_ttest_result>0),decoding_acc_attended(Decoding_acc_attend_ttest_result>0)*100,'r*');
% hold on; plot((1000/Fs)*timelag,decoding_acc_unattended*100,'b');
% hold on;plot((1000/Fs)*timelag(Decoding_acc_unattend_ttest_result>0),decoding_acc_unattended(Decoding_acc_unattend_ttest_result>0)*100,'b*');
figure; plot(timelag,decoding_acc_attended*100,'r');
hold on;plot(timelag(Decoding_acc_attend_ttest_result>0),decoding_acc_attended(Decoding_acc_attend_ttest_result>0)*100,'r*');
hold on; plot(timelag,decoding_acc_unattended*100,'b');
hold on;plot(timelag(Decoding_acc_unattend_ttest_result>0),decoding_acc_unattended(Decoding_acc_unattend_ttest_result>0)*100,'b*');
xlabel('Times(ms)'); 
ylabel('Decoding accuracy(%)')
saveName3 =strcat('Decoding-Accuracy across all time-lags using mTRF method',bandName,'.jpg');
% saveName3 =strcat('Decoding-Accuracy across all time-lags using mTRF method',band_name,'.jpg');
title(saveName3(1:end-4));
legend('Attended decoder','significant 』 50%','Unattended decoder','significant 』 50%','Location','northeast');ylim([30,100]);
saveas(gcf,saveName3);
close

%%  CCA speaker listener plot
p = 'E:\DataProcessing\correlation_cca_mTRF';
%  p = 'E:\DataProcessing\FDA_complex_feature\CCA-speaker-listener';
category = 'CCA_speaker_listener_EEG';

for  j = 1 : length(timelag)
    % load data
    datapath = strcat(p,'\',category,'\',bandName(2:end));
    %     dataName = strcat('cca_speaker_listener_EEG_result+',num2str(timelag(j)),'ms',bandName,'.mat');
    dataName = strcat('cca_S-L_EEG_result+',num2str((1000/Fs)*timelag(j)),'ms',bandName,'.mat');
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
saveName1 = strcat('Attended decoder Reconstruction-Acc using CCA S-L EEG method',bandName,'.jpg');
title(saveName1(1:end-4));
legend('r Attended ','r unAttended');ylim([-0.05,0.05]);
saveas(gcf,saveName1);
close

figure; plot((1000/Fs)*timelag,recon_UnattendDecoder_attend_total,'r');
hold on; plot((1000/Fs)*timelag,recon_UnattendDecoder_unattend_total,'b');
xlabel('Times(ms)'); ylabel('r-value')
saveName2 = strcat('Unattended decoder Reconstruction-Acc using CCA S-L EEG method',bandName,'.jpg');
title(saveName2(1:end-4));
legend('r Attended ','r unAttended');ylim([-0.05,0.05]);
saveas(gcf,saveName2);
close

figure; plot((1000/Fs)*timelag,decoding_acc_attended*100,'r');
hold on;plot((1000/Fs)*timelag(Decoding_acc_attend_ttest_result>0),decoding_acc_attended(Decoding_acc_attend_ttest_result>0)*100,'r*');
hold on; plot((1000/Fs)*timelag,decoding_acc_unattended*100,'b');
hold on;plot((1000/Fs)*timelag(Decoding_acc_unattend_ttest_result>0),decoding_acc_unattended(Decoding_acc_unattend_ttest_result>0)*100,'b*');
xlabel('Times(ms)'); ylabel('Decoding accuracy(%)')
saveName3 = strcat('Decoding-Acc across all time-lags using S-L EEG method',bandName,'.jpg');
title(saveName3(1:end-4));
legend('Attended decoder','significant 』 50%','Unattended decoder','significant 』 50%');ylim([30,100]);
saveas(gcf,saveName3);
close

% %% mTRF different data length
% 
% data_start_time = 5 : 0.5 : 10;
% % timelag = -200:25:500;
% 
% recon_AttendDecoder_attend_total = zeros(1,length(data_start_time));
% recon_AttendDecoder_unattend_total = zeros(1,length(data_start_time));
% recon_UnattendDecoder_attend_total = zeros(1,length(data_start_time));
% recon_UnattendDecoder_unattend_total = zeros(1,length(data_start_time));
% decoding_acc_attended = zeros(1,length(data_start_time));
% decoding_acc_unattended = zeros(1,length(data_start_time));
% Decoding_acc_attend_ttest_result = zeros(1,length(data_start_time));
% Decoding_acc_unattend_ttest_result = zeros(1,length(data_start_time));
% 
% for j = 1 : length(data_start_time)
%     data_path = strcat('E:\DataProcessing\correlation_cca_mTRF\mTRF\-200ms-500ms_',num2str(data_start_time(j)),'s-35s');
%     dataName = strcat('mTRF_sound_EEG_result+0ms.mat');
%     load(strcat(data_path,'\',dataName));
%     
%     %plot
%     %reconstruction accuracy
%     recon_AttendDecoder_attend_total(j) =  mean(mean(recon_AttendDecoder_attend_corr));
%     recon_AttendDecoder_unattend_total(j) =  mean(mean(recon_AttendDecoder_unattend_corr));
%     recon_UnattendDecoder_attend_total(j) = mean(mean(recon_UnattendDecoder_attend_corr));
%     recon_UnattendDecoder_unattend_total(j) = mean(mean(recon_UnattendDecoder_unattend_corr));
%     
%     %decoding accuracy
%     Decoding_result_attend_decoder = recon_AttendDecoder_attend_corr-recon_AttendDecoder_unattend_corr;
%     Individual_subjects_result_attend = sum(Decoding_result_attend_decoder>0,2)/15;
%     % ttest
%     Decoding_acc_attend_ttest_result(j) = ttest(Individual_subjects_result_attend,0.5);
%     decoding_acc_attended(j)= mean(Individual_subjects_result_attend);
%     
%     Decoding_result_unattend_decoder = recon_UnattendDecoder_unattend_corr-recon_UnattendDecoder_attend_corr;
%     Individual_subjects_result_unattend = sum(Decoding_result_unattend_decoder>0,2)/15;
%     % ttest
%     Decoding_acc_unattend_ttest_result(j) = ttest(Individual_subjects_result_unattend,0.5);
%     decoding_acc_unattended(j) = mean(Individual_subjects_result_unattend);
%     
% end
% 
% figure; plot(data_start_time,recon_AttendDecoder_attend_total,'r');
% hold on; plot(data_start_time,recon_AttendDecoder_unattend_total,'b');
% xlabel('Times(ms)'); ylabel('r-value')
% saveName1 = strcat( 'Attended decoder Reconstruction-Acc across all time-lags using mTRF method.jpg');
% title(saveName1(1:end-4));
% legend('r Attended ','r unAttended','Location','east');
% % ylim([-0.03,0.03]);
% saveas(gcf,saveName1);
% close
% 
% figure; plot(data_start_time,recon_UnattendDecoder_attend_total,'r');
% hold on; plot(data_start_time,recon_UnattendDecoder_unattend_total,'b');
% xlabel('Times(ms)'); ylabel('r-value')
% saveName2 = strcat('Unattended decoder Reconstruction-Acc across all time-lags using mTRF method.jpg');
% title(saveName2(1:end-4));
% legend('r Attended ','r unAttended','Location','east');
% % ylim([-0.03,0.03]);
% saveas(gcf,saveName2);
% close
% 
% figure; plot(data_start_time,decoding_acc_attended*100,'r');
% hold on;plot(data_start_time(Decoding_acc_attend_ttest_result>0),decoding_acc_attended(Decoding_acc_attend_ttest_result>0)*100,'r*');
% hold on; plot(data_start_time,decoding_acc_unattended*100,'b');
% hold on;plot(data_start_time(Decoding_acc_unattend_ttest_result>0),decoding_acc_unattended(Decoding_acc_unattend_ttest_result>0)*100,'b*');
% xlabel('Times(ms)'); ylabel('Decoding accuracy(%)')
% saveName3 =strcat('Decoding-Accuracy across all time-lags using mTRF method.jpg');
% title(saveName3(1:end-4));
% legend('Attended decoder','significant 』 50%','Unattended decoder','significant 』 50%','Location','southeast');ylim([50,100]);
% saveas(gcf,saveName3);
% close
