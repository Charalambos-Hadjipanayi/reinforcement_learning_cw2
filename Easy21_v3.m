classdef Easy21_v3 < handle
   properties
        max_length;
        player_1stCard_val;
        dealer_1stCard_val;
        player_sum;
        dealer_sum;
        
        state;
        player_goes_bust;
        dealer_goes_bust;
        
        player_card_val;
        player_card_col;
        
        dealer_card_val;
        dealer_card_col;
        
        ret;
        terminal;
        t;
   end
   
   methods
        function init(obj,max_len)
            obj.max_length = max_len;
        end
        
        function state = reset(obj)
            obj.player_1stCard_val = randi([1 10]);
            obj.dealer_1stCard_val = randi([1 10]);
            
            obj.player_sum = obj.player_1stCard_val;
            obj.dealer_sum = obj.dealer_1stCard_val;
            
            obj.state = [obj.dealer_1stCard_val,obj.player_1stCard_val]; 
            
            obj.player_goes_bust=false;
            obj.dealer_goes_bust=false;
            
            obj.ret=0;
            obj.terminal = false;
            obj.t=0;
            
            state = obj.state;
        end
        
        function [state,Terminal,reward,Dealer_sum,Player_sum]=step(obj, action)
            %Action: 1 = hit , 0=stick
            %colour: 1=black , -1=red
            
            r=0; %Reward
                        
            previous_player_sum = obj.player_sum;
            
            if action==1 %When player hits
                obj.player_card_val = randi([1 10]);
                
                x=rand; %Choosing random colour
                if x<(1/3)
                    colour=-1;
                else
                    colour=1;
                end
                obj.player_card_col=colour;
                
                obj.player_sum = obj.player_sum + (obj.player_card_val * obj.player_card_col);
                obj.player_goes_bust = (obj.player_sum>21 || obj.player_sum<1);
                
                if obj.player_goes_bust == 1
                    r = -1;
                    obj.terminal = true;
                end
            end
                
            if (action==0)&&(obj.terminal==0)%when player sticks
                while (obj.dealer_sum>0)&&(obj.dealer_sum<17) 
                    obj.dealer_card_val = randi([1 10]);
                    z=rand; %Choosing random colour
                    if z<(1/3)
                        col=-1;
                    else
                        col=1;
                    end
                    obj.dealer_card_col=col;
     
                    obj.dealer_sum = obj.dealer_sum + (obj.dealer_card_val * obj.dealer_card_col);
                    obj.dealer_goes_bust = (obj.dealer_sum>21 || obj.dealer_sum<1); 
                    
                    if obj.dealer_goes_bust == 1
                        r = 1;
                        obj.terminal = true;
                    end
                end
                

                
                obj.terminal = true; %game ends when dealer sticks
                if ~obj.dealer_goes_bust
                    if obj.player_sum>obj.dealer_sum
                        r=1;
                    elseif obj.player_sum<obj.dealer_sum
                        r=-1;
                    elseif obj.player_sum==obj.dealer_sum
                        r=0;
                    end
                end
            end
            
            obj.t = obj.t + 1;
            obj.ret = obj.ret + r;
            
            if ((obj.terminal==0) && (obj.t==obj.max_length))
                obj.terminal=true;
                if obj.player_sum>obj.dealer_sum
                    r=1;
                elseif obj.player_sum<obj.dealer_sum
                    r=-1;
                elseif obj.player_sum==obj.dealer_sum
                    r=0;
                end
            end
            
            if (obj.terminal==1) %Game has finished
                Terminal = obj.terminal;
%                 fprintf('\n \n Terminal \n \n');
                reward=r;
                obj.state(2) = previous_player_sum;
                state = obj.state;
            end
            
            if (obj.terminal==0)
                obj.state(2) = obj.player_sum;
                state = obj.state;
                reward=r;
                Terminal = obj.terminal;
            end
            
            Dealer_sum = obj.dealer_sum;
            Player_sum = obj.player_sum;
        end
            
   end
end
