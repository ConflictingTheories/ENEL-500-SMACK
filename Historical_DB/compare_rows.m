%%
%TITLE: compare_rows
%DESCRIPTION:
%               This function midigates the unlikely error that an incoming
%               file from environment Canada is incomplete. A simple size
%               comparison checks for this error then bypasses this section
%               if all is normal. If there is a size mismatch in the number
%               of degribbed rows for a given file, then this section of
%               code fills in the gaps with 'NaN' to allow for proper
%               concatenation, and so that the whole process can be
%               completed without interuption. Again the probability of
%               such an error is small and has only occured a small number
%               of times. It stands to perhaps occur 1/5000 files recieved
%               from environment Canada
%
%AUTHORS: Shane Fast
%
%NOTES:
%       -Change pathing in quotes below to fit path of used computer

%%
function[N_out,M_out] = compare_rows(a,c,N_in,M_in,res)
    if a>c    
        T =M_in;
        if M_in == 0
            T = ones(a,1)*NaN;
        else
            T(c+1:a) = NaN;
        end;
        M_out = T;
        N_out = N_in;
    elseif c>a
        if N_in == 0
            if res == 2.5
                N_in = csvread('C:/Users/Admin/Desktop/NWP/2point5km_resoulution_generic_locations.csv',1,0);
            else
                N_in = csvread('C:/Users/Admin/Desktop/NWP/10km_resoulution_generic_locations.csv',1,0);
            end;
            T = N_in;
            T(:,5) = NaN;
            N_out = T;
        else
            T = N_in;
            T(a+1:c) = NaN;
            N_out = T;
        end;
        M_out = M_in;
    end;
end

