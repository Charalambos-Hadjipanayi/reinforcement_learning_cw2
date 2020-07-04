clc
close all
clear all

%% Defining the Game

%Calling the object into this file
import Easy21_v3
Game = Easy21_v3;

N=100000; %Total number of games

Rewards=zeros(1,N);
for number_turns=1:N
    state = [];
    Actions=[];
    max_length = 1000;
    init(Game,max_length);
    state(1,:) = reset(Game);
    Terminal=0;

    index=1;
    while Terminal==0
        index=index+1;
        x=rand;
        if x<0.5
           action=1;
        else
           action=0;
        end
        
        Actions(index-1)=action;
        
        [next_state,Terminal,reward,s_D,~]=step(Game, action);
        if ~Terminal
            state(index,:)=next_state;
        end
        
    end
    D_sum(number_turns) = s_D;
    Rewards(number_turns)=reward;
end

figure;
histogram(Rewards)