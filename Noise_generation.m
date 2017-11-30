clear all
clc

load('C:\Users\ansartm\Desktop\New folder\BaseEMU\sample input data file\Family1Child.mat')

NumOut = 12;
LoadMax = 3.6;

Perfect_forecast = zeros(length(LoadInput)-NumOut,NumOut); % perfect forecast

Noise_2 = zeros(length(LoadInput)-NumOut,NumOut); % constant sigma
Noise_3 = zeros(length(LoadInput)-NumOut,NumOut); % growing sigma
% Noise_generated_4 = zeros(length(LoadInput)-NumOut,NumOut); % proportional sigma
% Noise_generated_5 = zeros(length(LoadInput)-NumOut,NumOut); % day/night sigma

Noise_6 = zeros(length(LoadInput)-NumOut,NumOut); % constant sigma
Noise_7 = zeros(length(LoadInput)-NumOut,NumOut); % growing sigma
% Noise_generated_8 = zeros(length(LoadInput)-NumOut,NumOut); % proportional sigma
% Noise_generated_9 = zeros(length(LoadInput)-NumOut,NumOut); % day/night sigma
 
Load = LoadInput;


sig2 = 0.1 ; 
sig3 = 0.1 ;


% sig2 = var(LoadInput) ; % constant sigma
% sig3 = var(LoadInput) ; % for growing sigma 
% sig = std(LoadInput) ; % standard deviation of original value
% m = mean (LoadInput) ; % average of original values
 
% sig_day = 0.3; % 8h - 22 h
% sig_night = 0.15; % 23h - 7h


for k = 1 : length(LoadInput)-NumOut
    
    h2 = random('norm', 0, sig2 , NumOut, 1);
    %     sig3 = gamcdf(abs(random('norm', 0.5, 0.5/3 , NumOut, 1)),5,0.5);
    %     h3 = random('norm', 0, sig3 , NumOut, 1);
    
    beta6 = zeros (1 : NumOut);
    beta7 = zeros (1 : NumOut);
    beta8 = zeros (1 : NumOut);
    beta9 = zeros (1 : NumOut);
    
    for t = 1 : NumOut
        
        %% perfect forecast
        Perfect_forecast(k,t)= Load(t+k-1); % perfect forecast
        
        %keep forecast realistic
        if Perfect_forecast(k,t) < 0
            Perfect_forecast(k,t) = 0;
        elseif Perfect_forecast(k,t) > LoadMax
            Perfect_forecast(k,t) = LoadMax;
        end
        
        %% no trend %%
        %% constant sigma
        Noise_2(k,t)= Load(t+k-1)+ h2(t); % constant error
        
        %% growing sigma
        h3 = random('norm', 0, sig3*t, NumOut, 1);
        Noise_3(k,t)= Load(t+k-1)+ h3(t); % growing error
        
        %         Noise_generated_4(k,t)= Load(t+k-1)+ h3(t); % gamma inverse error
        
%         %% proportional sigma
%         sig4 = (Load(t+k-1)*sig/m)^2 ;
%         h4 = random('norm', 0, sig4 , NumOut, 1) ;
%         Noise_generated_4(k,t)= Load(t+k-1)+ h4(t); % gamma dynamic
%         
%         %% day/night sigma
%         moment = mod((t+k),24);
%         if ( 7 < moment < 23)
%             h5 = random('norm', 0, sig_day , NumOut , 1) ;
%         else 
%             h5 = random('norm', 0, sig_night , NumOut , 1) ;
%         end
%         Noise_generated_5(k,t)= Load(t+k-1)+ h5(t);
        
        %% keep forecast realistic
        if Noise_2(k,t) < 0
            Noise_2(k,t) = 0;
        elseif Noise_2(k,t) > LoadMax
            Noise_2(k,t) = LoadMax;
        end
        
        if Noise_3(k,t) < 0
            Noise_3(k,t) = 0;
        elseif Noise_3(k,t) > LoadMax
            Noise_3(k,t) = LoadMax;
        end
        
%         if Noise_generated_4(k,t) < 0
%             Noise_generated_4(k,t) = 0;
%         elseif Noise_generated_4(k,t) > LoadMax
%             Noise_generated_4(k,t) = LoadMax;
%         end
%         
%         if Noise_generated_5(k,t) < 0
%             Noise_generated_5(k,t) = 0;
%         elseif Noise_generated_5(k,t) > LoadMax
%             Noise_generated_5(k,t) = LoadMax;
%         end
        
        %% with trend
        if t==1 
            Noise_6(k,t)= Load(t+k-1)+ h2(t); 
            Noise_7(k,t)= Load(t+k-1)+ h3(t); 
%             Noise_generated_8(k,t)= Load(t+k-1)+ h4(t);
%             Noise_generated_9(k,t)= Load(t+k-1)+ h5(t);
        else
            beta6(t) = Load(t-2+k) - Noise_6(k,t-1)+ h2(t);
            beta7(t) = Load(t-2+k) - Noise_7(k,t-1)+ h3(t);
%             beta8(t) = Load(t-2+k) - Noise_generated_8(k,t-1)+ h4(t);
%             beta9(t) = Load(t-2+k) - Noise_generated_5(k,t-1)+ h5(t);
             
            Noise_6(k,t)= Load(t+k-1)+ beta6(t); 
            Noise_7(k,t)= Load(t+k-1)+ beta7(t);
%             Noise_generated_8(k,t)= Load(t+k-1)+ beta8(t);
%             Noise_generated_9(k,t)= Load(t+k-1)+ beta9(t);
        end
        
        %% keep forecast realistic
        if Noise_6(k,t) < 0
            Noise_6(k,t) = 0;
        elseif Noise_6(k,t) > LoadMax
            Noise_6(k,t) = LoadMax;
        end
        
        if Noise_7(k,t) < 0
            Noise_7(k,t) = 0;
        elseif Noise_7(k,t) > LoadMax
            Noise_7(k,t) = LoadMax;
        end

%         if Noise_generated_8(k,t) < 0
%             Noise_generated_8(k,t) = 0;
%         elseif Noise_generated_8(k,t) > LoadMax
%             Noise_generated_8(k,t) = LoadMax;
%         end
%         
%         if Noise_generated_9(k,t) < 0
%             Noise_generated_9(k,t) = 0;
%         elseif Noise_generated_9(k,t) > LoadMax
%             Noise_generated_9(k,t) = LoadMax;
%         end
        
    end
end

save('Noise_generated','CostInput','Time','PVInput','Perfect_forecast','Noise_2','Noise_3','Noise_6','Noise_7','LoadInput');