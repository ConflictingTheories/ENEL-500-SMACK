function [ OUT ] = fill_in_missing_file(v,res,N_IN)
%UNTITLED2 Summary of this function goes here
%   Detailed explanation goes here
    if v == 1
        a = 0;
        if res == 2.5
            c = 332225;   %Estimated number of expected rows for 2.5km resolution (unthinned).
        else
            c = 770440;   %estimated number of expected rows for 10km resolution (unthinned).
        end;    
        [OUT,~] = compare_rows(a,c,0,0,res);                            
    else
        [a, ~] = size(N_IN);
        c = 0;
        [~,OUT] = compare_rows(a,c,0,0,res);
    end;
end

