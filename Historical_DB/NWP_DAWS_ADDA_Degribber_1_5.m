%%
%TITLE: NWP DAWS ADDA Degribber
%DESCRIPTION:
%               This application downloads the solar and wind related data 
%               for Alberta then proceeds to Degrib and archive the data.
%               The data is NWP data, which is intended to be archived and
%               have inquires performed to predict future forecast horizons
%               and thusly the power derived from harvesting such sources.
%               Will currently run one hour after downloading has begun.
%
%AUTHORS: Hamid Shaker, Hamed Chitsaz, Shane Fast
%
%VERSION: 1.0
%UPDATE NOTES:
%               -Added degribbing capabilities to 2.5km resolution
%               -Added data thinning for 2.5km resolution (Alberta and part
%                of BC).
%               -Applied a switch-case to handle a potential parfor
%               (2.5km).
%               -Note that switch-case is extensively expanded as a setup
%                for pipelined loops to speed up processing.
%VERSION: 1.1
%UPDATE NOTES:
%               -Added degribbing capabilities to 10km resolution
%               -Added data thinning for 10km resolution (Alberta and part
%                of BC).
%               -Applied a switch-case to handle a potential parfor (2.5km)
%               -added a quit feature to exit Matlab unpon completion.
%               -Created a separation between downloading and degribbing/
%                Archiving to speed up the process and to midigate the 
%                probability of connection failure (the less time this
%                application spends online the better).
%
%VERSION: 1.2
%UPDATE NOTES:
%               -Created this file to exclusively degrib and create CSV
%                files since CSV's can be directly captured and archived
%               -added additional columns into CSV files to allow for 
%               easier linking within the archive. The column added were:
%               year, month, day, forcast hour, and run time.
%               -created a reference to a date adjustment to handle date
%               overlapping.
%
%VERSION: 1.3
%UPDATE NOTES:
%               -created a function to handle the specific degribbed file
%               name prediction.
%               -Data thinning is now performed previous to the
%               concatenation of data. This action should increase speed of
%               the degribbing task.
%
%VERSION: 1.4
%UPDATE NOTES:
%               -Changed the files name to better suit its function.
%               -After extensive testing, Data thinning has been reset to
%               perform after concatenation.
%               -data will now me saved as .mat to reduce processing time.
%
%VERSION: 1.5
%UPDATE NOTES:
%               -Degribber now compares size of matricies before
%               concatenation, this should prevent this program from
%               attempting to perform concatenation of matricies of
%               different sizes.
%               -for mismatched matricies, the one with fewer rows will
%               fill to match by filling remaining rows with 'NaN'
%               -To reduce the visible lines of code for ease of reading
%               and review, the code assigned to perform comparisons on
%               matricies has been deligated to the function 'compare_rows'
%               -Removed all unused variables with the '~' symbol
%               indicating to Matlab to ignore those extranous outputs.
%               This should slightly decrease run time and allow for more
%               easier testing and debugging.
%               -created a resolution variable to support the difference in
%               the 'Clean_files' function's dealings with 2.5km resolution
%               vs 10km resolution.
%               -degribber now handles the allocation of missing files and
%               directories by assigning all missing data completed
%               matricies filled with NaN while maintaining the standard
%               locations known for incoming data.


%%
clear all
clc
tic

[y_end,m_end,d_end,~,~,~]=datevec(date);
diary (sprintf('C:/Users/Admin/Desktop/NWP/runtime_logs/degribbing/Degrib_%4d%02d%02d',y_end,m_end,d_end))
counter = 0;



try
matlabpool open 12;
parfor i = 0:11
%    Input for testing specific days    
%    y = 2014;
%    m = 7;
%    d = 17;

%    Generic current day for running live degribber
     [y,m,d,~,~,~]=datevec(date);
       
     switch i
%%        
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%CASE #0 - 2.5km resolution, run time 6h, forecast horizons 0h-21h
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

        case 0
            resolution_0 = 2.5;
            Forecast_Horizon_0=21;
            Variables_0={'WIND_TGL_10','WIND_TGL_40','WIND_TGL_80','WIND_TGL_120',...
                    'WDIR_TGL_10','WDIR_TGL_40','WDIR_TGL_80','WDIR_TGL_120',...
                    'UGRD_TGL_10','UGRD_TGL_40','UGRD_TGL_80','UGRD_TGL_120',...
                    'VGRD_TGL_10','VGRD_TGL_40','VGRD_TGL_80','VGRD_TGL_120',...
                    'RH_TGL_2','RH_TGL_40','RH_TGL_120',...
                    'TMP_TGL_2','TMP_TGL_40','TMP_TGL_80','TMP_TGL_120'...
                    'PRES_SFC_0','TCDC_SFC_0','DSWRF_NTAT_0','DSWRF_SFC_0','DEN_TGL_80'};
            
            Run_Time_0 = 6;
            Foldername2_0=sprintf('%02d',Run_Time_0);
            ParentFolder_0=sprintf('2.5km_resolution/%4d%02d%02d',y,m,d);
            cd(ParentFolder_0);   
            if exist(Foldername2_0,'dir') == 7
                cd(Foldername2_0);
            else
                mkdir(Foldername2_0)
                cd(Foldername2_0);
            end;
            
            %Intializing Cells to create a workspace for the parallel for loop
            index_0 = cell(1,Forecast_Horizon_0+1);
            Foldername3_0 = cell(1,Forecast_Horizon_0+1);
            CSVfilenames_0 = cell(1,Forecast_Horizon_0+1);
 
            for Forecast_Hour_0=0:Forecast_Horizon_0
                
                N_0 = cell(1,Forecast_Horizon_0+1);
                M_0 = cell(1,Forecast_Horizon_0+1);
                P_0 = cell(1,Forecast_Horizon_0+1);

                addpath('C:/Users/Admin/Desktop/NWP');
                [y_0,m_0,d_0,h_0] = Date_Adjustment(y,m,d,Run_Time_0,Forecast_Hour_0);
               
                index_0{Forecast_Hour_0+1} = sprintf('%02d%02d%02d00',m_0,d_0,h_0);
                
                Foldername3_0{Forecast_Hour_0+1}=sprintf('%03d',Forecast_Hour_0);
                if exist(Foldername3_0{Forecast_Hour_0+1},'dir') == 7
                    cd(Foldername3_0{Forecast_Hour_0+1});
                else
                    mkdir(Foldername3_0{Forecast_Hour_0+1})
                    cd(Foldername3_0{Forecast_Hour_0+1});
                end;

                for v_0=1:length(Variables_0)
                    if exist(sprintf('C:/Users/Admin/Desktop/NWP/2.5km_resolution/%4d%02d%02d/%02d/%03d/CMC_hrdps_west_%s_ps2.5km_%4d%02d%02d%02d_P%03d-00.grib2',y,m,d,Run_Time_0,Forecast_Hour_0,Variables_0{v_0},y,m,d,Run_Time_0,Forecast_Hour_0),'file') == 2

                        commandInstruction_0 = strcat('"C:\Users\Admin/Desktop/NWP/degrib"', sprintf(' "C:/Users/Admin/Desktop/NWP/2.5km_resolution/%4d%02d%02d/%02d/%03d/CMC_hrdps_west_%s_ps2.5km_%4d%02d%02d%02d_P%03d-00.grib2" -C -msg all -Csv',y,m,d,Run_Time_0,Forecast_Hour_0,Variables_0{v_0},y,m,d,Run_Time_0,Forecast_Hour_0));
                        system(commandInstruction_0);

                        [CSVfilename_0] = CSV_Filename_Predictor_2point5km(v_0,y,m,d,Run_Time_0,Forecast_Hour_0,index_0{Forecast_Hour_0+1});
                        CSVfilenames_0{Forecast_Hour_0+1} = cellstr(CSVfilename_0);
                        addpath('C:/Users/Admin/Desktop/NWP');

                        if v_0 == 1
                            N_0{1,Forecast_Hour_0+1} = csvread(char(CSVfilenames_0{Forecast_Hour_0+1}),1,0);    

                        elseif v_0 == length(Variables_0)
                            M_0{Forecast_Hour_0+1} = csvread(char(CSVfilenames_0{Forecast_Hour_0+1}),1,4);
                            [a_0, ~] = size(N_0{Forecast_Hour_0+1});
                            [c_0, ~] = size(M_0{Forecast_Hour_0+1});
                            result_0 = a_0==c_0;
                            if ~result_0
                                [N_0{Forecast_Hour_0+1},M_0{Forecast_Hour_0+1}] = compare_rows(a_0,c_0,N_0{Forecast_Hour_0+1},M_0{Forecast_Hour_0+1});
                            end;                        
                            [x_0, ~] = size(N_0{Forecast_Hour_0+1});
                            P_0{Forecast_Hour_0+1} = [ones(x_0,1) * y,ones(x_0,1) * m,ones(x_0,1) * d,ones(x_0,1) * Forecast_Hour_0,ones(x_0,1) * Run_Time_0];
                            N_0{Forecast_Hour_0+1} = [P_0{Forecast_Hour_0+1},N_0{Forecast_Hour_0+1},M_0{Forecast_Hour_0+1}];

                        else    
                            M_0{Forecast_Hour_0+1} = csvread(char(CSVfilenames_0{Forecast_Hour_0+1}),1,4);
                            [a_0, ~] = size(N_0{Forecast_Hour_0+1});
                            [c_0, ~] = size(M_0{Forecast_Hour_0+1});
                            result_0 = a_0==c_0;
                            if ~result_0
                                [N_0{Forecast_Hour_0+1},M_0{Forecast_Hour_0+1}] = compare_rows(a_0,c_0,N_0{Forecast_Hour_0+1},M_0{Forecast_Hour_0+1});
                            end;
                            N_0{Forecast_Hour_0+1} = [N_0{Forecast_Hour_0+1},M_0{Forecast_Hour_0+1}];

                        end; 
                    else
                       N_0{Forecast_Hour_0+1} = file_filler(v_0,N_0{Forecast_Hour_0+1},resolution_0,Variables_0,M_0{Forecast_Hour_0+1},y,m,d,Forecast_Hour_0,Run_Time_0);      
                    end;
                    counter = counter + 1;
                end;
                    N_0{1,Forecast_Hour_0+1} = Data_Thinner(N_0{1,Forecast_Hour_0+1},1);
                    [ ~ ] = Clean_files(y,m,d,Run_Time_0,Forecast_Hour_0,y_0,m_0,d_0,Variables_0,N_0{Forecast_Hour_0+1},resolution_0);
                cd ../
            end;
            cd ../../..
          
