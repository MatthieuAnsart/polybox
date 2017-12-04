% diary (strcat(TestName,'.txt'));
% diary on;

StartTime = 1; %Point in time to start optimisation

%% Energy Storage System Parameters %%

%Parameters taken from the Tesla Powerwall

%BattCap = 6.4; % kWh https://www.tesla.com/powerwall?redirect=no 6.4
BattLimC = 3.3; %kW 3.3
BattLimD = 3.3; %kW 3.3
BattEffD = (1/(1 - 0.04)); % Discharge losses
BattEffC = 1 - 0.04; % Charge losses
%BattEndState = 0.5*BattCap; % Battery state of charge at end of day

%%

%PvCap = 6; % kWh
Interval = 60; %minutes
Horizon = 12/24; %day, optimisation horizon 12 default
NumOut = Horizon*24*60/Interval; % Optimisation Prediction Horizon T
Period = 30; %Number of days that is being investigated 30

TimeStep = Interval*60/3600; %to convert values to kWh

% Environment Variables %
% what actually happen
P_act = [];
%1 = time step, 2 = E_grid, 3 = E_load
%4 = Consolidated Battery Power; 5 = Battery State;
%Step Values: 6 = I(Y;X); 7 = I(Y;X)_obj;
%Eval 8 = I(Y;X); 9 = Cumulative I(X;Y); 10 = SMA of I(Y;X);
P_act(1,5) = 0; % initial battery value in kWh


%% Privacy Module Specific Variables %%

m = 15;%number of x bins was 15
n = 15;%number of y bins was 15
StepPat = 1;%for xy count initialisation pattern, for uniform x and y, set to 1
HistWin = 120; %set to m x n to enable simple initialisation of a uniform x, y distribution
N_window = HistWin + NumOut; % estimation of probability window
LoadMax = 3.6; % in kWh per interval
GridMax = 3.6; % in kWh per interval
xbinsize = round(LoadMax/m,3); %
ybinsize = round(GridMax/n,3); %
err1 = 0.1; % additive for xy count
err2 = n*err1; % additive for x count
err3 = m*err1; % additive for y count

Z_ijt = binvar(NumOut,n); %binary variable to count y in T

%history and counts stored by the controller
xhist = zeros(HistWin,1);
yhist = zeros(HistWin,1);
xycountrec = repmat(err1,m,n);
xcountrec = repmat(err2,m,1);
ycountrec = repmat(err3,n,1);

xglobal = []; %first eight are random dummies for eval
yglobal = []; %first eight are random dummies for eval
xycounteval = zeros(m,n);
ycounteval = zeros(m,1);
xcounteval =zeros(n,1);

xycount_cumulative = xycountrec;
ycount_cumulative = ycountrec;
xcount_cumulative = xcountrec;

Z_ijtHist = [];
xycountc_store = [];
%% Controller Specific variables%%

% Optimization Variables - Basic %
% mu = 100; %privacy costs, cost-per-bit;

BattOp = binvar(NumOut,1);
E_batt = sdpvar(NumOut+1,1);
P_battC = sdpvar(NumOut,1);
P_battD = sdpvar(NumOut,1);
E_grid= sdpvar(NumOut,1);

%%% CPlex 12.6.3
% options = sdpsettings('solver','CPlex','verbose',1,'showprogress',1,'cplex.solutiontarget',3, 'cplex.mip.display', 'on', 'saveyalmipmodel', 1,...
%     'savesolveroutput',1, 'cplex.exportmodel', strcat(TestName,'.sav'));

%%% Gurobi

options = sdpsettings('solver','Gurobi','verbose',0,'showprogress',0,'saveyalmipmodel',1,'savesolveroutput',1);
options.gurobi.TimeLimit=2;



%%% parameters of yalmip %%%
%verbose

%By setting verbose to 0, the solvers will run with minimal 
%display. By increasing the value, the display level is 
%controlled (typically 1 gives modest display level while 
%2 gives an awful amount of information printed).

%showprogress

%When the field showprogress is set to 1, the user can see what 
%YALMIP currently is doing (might be a good idea for large-scale 
%problems).

% mipdisplay
% 
% Frequency of displaying branch-and-bound
% information (for optimizing integer variables):
% 0 (default) = never
% 1 = each integer feasible solution
% 2 = every "mipinterval" nodes
% 3 = every "mipinterval" nodes plus
% information on LP relaxations
% (as controlled by "display")
% 4 = same as 2, plus LP relaxation info
% 5 = same as 2, plus LP subproblem info.



% Environment Sensing Variables %
P_pv = zeros(NumOut,1);
E_load = zeros(NumOut,1);
cost = zeros(NumOut,1);

% Controller Record %
% what the controller thinks that happened 
P_out = [];
%1 = E_grid, 2 = Battery Discharge, 3 = Battery Charge; 4 = Consolidated
%Battery Power; 5 = Battery State; 6 = Load Forecast History; 7 = PV Forecast
xycountchist = []; %for checking whether further steps equate to prediction

%% Controller %%

