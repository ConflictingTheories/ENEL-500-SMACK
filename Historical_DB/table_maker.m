
Forecast_Horizon = 42;
for Forecast_Hour = 0:1:Forecast_Horizon
                conn = database('2point5kmDatabase','','');
                sqlquery = char(sprintf('CREATE TABLE %02d(Forecasted_at_date NUMBER, Forecasted_at_time NUMBER, Forecasted_for_date NUMBER, Forecasted_for_time NUMBER, Run_Time NUMBER, X NUMBER, Y NUMBER, Latitude NUMBER, Longitude NUMBER, WIND_TGL_10 NUMBER, WIND_TGL_40 NUMBER, WIND_TGL_80 NUMBER, WIND_TGL_120 NUMBER, WDIR_TGL_10 NUMBER, WDIR_TGL_40 NUMBER, WDIR_TGL_80 NUMBER, WDIR_TGL_120 NUMBER, UGRD_TGL_10 NUMBER, UGRD_TGL_40 NUMBER, UGRD_TGL_80 NUMBER, UGRD_TGL_120 NUMBER, VGRD_TGL_10 NUMBER, VGRD_TGL_40 NUMBER, VGRD_TGL_80 NUMBER, VGRD_TGL_120 NUMBER, RH_TGL_2 NUMBER, RH_TGL_40 NUMBER, RH_TGL_120 NUMBER, TMP_TGL_2 NUMBER, TMP_TGL_40 NUMBER, TMP_TGL_80 NUMBER, TMP_TGL_120 NUMBER, PRES_SFC_0 NUMBER, TCDC_SFC_0 NUMBER, DSWRF_NTAT_0 NUMBER, DSWRF_SFC_0 NUMBER, DEN_TGL_80 NUMBER);',Forecast_Hour));
                exec(conn,sqlquery);
                commit(conn);
                close(conn); 
end
    
Forecast_Horizon = 48;
for Forecast_Hour = 0:3:Forecast_Horizon
                conn = database('10kmDatabase','','');
                sqlquery = char(sprintf('CREATE TABLE %02d(Forecasted_at_date NUMBER, Forecasted_at_time NUMBER, Forecasted_for_date NUMBER, Forecasted_for_time NUMBER, Run_Time NUMBER, X NUMBER, Y NUMBER, Latitude NUMBER, Longitude NUMBER, WIND_TGL_10 NUMBER, WIND_TGL_40 NUMBER, WIND_TGL_80 NUMBER, WIND_TGL_120 NUMBER, WDIR_TGL_10 NUMBER, WDIR_TGL_40 NUMBER, WDIR_TGL_80 NUMBER, WDIR_TGL_120 NUMBER, UGRD_TGL_10 NUMBER, UGRD_TGL_40 NUMBER, UGRD_TGL_80 NUMBER, UGRD_TGL_120 NUMBER, VGRD_TGL_10 NUMBER, VGRD_TGL_40 NUMBER, VGRD_TGL_80 NUMBER, VGRD_TGL_120 NUMBER, TMP_TGL_2 NUMBER, SPFH_TGL_2 NUMBER, PRES_SFC_0 NUMBER, TCDC_SFC_0 NUMBER, NSWRS_SFC_0 NUMBER);',Forecast_Hour));
                exec(conn,sqlquery);
                commit(conn);
                close(conn); 
end