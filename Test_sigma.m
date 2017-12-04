cd ('/cluster/home/ansartm/polybox/results_test_mu')

list = dir;
list = list([list.isdir]); % number of subfolders
list = list(~ismember({list.name},{'.' '..'})); % permet de degager {'.' '..'}
N=length(list);

% for results display
% mu       %sigma      %I(X,Y)
results_1 = [];
results_2 = [];
results_3 = [];
results_6 = [];
results_7 = [];

for i = 1 : N
    Number_1 = strfind(list(i).name,'1');
    Number_2 = strfind(list(i).name,'2');
    Number_3 = strfind(list(i).name,'3');
    Number_6 = strfind(list(i).name,'6');
    Number_7 = strfind(list(i).name,'7');
    cd(list(i).name);
    listSubfolder=dir;
    listSubfolder = listSubfolder([listSubfolder.isdir]); % number of subfolders
    listSubfolder = listSubfolder(~ismember({listSubfolder.name},{'.' '..'})); % permet de degager {'.' '..'}
    L = length(listSubfolder);
    
    for p = 1 : L
        % permet de recuperer sigma qui se trouve dans le titre du dossier
        sig =(extractBefore(extractAfter(listSubfolder(p).name,20),4));
        % on teste si sigma s ecrit avec 2 ou 3 chiffres
        if extractAfter(sig,2)=='_'
            sig = str2double(extractBefore(sig,3))/100;
        else
            sig = str2double(sig)/100;
        end
        cd(listSubfolder(p).name);
        file = dir('*.mat');
        if isempty(file)
            break
        else
            load (file.name);
            if size(Number_1,1)~= 0 && Number_1(1) == 7 % le numero du bruit est en 7eme position
                results_1 = [results_1 ; mu sig P_act(PeriodEnd,9)];
            elseif size(Number_2,1)~= 0 && Number_2(1) == 7
                results_2 = [results_2 ; mu sig P_act(PeriodEnd,9)];
            elseif size(Number_3,1)~= 0 && Number_3(1) == 7
                results_3 = [results_3 ; mu sig P_act(PeriodEnd,9)];
            elseif size(Number_6,1)~= 0 && Number_6(1) == 7
                results_6 = [results_6 ; mu sig P_act(PeriodEnd,9)];
            elseif size(Number_7,1)~= 0 && Number_7(1) == 7
                results_7 = [results_7 ; mu sig P_act(PeriodEnd,9)];
            else
                break
            end
            cd ('..')
            clearvars -except listSubfolder N L list results_1 results_2 results_3 results_6 results_7 p i Number_1 Number_2 Number_3 Number_6 Number_7 PeriodEnd
        end
    end
    cd ('..')
end

%on classe par rapport a la premiere colonne (mu)
results_1 = sortrows(results_1);
results_2 = sortrows(results_2);
results_3 = sortrows(results_3);
results_6 = sortrows(results_6);
results_7 = sortrows(results_7);

%on classe par rapport a la deuxieme colonne (sigma)
results_1 = sortrows(results_1,2);
results_2 = sortrows(results_2,2);
results_3 = sortrows(results_3,2);
results_6 = sortrows(results_6,2);
results_7 = sortrows(results_7,2);


if size(results_1,1) ~= 0
    a = results_1(1,2); % valeur de sigma
    m = 1;
    for i = 1 : size(results_1,1)
        if results_1(i,2) ~= a
            plot3(results_1(m : i-1,1),(results_1(m : i-1,2)),results_1(m : i-1,3),'DisplayName',strcat('I(X,Y) avec sigma =',int2str(a)));
            hold on
            m = i ; % on reajuste le 1er indice du nouveau sigma
            a = results_1(m,2); % ainsi que la valeur de a
        end
    end
    plot3(results_1(m : i,1),(results_1(m : i,2)),results_1(m : i,3),'DisplayName',strcat('I(X,Y) avec sigma =',int2str(a)));
    legend('show')
    title('I(X,Y) perfect forecast')
    grid on
    xlabel('mu')
    ylabel('sigma')
    zlabel('I(X,Y)')
    hold off
    print('I(X,Y) perfect forecast','-djpeg100','-r200');
    saveas(gcf,'I(X,Y) perfect forecast','fig');
end


