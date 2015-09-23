%%
%TITLE: NWP DAWS ADDA Degribber
%DESCRIPTION:
%
%A function used to simplify the master degribbing code. This functions
%saves the matrix N as a .mat file (as determined to be the superior format
%of saving) to the desired directory. the extraneous file are also deleted
%to conserve disk space. As a final step this function also zips the .mat
%file create to further conserve disk space. Additionally the commented
%lines have been left incase the old .csv saving structure is desired in
%the future. The return value 'done' is a boolean value intended for error
%reports, it's function is to better indicate the location of error in the
%degribbing code being as extensive and convoluted as it is, and how that
%matlab's parfor function has poor error reporting.
%
%AUTHORS: Shane Fast
%
%UPDATE: 15/07/2014
%           -Included proper support for the 10km file cleaning that was
%           lacking previously for NWP_DAWS_ADDA_Degribber_1_4.
%           -test activated the delete line
%           -File zipping has been commented out since .mat files are small
%           enough, this action should save on some processing time.

%%
function [ done ] = Clean_files(y,m,d,Run_Time,Forecast_Hour,y_adj,m_adj,d_adj,Variables,N,resolution)
done = 0;
% try
    if resolution == 2.5
                
        delete(sprintf('C:/Users/Admin/Desktop/NWP/2.5km_resolution/%4d%02d%02d/%02d/%03d/*.csv',y,m,d,Run_Time,Forecast_Hour));
                %Deletes only the csv files created by the degribbing
                
        delete(sprintf('C:/Users/Admin/Desktop/NWP/2.5km_resolution/%4d%02d%02d/%02d/%03d/*.txt',y,m,d,Run_Time,Forecast_Hour));
                %Deletes only the text files created by the degribbing
                
        filename = sprintf('C:/Users/Admin/Desktop/NWP/2.5km_resolution/%4d%02d%02d/%02d/%03d/CMC_hrdps_west_ALL_ps2.5km_%4d%02d%02d%02d_P%03d-00.mat',y,m,d,Run_Time,Forecast_Hour,y_adj,m_adj,d_adj,Run_Time,Forecast_Hour);
        save(filename,'N');
        
        done = 1;           %sucessful file clean up.
    elseif resolution == 10

        delete(sprintf('C:/Users/Admin/Desktop/NWP/10km_resolution/%4d%02d%02d/%02d/%03d/*.csv',y,m,d,Run_Time,Forecast_Hour));     
                %Deletes only the csv files created by the degribbing
                
        delete(sprintf('C:/Users/Admin/Desktop/NWP/10km_resolution/%4d%02d%02d/%02d/%03d/*.txt',y,m,d,Run_Time,Forecast_Hour));
                %Deletes only the text files created by the degribbing
                
        filename = sprintf('C:/Users/Admin/Desktop/NWP/10km_resolution/%4d%02d%02d/%02d/%03d/CMC_hrdps_west_ALL_ps10km_%4d%02d%02d%02d_P%03d-00.mat',y,m,d,Run_Time,Forecast_Hour,y_adj,m_adj,d_adj,Run_Time,Forecast_Hour);
        
        save(filename,'N');
        done = 1;           %sucessful file clean up.
    else
        done = 0;
    end;
% catch
%     %done = 0;           %failed file clean up, additional lines required for proper error reporting.
%     matlabpool close;
%     quit;
% end;
end