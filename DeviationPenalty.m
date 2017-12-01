function Penalty = DeviationPenalty(gamma, rho, LoadPrev, LoadNow, PVPrev, PVNow, DecisionPrev, DecisionNow, NumOut)

%%% when it is called (BEFORE)
% DeviationPenalty(gamma, rho, P_out(2:NumOut,6,act-1), E_load(1:NumOut-1), P_out(2:NumOut, 7,act-1), P_pv(1:NumOut-1), ...
%         P_out(2:NumOut,4,act-1), (P_battC(1:NumOut-1)-P_battD(1:NumOut-1)), NumOut))

%%% when it is called (NOW)
% DeviationPenalty(gamma, rho, P_out(2:NumOut,6,act-1), LoadInput(act : act + NumOut - 2), P_out(2:NumOut, 7,act-1), P_pv(1:NumOut-1), ...
%     P_out(2:NumOut,4,act-1), (P_battC(1:NumOut-1)-P_battD(1:NumOut-1)), NumOut));




% Penalty = abs( DecisionNow - DecisionPrev ) ./ max( gamma*abs(LoadNow - LoadPrev) , rho );
% But Yalmip doesn't take it...
Penalty = 0;

for loop = 1: NumOut - 1
    
    Penalty = Penalty + abs( DecisionNow(loop) - DecisionPrev(loop) );
    
end

Penalty = Penalty/(NumOut-1);

Penalty = (1/rho) * Penalty/(gamma*sum(abs(LoadNow - LoadPrev) + abs(PVNow - PVPrev)) + 1);

fprintf('\n****Penalty****\n')
Penalty
fprintf('***************\n')

clear loop;

end