%%             
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%CASE #1 - 2.5km resolution, run time 6h, forecast horizons 22h-42h
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

        case 1
            resolution_1 = 2.5;
            Forecast_Horizon_1=42;
            Variables_1={'WIND_TGL_10','WIND_TGL_40','WIND_TGL_80','WIND_TGL_120',...
                    'WDIR_TGL_10','WDIR_TGL_40','WDIR_TGL_80','WDIR_TGL_120',...
                    'UGRD_TGL_10','UGRD_TGL_40','UGRD_TGL_80','UGRD_TGL_120',...
                    'VGRD_TGL_10','VGRD_TGL_40','VGRD_TGL_80','VGRD_TGL_120',...
                    'RH_TGL_2','RH_TGL_40','RH_TGL_120',...
                    'TMP_TGL_2','TMP_TGL_40','TMP_TGL_80','TMP_TGL_120'...
                    'PRES_SFC_0','TCDC_SFC_0','DSWRF_NTAT_0','DSWRF_SFC_0','DEN_TGL_80'};
            
            Run_Time_1 = 6;
            Foldername2_1=sprintf('%02d',Run_Time_1);
            ParentFolder_1=sprintf('2.5km_resolution/%4d%02d%02d',y,m,d);
            cd(ParentFolder_1);
    
            if exist(Foldername2_1,'dir') == 7
                cd(Foldername2_1);
            else
                mkdir(Foldername2_1)
                cd(Foldername2_1);
            end;
     
            %Intializing Cells to create a workspace for the parallel for loop
            index_1 = cell(1,Forecast_Horizon_1+1);
            Foldername3_1 = cell(1,Forecast_Horizon_1+1);
            CSVfilenames_1 = cell(1,Forecast_Horizon_1+1);
 
            for Forecast_Hour_1=22:Forecast_Horizon_1
                
                N_1 = cell(1,Forecast_Horizon_1+1);
                M_1 = cell(1,Forecast_Horizon_1+1);
                P_1 = cell(1,Forecast_Horizon_1+1);

                addpath('C:/Users/Admin/Desktop/NWP');
                [y_1,m_1,d_1,h_1] = Date_Adjustment(y,m,d,Run_Time_1,Forecast_Hour_1);
               
                index_1{Forecast_Hour_1+1} = sprintf('%02d%02d%02d00',m_1,d_1,h_1);
                Foldername3_1{Forecast_Hour_1+1}=sprintf('%03d',Forecast_Hour_1);
                if exist(Foldername3_1{Forecast_Hour_1+1},'dir') == 7
                    cd(Foldername3_1{Forecast_Hour_1+1});
                else
                    mkdir(Foldername3_1{Forecast_Hour_1+1})
                    cd(Foldername3_1{Forecast_Hour_1+1});
                end;

                for v_1=1:length(Variables_1)
                    if exist(sprintf('C:/Users/Admin/Desktop/NWP/2.5km_resolution/%4d%02d%02d/%02d/%03d/CMC_hrdps_west_%s_ps2.5km_%4d%02d%02d%02d_P%03d-00.grib2',y,m,d,Run_Time_1,Forecast_Hour_1,Variables_1{v_1},y,m,d,Run_Time_1,Forecast_Hour_1),'file') == 2

                        commandInstruction_1 = strcat('"C:\Users\Admin/Desktop/NWP/degrib"', sprintf(' "C:/Users/Admin/Desktop/NWP/2.5km_resolution/%4d%02d%02d/%02d/%03d/CMC_hrdps_west_%s_ps2.5km_%4d%02d%02d%02d_P%03d-00.grib2" -C -msg all -Csv',y,m,d,Run_Time_1,Forecast_Hour_1,Variables_1{v_1},y,m,d,Run_Time_1,Forecast_Hour_1));
                        system(commandInstruction_1);

                        [CSVfilename_1] = CSV_Filename_Predictor_2point5km(v_1,y,m,d,Run_Time_1,Forecast_Hour_1,index_1{Forecast_Hour_1+1});
                        CSVfilenames_1{Forecast_Hour_1+1} = cellstr(CSVfilename_1);
                        addpath('C:/Users/Admin/Desktop/NWP');

                        if v_1==1
                            N_1{1,Forecast_Hour_1+1} = csvread(char(CSVfilenames_1{Forecast_Hour_1+1}),1,0);

                        elseif v_1==length(Variables_1)
                            M_1{Forecast_Hour_1+1} = csvread(char(CSVfilenames_1{Forecast_Hour_1+1}),1,4);
                            [a_1, ~] = size(N_1{Forecast_Hour_1+1});
                            [c_1, ~] = size(M_1{Forecast_Hour_1+1});
                            result_1 = a_1==c_1;
                            if ~result_1
                                [N_1{Forecast_Hour_1+1},M_1{Forecast_Hour_1+1}] = compare_rows(a_1,c_1,N_1{Forecast_Hour_1+1},M_1{Forecast_Hour_1+1});
                            end;
                            [x_1, ~] = size(N_1{Forecast_Hour_1+1});
                            P_1{Forecast_Hour_1+1} = [ones(x_1,1) * y,ones(x_1,1) * m,ones(x_1,1) * d,ones(x_1,1) * Forecast_Hour_1,ones(x_1,1) * Run_Time_1];
                            N_1{Forecast_Hour_1+1} = [P_1{Forecast_Hour_1+1},N_1{Forecast_Hour_1+1},M_1{1,Forecast_Hour_1+1}];

                        else    
                            M_1{Forecast_Hour_1+1} = csvread(char(CSVfilenames_1{Forecast_Hour_1+1}),1,4);
                            [a_1, ~] = size(N_1{Forecast_Hour_1+1});
                            [c_1, ~] = size(M_1{Forecast_Hour_1+1});
                            result_1 = a_1==c_1;
                            if ~result_1
                                [N_1{Forecast_Hour_1+1},M_1{Forecast_Hour_1+1}] = compare_rows(a_1,c_1,N_1{Forecast_Hour_1+1},M_1{Forecast_Hour_1+1});
                            end;
                            N_1{Forecast_Hour_1+1} = [N_1{Forecast_Hour_1+1},M_1{Forecast_Hour_1+1}];
                        end; 
                    else
                       N_1{Forecast_Hour_1+1} = file_filler(v_1,N_1{Forecast_Hour_1+1},resolution_1,Variables_1,M_1{Forecast_Hour_1+1},y,m,d,Forecast_Hour_1,Run_Time_1);      
                    end;
                    counter = counter + 1;
                end;
                    N_1{1,Forecast_Hour_1+1} = Data_Thinner(N_1{1,Forecast_Hour_1+1},1);
                    [ ~ ] = Clean_files(y,m,d,Run_Time_1,Forecast_Hour_1,y_1,m_1,d_1,Variables_1,N_1{Forecast_Hour_1+1},resolution_1);
                cd ../
            end;
            cd ../../..
            
%%            
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%CASE #2 - 2.5km resolution, run time 18h, forecast horizons 0h-21h
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

        case 2
            resolution_2 = 2.5;
            Forecast_Horizon_2=21;
            Variables_2={'WIND_TGL_10','WIND_TGL_40','WIND_TGL_80','WIND_TGL_120',...
                    'WDIR_TGL_10','WDIR_TGL_40','WDIR_TGL_80','WDIR_TGL_120',...
                    'UGRD_TGL_10','UGRD_TGL_40','UGRD_TGL_80','UGRD_TGL_120',...
                    'VGRD_TGL_10','VGRD_TGL_40','VGRD_TGL_80','VGRD_TGL_120',...
                    'RH_TGL_2','RH_TGL_40','RH_TGL_120',...
                    'TMP_TGL_2','TMP_TGL_40','TMP_TGL_80','TMP_TGL_120'...
                    'PRES_SFC_0','TCDC_SFC_0','DSWRF_NTAT_0','DSWRF_SFC_0','DEN_TGL_80'};
            
            Run_Time_2 = 18;
            Foldername2_2=sprintf('%02d',Run_Time_2);
            ParentFolder_2=sprintf('2.5km_resolution/%4d%02d%02d',y,m,d);
            cd(ParentFolder_2);   
            if exist(Foldername2_2,'dir') == 7
                cd(Foldername2_2);
            else
                mkdir(Foldername2_2)
                cd(Foldername2_2);
            end;
            
            %Intializing Cells to create a workspace for the parallel for loop
            index_2 = cell(1,Forecast_Horizon_2+1);
            Foldername3_2 = cell(1,Forecast_Horizon_2+1);
            CSVfilenames_2 = cell(1,Forecast_Horizon_2+1);
 
            for Forecast_Hour_2=0:Forecast_Horizon_2
                
                N_2 = cell(1,Forecast_Horizon_2+1);
                M_2 = cell(1,Forecast_Horizon_2+1);
                P_2 = cell(1,Forecast_Horizon_2+1);

                addpath('C:/Users/Admin/Desktop/NWP');
                [y_2,m_2,d_2,h_2] = Date_Adjustment(y,m,d,Run_Time_2,Forecast_Hour_2);
               
                index_2{Forecast_Hour_2+1} = sprintf('%02d%02d%02d00',m_2,d_2,h_2);
                Foldername3_2{Forecast_Hour_2+1}=sprintf('%03d',Forecast_Hour_2);
                if exist(Foldername3_2{Forecast_Hour_2+1},'dir') == 7
                    cd(Foldername3_2{Forecast_Hour_2+1});
                else
                    mkdir(Foldername3_2{Forecast_Hour_2+1})
                    cd(Foldername3_2{Forecast_Hour_2+1});
                end;

                for v_2=1:length(Variables_2)
                    if exist(sprintf('C:/Users/Admin/Desktop/NWP/2.5km_resolution/%4d%02d%02d/%02d/%03d/CMC_hrdps_west_%s_ps2.5km_%4d%02d%02d%02d_P%03d-00.grib2',y,m,d,Run_Time_2,Forecast_Hour_2,Variables_2{v_2},y,m,d,Run_Time_2,Forecast_Hour_2),'file') == 2

                        commandInstruction_2 = strcat('"C:\Users\Admin/Desktop/NWP/degrib"', sprintf(' "C:/Users/Admin/Desktop/NWP/2.5km_resolution/%4d%02d%02d/%02d/%03d/CMC_hrdps_west_%s_ps2.5km_%4d%02d%02d%02d_P%03d-00.grib2" -C -msg all -Csv',y,m,d,Run_Time_2,Forecast_Hour_2,Variables_2{v_2},y,m,d,Run_Time_2,Forecast_Hour_2));
                        system(commandInstruction_2);

                        [CSVfilename_2] = CSV_Filename_Predictor_2point5km(v_2,y,m,d,Run_Time_2,Forecast_Hour_2,index_2{Forecast_Hour_2+1});
                        CSVfilenames_2{Forecast_Hour_2+1} = cellstr(CSVfilename_2);
                        addpath('C:/Users/Admin/Desktop/NWP');

                        if v_2==1
                            N_2{1,Forecast_Hour_2+1} = csvread(char(CSVfilenames_2{Forecast_Hour_2+1}),1,0);

                        elseif v_2==length(Variables_2)
                            M_2{Forecast_Hour_2+1} = csvread(char(CSVfilenames_2{Forecast_Hour_2+1}),1,4);
                            [a_2, ~] = size(N_2{Forecast_Hour_2+1});
                            [c_2, ~] = size(M_2{Forecast_Hour_2+1});
                            result_2 = a_2==c_2;
                            if ~result_2
                                [N_2{Forecast_Hour_2+1},M_2{Forecast_Hour_2+1}] = compare_rows(a_2,c_2,N_2{Forecast_Hour_2+1},M_2{Forecast_Hour_2+1});
                            end;
                            [x_2, ~] = size(N_2{Forecast_Hour_2+1});
                            P_2{Forecast_Hour_2+1} = [ones(x_2,1) * y,ones(x_2,1) * m,ones(x_2,1) * d,ones(x_2,1) * Forecast_Hour_2,ones(x_2,1) * Run_Time_2];
                            N_2{Forecast_Hour_2+1} = [P_2{Forecast_Hour_2+1},N_2{Forecast_Hour_2+1},M_2{Forecast_Hour_2+1}];

                        else    
                            M_2{Forecast_Hour_2+1} = csvread(char(CSVfilenames_2{Forecast_Hour_2+1}),1,4);
                            [a_2, ~] = size(N_2{Forecast_Hour_2+1});
                            [c_2, ~] = size(M_2{Forecast_Hour_2+1});
                            result_2 = a_2==c_2;
                            if ~result_2
                                [N_2{Forecast_Hour_2+1},M_2{Forecast_Hour_2+1}] = compare_rows(a_2,c_2,N_2{Forecast_Hour_2+1},M_2{Forecast_Hour_2+1});
                            end;
                            N_2{Forecast_Hour_2+1} = [N_2{Forecast_Hour_2+1},M_2{Forecast_Hour_2+1}];
                        end;
                    else
                       N_2{Forecast_Hour_2+1} = file_filler(v_2,N_2{Forecast_Hour_2+1},resolution_2,Variables_2,M_2{Forecast_Hour_2+1},y,m,d,Forecast_Hour_2,Run_Time_2);      
                    end;
                    counter = counter + 1;
                end;
                    N_2{1,Forecast_Hour_2+1} = Data_Thinner(N_2{1,Forecast_Hour_2+1},1);
                    [ ~ ] = Clean_files(y,m,d,Run_Time_2,Forecast_Hour_2,y_2,m_2,d_2,Variables_2,N_2{Forecast_Hour_2+1},resolution_2);
                cd ../
            end;
            cd ../../..
            
