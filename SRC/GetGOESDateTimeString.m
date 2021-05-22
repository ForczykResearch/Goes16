function [Year,Day,Hour,Minute,Second] = GetGOESDateTimeString(filename,itype)
% Decode the filename to arrive at the GOES startscan,end scan or file
% save time
% Written By: Stephen Forczyk
% Created: August 8,2020
% Revised:------
% Classification: Unclassified
% The GOES Date time data is encoded as follows
% type = 1 start scan -  scan start time sYYYYJJJHHMMSSm: year, day of year, hour, minute, second, tenth second 
% type = 2 end scan   -  scan end time   eYYYYJJJHHMMSSm: year, day of year, hour, minute, second, tenth second 
% type = 3 save scan  -  scan save time  cYYYYJJJHHMMSSm: year, day of year, hour, minute, second, tenth second 

[iunder]=strfind(filename,'_');
numunder=length(iunder);
[iper]=strfind(filename,'.');
if(itype==1)
    is=iunder(3)+2;
    ie=iunder(4)-1;
elseif(itype==2)
    is=iunder(4)+2;
    ie=iunder(5)-1;
else
    is=iunder(5)+2;
    ie=iper(1)-1;
end
timestr=filename(is:ie);
Year=str2num(timestr(1:4));
Day=str2num(timestr(5:7));
Hour=str2num(timestr(8:9));
Minute=str2num(timestr(10:11));
Second=str2num(timestr(12:13));
Frac=str2num(timestr(14:14));
Second=Second+Frac/10;
ab=1;
end

