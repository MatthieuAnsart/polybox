cd ('\\d\dfs\groups\itet\eeh\psl\stud\ansartm\public\New folder\BaseEMU\Le big test')

list=dir;
list = list([list.isdir]); % number of subfolders
list = list(~ismember({list.name},{'.' '..'})); % permet de degager {'.' '..'}
N=length(list);

% for results display
% mu       %gamma      %I(X,Y)
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
        cd(listSubfolder(p).name);
        file = dir('*.mat');
        if isempty(file)
            break
        else
            load (file.name);
            if size(Number_1,1)~= 0 && Number_1(1) == 7 % le numero du bruit est en 7eme position
                results_1 = [results_1 ; mu gamma P_act(PeriodEnd,9)];
            elseif size(Number_2,1)~= 0 && Number_2(1) == 7
                results_2 = [results_2 ; mu gamma P_act(PeriodEnd,9)];
            elseif size(Number_3,1)~= 0 && Number_3(1) == 7
                results_3 = [results_3 ; mu gamma P_act(PeriodEnd,9)];
            elseif size(Number_6,1)~= 0 && Number_6(1) == 7
                results_6 = [results_6 ; mu gamma P_act(PeriodEnd,9)];
            elseif size(Number_7,1)~= 0 && Number_7(1) == 7
                results_7 = [results_7 ; mu gamma P_act(PeriodEnd,9)];
            end
            cd ('..')
            clearvars -except listSubfolder N L list results_1 results_2 results_3 results_6 results_7 p i Number_1 Number_2 Number_3 Number_6 Number_7 PeriodEnd
        end
    end
    cd ('\\d\dfs\groups\itet\eeh\psl\stud\ansartm\public\New folder\BaseEMU\Le big test')
    
end

%on classe d'abord par rapport a gamma
results_1 = sortrows(results_1,2);
results_2 = sortrows(results_2,2);
results_3 = sortrows(results_3,2);
results_6 = sortrows(results_6,2);
results_7 = sortrows(results_7,2);

%on classe par rapport a la premiere colonne (mu)
results_1 = sortrows(results_1);
results_2 = sortrows(results_2);
results_3 = sortrows(results_3);
results_6 = sortrows(results_6);
results_7 = sortrows(results_7);

% on passe gamma en echelle log
if size(results_1,1)~= 0
    results_1 (:,2) = log(results_1 (:,2));
end
if size(results_2,1)~= 0
    results_2 (:,2) = log(results_2 (:,2));
end
if size(results_3,1)~= 0
    results_3 (:,2) = log(results_3 (:,2));
end
if size(results_6,1)~= 0
    results_6 (:,2) = log(results_6 (:,2));
end
if size(results_7,1)~= 0
    results_7 (:,2) = log(results_7 (:,2));
end


if size(results_1,1) ~= 0
    a = results_1(1,1); % valeur de mu
    m = 1;
    for i = 1 : size(results_1,1)
        if results_1(i,1) ~= a
            plot3(results_1(m : i-1,1),(results_1(m : i-1,2)),results_1(m : i-1,3),'DisplayName',strcat('I(X,Y) avec mu =',int2str(a)));
            hold on
            m = i ; % on reajuste le 1er indice du nouveau mu
            a = results_1(m,1); % ainsi que la valeur de a
        end
    end
    plot3(results_1(m : i,1),(results_1(m : i,2)),results_1(m : i,3),'DisplayName',strcat('I(X,Y) avec mu =',int2str(a)));
    legend('show')
    title('I(X,Y) perfect forecast')
    grid on
    xlabel('mu')
    ylabel('gamma (log)')
    zlabel('I(X,Y)')
    hold off
    print('I(X,Y) perfect forecast','-djpeg100','-r200');
    saveas(gcf,'I(X,Y) perfect forecast','fig');
end