% k = cells(), k(:) = {value}, but can't perform functions as an array.
% need to implement piece wise operation of content, i.e. k{} + k{}

% Initialise privacy count matrices %
xhist = repmat(m:-StepPat:1,HistWin/m*StepPat,1);
xhist = xhist(:)';
%yhist = repmat(1:StepPat:n,1,HistWin/n*StepPat);
yhist = repmat(4,1,HistWin); %leveled load

for t = 1:HistWin
    xycountrec(xhist(t),yhist(t)) = xycountrec(xhist(t),yhist(t)) + 1;% initialised with a set pattern
    xcountrec(xhist(t),1) = xcountrec(xhist(t),1) + 1;
    ycountrec(yhist(t),1) = ycountrec(yhist(t),1) + 1;
end

for i = 1:m
    
    if round(sum(xycountrec(i,:)),6) ~= xcountrec(i,1)
        
        fprintf('\nInconstistent x marginal!\n');
        
    end
    
end

for j = 1:n
    
    if round(sum(xycountrec(:,j),'double'),6) ~= ycountrec(j,1)
        
        fprintf('\nInconstistent y marginal!\n');
        
    end
    
end

%% evaluation only

CumulativeStart = 1; % 0 means the first cumulative value is computed with controller iniated history,
% -1 means with evaluation history, >0 means no history, start at point of initialisation
SMAWindow = 16; %Simple moving average window


xglobal(1:NumOut) = repmat(5,1,NumOut);
%yglobal(1:NumOut) = randi(n,1,NumOut);
yglobal(1:NumOut) = repmat(5,1,NumOut); %leveled load

xglobal(NumOut+1:N_window) = xhist;
yglobal(NumOut+1:N_window) = yhist;

xycounteval = xycountrec;
ycounteval = ycountrec;
xcounteval = xcountrec;

for t = 1:NumOut
    xycounteval(xglobal(t),yglobal(t)) = xycounteval(xglobal(t),yglobal(t)) + 1;
    xcounteval(xglobal(t),1) = xcounteval(xglobal(t),1) + 1;
    ycounteval(yglobal(t),1) = ycounteval(yglobal(t),1) + 1;
end

if CumulativeStart == 0 % 0 means the first cumulative value is computed with controller initiated history,
    
    xycount_cumulative = xycountrec;
    ycount_cumulative = ycountrec;
    xcount_cumulative = xcountrec;
    Win_Cumu = HistWin;
    CumulativeStart = 1;
    
elseif CumulativeStart == -1 % -1 means with evaluation history

    xycount_cumulative = xycounteval;
    ycount_cumulative = ycounteval;
    xcount_cumulative = xcounteval;
    Win_Cumu = N_window;
    CumulativeStart = 1;
    
else %  >0 means no history, start at point of initialisation
    
    Win_Cumu = 0;
    
end

clear t

%% Controller continued %%
%check to ensure only set number of cells are filled
fprintf('(x,y)count:');
disp(sum(sum(xycountrec)));
fprintf('( x )count:');
disp(sum(sum(xcountrec)));
fprintf('( y )count:');
disp(sum(sum(ycountrec)));

fprintf('(x,y)count eval:');
disp(sum(sum(xycounteval)));
fprintf('( x )count eval:');
disp(sum(sum(xcounteval)));
fprintf('( y )count eval:');
disp(sum(sum(ycounteval)));

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% CPLexOut = {round(Period*24*60/Interval),5};


for act = 1 :  round(Period*24*60/Interval)
    
    fprintf('\nTime from Start: ');
    disp(act);
    % change of environnement sense from ReadOption = 1 to ReadOption =
    % answer in order to change value outputs if we consider noises or no
    [P_pv, E_load, cost] = EnvironmentSense(answer, P_pv, E_load, cost, PVInput, LoadInput, Forecast, CostInput, StartTime, act, NumOut, Interval);
    ControllerBase2; %Default
    GurobiOut(act) = sol;
    
    if act == 1
        options = sdpsettings('solver','gurobi','verbose',0,'showprogress',0, 'saveyalmipmodel', 1, 'savesolveroutput',1);
	options.gurobi.TimeLimit = 2;
    end
    
end

CostRec = CostRec(1,StartTime,Period,Interval,CostInput);

%% Plot figures

PlotAll;

%% End Test
% diary off;

yalmip('clear');
TestName = strcat(TestName, '.mat');
save(TestName);
cd('..');

PeriodStart = 1;
PeriodEnd = Period*24*60/Interval;
A = [mu, sum(P_act(PeriodStart:PeriodEnd,2)), CostCalc(PeriodStart,PeriodEnd,P_act(:,2),CostRec(:))/100 , ...
    mean(P_act(:,6)), mean(P_act(:,7)), mean(P_act(:,8)), P_act(act,9), max(abs(P_act(:,6)-P_act(:,7))),CostOn, BattCap, rho, gamma] ;
xlswrite('OutputCompilation.csv', A, 'Data', num2str(Run+3)); %Run + 3 default...
clear A

%   P_out(1,96,:) %to view the optimisation results of a certain time step