%%                      
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%CASE #3 - 2.5km resolution, run time 18h, forecast horizons 22h-42h
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

        case 3
            resolution_3 = 2.5;
            Forecast_Horizon_3=42;
            Variables_3={'WIND_TGL_10','WIND_TGL_40','WIND_TGL_80','WIND_TGL_120',...
                    'WDIR_TGL_10','WDIR_TGL_40','WDIR_TGL_80','WDIR_TGL_120',...
                    'UGRD_TGL_10','UGRD_TGL_40','UGRD_TGL_80','UGRD_TGL_120',...
                    'VGRD_TGL_10','VGRD_TGL_40','VGRD_TGL_80','VGRD_TGL_120',...
                    'RH_TGL_2','RH_TGL_40','RH_TGL_120',...
                    'TMP_TGL_2','TMP_TGL_40','TMP_TGL_80','TMP_TGL_120'...
                    'PRES_SFC_0','TCDC_SFC_0','DSWRF_NTAT_0','DSWRF_SFC_0','DEN_TGL_80'};
            
            Run_Time_3 = 18;
            Foldername2_3=sprintf('%02d',Run_Time_3);
            ParentFolder_3=sprintf('2.5km_resolution/%4d%02d%02d',y,m,d);
            cd(ParentFolder_3);   
            if exist(Foldername2_3,'dir') == 7
                cd(Foldername2_3);
            else
                mkdir(Foldername2_3)
                cd(Foldername2_3);
            end;
            
            %Intializing Cells to create a workspace for the parallel for loop
            index_3 = cell(1,Forecast_Horizon_3+1);
            Foldername3_3 = cell(1,Forecast_Horizon_3+1);
            CSVfilenames_3 = cell(1,Forecast_Horizon_3+1);
 
            for Forecast_Hour_3=22:Forecast_Horizon_3
                
                N_3 = cell(1,Forecast_Horizon_3+1);
                M_3 = cell(1,Forecast_Horizon_3+1);
                P_3 = cell(1,Forecast_Horizon_3+1);

                addpath('C:/Users/Admin/Desktop/NWP');
                [y_3,m_3,d_3,h_3] = Date_Adjustment(y,m,d,Run_Time_3,Forecast_Hour_3);
               
                index_3{Forecast_Hour_3+1} = sprintf('%02d%02d%02d00',m_3,d_3,h_3);
                Foldername3_3{Forecast_Hour_3+1}=sprintf('%03d',Forecast_Hour_3);
                if exist(Foldername3_3{Forecast_Hour_3+1},'dir') == 7
                    cd(Foldername3_3{Forecast_Hour_3+1});
                else
                    mkdir(Foldername3_3{Forecast_Hour_3+1})
                    cd(Foldername3_3{Forecast_Hour_3+1});
                end;

                for v_3=1:length(Variables_3)
                    if exist(sprintf('C:/Users/Admin/Desktop/NWP/2.5km_resolution/%4d%02d%02d/%02d/%03d/CMC_hrdps_west_%s_ps2.5km_%4d%02d%02d%02d_P%03d-00.grib2',y,m,d,Run_Time_3,Forecast_Hour_3,Variables_3{v_3},y,m,d,Run_Time_3,Forecast_Hour_3),'file') == 2

                        commandInstruction_3 = strcat('"C:\Users\Admin/Desktop/NWP/degrib"', sprintf(' "C:/Users/Admin/Desktop/NWP/2.5km_resolution/%4d%02d%02d/%02d/%03d/CMC_hrdps_west_%s_ps2.5km_%4d%02d%02d%02d_P%03d-00.grib2" -C -msg all -Csv',y,m,d,Run_Time_3,Forecast_Hour_3,Variables_3{v_3},y,m,d,Run_Time_3,Forecast_Hour_3));
                        system(commandInstruction_3);

                        [CSVfilename_3] = CSV_Filename_Predictor_2point5km(v_3,y,m,d,Run_Time_3,Forecast_Hour_3,index_3{Forecast_Hour_3+1});
                        CSVfilenames_3{Forecast_Hour_3+1} = cellstr(CSVfilename_3);
                        addpath('C:/Users/Admin/Desktop/NWP');

                        if v_3==1
                            N_3{1,Forecast_Hour_3+1} = csvread(char(CSVfilenames_3{Forecast_Hour_3+1}),1,0);

                        elseif v_3==length(Variables_3)
                            M_3{Forecast_Hour_3+1} = csvread(char(CSVfilenames_3{Forecast_Hour_3+1}),1,4);
                            [a_3, ~] = size(N_3{Forecast_Hour_3+1});
                            [c_3, ~] = size(M_3{Forecast_Hour_3+1});
                            result_3 = a_3==c_3;
                            if ~result_3
                                [N_3{Forecast_Hour_3+1},M_3{Forecast_Hour_3+1}] = compare_rows(a_3,c_3,N_3{Forecast_Hour_3+1},M_3{Forecast_Hour_3+1});
                            end;
                            [x_3, ~] = size(N_3{Forecast_Hour_3+1});
                            P_3{Forecast_Hour_3+1} = [ones(x_3,1) * y,ones(x_3,1) * m,ones(x_3,1) * d,ones(x_3,1) * Forecast_Hour_3,ones(x_3,1) * Run_Time_3];
                            N_3{Forecast_Hour_3+1} = [P_3{Forecast_Hour_3+1},N_3{Forecast_Hour_3+1},M_3{Forecast_Hour_3+1}];

                        else    
                            M_3{Forecast_Hour_3+1} = csvread(char(CSVfilenames_3{Forecast_Hour_3+1}),1,4);
                            [a_3, ~] = size(N_3{Forecast_Hour_3+1});
                            [c_3, ~] = size(M_3{Forecast_Hour_3+1});
                            result_3 = a_3==c_3;
                            if ~result_3
                                [N_3{Forecast_Hour_3+1},M_3{Forecast_Hour_3+1}] = compare_rows(a_3,c_3,N_3{Forecast_Hour_3+1},M_3{Forecast_Hour_3+1});
                            end;
                            N_3{Forecast_Hour_3+1} = [N_3{Forecast_Hour_3+1},M_3{Forecast_Hour_3+1}];
                        end; 
                    else
                       N_3{Forecast_Hour_3+1} = file_filler(v_3,N_3{Forecast_Hour_3+1},resolution_3,Variables_3,M_3{Forecast_Hour_3+1},y,m,d,Forecast_Hour_3,Run_Time_3);      
                    end; 
                    counter = counter + 1;
                end;
                    N_3{1,Forecast_Hour_3+1} = Data_Thinner(N_3{1,Forecast_Hour_3+1},1);
                    [ ~ ] = Clean_files(y,m,d,Run_Time_3,Forecast_Hour_3,y_3,m_3,d_3,Variables_3,N_3{Forecast_Hour_3+1},resolution_3);
                cd ../
            end;
            cd ../../..            
                   