if size(results_2,1) ~= 0
    a = results_2(1,1); % valeur de mu
    m = 1;
    for i = 1 : size(results_2,1)
        if results_2(i,1) ~= a
            plot3(results_2(m : i-1,1),(results_2(m : i-1,2)),results_2(m : i-1,3),'DisplayName',strcat('I(X,Y) avec mu =',int2str(a)));
            hold on
            m = i ; % on reajuste le 1er indice du nouveau mu
            a = results_2(m,1); % ainsi que la valeur de a
        end
    end
    plot3(results_2(m : i,1),(results_2(m : i,2)),results_2(m : i,3),'DisplayName',strcat('I(X,Y) avec mu =',int2str(a)));
    legend('show')
    title('I(X,Y) no trend constant variance')
    grid on
    xlabel('mu')
    ylabel('gamma (log)')
    zlabel('I(X,Y)')
    hold off
    print('I(X,Y) no trend constant variance','-djpeg100','-r200');
    saveas(gcf,'I(X,Y) no trend constant variance','fig');
end

if size(results_3,1) ~= 0
    a = results_3(1,1); % valeur de mu
    m = 1;
    for i = 1 : size(results_3,1)
        if results_3(i,1) ~= a
            plot3(results_3(m : i-1,1),(results_3(m : i-1,2)),results_3(m : i-1,3),'DisplayName',strcat('I(X,Y) avec mu =',int2str(a)));
            hold on
            m = i ; % on reajuste le 1er indice du nouveau mu
            a = results_3(m,1); % ainsi que la valeur de a
        end
    end
    plot3(results_3(m : i,1),(results_3(m : i,2)),results_3(m : i,3),'DisplayName',strcat('I(X,Y) avec mu =',int2str(a)));
    legend('show')
    title('I(X,Y) no trend growing variance')
    grid on
    xlabel('mu')
    ylabel('gamma (log)')
    zlabel('I(X,Y)')
    hold off
    print('I(X,Y) no trend growing variance','-djpeg100','-r200');
    saveas(gcf,'I(X,Y) no trend growing variance','fig');
end


if size(results_6,1) ~= 0
    a = results_6(1,1); % valeur de mu
    m = 1;
    for i = 1 : size(results_6,1)
        if results_6(i,1) ~= a
            plot3(results_6(m : i-1,1),(results_6(m : i-1,2)),results_6(m : i-1,3),'DisplayName',strcat('I(X,Y) avec mu =',int2str(a)));
            hold on
            m = i ; % on reajuste le 1er indice du nouveau mu
            a = results_6(m,1); % ainsi que la valeur de a
        end
    end
    plot3(results_6(m : i,1),(results_6(m : i,2)),results_6(m : i,3),'DisplayName',strcat('I(X,Y) avec mu =',int2str(a)));
    legend('show')
    title('I(X,Y) with trend constant variance')
    grid on
    xlabel('mu')
    ylabel('gamma (log)')
    zlabel('I(X,Y)')
    hold off
    print('I(X,Y) with trend constant variance','-djpeg100','-r200');
    saveas(gcf,'I(X,Y) with trend constant variance','fig');
end

if size(results_7,1) ~= 0
    a = results_7(1,1); % valeur de mu
    m = 1;
    for i = 1 : size(results_7,1)
        if results_7(i,1) ~= a
            plot3(results_7(m : i-1,1),(results_7(m : i-1,2)),results_7(m : i-1,3),'DisplayName',strcat('I(X,Y) avec mu =',int2str(a)));
            hold on
            m = i ; % on reajuste le 1er indice du nouveau mu
            a = results_7(m,1); % ainsi que la valeur de a
        end
    end
    plot3(results_7(m : i,1),(results_7(m : i,2)),results_7(m : i,3),'DisplayName',strcat('I(X,Y) avec mu =',int2str(a)));
    legend('show')
    title('I(X,Y) with trend growing variance')
    grid on
    xlabel('mu')
    ylabel('gamma (log)')
    zlabel('I(X,Y)')
    hold off
    print('I(X,Y) with trend growing variance','-djpeg100','-r200');
    saveas(gcf,'I(X,Y) with trend growing variance','fig');
end