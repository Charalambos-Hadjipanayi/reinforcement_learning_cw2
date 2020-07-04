close all ; clear all ; clc

%Loading Learning Curves of the three methods
load('avg_Rewards_MC.mat');
load('std_Rewards_MC.mat');

load('avg_Rewards_SARSA.mat');
load('std_Rewards_SARSA.mat');

load('avg_Rewards_QLearning.mat');
load('std_Rewards_QLearning.mat');

%construction of the two x-axes to be used
n_episodes=1000000;
index_test_mean=100000;
index_test_std=50000;
xaxis_means=[];
xaxis_std =[];

for episode=1:n_episodes
    if mod(episode,50000)==0
        episode
    end
    
    
            if mod(episode,index_test_mean)==0 || episode==1
                xaxis_means=[xaxis_means;episode];
            end     
            
            if mod(episode,index_test_std)==0 || episode==1
                xaxis_std=[xaxis_std;episode];
            end     
end

%% Average Reward plots
figure(1);
subplot(1,2,1)
hold on
grid on
plot(xaxis_means,avg_Rewards_MC);
plot(xaxis_means,avg_Rewards_SARSA);
plot(xaxis_means,avg_Rewards_QLearning);
xlabel('Episode'); ylabel('Average Reward')
legend('MC Control','SARSA','Q Learning','Location','best')

%% Std Plots
figure(1);
subplot(1,2,2)
hold on
grid on
plot(xaxis_std,std_Rewards_MC);
plot(xaxis_std,std_Rewards_SARSA);
plot(xaxis_std,std_Rewards_QLearning);
xlabel('Episode'); ylabel('Std of Rewards')
legend('MC Control','SARSA','Q Learning','Location','best')
hold off

%%
h=gcf;
h.PaperPositionMode='auto';
set(h,'PaperOrientation','landscape');
set(findall(gcf,'-property','FontSize'),'FontSize',12)
print(gcf, '-dpdf', 'Value Function.pdf','-fillpage')