if size(results_2,1) ~= 0
    a = results_2(1,2); % valeur de sigma
    m = 1;
    for i = 1 : size(results_2,1)
        if results_2(i,2) ~= a
            plot3(results_2(m : i-1,1),results_2(m : i-1,2),results_2(m : i-1,3),'DisplayName',strcat('I(X,Y) avec sigma =',int2str(a)));
            hold on
            m = i ; % on reajuste le 1er indice du nouveau sigma
            a = results_2(m,2); % ainsi que la valeur de a
        end
    end
    plot3(results_2(m : i,1),(results_2(m : i,2)),results_2(m : i,3),'DisplayName',strcat('I(X,Y) avec sigmah =',int2str(a)));
    legend('show')
    title('I(X,Y) no trend constant variance')
    grid on
    xlabel('mu')
    ylabel('sigma')
    zlabel('I(X,Y)')
    hold off
    print('I(X,Y) no trend constant variance','-djpeg100','-r200');
    saveas(gcf,'I(X,Y) no trend constant variance','fig');
end

if size(results_3,1) ~= 0
    a = results_3(1,2); % valeur de sigma
    m = 1;
    for i = 1 : size(results_3,1)
        if results_3(i,2) ~= a
            plot3(results_3(m : i-1,1),(results_3(m : i-1,2)),results_3(m : i-1,3),'DisplayName',strcat('I(X,Y) avec sigma =',int2str(a)));
            hold on
            m = i ; % on reajuste le 1er indice du nouveau sigma
            a = results_3(m,2); % ainsi que la valeur de a
        end
    end
    plot3(results_3(m : i,1),(results_3(m : i,2)),results_3(m : i,3),'DisplayName',strcat('I(X,Y) avec sigma =',int2str(a)));
    legend('show')
    title('I(X,Y) no trend growing variance')
    grid on
    xlabel('mu')
    ylabel('sigma')
    zlabel('I(X,Y)')
    hold off
    print('I(X,Y) no trend growing variance','-djpeg100','-r200');
    saveas(gcf,'I(X,Y) no trend growing variance','fig');
end


if size(results_6,1) ~= 0
    a = results_6(1,2); % valeur de sigma
    m = 1;
    for i = 1 : size(results_6,1)
        if results_6(i,2) ~= a
            plot3(results_6(m : i-1,1),(results_6(m : i-1,2)),results_6(m : i-1,3),'DisplayName',strcat('I(X,Y) avec sigma =',int2str(a)));
            hold on
            m = i ; % on reajuste le 1er indice du nouveau sigma
            a = results_6(m,2); % ainsi que la valeur de a
        end
    end
    plot3(results_6(m : i,1),(results_6(m : i,2)),results_6(m : i,3),'DisplayName',strcat('I(X,Y) avec sigma =',int2str(a)));
    legend('show')
    title('I(X,Y) with trend constant variance')
    grid on
    xlabel('mu')
    ylabel('sigma')
    zlabel('I(X,Y)')
    hold off
    print('I(X,Y) with trend constant variance','-djpeg100','-r200');
    saveas(gcf,'I(X,Y) with trend constant variance','fig');
end

if size(results_7,1) ~= 0
    a = results_7(1,2); % valeur de sigma
    m = 1;
    for i = 1 : size(results_7,1)
        if results_7(i,2) ~= a
            plot3(results_7(m : i-1,1),(results_7(m : i-1,2)),results_7(m : i-1,3),'DisplayName',strcat('I(X,Y) avec sigma =',int2str(a)));
            hold on
            m = i ; % on reajuste le 1er indice du nouveau sigma
            a = results_7(m,2); % ainsi que la valeur de a
        end
    end
    plot3(results_7(m : i,1),(results_7(m : i,2)),results_7(m : i,3),'DisplayName',strcat('I(X,Y) avec sigma =',int2str(a)));
    legend('show')
    title('I(X,Y) with trend growing variance')
    grid on
    xlabel('mu')
    ylabel('sigma')
    zlabel('I(X,Y)')
    hold off
    print('I(X,Y) with trend growing variance','-djpeg100','-r200');
    saveas(gcf,'I(X,Y) with trend growing variance','fig');
end

clearvars -except results_1 results_2 results_3 results_6 results_7
save test.mat
