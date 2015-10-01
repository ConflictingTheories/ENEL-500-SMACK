%%
%TITLE: NWP DAWS ADDA Degribber
%DESCRIPTION:
% 
%This Code intakes the entire matix of data relating to the various
%weather variables for both 2.5km and 10km resolutions. By assigning the
%input matrix to a tempoary variable the data is thinned out to only
%represent the locations within a rectangle including Alberta and south
%eastern British Columbia. The result is then sent back out. The option of
%saving the latitude and longitude was made inherit to allow for this
%function to be used to thin data between variable passes.
%
%AUTHORS: Shane Fast

%%
function [OUT] = Data_Thinner(IN,KEEP_LAT_LNG)

TEMP = IN;
TF1_0 = TEMP(:,8)>60;   %The maximum allowable Latitude.
TF2_0 = TEMP(:,8)<49;   %The minimum allowable Latitude.
TF3_0 = TEMP(:,9)>-110; %The maximum allowable Longitude.
TF4_0 = TEMP(:,9)<-120; %The minimum allowable Longitude.
Tout_0 = TF1_0 | TF2_0 | TF3_0 | TF4_0;
%If any of the above conditions are exceeded then this function eliminates
%the entire row.
TEMP(Tout_0,:)=[];

if KEEP_LAT_LNG
    OUT = TEMP;         %Returns the remainder.
else
    OUT = TEMP(:,5);    %Returns only the data row, use only during
                        %intermediate passes, else most data becomes lost.
end;

end