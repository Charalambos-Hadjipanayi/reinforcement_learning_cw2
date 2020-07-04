clc
close all
clear all

%% Defining the Game

%Calling the object into this file
import Easy21_v3
Game = Easy21_v3;

max_length = 1000;
init(Game,max_length);
state(1,:) = reset(Game);
Terminal=0;

index=1;

while Terminal==0
        x=rand;
        if x<0.75
            action=1;
        else
            action=0;
        end
    actions(index)=action;
    [next_state,Terminal,reward,s_D,s_P]=step(Game, action);
    Rew(index)=reward;
    index=index+1;
    if ~Terminal
        state(index,:) = next_state;
    end
end
