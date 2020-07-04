clc
close all
clear all

%Defining the Game

%Calling the object into this file
import Easy21_v3
Game = Easy21_v3;

%No_vec=[500 300 200 100 10]; %Testing the performance of MC Control with different No
No_vec = 100; %Using the desired No value
%alpha = [0 0.01 0.05 0.1 0.3 0.5 1];
alpha=0;

for i=1:length(alpha)
    
    No=No_vec;
    %Initialisation for SARSA

    Q_Sar = zeros(10,21,2); %Q(s,a)
    count_s_a = zeros(10,21,2); %N(s,a)
    count_s = zeros(10,21); %N(s)

    max_length = 1000;
    n_episodes=1000000;
    pol=0.5*ones(10,21,2);
    Rewards=zeros(1,n_episodes);
    
    index_test=50000;
    size_test_set=100000;
    Mean_vect=[];
    Std_vect=[];
    xaxis=[];

    for episode=1:n_episodes
        if mod((episode/n_episodes),0.05)==0
            episode/n_episodes
        end
        init(Game,max_length);
        init_s = reset(Game);
        [Q_Sar,Return_episode,pol,count_s,count_s_action]=...
         SARSA_episode(Game,No,init_s,Q_Sar,pol,count_s,count_s_a,alpha(i));
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
%legend(num2str([0;0.01;0.05;0.1;0.3;0.5;1]))

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

%% Storing Learning Curves mean
avg_Rewards_SARSA=Mean_vect;
save('avg_Rewards_SARSA.mat','avg_Rewards_SARSA')
%% Storing Learning Curves std
std_Rewards_SARSA=Std_vect;
save('std_Rewards_SARSA.mat','std_Rewards_SARSA')

%% Optimal value plot

[V_Sarsa, index] = max(Q_Sar,[],3);

figure(2);
subplot(1,2,1)
surf(V_Sarsa','EdgeColor','none')
ylabel('Player Sum')
ylim([1 21])
xlabel('Dealer showing')
xlim([1 10])
zlabel('Value')
title('Value Function - using SARSA')
colormap(gca,coolwarm)
hcb1=colorbar;

h=gcf;
set(h,'Position',[50 50 1100 700]);
set(h,'PaperOrientation','landscape');
print(gcf, '-dpdf', 'Value Function.pdf')

%%
h=gcf;
h.PaperPositionMode='auto';
set(h,'PaperOrientation','landscape');
set(findall(gcf,'-property','FontSize'),'FontSize',12)
print(gcf, '-dpdf', 'Value Function.pdf','-fillpage')