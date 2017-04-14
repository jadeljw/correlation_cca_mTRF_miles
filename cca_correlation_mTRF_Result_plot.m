%cca_correlation_mTRF Result plot

%% cca result
load('cca_sound_EEG_result.mat')

% reconstruction accuracy plot attend
figure; plot(mean(recon_AttendDecoder_attend_cca,2),'r'); 
hold on; plot(mean(recon_AttendDecoder_unattend_cca,2),'b'); 
xlabel('Subject No.'); ylabel('r value')
title('Reconstruction Accuracy using CCA method for attend decoder');
legend('Audio attend ','Audio not Attend')
saveas(gcf,'Reconstruction_Accuracy_using_CCA_method_for_attend_decoder.jpg')

% reconstruction accuracy plot unattend
figure; plot(mean(recon_UnattendDecoder_attend_cca,2),'r'); 
hold on; plot(mean(recon_UnattendDecoder_unattend_cca,2),'b'); 
xlabel('Subject No.'); ylabel('r value')
title('Reconstruction Accuracy using CCA method for unattend decoder');
legend('Audio attend ','Audio not Attend')
saveas(gcf,'Reconstruction_Accuracy_using_CCA_method_for_unattend_decoder.jpg')

% Decoding accuracy plot attend
Decoding_result_attend_decoder = recon_AttendDecoder_attend_cca-recon_AttendDecoder_unattend_cca;
Individual_subjects_result_attend = sum(Decoding_result_attend_decoder>0,2)/12;
mean(Individual_subjects_result_attend)
Decoding_result_unattend_decoder = recon_UnattendDecoder_unattend_cca-recon_UnattendDecoder_attend_cca;
Individual_subjects_result_unattend = sum(Decoding_result_unattend_decoder>0,2)/12;
mean(Individual_subjects_result_unattend)
figure; plot(Individual_subjects_result_attend*100,'r'); 
hold on; plot(Individual_subjects_result_unattend*100,'b'); 
xlabel('Subject No.'); ylabel('Decoding Accuarcy %');ylim([0,100]);
title('Decoding accuracy using cca method')
legend('Attend Decoder','Unattend Decoder')
saveas(gcf,'Decoding accuracy using CCA method.jpg')

%% correlation result
load('correlation_sound_EEG_result.mat')

% reconstruction accuracy plot attend
figure; plot(mean(recon_AttendDecoder_attend_corr),'r'); 
hold on; plot(mean(recon_AttendDecoder_unattend_corr),'b'); 
xlabel('Subject No.'); ylabel('r value')
title('Reconstruction Accuracy using correlation method for attend decoder');
legend('Audio attend ','Audio not Attend')
saveas(gcf,'Reconstruction_Accuracy_using_correlation_method_for_attend_decoder.jpg')

% reconstruction accuracy plot unattend
figure; plot(mean(recon_UnattendDecoder_attend_corr,2),'r'); 
hold on; plot(mean(recon_UnattendDecoder_unattend_corr,2),'b'); 
xlabel('Subject No.'); ylabel('r value')
title('Reconstruction Accuracy using corrrelation method for unattend decoder');
legend('Audio attend ','Audio not Attend')
saveas(gcf,'Reconstruction_Accuracy_using_correlation_method_for_unattend_decoder.jpg')

% Decoding accuracy plot attend
Decoding_result_attend_decoder = recon_AttendDecoder_attend_corr-recon_AttendDecoder_unattend_corr;
Individual_subjects_result_attend = sum(Decoding_result_attend_decoder>0,2)/12;
mean(Individual_subjects_result_attend)
Decoding_result_unattend_decoder = recon_UnattendDecoder_unattend_corr-recon_UnattendDecoder_attend_corr;
Individual_subjects_result_unattend = sum(Decoding_result_unattend_decoder>0,2)/12;
mean(Individual_subjects_result_unattend)
figure; plot(Individual_subjects_result_attend*100,'r'); 
hold on; plot(Individual_subjects_result_unattend*100,'b'); 
xlabel('Subject No.'); ylabel('Decoding Accuarcy %');ylim([0,100]);
title('Decoding accuracy using correlation method for attend decoder')
legend('Attend Decoder','Unattend Decoder')
saveas(gcf,'Decoding accuracy using correlation method for attend decoder.jpg')


%% mTRF result
load('mTRF_sound_EEG_result.mat')

% reconstruction accuracy plot attend
figure; plot(mean(recon_AttendDecoder_attend_corr,2),'r'); 
hold on; plot(mean(recon_AttendDecoder_unattend_corr,2),'b'); 
xlabel('Subject No.'); ylabel('r value')
title('Reconstruction Accuracy using mTRF method for attend decoder');
legend('Audio attend ','Audio not Attend')
saveas(gcf,'Reconstruction_Accuracy_using_mTRF_method_for_attend_decoder.jpg')

% reconstruction accuracy plot unattend
figure; plot(mean(recon_UnattendDecoder_attend_corr,2),'r'); 
hold on; plot(mean(recon_UnattendDecoder_unattend_corr,2),'b'); 
xlabel('Subject No.'); ylabel('r value')
title('Reconstruction Accuracy using mTRF method for unattend decoder');
legend('Audio attend ','Audio not Attend')
saveas(gcf,'Reconstruction_Accuracy_using_mTRF_method_for_unattend_decoder.jpg')

% Decoding accuracy plot attend
Decoding_result_attend_decoder = recon_AttendDecoder_attend_corr-recon_AttendDecoder_unattend_corr;
Individual_subjects_result_attend = sum(Decoding_result_attend_decoder>0,2)/12;
mean(Individual_subjects_result_attend)
Decoding_result_unattend_decoder = recon_UnattendDecoder_unattend_corr-recon_UnattendDecoder_attend_corr;
Individual_subjects_result_unattend = sum(Decoding_result_unattend_decoder>0,2)/12;
mean(Individual_subjects_result_unattend)
figure; plot(Individual_subjects_result_attend*100,'r'); 
hold on; plot(Individual_subjects_result_unattend*100,'b'); 
xlabel('Subject No.'); ylabel('Decoding Accuarcy %');ylim([0,100]);
title('Decoding accuracy using mTRF method')
legend('Attend Decoder','Unattend Decoder')
saveas(gcf,'Decoding accuracy using mTRF method.jpg')


