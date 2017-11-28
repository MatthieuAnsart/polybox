
function [P_pv E_load cost] = EnvironmentSense(ReadOption, P_pv, E_load, cost, PVInput, LoadInput, CostInput, StartTime, act, NumOut, Interval)

for env = 1 : NumOut %altering start date / period should be done here
    
    P_pv(env) = PVInput(act + env - 2 + StartTime);
    
    if ReadOption == 1 % Perfect Prediction with two Tiered Pricing
        E_load(env) = LoadInput(act + env - 2 + StartTime);
    else % noisy  forecast
        E_load(env) = Forecast (act + StartTime - 1,env);
    end
    
    if floor((act + env - 2 + StartTime) / (24*60/Interval)) == (act + env - 2 + StartTime) / (24*60/Interval)   %to be altered for dynamic MPC Horizons
        cost(env) = CostInput(act + env - 2 + StartTime - (24*60/Interval)*(floor((act + env - 2 + StartTime)/(24*60/Interval)) - 1));
    else
        cost(env) = CostInput(act + env - 2 + StartTime - (24*60/Interval)*floor((act + env - 2 + StartTime)/(24*60/Interval)));
    end
end

end
