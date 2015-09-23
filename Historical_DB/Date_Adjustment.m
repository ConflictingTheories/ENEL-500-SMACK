%%
%TITLE: Date_Adjustment
%DESCRIPTION:
%
%Date_Adjustment: checks to see if run time added to forecast hour overlaps
%into the following day, month, and year. prevents run-time errors and
%allows the degribber file perdictors functions to work properly. This
%function should allow proper function of degribber indefinately. If matlab
%returns an error stating that a csv file cannot be found please attempt to
%compare the degribbed file name to that of the result of this function.
%The error will more likely than not be a result of a mistake made by this
%function.
%
%AUTHORS: Shane Fast

%%
function [n_y,n_m,n_d,n_h] = Date_Adjustment(y,m,d,Run_Time,Forecast_Hour)

 test = Run_Time+Forecast_Hour;
 h24_check = 1;
 
 if m==2
     is_multiple = (4*round(double(y)/4) == y); 
     %Checks if the current year is a leap year, then acts accordingly.
     if is_multiple
         d_check = 29;  %considers an extra day observing a leap year.
     else
         d_check = 28;  %the normal length of February.
     end;
 elseif m==4||m==6||m==9||m==11
     %Considerations for the 30 day long months: April, June, September,
     %and November.
     d_check = 30;
 else
     d_check = 31;  %The rest obviously having 31 day.
 end;
 
 %Now that the length of the month has been established the sum of the run
 %time and forecast horizon are checked to observe any overlap in days,
 %months, or even years.
 
 while h24_check 
    %Since the sum of the run time and the forecast horizon can exceed 48
    %hours a while loop forces the check to add multiple days if necessary.
        if test > 23
           test = test-24;
           h24_check = 1;
           d=d+1;
           %If hours exceed 23h add a day and remove 24 hours.
           if d>d_check
             d=1;
             m = m+1;
             %But if we add a day we need to make sure we have not
             %overlapped into the next month. If we have, then the day 
             %counter is reset to 1 and the month counter is increased by 
             %1.
             if m > 12
                m = 1;
                y = y + 1;
                %But if we add a month we need to make sure we have not
                %overlapped into the next year. If we have, then the month
                %counter is reset to 1 and the year counter is increased by
                %1.
             end;
           end;
           
        else
           h24_check = 0; 
           %Leave loop once the remaining hours no longer exceed 23h.
        end;
 end;
 %Return the updated time values.
 n_y = y;
 n_m = m;
 n_d = d;
 n_h = test; %The remaining hour of which no longer exceed 23h.
 
end

