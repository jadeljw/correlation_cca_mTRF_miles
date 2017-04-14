%% mTRF single trial plot

%% initial
Fs = 64;
timelag = -250:(1000/Fs):500;


%% load data
load('mTRF_sound_EEG_result+0ms weights.mat')

%% workpath
p = pwd;

%% plot
for listener = 1 : 12
    for story = 1: 15
        filepath = strcat('listener',num2str(listener),' story',num2str(story));
        mkdir(filepath);
        cd(filepath);
        
        for chn = 1 :60
            saveName1 = strcat('mTRF attended decoder weights listener',num2str(listener),' story',num2str(story),' chn',num2str(chn),'.jpg');
            plot(timelag,squeeze(train_mTRF_attend_w_train_all_listener{listener,story}(chn,:,:)));
            title(saveName1(1:end-4));
            saveas(gcf,saveName1);
            close
            
            saveName2 = strcat('mTRF unattended decoder weights listener',num2str(listener),' story',num2str(story),' chn',num2str(chn),'.jpg');
            plot(timelag,squeeze(train_mTRF_unattend_w_train_all_listener{listener,story}(chn,:,:)));
            title(saveName2(1:end-4));
            saveas(gcf,saveName2);
            close
            
        end
        
        cd(p);
    end
end