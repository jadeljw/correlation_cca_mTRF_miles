
% mTRF weights plot for individual channels

%% initial
w_attend_total = zeros(60,60);
w_unattend_total = zeros(60,60);


Fs = 64;
timelag = (-250:500/32:500)/(1000/Fs);
load('E:\DataProcessing\label66.mat');
load('E:\DataProcessing\easycapm1.mat');
chn2chnName= [1:32 34:42 44:59 61:63];

timelag = timelag(6:17);

%% band name
band_name = ' 64Hz_bandpass_2-8Hz';
% 2 - 8 Hz for theta analysis


for j = 1 : length(timelag)
    %% total matrix
    
    dataName = strcat('mTRF_sound_EEG_result+',num2str(1000/Fs*timelag(j)),'ms',band_name,'.mat');
    load(dataName);
    cnt = 1;
    for listener = 1 : 12
        for story = 1 : 15
            
            w_attend_total(:,cnt) = train_mTRF_attend_w_total{listener,story};
            w_unattend_total(:,cnt) = train_mTRF_unattend_w_total{listener,story};
            cnt = cnt + 1;
        end
    end
    
    %% mean
    w_attend_total_mean = mean(w_attend_total,2);
    w_unattend_total_mean = mean(w_unattend_total,2);
    
    
    %% plot
    save_nameA = strcat('mTRF weights for +',num2str(1000/Fs*timelag(j)),'ms',band_name,'.jpg');
    title(save_nameA(1:end-4))
    U_topoplot(abs(zscore(w_attend_total_mean)), 'easycapm1.lay', label66(chn2chnName));
    
    saveas(gcf,save_nameA);
    close all
    
end