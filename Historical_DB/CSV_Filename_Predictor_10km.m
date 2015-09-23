%%
%TITLE: CSV_Filename_Predictor_10km (FUNCTION)
%DESCRIPTION:
%
%CSV_Filename_Predictor_10km Predicts the name of the CSV file produced by 
%the degribbing process. 10km resolution has 9 different 
%variable types selected for download each type may or may not have
%multiple files associated with it. For example, wind speed (designated as
%'WIND') has 4 GRIB2 files associated with it for each forecast horizon.
%Each one is associated with a different height, however the degribber
%cannot make that distinction. When consecutive files of the same variable
%type follow the first through the degribbing software, the degribber saves
%all of the same variable type to the same file therefore overwriting all
%of the previous data of the same type lossing vast amounts of data. To
%prevent this issue data gets read by matlab before the degribber has an
%oppurtunity to overwrite any data. 
%
%The other issue presented by the degribbing software is attempting to
%predict what the name of the output csv file will be. This function along
%with its 2.5km counterpart allow the degribed files to be read and properly
%sorted and stored into their respective files.
%
%The additional feature of this function is the recognition of the first
%and last variable to be processed for a given forecast horizon. This tells
%the main degribbing script when to concatenate normally, not to
%concatenate, and when to complete the matrix by include the concatenation
%of columns including the time stamp.
%
    %ADJUST PATHING AS PER COMPUTER USED, This function is currently
    %designated to function on 'C:/Users/Shane Fast/Desktop/NSERC/'. Please
    %adjust accordingly.               
%
%AUTHORS: Shane Fast
%
%VERSION: 1.0
%UPDATE NOTES
%           -Created to simplify the main degribbing script and to allow
%           reading and debugging to become easier
%
%VERSION: 1.1
%UPDATE NOTES
%           -Included last_var and first_var output arguments as triggers
%           for concatenation in NWP_DAWS_ADDA_Degribber.

%%

function [CSVfilename] = CSV_Filename_Predictor_10km(v,y,m,d,Run_Time,Forecast_Hour,index)
    if v < 2
        CSVfilename = sprintf('C:/Users/Admin/Desktop/NWP/10km_resolution/%4d%02d%02d/%02d/%03d/WIND_%s.csv',y,m,d,Run_Time,Forecast_Hour,index);     
    elseif v < 5
        CSVfilename = sprintf('C:/Users/Admin/Desktop/NWP/10km_resolution/%4d%02d%02d/%02d/%03d/WIND_%s.csv',y,m,d,Run_Time,Forecast_Hour,index);
    elseif v<9
        CSVfilename = sprintf('C:/Users/Admin/Desktop/NWP/10km_resolution/%4d%02d%02d/%02d/%03d/WDIR_%s.csv',y,m,d,Run_Time,Forecast_Hour,index);
    elseif v<13
        CSVfilename = sprintf('C:/Users/Admin/Desktop/NWP/10km_resolution/%4d%02d%02d/%02d/%03d/UGRD_%s.csv',y,m,d,Run_Time,Forecast_Hour,index);
    elseif v<17
        CSVfilename = sprintf('C:/Users/Admin/Desktop/NWP/10km_resolution/%4d%02d%02d/%02d/%03d/VGRD_%s.csv',y,m,d,Run_Time,Forecast_Hour,index);
    elseif v<18
        CSVfilename = sprintf('C:/Users/Admin/Desktop/NWP/10km_resolution/%4d%02d%02d/%02d/%03d/TMP_%s.csv',y,m,d,Run_Time,Forecast_Hour,index);
    elseif v<19
        CSVfilename = sprintf('C:/Users/Admin/Desktop/NWP/10km_resolution/%4d%02d%02d/%02d/%03d/SPFH_%s.csv',y,m,d,Run_Time,Forecast_Hour,index);
    elseif v<20
        CSVfilename = sprintf('C:/Users/Admin/Desktop/NWP/10km_resolution/%4d%02d%02d/%02d/%03d/PRES_%s.csv',y,m,d,Run_Time,Forecast_Hour,index);
    elseif v<21
        CSVfilename = sprintf('C:/Users/Admin/Desktop/NWP/10km_resolution/%4d%02d%02d/%02d/%03d/TCDC_%s.csv',y,m,d,Run_Time,Forecast_Hour,index);   
    else
        CSVfilename = sprintf('C:/Users/Admin/Desktop/NWP/10km_resolution/%4d%02d%02d/%02d/%03d/NSWRS_%s.csv',y,m,d,Run_Time,Forecast_Hour,index);
    end;

end