%%        
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%CASE #4 - 10km resolution, run time 0h, forecast horizons 0h-23h
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%    
        case 4
            resolution_4 = 10;
            Run_Time_4 = 0;
            Forecast_Horizon_4=23;
            Variables2_4={'WIND_TGL_10','WIND_TGL_40','WIND_TGL_80','WIND_TGL_120',...
                    'WDIR_TGL_10','WDIR_TGL_40','WDIR_TGL_80','WDIR_TGL_120',...
                    'UGRD_TGL_10','UGRD_TGL_40','UGRD_TGL_80','UGRD_TGL_120',...
                    'VGRD_TGL_10','VGRD_TGL_40','VGRD_TGL_80','VGRD_TGL_120',...
                    'TMP_TGL_2','SPFH_TGL_2','PRES_SFC_0','TCDC_SFC_0','NSWRS_SFC_0'}; 
            Foldername2_4=sprintf('%02d',Run_Time_4);
            ParentFolder_4=sprintf('10km_resolution/%4d%02d%02d',y,m,d);
            cd(ParentFolder_4);
            if exist(Foldername2_4,'dir') == 7
                cd(Foldername2_4);
            else
                mkdir(Foldername2_4)
                cd(Foldername2_4);
            end;

            %Intializing Cells to create a workspace for the parallel for loop
            index_4 = cell(1,Forecast_Horizon_4+1);
            Foldername3_4 = cell(1,Forecast_Horizon_4+1);
            CSVfilenames_4 = cell(1,Forecast_Horizon_4+1);
    
            for Forecast_Hour_4=0:3:Forecast_Horizon_4
                
                N_4 = cell(1,Forecast_Horizon_4+1);
                M_4 = cell(1,Forecast_Horizon_4+1);
                P_4 = cell(1,Forecast_Horizon_4+1);
                
                addpath('C:/Users/Admin/Desktop/NWP');
                [y_4,m_4,d_4,h_4] = Date_Adjustment(y,m,d,Run_Time_4,Forecast_Hour_4);
               
                index_4{Forecast_Hour_4+1} = sprintf('%02d%02d%02d00',m_4,d_4,h_4);
                
                Foldername3_4{Forecast_Hour_4+1}=sprintf('%03d',Forecast_Hour_4);        
                if exist(Foldername3_4{Forecast_Hour_4+1},'dir') == 7
                    cd(Foldername3_4{Forecast_Hour_4+1});
                else
                    mkdir(Foldername3_4{Forecast_Hour_4+1})
                    cd(Foldername3_4{Forecast_Hour_4+1});
                end;

                for v_4=1:length(Variables2_4)
                    if exist(sprintf('C:/Users/Admin/Desktop/NWP/10km_resolution/%4d%02d%02d/%02d/%03d/CMC_reg_%s_ps10km_%4d%02d%02d%02d_P%03d.grib2',y,m,d,Run_Time_4,Forecast_Hour_4,Variables2_4{v_4},y,m,d,Run_Time_4,Forecast_Hour_4),'file') == 2

                        commandInstruction_4 = strcat('"C:\Users\Admin/Desktop/NWP/degrib"', sprintf(' "C:/Users/Admin/Desktop/NWP/10km_resolution/%4d%02d%02d/%02d/%03d/CMC_reg_%s_ps10km_%4d%02d%02d%02d_P%03d.grib2" -C -msg all -Csv',y,m,d,Run_Time_4,Forecast_Hour_4,Variables2_4{v_4},y,m,d,Run_Time_4,Forecast_Hour_4));
                        system(commandInstruction_4);

                        [CSVfilename_4] = CSV_Filename_Predictor_10km(v_4,y,m,d,Run_Time_4,Forecast_Hour_4,index_4{Forecast_Hour_4+1});
                        CSVfilenames_4{Forecast_Hour_4+1} = cellstr(CSVfilename_4);
                        addpath('C:/Users/Admin/Desktop/NWP');

                        if v_4==1
                            N_4{1,Forecast_Hour_4+1} = csvread(char(CSVfilenames_4{Forecast_Hour_4+1}),1,0);


                        elseif v_4==length(Variables2_4)
                            M_4{Forecast_Hour_4+1} = csvread(char(CSVfilenames_4{Forecast_Hour_4+1}),1,4);
                            [a_4, ~] = size(N_4{Forecast_Hour_4+1});
                            [c_4, ~] = size(M_4{Forecast_Hour_4+1});
                            result_4 = a_4==c_4;
                            if ~result_4
                                [N_4{Forecast_Hour_4+1},M_4{Forecast_Hour_4+1}] = compare_rows(a_4,c_4,N_4{Forecast_Hour_4+1},M_4{Forecast_Hour_4+1});
                            end;
                            [x_4, ~] = size(N_4{Forecast_Hour_4+1});
                            P_4{Forecast_Hour_4+1} = [ones(x_4,1) * y,ones(x_4,1) * m,ones(x_4,1) * d,ones(x_4,1) * Forecast_Hour_4,ones(x_4,1) * Run_Time_4];
                            N_4{Forecast_Hour_4+1} = [P_4{Forecast_Hour_4+1},N_4{Forecast_Hour_4+1},M_4{Forecast_Hour_4+1}];

                        else    
                            M_4{Forecast_Hour_4+1} = csvread(char(CSVfilenames_4{Forecast_Hour_4+1}),1,4);
                            [a_4, ~] = size(N_4{Forecast_Hour_4+1});
                            [c_4, ~] = size(M_4{Forecast_Hour_4+1});
                            result_4 = a_4==c_4;
                            if ~result_4
                                [N_4{Forecast_Hour_4+1},M_4{Forecast_Hour_4+1}] = compare_rows(a_4,c_4,N_4{Forecast_Hour_4+1},M_4{Forecast_Hour_4+1});
                            end;
                            N_4{Forecast_Hour_4+1} = [N_4{Forecast_Hour_4+1},M_4{Forecast_Hour_4+1}];
                        end;
                    else
                       N_4{Forecast_Hour_4+1} = file_filler(v_4,N_4{Forecast_Hour_4+1},resolution_4,Variables2_4,M_4{Forecast_Hour_4+1},y,m,d,Forecast_Hour_4,Run_Time_4);      
                    end;
                    counter = counter + 1;
                end;
                    N_4{1,Forecast_Hour_4+1} = Data_Thinner(N_4{1,Forecast_Hour_4+1},1);
                    [ ~ ] = Clean_files(y,m,d,Run_Time_4,Forecast_Hour_4,y_4,m_4,d_4,Variables2_4,N_4{Forecast_Hour_4+1},resolution_4);
            cd ../
            end;
            cd ../../..
%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%CASE #5 - 10km resolution, run time 0h, forecast horizons 24h-48h
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%    
        case 5
            resolution_5 = 10;
            Run_Time_5 = 0;
            Forecast_Horizon_5=48;
            Variables2_5={'WIND_TGL_10','WIND_TGL_40','WIND_TGL_80','WIND_TGL_120',...
                    'WDIR_TGL_10','WDIR_TGL_40','WDIR_TGL_80','WDIR_TGL_120',...
                    'UGRD_TGL_10','UGRD_TGL_40','UGRD_TGL_80','UGRD_TGL_120',...
                    'VGRD_TGL_10','VGRD_TGL_40','VGRD_TGL_80','VGRD_TGL_120',...
                    'TMP_TGL_2','SPFH_TGL_2','PRES_SFC_0','TCDC_SFC_0','NSWRS_SFC_0'}; 
            Foldername2_5=sprintf('%02d',Run_Time_5);
            ParentFolder_5=sprintf('10km_resolution/%4d%02d%02d',y,m,d);
            cd(ParentFolder_5);
            if exist(Foldername2_5,'dir') == 7
                cd(Foldername2_5);
            else
                mkdir(Foldername2_5)
                cd(Foldername2_5);
            end;

            %Intializing Cells to create a workspace for the parallel for loop
            index_5 = cell(1,Forecast_Horizon_5+1);
            Foldername3_5 = cell(1,Forecast_Horizon_5+1);
            CSVfilenames_5 = cell(1,Forecast_Horizon_5+1);
    
            for Forecast_Hour_5=24:3:Forecast_Horizon_5
                
                N_5 = cell(1,Forecast_Horizon_5+1);
                M_5 = cell(1,Forecast_Horizon_5+1);
                P_5 = cell(1,Forecast_Horizon_5+1);
                addpath('C:/Users/Admin/Desktop/NWP');
                
                [y_5,m_5,d_5,h_5] = Date_Adjustment(y,m,d,Run_Time_5,Forecast_Hour_5);
               
                index_5{Forecast_Hour_5+1} = sprintf('%02d%02d%02d00',m_5,d_5,h_5);
                
                Foldername3_5{Forecast_Hour_5+1}=sprintf('%03d',Forecast_Hour_5);        
                if exist(Foldername3_5{Forecast_Hour_5+1},'dir') == 7
                    cd(Foldername3_5{Forecast_Hour_5+1});
                else
                    mkdir(Foldername3_5{Forecast_Hour_5+1})
                    cd(Foldername3_5{Forecast_Hour_5+1});
                end;

                for v_5=1:length(Variables2_5)
                    if exist(sprintf('C:/Users/Admin/Desktop/NWP/10km_resolution/%4d%02d%02d/%02d/%03d/CMC_reg_%s_ps10km_%4d%02d%02d%02d_P%03d.grib2',y,m,d,Run_Time_5,Forecast_Hour_5,Variables2_5{v_5},y,m,d,Run_Time_5,Forecast_Hour_5),'file') == 2

                        commandInstruction_5 = strcat('"C:\Users\Admin/Desktop/NWP/degrib"', sprintf(' "C:/Users/Admin/Desktop/NWP/10km_resolution/%4d%02d%02d/%02d/%03d/CMC_reg_%s_ps10km_%4d%02d%02d%02d_P%03d.grib2" -C -msg all -Csv',y,m,d,Run_Time_5,Forecast_Hour_5,Variables2_5{v_5},y,m,d,Run_Time_5,Forecast_Hour_5));
                        system(commandInstruction_5);

                        [CSVfilename_5] = CSV_Filename_Predictor_10km(v_5,y,m,d,Run_Time_5,Forecast_Hour_5,index_5{Forecast_Hour_5+1});
                        CSVfilenames_5{Forecast_Hour_5+1} = cellstr(CSVfilename_5);
                        addpath('C:/Users/Admin/Desktop/NWP');

                        if v_5==1
                            N_5{1,Forecast_Hour_5+1} = csvread(char(CSVfilenames_5{Forecast_Hour_5+1}),1,0);


                        elseif v_5==length(Variables2_5)
                            M_5{Forecast_Hour_5+1} = csvread(char(CSVfilenames_5{Forecast_Hour_5+1}),1,4);
                            [a_5, ~] = size(N_5{Forecast_Hour_5+1});
                            [c_5, ~] = size(M_5{Forecast_Hour_5+1});
                            result_5 = a_5==c_5;
                            if ~result_5
                                [N_5{Forecast_Hour_5+1},M_5{Forecast_Hour_5+1}] = compare_rows(a_5,c_5,N_5{Forecast_Hour_5+1},M_5{Forecast_Hour_5+1});
                            end;
                            [x_5, ~] = size(N_5{Forecast_Hour_5+1});
                            P_5{Forecast_Hour_5+1} = [ones(x_5,1) * y,ones(x_5,1) * m,ones(x_5,1) * d,ones(x_5,1) * Forecast_Hour_5,ones(x_5,1) * Run_Time_5];
                            N_5{Forecast_Hour_5+1} = [P_5{Forecast_Hour_5+1},N_5{Forecast_Hour_5+1},M_5{Forecast_Hour_5+1}];

                        else    
                            M_5{Forecast_Hour_5+1} = csvread(char(CSVfilenames_5{Forecast_Hour_5+1}),1,4);
                            [a_5, ~] = size(N_5{Forecast_Hour_5+1});
                            [c_5, ~] = size(M_5{Forecast_Hour_5+1});
                            result_5 = a_5==c_5;
                            if ~result_5
                                [N_5{Forecast_Hour_5+1},M_5{Forecast_Hour_5+1}] = compare_rows(a_5,c_5,N_5{Forecast_Hour_5+1},M_5{Forecast_Hour_5+1});
                            end;
                            N_5{Forecast_Hour_5+1} = [N_5{Forecast_Hour_5+1},M_5{Forecast_Hour_5+1}];
                        end; 
                    else
                       N_5{Forecast_Hour_5+1} = file_filler(v_5,N_5{Forecast_Hour_5+1},resolution_5,Variables2_5,M_5{Forecast_Hour_5+1},y,m,d,Forecast_Hour_5,Run_Time_5);      
                    end;  
                    counter = counter + 1;
                end; 
                    N_5{1,Forecast_Hour_5+1} = Data_Thinner(N_5{1,Forecast_Hour_5+1},1);
                    [ ~ ] = Clean_files(y,m,d,Run_Time_5,Forecast_Hour_5,y_5,m_5,d_5,Variables2_5,N_5{Forecast_Hour_5+1},resolution_5);
                cd ../
            end;
            cd ../../..
