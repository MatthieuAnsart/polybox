    
    projectpath = genpath(pwd);
    addpath(projectpath);
sigma = num2str(sig,2)

%     load('\\d\dfs\groups\itet\eeh\psl\stud\ansartm\public\New folder\BaseEMU\sample input data file\Noise_generated.mat')
    load(strcat('/cluster/home/ansartm/polybox/sample_input_data_file/Noise_generated_sig_',sigma,'.mat'))
    
    %                      mu          cost      rho        gamma   battsize(kWh)
    
    SimSettings = [    %     0            1       9.1        10000       6.4;
         1            1       9.1        10000       6.4;
         2            1       9.1        10000       6.4;
%         3            1       9.1        10000       6.4;
%         4            1       9.1        10000       6.4;
%         5            1       9.1        10000       6.4;
%         6            1       9.1        10000       6.4;
%         7            1       9.1        10000       6.4;
%         8            1       9.1        10000       6.4;
%         9            1       9.1        10000       6.4;
%         10           1       9.1        10000       6.4;
%         12           1       9.1        10000       6.4;
%         14           1       9.1        10000       6.4;
%         15           1       9.1        10000       6.4;
%         16           1       9.1        10000       6.4;
%         18           1       9.1        10000       6.4;
%         20           1       9.1        10000       6.4;
%         25           1       9.1        10000       6.4;
%         30           1       9.1        10000       6.4;
%         35           1       9.1        10000       6.4;
%         40           1       9.1        10000       6.4;
%         45           1       9.1        10000       6.4;
%         50           1       9.1        10000       6.4;
%         55           1       9.1        10000       6.4;
%         60           1       9.1        10000       6.4;
%         65           1       9.1        10000       6.4;
%         70           1       9.1        10000       6.4;
%         75           1       9.1        10000       6.4;
%         80           1       9.1        10000       6.4;
%         85           1       9.1        10000       6.4;
%         90           1       9.1        10000       6.4;
%         95           1       9.1        10000       6.4;
%         100          1       9.1        10000       6.4;
        ]


    %                      mu          cost      rho        gamma   battsize(kWh)
    
%     SimSettings = [    %     0            1       9.1        10000       6.4;
%         5            1       9.1        10       6.4;
%         5            1       9.1        20       6.4;
%         5            1       9.1        50       6.4;
%         5            1       9.1        80       6.4;
%         5            1       9.1        100      6.4;
%         5            1       9.1        200      6.4;
%         5            1       9.1        250      6.4;
%         5            1       9.1        300      6.4;
%         5            1       9.1        500      6.4;
%         5            1       9.1        750      6.4;
%         5            1       9.1        1000     6.4;
%         5            1       9.1        1500     6.4;
%         5            1       9.1        2000     6.4;
%         5            1       9.1        5000     6.4;
%         5            1       9.1        10000    6.4;
%         30           1       9.1        10000       6.4;
%         35           1       9.1        10000       6.4;
%         40           1       9.1        10000       6.4;
%         45           1       9.1        10000       6.4;
%         50           1       9.1        10000       6.4;
%         55           1       9.1        10000       6.4;
%         60           1       9.1        10000       6.4;
%         65           1       9.1        10000       6.4;
%         70           1       9.1        10000       6.4;
%         75           1       9.1        10000       6.4;
%         80           1       9.1        10000       6.4;
%         85           1       9.1        10000       6.4;
%         90           1       9.1        10000       6.4;
%         95           1       9.1        10000       6.4;
%         100          1       9.1        10000       6.4;
%          ]

    
    
    clc;
    
    Out = size(SimSettings(:,1));
    
    
    cd('/cluster/home/ansartm/polybox/');
    folder = 'Test mu_sig 0.1_'; %T12 @ 30 min = 24 Step
    k = datestr(now,'dd-mmm-yyyy HH.MM.SS');
    str = int2str(answer);
    mkdir(strcat('Noise_',str, '__',folder, '__', k));
    cd(strcat('Noise_',str, '__',folder , '__', k));
    clear k;
    
    xlswrite('OutputCompilation.csv', {folder}, 'Data', '2');
    xlswrite('OutputCompilation.csv', {'gamma' , 'Total Grid Energy (kWh)', 'Total Cost (SFr)' , ...
        'Time Average Step I(Y;X)' , 'Time Average Step I(Y;X)_obj' , 'Time Average I(Y;X)' , ...
        'Cumulative I(Y;X)', 'Max abs(I(Y;X)-I(Y;X)_obj)','Cost', 'BattCap', 'rho', 'gamma'}, 'Data', '3');
    
    % prompt = 'Which kind of forecast do you want to generate? \n 1 : perfect forecast \n 2 : gaussian noise with constant deviation penalty (no trend) \n 3 : gaussian noise with growing deviation penalty (no trend) \n 4 : gaussian noise with random deviation penalty (no trend) \n 5 : gaussian noise with constant deviation penalty (with trend) \n 6 : gaussian noise with growing deviation penalty (with trend) \n 7 : gaussian noise with random deviation penalty (with trend) \n \n';
    % answer = input(prompt);
    
    if answer == 1
        Forecast = Perfect_forecast;
    elseif answer == 2
        Forecast = Noise_2;
    elseif answer == 3
        Forecast = Noise_3;
    elseif answer == 6
        Forecast = Noise_6;
    elseif answer == 7
        Forecast = Noise_7;       
    end
    
    
    for Run = 1:Out
        
        TestName = strcat('mu=',num2str(SimSettings(Run,1)), ', gamma=',num2str(SimSettings(Run,4)), ', cost=',num2str(SimSettings(Run,2)),', battsize=',num2str(SimSettings(Run,5)),', add 1'); %add special notes here
        mkdir(TestName);
        cd(TestName);
        mu = SimSettings(Run,1);
        CostOn = SimSettings(Run,2);
        BattCap = SimSettings(Run,5);
        
        rho = SimSettings(Run,3);
        gamma = SimSettings(Run,4);
        
        fprintf('**********************************\n\n');
        disp(TestName);
        fprintf('\n**********************************\n\n');
        
        MinCostRH;
        
        clearvars -except answer TestNameStore Run Out SimSettings folder PVInput Time Forecast LoadInput CostInput;
        %     clc;
        
    end
    
end
