function [ N_OUT ] = file_filler( v,N_IN,res,Vars,M_IN,y,m,d,Forecast_Hour,Run_Time)
%UNTITLED3 Summary of this function goes here
%   Detailed explanation goes here
    if v == 1
        N_OUT = fill_in_missing_file(v,res,0);

    elseif v == length(Vars)   
        M_IN = fill_in_missing_file(v,res, N_IN);
        [a, ~] = size(N_IN);
        [c, ~] = size(M_IN);
        result = a==c;
        if ~result
            [N_IN,M_IN] = compare_rows(a,c,N_IN,M_IN);
        end;                        
        [x, ~] = size(N_IN);
        P = [ones(x,1) * y,ones(x,1) * m,ones(x,1) * d,ones(x,1) * Forecast_Hour,ones(x,1) * Run_Time];
        N_OUT = [P,N_IN,M_IN];

    else
         M_IN = fill_in_missing_file(v,res, N_IN);
        [a, ~] = size(N_IN);
        [c, ~] = size(M_IN);
        result = a==c;
        if ~result
            [N_IN,M_IN] = compare_rows(a,c,N_IN,M_IN);
        end;
        N_OUT = [N_IN,M_IN];

    end;

end