%%    
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%CASE #6 - 10km resolution, run time 6h, forecast horizons 0h-23h
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%    
        case 6
            resolution_6 = 10;
            Run_Time_6 = 6;
            Forecast_Horizon_6=23;
            Variables2_6={'WIND_TGL_10','WIND_TGL_40','WIND_TGL_80','WIND_TGL_120',...
                    'WDIR_TGL_10','WDIR_TGL_40','WDIR_TGL_80','WDIR_TGL_120',...
                    'UGRD_TGL_10','UGRD_TGL_40','UGRD_TGL_80','UGRD_TGL_120',...
                    'VGRD_TGL_10','VGRD_TGL_40','VGRD_TGL_80','VGRD_TGL_120',...
                    'TMP_TGL_2','SPFH_TGL_2','PRES_SFC_0','TCDC_SFC_0','NSWRS_SFC_0'}; 
            Foldername2_6=sprintf('%02d',Run_Time_6);
            ParentFolder_6=sprintf('10km_resolution/%4d%02d%02d',y,m,d);
            cd(ParentFolder_6);
            if exist(Foldername2_6,'dir') == 7
                cd(Foldername2_6);
            else
                mkdir(Foldername2_6)
                cd(Foldername2_6);
            end;

            %Intializing Cells to create a workspace for the parallel for loop
            index_6 = cell(1,Forecast_Horizon_6+1);
            Foldername3_6 = cell(1,Forecast_Horizon_6+1);
            CSVfilenames_6 = cell(1,Forecast_Horizon_6+1);
    
            for Forecast_Hour_6=0:3:Forecast_Horizon_6
                
                N_6 = cell(1,Forecast_Horizon_6+1);
                M_6 = cell(1,Forecast_Horizon_6+1);
                P_6 = cell(1,Forecast_Horizon_6+1);
                addpath('C:/Users/Admin/Desktop/NWP');
                
                [y_6,m_6,d_6,h_6] = Date_Adjustment(y,m,d,Run_Time_6,Forecast_Hour_6);
               
                index_6{Forecast_Hour_6+1} = sprintf('%02d%02d%02d00',m_6,d_6,h_6);
                
                Foldername3_6{Forecast_Hour_6+1}=sprintf('%03d',Forecast_Hour_6);        
                if exist(Foldername3_6{Forecast_Hour_6+1},'dir') == 7
                    cd(Foldername3_6{Forecast_Hour_6+1});
                else
                    mkdir(Foldername3_6{Forecast_Hour_6+1})
                    cd(Foldername3_6{Forecast_Hour_6+1});
                end;

                for v_6=1:length(Variables2_6)
                    if exist(sprintf('C:/Users/Admin/Desktop/NWP/10km_resolution/%4d%02d%02d/%02d/%03d/CMC_reg_%s_ps10km_%4d%02d%02d%02d_P%03d.grib2',y,m,d,Run_Time_6,Forecast_Hour_6,Variables2_6{v_6},y,m,d,Run_Time_6,Forecast_Hour_6),'file') == 2

                        commandInstruction_6 = strcat('"C:\Users\Admin/Desktop/NWP/degrib"', sprintf(' "C:/Users/Admin/Desktop/NWP/10km_resolution/%4d%02d%02d/%02d/%03d/CMC_reg_%s_ps10km_%4d%02d%02d%02d_P%03d.grib2" -C -msg all -Csv',y,m,d,Run_Time_6,Forecast_Hour_6,Variables2_6{v_6},y,m,d,Run_Time_6,Forecast_Hour_6));
                        system(commandInstruction_6);

                        [CSVfilename_6] = CSV_Filename_Predictor_10km(v_6,y,m,d,Run_Time_6,Forecast_Hour_6,index_6{Forecast_Hour_6+1});
                        CSVfilenames_6{Forecast_Hour_6+1} = cellstr(CSVfilename_6);
                        addpath('C:/Users/Admin/Desktop/NWP');

                        if v_6==1
                            N_6{1,Forecast_Hour_6+1} = csvread(char(CSVfilenames_6{Forecast_Hour_6+1}),1,0);                        

                        elseif v_6==length(Variables2_6)
                            M_6{Forecast_Hour_6+1} = csvread(char(CSVfilenames_6{Forecast_Hour_6+1}),1,4);
                            [a_6, ~] = size(N_6{Forecast_Hour_6+1});
                            [c_6, ~] = size(M_6{Forecast_Hour_6+1});
                            result_6 = a_6==c_6;
                            if ~result_6
                                [N_6{Forecast_Hour_6+1},M_6{Forecast_Hour_6+1}] = compare_rows(a_6,c_6,N_6{Forecast_Hour_6+1},M_6{Forecast_Hour_6+1});
                            end;
                            [x_6, ~] = size(N_6{Forecast_Hour_6+1});
                            P_6{Forecast_Hour_6+1} = [ones(x_6,1) * y,ones(x_6,1) * m,ones(x_6,1) * d,ones(x_6,1) * Forecast_Hour_6,ones(x_6,1) * Run_Time_6];
                            N_6{Forecast_Hour_6+1} = [P_6{Forecast_Hour_6+1},N_6{Forecast_Hour_6+1},M_6{Forecast_Hour_6+1}];

                        else    
                            M_6{Forecast_Hour_6+1} = csvread(char(CSVfilenames_6{Forecast_Hour_6+1}),1,4);
                            [a_6, ~] = size(N_6{Forecast_Hour_6+1});
                            [c_6, ~] = size(M_6{Forecast_Hour_6+1});
                            result_6 = a_6==c_6;
                            if ~result_6
                                [N_6{Forecast_Hour_6+1},M_6{Forecast_Hour_6+1}] = compare_rows(a_6,c_6,N_6{Forecast_Hour_6+1},M_6{Forecast_Hour_6+1});
                            end;
                            N_6{Forecast_Hour_6+1} = [N_6{Forecast_Hour_6+1},M_6{Forecast_Hour_6+1}];
                        end; 
                    else
                       N_6{Forecast_Hour_6+1} = file_filler(v_6,N_6{Forecast_Hour_6+1},resolution_6,Variables2_6,M_6{Forecast_Hour_6+1},y,m,d,Forecast_Hour_6,Run_Time_6);      
                    end; 
                    counter = counter + 1;
                end;  
                    N_6{1,Forecast_Hour_6+1} = Data_Thinner(N_6{1,Forecast_Hour_6+1},1);
                    [ ~ ] = Clean_files(y,m,d,Run_Time_6,Forecast_Hour_6,y_6,m_6,d_6,Variables2_6,N_6{Forecast_Hour_6+1},resolution_6);
                cd ../
            end;
            cd ../../..
