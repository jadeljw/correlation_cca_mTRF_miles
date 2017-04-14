%% testing script for CCA based speaker-listener analysis
%time of interest: 16 sec starting from
clear;

load ListenA_Or_Not.mat
load ISC_all_ref_after_ICA_64Hz.mat %listener 0.5-40Hz
load data_speaker_64Hz.mat %speaker 0.5-40Hz

fs = 64;
chn = [1:32 34:42 44:59 61:63];
toi = 15*fs:40*fs-1;%5 sec baseline + 5 sec beep sound + 5 sec pre-excluded

%% band-pass filter again

[B_theta,A_theta] = bp_filter2(fs,1.5,2,8,8.5);
[B_alpha,A_alpha] = bp_filter2(fs,7.5,8,13,14);

for i = 1:12
    eval(['EEG_L = Listener' int2str(i) ';']);
    for j = 1:15
        for k = 1:60
            EEG_L{j}(k,:) = filtfilt(B_theta,A_theta,EEG_L{j}(k,:));
        end
    end
    eval(['Listener' int2str(i) ' = EEG_L;']);
end

for j = 1:15
    for k = 1:66
        data_speakerA{j}(k,:) = filtfilt(B_theta,A_theta,data_speakerA{j}(k,:));
        data_speakerB{j}(k,:) = filtfilt(B_theta,A_theta,data_speakerB{j}(k,:));
    end
end

%% CCA, current approach

acc_test_unatt = zeros(12,15);
acc_test_att = zeros(12,15);
acc_train_unatt = zeros(12,15);
acc_train_att = zeros(12,15);

t_lags = round((-0.3:0.1:0.5)*fs);%-300, -200, -100, 0, 100, 200, 300
% t_lags = round((0.4:0.1:0.5)*fs);
% t_lags = round((0.3)*fs);
tic;
for ii = 1:length(t_lags)
    t_lag = t_lags(ii);
    disp(['Processing lags ' int2str(ii) '...']);
    for i = 1:12 % each individual listener
        disp(['Processing listener ' int2str(i) '...']);
        eval(['EEG_L = Listener' int2str(i) ';']);
        Att_Task = ListenA_Or_Not(:,i);
        for j = 1:15% 15 repetitio of leave-one-out
            %             disp(['LOO rep ' int2str(j)]);
            set_sel = setdiff(1:15,j);
            EEG_L_cca = zeros(length(chn),length(set_sel)*length(toi));
            EEG_SAtt_cca = zeros(length(chn),length(set_sel)*length(toi));
            EEG_SUnatt_cca = zeros(length(chn),length(set_sel)*length(toi));
            cnt = 1;
            for k = 1:length(set_sel)
                EEG_L_cca(:,cnt:cnt+length(toi)-1) = EEG_L{set_sel(k)}(:,toi + t_lag);
                if(Att_Task(set_sel(k)) == 1)%attending A
                    EEG_SAtt_cca(:,cnt:cnt+length(toi)-1) = data_speakerA{set_sel(k)}(chn,toi);
                    EEG_SUnatt_cca(:,cnt:cnt+length(toi)-1) = data_speakerB{set_sel(k)}(chn,toi);
                else
                    EEG_SAtt_cca(:,cnt:cnt+length(toi)-1) = data_speakerB{set_sel(k)}(chn,toi);
                    EEG_SUnatt_cca(:,cnt:cnt+length(toi)-1) = data_speakerA{set_sel(k)}(chn,toi);
                end
                cnt = cnt + length(toi);
            end
            %         disp([int2str(cnt) ' ' int2str(length(set_sel)*length(toi))]);
            %now cca
            [SF_LAtt,SF_SAtt,r_Att,~,~,stats_Att] = canoncorr(EEG_L_cca', EEG_SAtt_cca');
            [SF_LUnatt,SF_SUnatt,r_Unatt,~,~,stats_Unatt] = canoncorr(EEG_L_cca', EEG_SUnatt_cca');
