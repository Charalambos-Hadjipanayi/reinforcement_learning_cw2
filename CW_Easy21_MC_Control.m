clc
close all
clear all

% Defining the Game

%Calling the object into this file
import Easy21_v3
Game = Easy21_v3;

No_vec=[1000 200 100 10]; %Testing the performance of MC Control with different No
%No_vec = 100; %Using the desired No value
for i=1:length(No_vec)
    
    No=No_vec(i);
    
    %Initialisation for MC

    Q_MC = zeros(10,21,2); %Q(s,a)
    Ret = zeros(10,21,2);
    count_s_a = zeros(10,21,2); %N(s,a)
    count_s = zeros(10,21); %N(s)

    max_length = 1000;
    n_episodes=1000000;
    run_mean=0;
    pol=0.5*ones(10,21,2); %Initial policy
    Rewards=zeros(1,n_episodes);

    index_test=50000;
    size_test_set=150000;
    Mean_vect=[];
    Std_vect=[];
    xaxis=[];

    %Generating episodes and calculating Q function
    for episode=1:n_episodes
        if mod((episode/n_episodes),0.05)==0
            episode/n_episodes
        end
        init(Game,max_length);
        init_s = reset(Game);
        [Q_MC,Return_episode,pol,Ret,count_s,count_s_a]=...
            MC_FV_episode(Game,No,init_s,Q_MC,Ret,pol,count_s,count_s_a);
        Rewards(episode)=Return_episode;
        
        %This is when validation testing is done
        if mod(episode,index_test)==0 || episode==1
            [mean_test,std_test]=test(pol,size_test_set);
            Mean_vect = [Mean_vect;mean_test];
            Std_vect = [Std_vect;std_test];
            xaxis=[xaxis;episode];
        end 
    end

    figure(1)
    subplot(1,2,1)
    hold on
    grid on
    plot(xaxis,Mean_vect)
    ylabel('Mean of Rewards')
    xlabel('Episode')

    subplot(1,2,2)
    hold on
    grid on
    plot(xaxis,Std_vect)
    ylabel('Std of Rewards')
    xlabel('Episode')
end

legend(num2str([1000; 200; 100 ;10]))

%%
h=gcf;
h.PaperPositionMode='auto';
set(h,'PaperOrientation','landscape');
set(findall(gcf,'-property','FontSize'),'FontSize',14)
print(gcf, '-dpdf', 'Learning Curve .pdf','-fillpage')

%%
%Plot of policy of hitting
figure(2);
subplot(1,2,2)
h = heatmap(pol(:,:,2));
xlabel('Player Sum')
xlim([1 21])
ylabel('Dealer showing')
ylim([1 10])
title('Optimal Policy of action HIT')
colormap(gca,'gray')

%Histogram of Rewards
figure;
histogram(Rewards)

%% Storing the learning curves mean
avg_Rewards_MC=Mean_vect;
save('avg_Rewards_MC.mat','avg_Rewards_MC')

%% Storing the learning curves std
std_Rewards_MC=Std_vect;
save('std_Rewards_MC.mat','std_Rewards_MC')
%% Optimal value plot

[V_MC, index] = max(Q_MC,[],3);
index=index-1;

figure(2);
subplot(1,2,1)
surf(V_MC','EdgeColor','none')
ylabel('Player Sum')
ylim([1 21])
xlabel('Dealer showing')
xlim([1 10])
zlabel('Value')
title('Value Function - using MC Control')
colormap(gca,coolwarm)
hcb1=colorbar;

%%
h=gcf;
h.PaperPositionMode='auto';
set(h,'PaperOrientation','landscape');
set(findall(gcf,'-property','FontSize'),'FontSize',12)
print(gcf, '-dpdf', 'Value Function.pdf','-fillpage')