%%    
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%CASE #7 - 10km resolution, run time 6h, forecast horizons 24h-48h
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%    
        case 7
            resolution_7 = 10;
            Run_Time_7 = 6;
            Forecast_Horizon_7=48;
            Variables2_7={'WIND_TGL_10','WIND_TGL_40','WIND_TGL_80','WIND_TGL_120',...
                    'WDIR_TGL_10','WDIR_TGL_40','WDIR_TGL_80','WDIR_TGL_120',...
                    'UGRD_TGL_10','UGRD_TGL_40','UGRD_TGL_80','UGRD_TGL_120',...
                    'VGRD_TGL_10','VGRD_TGL_40','VGRD_TGL_80','VGRD_TGL_120',...
                    'TMP_TGL_2','SPFH_TGL_2','PRES_SFC_0','TCDC_SFC_0','NSWRS_SFC_0'}; 
            Foldername2_7=sprintf('%02d',Run_Time_7);
            ParentFolder_7=sprintf('10km_resolution/%4d%02d%02d',y,m,d);
            cd(ParentFolder_7);
            if exist(Foldername2_7,'dir') == 7
                cd(Foldername2_7);
            else
                mkdir(Foldername2_7)
                cd(Foldername2_7);
            end;

            %Intializing Cells to create a workspace for the parallel for loop
            index_7 = cell(1,Forecast_Horizon_7+1);
            Foldername3_7 = cell(1,Forecast_Horizon_7+1);
            CSVfilenames_7 = cell(1,Forecast_Horizon_7+1);
    
            for Forecast_Hour_7=24:3:Forecast_Horizon_7
                
                N_7 = cell(1,Forecast_Horizon_7+1);
                M_7 = cell(1,Forecast_Horizon_7+1);
                P_7 = cell(1,Forecast_Horizon_7+1);
                addpath('C:/Users/Admin/Desktop/NWP');
                
                [y_7,m_7,d_7,h_7] = Date_Adjustment(y,m,d,Run_Time_7,Forecast_Hour_7);
               
                index_7{Forecast_Hour_7+1} = sprintf('%02d%02d%02d00',m_7,d_7,h_7);
                
                Foldername3_7{Forecast_Hour_7+1}=sprintf('%03d',Forecast_Hour_7);        
                if exist(Foldername3_7{Forecast_Hour_7+1},'dir') == 7
                    cd(Foldername3_7{Forecast_Hour_7+1});
                else
                    mkdir(Foldername3_7{Forecast_Hour_7+1})
                    cd(Foldername3_7{Forecast_Hour_7+1});
                end;

                for v_7=1:length(Variables2_7)
                    if exist(sprintf('C:/Users/Admin/Desktop/NWP/10km_resolution/%4d%02d%02d/%02d/%03d/CMC_reg_%s_ps10km_%4d%02d%02d%02d_P%03d.grib2',y,m,d,Run_Time_7,Forecast_Hour_7,Variables2_7{v_7},y,m,d,Run_Time_7,Forecast_Hour_7),'file') == 2

                        commandInstruction_7 = strcat('"C:\Users\Admin/Desktop/NWP/degrib"', sprintf(' "C:/Users/Admin/Desktop/NWP/10km_resolution/%4d%02d%02d/%02d/%03d/CMC_reg_%s_ps10km_%4d%02d%02d%02d_P%03d.grib2" -C -msg all -Csv',y,m,d,Run_Time_7,Forecast_Hour_7,Variables2_7{v_7},y,m,d,Run_Time_7,Forecast_Hour_7));
                        system(commandInstruction_7);

                        [CSVfilename_7] = CSV_Filename_Predictor_10km(v_7,y,m,d,Run_Time_7,Forecast_Hour_7,index_7{Forecast_Hour_7+1});
                        CSVfilenames_7{Forecast_Hour_7+1} = cellstr(CSVfilename_7);
                        addpath('C:/Users/Admin/Desktop/NWP');

                        if v_7==1
                            N_7{1,Forecast_Hour_7+1} = csvread(char(CSVfilenames_7{Forecast_Hour_7+1}),1,0);                      

                        elseif v_7==length(Variables2_7)
                            M_7{Forecast_Hour_7+1} = csvread(char(CSVfilenames_7{Forecast_Hour_7+1}),1,4);
                            [a_7, ~] = size(N_7{Forecast_Hour_7+1});
                            [c_7, ~] = size(M_7{Forecast_Hour_7+1});
                            result_7 = a_7==c_7;
                            if ~result_7
                                [N_7{Forecast_Hour_7+1},M_7{Forecast_Hour_7+1}] = compare_rows(a_7,c_7,N_7{Forecast_Hour_7+1},M_7{Forecast_Hour_7+1});
                            end;
                            [x_7, ~] = size(N_7{Forecast_Hour_7+1});
                            P_7{Forecast_Hour_7+1} = [ones(x_7,1) * y,ones(x_7,1) * m,ones(x_7,1) * d,ones(x_7,1) * Forecast_Hour_7,ones(x_7,1) * Run_Time_7];
                            N_7{Forecast_Hour_7+1} = [P_7{Forecast_Hour_7+1},N_7{Forecast_Hour_7+1},M_7{Forecast_Hour_7+1}];

                        else    
                            M_7{Forecast_Hour_7+1} = csvread(char(CSVfilenames_7{Forecast_Hour_7+1}),1,4);
                            [a_7, ~] = size(N_7{Forecast_Hour_7+1});
                            [c_7, ~] = size(M_7{Forecast_Hour_7+1});
                            result_7 = a_7==c_7;
                            if ~result_7
                                [N_7{Forecast_Hour_7+1},M_7{Forecast_Hour_7+1}] = compare_rows(a_7,c_7,N_7{Forecast_Hour_7+1},M_7{Forecast_Hour_7+1});
                            end;
                            N_7{Forecast_Hour_7+1} = [N_7{Forecast_Hour_7+1},M_7{Forecast_Hour_7+1}];
                        end; 
                    else
                       N_7{Forecast_Hour_7+1} = file_filler(v_7,N_7{Forecast_Hour_7+1},resolution_7,Variables2_7,M_7{Forecast_Hour_7+1},y,m,d,Forecast_Hour_7,Run_Time_7);      
                    end;
                    counter = counter + 1;
                end;  
                    N_7{1,Forecast_Hour_7+1} = Data_Thinner(N_7{1,Forecast_Hour_7+1},1);
                    [ ~ ] = Clean_files(y,m,d,Run_Time_7,Forecast_Hour_7,y_7,m_7,d_7,Variables2_7,N_7{Forecast_Hour_7+1},resolution_7);
                cd ../
            end;
            cd ../../..
%%            
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%CASE #8 - 10km resolution, run time 12h, forecast horizons 0h-23h
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%    
        case 8
            resolution_8 = 10;
            Run_Time_8 = 12;
            Forecast_Horizon_8=23;
            Variables2_8={'WIND_TGL_10','WIND_TGL_40','WIND_TGL_80','WIND_TGL_120',...
                    'WDIR_TGL_10','WDIR_TGL_40','WDIR_TGL_80','WDIR_TGL_120',...
                    'UGRD_TGL_10','UGRD_TGL_40','UGRD_TGL_80','UGRD_TGL_120',...
                    'VGRD_TGL_10','VGRD_TGL_40','VGRD_TGL_80','VGRD_TGL_120',...
                    'TMP_TGL_2','SPFH_TGL_2','PRES_SFC_0','TCDC_SFC_0','NSWRS_SFC_0'}; 
            Foldername2_8=sprintf('%02d',Run_Time_8);
            ParentFolder_8=sprintf('10km_resolution/%4d%02d%02d',y,m,d);
            cd(ParentFolder_8);
            if exist(Foldername2_8,'dir') == 7
                cd(Foldername2_8);
            else
                mkdir(Foldername2_8)
                cd(Foldername2_8);
            end;

            %Intializing Cells to create a workspace for the parallel for loop
            index_8 = cell(1,Forecast_Horizon_8+1);
            Foldername3_8 = cell(1,Forecast_Horizon_8+1);
            CSVfilenames_8 = cell(1,Forecast_Horizon_8+1);
    
            for Forecast_Hour_8=0:3:Forecast_Horizon_8
                
                N_8 = cell(1,Forecast_Horizon_8+1);
                M_8 = cell(1,Forecast_Horizon_8+1);
                P_8 = cell(1,Forecast_Horizon_8+1);
                
                addpath('C:/Users/Admin/Desktop/NWP');
                [y_8,m_8,d_8,h_8] = Date_Adjustment(y,m,d,Run_Time_8,Forecast_Hour_8);
               
                index_8{Forecast_Hour_8+1} = sprintf('%02d%02d%02d00',m_8,d_8,h_8);
                
                Foldername3_8{Forecast_Hour_8+1}=sprintf('%03d',Forecast_Hour_8);        
                if exist(Foldername3_8{Forecast_Hour_8+1},'dir') == 7
                    cd(Foldername3_8{Forecast_Hour_8+1});
                else
                    mkdir(Foldername3_8{Forecast_Hour_8+1})
                    cd(Foldername3_8{Forecast_Hour_8+1});
                end;

                for v_8=1:length(Variables2_8)
                    if exist(sprintf('C:/Users/Admin/Desktop/NWP/10km_resolution/%4d%02d%02d/%02d/%03d/CMC_reg_%s_ps10km_%4d%02d%02d%02d_P%03d.grib2',y,m,d,Run_Time_8,Forecast_Hour_8,Variables2_8{v_8},y,m,d,Run_Time_8,Forecast_Hour_8),'file') == 2

                        commandInstruction_8 = strcat('"C:\Users\Admin/Desktop/NWP/degrib"', sprintf(' "C:/Users/Admin/Desktop/NWP/10km_resolution/%4d%02d%02d/%02d/%03d/CMC_reg_%s_ps10km_%4d%02d%02d%02d_P%03d.grib2" -C -msg all -Csv',y,m,d,Run_Time_8,Forecast_Hour_8,Variables2_8{v_8},y,m,d,Run_Time_8,Forecast_Hour_8));
                        system(commandInstruction_8);

                        [CSVfilename_8] = CSV_Filename_Predictor_10km(v_8,y,m,d,Run_Time_8,Forecast_Hour_8,index_8{Forecast_Hour_8+1});
                        CSVfilenames_8{Forecast_Hour_8+1} = cellstr(CSVfilename_8);
                        addpath('C:/Users/Admin/Desktop/NWP');

                        if v_8==1
                            N_8{1,Forecast_Hour_8+1} = csvread(char(CSVfilenames_8{Forecast_Hour_8+1}),1,0);                        

                        elseif v_8==length(Variables2_8)
                            M_8{Forecast_Hour_8+1} = csvread(char(CSVfilenames_8{Forecast_Hour_8+1}),1,4);
                            [a_8, ~] = size(N_8{Forecast_Hour_8+1});
                            [c_8, ~] = size(M_8{Forecast_Hour_8+1});
                            result_8 = a_8==c_8;
                            if ~result_8
                                [N_8{Forecast_Hour_8+1},M_8{Forecast_Hour_8+1}] = compare_rows(a_8,c_8,N_8{Forecast_Hour_8+1},M_8{Forecast_Hour_8+1});
                            end;
                            [x_8, ~] = size(N_8{Forecast_Hour_8+1});
                            P_8{Forecast_Hour_8+1} = [ones(x_8,1) * y,ones(x_8,1) * m,ones(x_8,1) * d,ones(x_8,1) * Forecast_Hour_8,ones(x_8,1) * Run_Time_8];
                            N_8{Forecast_Hour_8+1} = [P_8{Forecast_Hour_8+1},N_8{Forecast_Hour_8+1},M_8{Forecast_Hour_8+1}];

                        else    
                            M_8{Forecast_Hour_8+1} = csvread(char(CSVfilenames_8{Forecast_Hour_8+1}),1,4);
                            [a_8, ~] = size(N_8{Forecast_Hour_8+1});
                            [c_8, ~] = size(M_8{Forecast_Hour_8+1});
                            result_8 = a_8==c_8;
                            if ~result_8
                                [N_8{Forecast_Hour_8+1},M_8{Forecast_Hour_8+1}] = compare_rows(a_8,c_8,N_8{Forecast_Hour_8+1},M_8{Forecast_Hour_8+1});
                            end;
                            N_8{Forecast_Hour_8+1} = [N_8{Forecast_Hour_8+1},M_8{Forecast_Hour_8+1}];
                        end; 
                    else
                       N_8{Forecast_Hour_8+1} = file_filler(v_8,N_8{Forecast_Hour_8+1},resolution_8,Variables2_8,M_8{Forecast_Hour_8+1},y,m,d,Forecast_Hour_8,Run_Time_8);      
                    end;
                    counter = counter + 1;
                end;
                    N_8{1,Forecast_Hour_8+1} = Data_Thinner(N_8{1,Forecast_Hour_8+1},1);
                    [ ~ ] = Clean_files(y,m,d,Run_Time_8,Forecast_Hour_8,y_8,m_8,d_8,Variables2_8,N_8{Forecast_Hour_8+1},resolution_8);
                cd ../
            end;
            cd ../../..