%             if(j==1)
%                 disp(r_Att(1:10));
%                 disp(r_Unatt(1:10));
%                 pause;
%             end
            %training set calculation
            r_train = zeros(length(set_sel),4);
            for k = 1:length(set_sel)
                EEG_L_train = EEG_L{set_sel(k)}(:,toi + t_lag);
                EEG_SA_train = data_speakerA{j}(chn,toi);
                EEG_SB_train = data_speakerB{j}(chn,toi);
                r_train(k,1) = corr(EEG_L_train'*SF_LAtt(:,1),EEG_SA_train'*SF_SAtt(:,1));
                r_train(k,2) = corr(EEG_L_train'*SF_LAtt(:,1),EEG_SB_train'*SF_SAtt(:,1));
                r_train(k,3) = corr(EEG_L_train'*SF_LUnatt(:,1),EEG_SA_train'*SF_SUnatt(:,1));
                r_train(k,4) = corr(EEG_L_train'*SF_LUnatt(:,1),EEG_SB_train'*SF_SUnatt(:,1));
            end
            
            Att_One = Att_Task(set_sel);
            dec_train_att = sign(r_train(:,1) - r_train(:,2));
            dec_train_att(dec_train_att == -1) = 0;
            acc_train_att(i,j) = length(find(Att_One == dec_train_att)) / 14;
            
            dec_train_unatt = sign(r_train(:,4) - r_train(:,3));
            dec_train_unatt(dec_train_unatt == -1) = 0;
            acc_train_unatt(i,j) = length(find(Att_One == dec_train_unatt)) / 14;
            
            %testing set calculation
            EEG_L_test = EEG_L{j}(:,toi + t_lag);
            EEG_SA_test = data_speakerA{j}(chn,toi);
            EEG_SB_test = data_speakerB{j}(chn,toi);
            r_test(1) = corr(EEG_L_test'*SF_LAtt(:,1),EEG_SA_test'*SF_SAtt(:,1));
            r_test(2) = corr(EEG_L_test'*SF_LAtt(:,1),EEG_SB_test'*SF_SAtt(:,1));
            r_test(3) = corr(EEG_L_test'*SF_LUnatt(:,1),EEG_SA_test'*SF_SUnatt(:,1));
            r_test(4) = corr(EEG_L_test'*SF_LUnatt(:,1),EEG_SB_test'*SF_SUnatt(:,1));
            
            %         if(Att_Task(j) == 1)
            %             disp('Att A, expected r1 > r2, r3 < r4');
            %             disp(r_test);
            %         else
            %             disp('Att B, expected r1 < r2, r3 > r4' );
            %             disp(r_test);
            %         end
            
            if(Att_Task(j) == 1)
                if(r_test(1)>r_test(2))
                    acc_test_att(i,j) = 1;
                else
                    acc_test_att(i,j) = 0;
                end
                if(r_test(4)>r_test(3))
                    acc_test_unatt(i,j) = 1;
                else
                    acc_test_unatt(i,j) = 0;
                end
            else
                if(r_test(1)>r_test(2))
                    acc_test_att(i,j) = 1;
                else
                    acc_test_att(i,j) = 0;
                end
                if(r_test(4)>r_test(3))
                    acc_test_unatt(i,j) = 1;
                else
                    acc_test_unatt(i,j) = 0;
                end
            end
        end
    end
    t_elapse = toc;
    disp(['acc test att, lag ' int2str(t_lag/fs*1000) ': ' num2str(100*mean(sum(acc_test_att,2)/15)) '%']);
    disp(['acc test unatt, lag ' int2str(t_lag/fs*1000) ': ' num2str(100*mean(sum(acc_test_unatt,2)/15)) '%']);
    disp(['acc train att, lag ' int2str(t_lag/fs*1000) ': ' num2str(100*mean(mean(acc_train_att))) '%']);
    disp(['acc train unatt, lag ' int2str(t_lag/fs*1000) ': ' num2str(100*mean(mean(acc_train_unatt))) '%']);
end

%% CCA, trial based approach - not applicable, r values too high

% CCA by removing the surrounding electrodes suspicious for artifacts


%% RESULTS

%broad-band (0.5-40Hz) accuracy: +300 ms lag with maximal (~56%, p =
%0.18,n.s.), but training all ~50% (strange...)

%2-8Hz band-pass for both listeners and speakers, ...

%2-8Hz band-pass for listeners, and 8-13 Hz band-pass + Hilbert for
%speakers ...


