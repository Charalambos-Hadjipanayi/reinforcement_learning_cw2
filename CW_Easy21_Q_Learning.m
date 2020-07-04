clc
close all
clear all

% Defining the Game

%Calling the object into this file
import Easy21_v3
Game = Easy21_v3;

%No_vec=[500 300 200 100 10]; %Testing the performance of MC Control with different No
No_vec = 100; %Using the desired No value
e = [0,0.01,0.05,0.1,0.2,1]; %Epsilon-greedyness

for i=1:length(e)
    No=No_vec;
    
    %Initialisation for SARSA

    Q_QL = zeros(10,21,2); %Q(s,a)
    c_s_a = zeros(10,21,2); %N(s,a)
    c_s = zeros(10,21); %N(s)

    max_length = 1000;
    n_episodes=1000000;
    b_pol=0.5*ones(10,21,2); %Behavioral policy
    t_pol = 0.5*ones(10,21,2); %Target policy
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
        [Q_QL,Ret_episode,b_pol,t_pol,c_s,c_s_a]=...
        Q_Learning_episode(Game,No,init_s,Q_QL,b_pol,t_pol,c_s,c_s_a,e(i));
        Rewards(episode)=Ret_episode;
        
        %This is when validation testing is done
        if mod(episode,index_test)==0 || episode==1
             [mean_test,std_test]=test(b_pol,size_test_set);
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

legend(num2str([0;0.01;0.05;0.1;0.2;1]))

%%
h=gcf;
h.PaperPositionMode='auto';
set(h,'PaperOrientation','landscape');
set(findall(gcf,'-property','FontSize'),'FontSize',12)
print(gcf, '-dpdf', 'Learning Curve .pdf','-fillpage')

%%
%Plot of policy of hitting
figure(2);
subplot(1,2,2)
h = heatmap(b_pol(:,:,2));
xlabel('Player Sum')
xlim([1 21])
ylabel('Dealer showing')
ylim([1 10])
title('Optimal Behaviour policy of action HIT')
colormap(gca,'gray')

%Histogram of Rewards
figure;
histogram(Rewards)

%% Storing Learning Curves mean
avg_Rewards_QLearning=Mean_vect;
save('avg_Rewards_QLearning.mat','avg_Rewards_QLearning')
%% Storing Learning Curves std
std_Rewards_QLearning=Std_vect;
save('std_Rewards_QLearning.mat','std_Rewards_QLearning')

%% Optimal value plot

[V_Q_learning, index] = max(Q_QL,[],3);

figure(2);
subplot(1,2,1)
surf(V_Q_learning','EdgeColor','none')
ylabel('Player Sum')
ylim([1 21])
xlabel('Dealer showing')
xlim([1 10])
zlabel('Value')
title('Value Function - using Q Learning')
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