%%    
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%CASE #9 - 10km resolution, run time 12h, forecast horizons 24h-48h
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%    
        case 9
            resolution_9 = 10;
            Run_Time_9 = 12;
            Forecast_Horizon_9=48;
            Variables2_9={'WIND_TGL_10','WIND_TGL_40','WIND_TGL_80','WIND_TGL_120',...
                    'WDIR_TGL_10','WDIR_TGL_40','WDIR_TGL_80','WDIR_TGL_120',...
                    'UGRD_TGL_10','UGRD_TGL_40','UGRD_TGL_80','UGRD_TGL_120',...
                    'VGRD_TGL_10','VGRD_TGL_40','VGRD_TGL_80','VGRD_TGL_120',...
                    'TMP_TGL_2','SPFH_TGL_2','PRES_SFC_0','TCDC_SFC_0','NSWRS_SFC_0'}; 
            Foldername2_9=sprintf('%02d',Run_Time_9);
            ParentFolder_9=sprintf('10km_resolution/%4d%02d%02d',y,m,d);
            cd(ParentFolder_9);
            if exist(Foldername2_9,'dir') == 7
                cd(Foldername2_9);
            else
                mkdir(Foldername2_9)
                cd(Foldername2_9);
            end;

            %Intializing Cells to create a workspace for the parallel for loop
            index_9 = cell(1,Forecast_Horizon_9+1);
            Foldername3_9 = cell(1,Forecast_Horizon_9+1);
            CSVfilenames_9 = cell(1,Forecast_Horizon_9+1);
    
            for Forecast_Hour_9=24:3:Forecast_Horizon_9
                
                N_9 = cell(1,Forecast_Horizon_9+1);
                M_9 = cell(1,Forecast_Horizon_9+1);
                P_9 = cell(1,Forecast_Horizon_9+1);
                
                addpath('C:/Users/Admin/Desktop/NWP');
                [y_9,m_9,d_9,h_9] = Date_Adjustment(y,m,d,Run_Time_9,Forecast_Hour_9);
               
                index_9{Forecast_Hour_9+1} = sprintf('%02d%02d%02d00',m_9,d_9,h_9);
                
                Foldername3_9{Forecast_Hour_9+1}=sprintf('%03d',Forecast_Hour_9);        
                if exist(Foldername3_9{Forecast_Hour_9+1},'dir') == 7
                    cd(Foldername3_9{Forecast_Hour_9+1});
                else
                    mkdir(Foldername3_9{Forecast_Hour_9+1})
                    cd(Foldername3_9{Forecast_Hour_9+1});
                end;

                for v_9=1:length(Variables2_9)
                    if exist(sprintf('C:/Users/Admin/Desktop/NWP/10km_resolution/%4d%02d%02d/%02d/%03d/CMC_reg_%s_ps10km_%4d%02d%02d%02d_P%03d.grib2',y,m,d,Run_Time_9,Forecast_Hour_9,Variables2_9{v_9},y,m,d,Run_Time_9,Forecast_Hour_9),'file') == 2

                        commandInstruction_9 = strcat('"C:\Users\Admin/Desktop/NWP/degrib"', sprintf(' "C:/Users/Admin/Desktop/NWP/10km_resolution/%4d%02d%02d/%02d/%03d/CMC_reg_%s_ps10km_%4d%02d%02d%02d_P%03d.grib2" -C -msg all -Csv',y,m,d,Run_Time_9,Forecast_Hour_9,Variables2_9{v_9},y,m,d,Run_Time_9,Forecast_Hour_9));
                        system(commandInstruction_9);

                        [CSVfilename_9] = CSV_Filename_Predictor_10km(v_9,y,m,d,Run_Time_9,Forecast_Hour_9,index_9{Forecast_Hour_9+1});
                        CSVfilenames_9{Forecast_Hour_9+1} = cellstr(CSVfilename_9);
                        addpath('C:/Users/Admin/Desktop/NWP');

                        if v_9==1
                            N_9{1,Forecast_Hour_9+1} = csvread(char(CSVfilenames_9{Forecast_Hour_9+1}),1,0);                        

                        elseif v_9==length(Variables2_9)
                            M_9{Forecast_Hour_9+1} = csvread(char(CSVfilenames_9{Forecast_Hour_9+1}),1,4);
                            [a_9, ~] = size(N_9{Forecast_Hour_9+1});
                            [c_9, ~] = size(M_9{Forecast_Hour_9+1});
                            result_9 = a_9==c_9;
                            if ~result_9
                                [N_9{Forecast_Hour_9+1},M_9{Forecast_Hour_9+1}] = compare_rows(a_9,c_9,N_9{Forecast_Hour_9+1},M_9{Forecast_Hour_9+1});
                            end;
                            [x_9, ~] = size(N_9{Forecast_Hour_9+1});
                            P_9{Forecast_Hour_9+1} = [ones(x_9,1) * y,ones(x_9,1) * m,ones(x_9,1) * d,ones(x_9,1) * Forecast_Hour_9,ones(x_9,1) * Run_Time_9];
                            N_9{Forecast_Hour_9+1} = [P_9{Forecast_Hour_9+1},N_9{Forecast_Hour_9+1},M_9{Forecast_Hour_9+1}];

                        else    
                            M_9{Forecast_Hour_9+1} = csvread(char(CSVfilenames_9{Forecast_Hour_9+1}),1,4);
                            [a_9, ~] = size(N_9{Forecast_Hour_9+1});
                            [c_9, ~] = size(M_9{Forecast_Hour_9+1});
                            result_9 = a_9==c_9;
                            if ~result_9
                                [N_9{Forecast_Hour_9+1},M_9{Forecast_Hour_9+1}] = compare_rows(a_9,c_9,N_9{Forecast_Hour_9+1},M_9{Forecast_Hour_9+1});
                            end;
                            N_9{Forecast_Hour_9+1} = [N_9{Forecast_Hour_9+1},M_9{Forecast_Hour_9+1}];
                        end; 
                    else
                       N_9{Forecast_Hour_9+1} = file_filler(v_9,N_9{Forecast_Hour_9+1},resolution_9,Variables2_9,M_9{Forecast_Hour_9+1},y,m,d,Forecast_Hour_9,Run_Time_9);      
                    end;
                    counter = counter + 1;
                end;
                    N_9{1,Forecast_Hour_9+1} = Data_Thinner(N_9{1,Forecast_Hour_9+1},1);
                    [ ~ ] = Clean_files(y,m,d,Run_Time_9,Forecast_Hour_9,y_9,m_9,d_9,Variables2_9,N_9{Forecast_Hour_9+1},resolution_9);
                cd ../
            end;
            cd ../../..
%%            
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%CASE #10 - 10km resolution, run time 18h, forecast horizons 0h-23h
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%    
        case 10
            resolution_10 = 10;
            Run_Time_10 = 18;
            Forecast_Horizon_10=23;
            Variables2_10={'WIND_TGL_10','WIND_TGL_40','WIND_TGL_80','WIND_TGL_120',...
                    'WDIR_TGL_10','WDIR_TGL_40','WDIR_TGL_80','WDIR_TGL_120',...
                    'UGRD_TGL_10','UGRD_TGL_40','UGRD_TGL_80','UGRD_TGL_120',...
                    'VGRD_TGL_10','VGRD_TGL_40','VGRD_TGL_80','VGRD_TGL_120',...
                    'TMP_TGL_2','SPFH_TGL_2','PRES_SFC_0','TCDC_SFC_0','NSWRS_SFC_0'}; 
            Foldername2_10=sprintf('%02d',Run_Time_10);
            ParentFolder_10=sprintf('10km_resolution/%4d%02d%02d',y,m,d);
            cd(ParentFolder_10);
            if exist(Foldername2_10,'dir') == 7
                cd(Foldername2_10);
            else
                mkdir(Foldername2_10)
                cd(Foldername2_10);
            end;

            %Intializing Cells to create a workspace for the parallel for loop
            index_10 = cell(1,Forecast_Horizon_10+1);
            Foldername3_10 = cell(1,Forecast_Horizon_10+1);
            CSVfilenames_10 = cell(1,Forecast_Horizon_10+1);
    
            for Forecast_Hour_10=0:3:Forecast_Horizon_10
                
                N_10 = cell(1,Forecast_Horizon_10+1);
                M_10 = cell(1,Forecast_Horizon_10+1);
                P_10 = cell(1,Forecast_Horizon_10+1);
                
                addpath('C:/Users/Admin/Desktop/NWP');
                [y_10,m_10,d_10,h_10] = Date_Adjustment(y,m,d,Run_Time_10,Forecast_Hour_10);
               
                index_10{Forecast_Hour_10+1} = sprintf('%02d%02d%02d00',m_10,d_10,h_10);
                
                Foldername3_10{Forecast_Hour_10+1}=sprintf('%03d',Forecast_Hour_10);        
                if exist(Foldername3_10{Forecast_Hour_10+1},'dir') == 7
                    cd(Foldername3_10{Forecast_Hour_10+1});
                else
                    mkdir(Foldername3_10{Forecast_Hour_10+1})
                    cd(Foldername3_10{Forecast_Hour_10+1});
                end;

                for v_10=1:length(Variables2_10)
                    if exist(sprintf('C:/Users/Admin/Desktop/NWP/10km_resolution/%4d%02d%02d/%02d/%03d/CMC_reg_%s_ps10km_%4d%02d%02d%02d_P%03d.grib2',y,m,d,Run_Time_10,Forecast_Hour_10,Variables2_10{v_10},y,m,d,Run_Time_10,Forecast_Hour_10),'file') == 2

                        commandInstruction_10 = strcat('"C:\Users\Admin/Desktop/NWP/degrib"', sprintf(' "C:/Users/Admin/Desktop/NWP/10km_resolution/%4d%02d%02d/%02d/%03d/CMC_reg_%s_ps10km_%4d%02d%02d%02d_P%03d.grib2" -C -msg all -Csv',y,m,d,Run_Time_10,Forecast_Hour_10,Variables2_10{v_10},y,m,d,Run_Time_10,Forecast_Hour_10));
                        system(commandInstruction_10);

                        [CSVfilename_10] = CSV_Filename_Predictor_10km(v_10,y,m,d,Run_Time_10,Forecast_Hour_10,index_10{Forecast_Hour_10+1});
                        CSVfilenames_10{Forecast_Hour_10+1} = cellstr(CSVfilename_10);
                        addpath('C:/Users/Admin/Desktop/NWP');

                        if v_10==1
                            N_10{1,Forecast_Hour_10+1} = csvread(char(CSVfilenames_10{Forecast_Hour_10+1}),1,0);                        

                        elseif v_10==length(Variables2_10)
                            M_10{Forecast_Hour_10+1} = csvread(char(CSVfilenames_10{Forecast_Hour_10+1}),1,4);
                            [a_10, ~] = size(N_10{Forecast_Hour_10+1});
                            [c_10, ~] = size(M_10{Forecast_Hour_10+1});
                            result_10 = a_10==c_10;
                            if ~result_10
                                [N_10{Forecast_Hour_10+1},M_10{Forecast_Hour_10+1}] = compare_rows(a_10,c_10,N_10{Forecast_Hour_10+1},M_10{Forecast_Hour_10+1});
                            end;
                            [x_10, ~] = size(N_10{Forecast_Hour_10+1});
                            P_10{Forecast_Hour_10+1} = [ones(x_10,1) * y,ones(x_10,1) * m,ones(x_10,1) * d,ones(x_10,1) * Forecast_Hour_10,ones(x_10,1) * Run_Time_10];
                            N_10{Forecast_Hour_10+1} = [P_10{Forecast_Hour_10+1},N_10{Forecast_Hour_10+1},M_10{Forecast_Hour_10+1}];

                        else    
                            M_10{Forecast_Hour_10+1} = csvread(char(CSVfilenames_10{Forecast_Hour_10+1}),1,4);
                            [a_10, ~] = size(N_10{Forecast_Hour_10+1});
                            [c_10, ~] = size(M_10{Forecast_Hour_10+1});
                            result_10 = a_10==c_10;
                            if ~result_10
                                [N_10{Forecast_Hour_10+1},M_10{Forecast_Hour_10+1}] = compare_rows(a_10,c_10,N_10{Forecast_Hour_10+1},M_10{Forecast_Hour_10+1});
                            end;
                            N_10{Forecast_Hour_10+1} = [N_10{Forecast_Hour_10+1},M_10{Forecast_Hour_10+1}];
                        end; 
                    else
                       N_10{Forecast_Hour_10+1} = file_filler(v_10,N_10{Forecast_Hour_10+1},resolution_10,Variables2_10,M_10{Forecast_Hour_10+1},y,m,d,Forecast_Hour_10,Run_Time_10);      
                    end;  
                    counter = counter + 1;
                end;   
                    N_10{1,Forecast_Hour_10+1} = Data_Thinner(N_10{1,Forecast_Hour_10+1},1);
                    [ ~ ] = Clean_files(y,m,d,Run_Time_10,Forecast_Hour_10,y_10,m_10,d_10,Variables2_10,N_10{Forecast_Hour_10+1},resolution_10);
                cd ../
            end;
            cd ../../..
%%            
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%CASE #11 - 10km resolution, run time 18h, forecast horizons 24h-48h
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%    
        case 11
            resolution_11 = 10;
            Run_Time_11 = 18;
            Forecast_Horizon_11=48;
            Variables2_11={'WIND_TGL_10','WIND_TGL_40','WIND_TGL_80','WIND_TGL_120',...
                    'WDIR_TGL_10','WDIR_TGL_40','WDIR_TGL_80','WDIR_TGL_120',...
                    'UGRD_TGL_10','UGRD_TGL_40','UGRD_TGL_80','UGRD_TGL_120',...
                    'VGRD_TGL_10','VGRD_TGL_40','VGRD_TGL_80','VGRD_TGL_120',...
                    'TMP_TGL_2','SPFH_TGL_2','PRES_SFC_0','TCDC_SFC_0','NSWRS_SFC_0'}; 
            Foldername2_11=sprintf('%02d',Run_Time_11);
            ParentFolder_11=sprintf('10km_resolution/%4d%02d%02d',y,m,d);
            cd(ParentFolder_11);
            if exist(Foldername2_11,'dir') == 7
                cd(Foldername2_11);
            else
                mkdir(Foldername2_11)
                cd(Foldername2_11);
            end;

            %Intializing Cells to create a workspace for the parallel for loop
            index_11 = cell(1,Forecast_Horizon_11+1);
            Foldername3_11 = cell(1,Forecast_Horizon_11+1);
            CSVfilenames_11 = cell(1,Forecast_Horizon_11+1);
    
            for Forecast_Hour_11=24:3:Forecast_Horizon_11
                
                N_11 = cell(1,Forecast_Horizon_11+1);
                M_11 = cell(1,Forecast_Horizon_11+1);
                P_11 = cell(1,Forecast_Horizon_11+1);
                
                addpath('C:/Users/Admin/Desktop/NWP');
                [y_11,m_11,d_11,h_11] = Date_Adjustment(y,m,d,Run_Time_11,Forecast_Hour_11);
               
                index_11{Forecast_Hour_11+1} = sprintf('%02d%02d%02d00',m_11,d_11,h_11);
                
                Foldername3_11{Forecast_Hour_11+1}=sprintf('%03d',Forecast_Hour_11);        
                if exist(Foldername3_11{Forecast_Hour_11+1},'dir') == 7
                    cd(Foldername3_11{Forecast_Hour_11+1});
                else
                    mkdir(Foldername3_11{Forecast_Hour_11+1})
                    cd(Foldername3_11{Forecast_Hour_11+1});
                end;

                for v_11=1:length(Variables2_11)
                    if exist(sprintf('C:/Users/Admin/Desktop/NWP/10km_resolution/%4d%02d%02d/%02d/%03d/CMC_reg_%s_ps10km_%4d%02d%02d%02d_P%03d.grib2',y,m,d,Run_Time_11,Forecast_Hour_11,Variables2_11{v_11},y,m,d,Run_Time_11,Forecast_Hour_11),'file') == 2

                        commandInstruction_11 = strcat('"C:\Users\Admin/Desktop/NWP/degrib"', sprintf(' "C:/Users/Admin/Desktop/NWP/10km_resolution/%4d%02d%02d/%02d/%03d/CMC_reg_%s_ps10km_%4d%02d%02d%02d_P%03d.grib2" -C -msg all -Csv',y,m,d,Run_Time_11,Forecast_Hour_11,Variables2_11{v_11},y,m,d,Run_Time_11,Forecast_Hour_11));
                        system(commandInstruction_11);

                        [CSVfilename_11] = CSV_Filename_Predictor_10km(v_11,y,m,d,Run_Time_11,Forecast_Hour_11,index_11{Forecast_Hour_11+1});
                        CSVfilenames_11{Forecast_Hour_11+1} = cellstr(CSVfilename_11);
                        addpath('C:/Users/Admin/Desktop/NWP');

                        if v_11==1
                            N_11{1,Forecast_Hour_11+1} = csvread(char(CSVfilenames_11{Forecast_Hour_11+1}),1,0);                        

                        elseif v_11==length(Variables2_11)
                            M_11{Forecast_Hour_11+1} = csvread(char(CSVfilenames_11{Forecast_Hour_11+1}),1,4);
                            [a_11, ~] = size(N_11{Forecast_Hour_11+1});
                            [c_11, ~] = size(M_11{Forecast_Hour_11+1});
                            result_11 = a_11==c_11;
                            if ~result_11
                                [N_11{Forecast_Hour_11+1},M_11{Forecast_Hour_11+1}] = compare_rows(a_11,c_11,N_11{Forecast_Hour_11+1},M_11{Forecast_Hour_11+1});
                            end;
                            [x_11, ~] = size(N_11{Forecast_Hour_11+1});
                            P_11{Forecast_Hour_11+1} = [ones(x_11,1) * y,ones(x_11,1) * m,ones(x_11,1) * d,ones(x_11,1) * Forecast_Hour_11,ones(x_11,1) * Run_Time_11];
                            N_11{Forecast_Hour_11+1} = [P_11{Forecast_Hour_11+1},N_11{Forecast_Hour_11+1},M_11{Forecast_Hour_11+1}];

                        else    
                            M_11{Forecast_Hour_11+1} = csvread(char(CSVfilenames_11{Forecast_Hour_11+1}),1,4);
                            [a_11, ~] = size(N_11{Forecast_Hour_11+1});
                            [c_11, ~] = size(M_11{Forecast_Hour_11+1});
                            result_11 = a_11==c_11;
                            if ~result_11
                                [N_11{Forecast_Hour_11+1},M_11{Forecast_Hour_11+1}] = compare_rows(a_11,c_11,N_11{Forecast_Hour_11+1},M_11{Forecast_Hour_11+1});
                            end;
                            N_11{Forecast_Hour_11+1} = [N_11{Forecast_Hour_11+1},M_11{Forecast_Hour_11+1}];
                        end; 
                    else
                       N_11{Forecast_Hour_11+1} = file_filler(v_11,N_11{Forecast_Hour_11+1},resolution_11,Variables2_11,M_11{Forecast_Hour_11+1},y,m,d,Forecast_Hour_11,Run_Time_11);      
                    end;  
                    counter = counter + 1;
                end;   
                    N_11{1,Forecast_Hour_11+1} = Data_Thinner(N_11{1,Forecast_Hour_11+1},1);
                    [ ~ ] = Clean_files(y,m,d,Run_Time_11,Forecast_Hour_11,y_11,m_11,d_11,Variables2_11,N_11{Forecast_Hour_11+1},resolution_11);
                cd ../
            end;
            cd ../../...
        
     end;
end;
        addpath('C:/Users/Admin/Desktop/NWP');
        matlabpool close;
        toc
        diary off
        send_mail_message('h.shakerardakani@gmail.com','NWP_DAWS_ADDA_Degribber completed',counter,sprintf('C:/Users/Admin/Desktop/NWP/runtime_logs/degribbing/Degrib_%4d%02d%02d',y_end,m_end,d_end))
        send_mail_message('hamed_chitsaz63@yahoo.com','NWP_DAWS_ADDA_Degribber completed',counter,sprintf('C:/Users/Admin/Desktop/NWP/runtime_logs/degribbing/Degrib_%4d%02d%02d',y_end,m_end,d_end))
        send_mail_message('shane.fast01@gmail.com','NWP_DAWS_ADDA_Degribber completed',counter,sprintf('C:/Users/Admin/Desktop/NWP/runtime_logs/degribbing/Degrib_%4d%02d%02d',y_end,m_end,d_end))
        quit;

catch Report
    cd ../../..
    matlabpool close;
    addpath('C:/Users/Admin/Desktop/NWP');   
    toc
    diary off
    send_mail_message('h.shakerardakani@gmail.com','NWP_DAWS_ADDA_Degribber Failed, check it rightaway.',counter,sprintf('C:/Users/Admin/Desktop/NWP/runtime_logs/degribbing/Degrib_%4d%02d%02d',y_end,m_end,d_end))
    send_mail_message('hamed_chitsaz63@yahoo.com','NWP_DAWS_ADDA_Degribber Failed, check it rightaway.',counter,sprintf('C:/Users/Admin/Desktop/NWP/runtime_logs/degribbing/Degrib_%4d%02d%02d',y_end,m_end,d_end))    
    send_mail_message('shane.fast01@gmail.com','NWP_DAWS_ADDA_Degribber Failed, check it rightaway.',counter,sprintf('C:/Users/Admin/Desktop/NWP/runtime_logs/degribbing/Degrib_%4d%02d%02d',y_end,m_end,d_end))
    quit;
end;
