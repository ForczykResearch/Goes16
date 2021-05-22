function [GeodLat,GeodLon] = CalculateGeodCoordFromXYPosRev1(x,y)
% This function is intended to calculate the Geodetic Coordinates of the XY
% scan Position valaues for the GOES satellite series
% 
% Written By: Stephen Forczyk
% Created: April 12,2021
% Revised: -----
% Classification: Unclassified
% Reverence:GOES R SERIES PRODUCT DEFINITION AND USERS GUIDE (PUG)
% Version 2.2 Page 21-25

% Variable  Definition
%   req     goes_imagery_projection:semi_major_axis = 6378137 (meters)
%   finv    goes_imagery_projection:inverse_flattening=298.257222096
%   rpol    goes_imagery_projection:semi_minor_axis = 6356752.31414 (meters)
%   econst  0.0818191910435
%   sat_h   goes_imagery_projection:perspective_point_height = 35786023 (meters)
%   H       goes_imagery projection=42164160;
global goesImagerS;
req=goesImagerS.semi_major_axis;
rpol=goesImagerS.semi_minor_axis;
finv=goesImagerS.inverse_flattening;
ppheight=goesImagerS.perspective_point_height;
H=goesImagerS.perspective_point_height + goesImagerS.semi_major_axis;
% at=1.000061039;
% bt=-83921070.03;
% ct=1.73714E+15;
% rst=37116295.87;
% sxt=36937048.73;
% syt=892635.0779;
% szt=3532287.213;
% Variable Values
%req=6378137;% retrieved
%finv=298.257222096;%retrieved

%rpol=6356752.31414;% retrieved
ratio=req^2/rpol^2;
%H=42164160;
Lon0=goesImagerS.longitude_of_projection_origin;
Lat0=goesImagerS.latitude_of_projection_origin;
Lon0=Lon0*(pi/180);
Lat0=Lat0*(pi/180);
GeodLat=0.0;
GeodLon=0.0;
GeodLatTrue=33.846162;
GeodLonTrue=-84.690932;
% Now compute Sx Sy and Sz
paren=(cos(y))^2 + ratio*(sin(y))^2;
a=(sin(x))^2 + paren*(cos(x))^2;
b=-2*H*cos(x)*cos(y);
c=H^2-req^2;
% rs1=-b-sqrt((b^2)-4*a*c); % Does not work correctly
% rs=rs1/2*a;
rs=(-b-sqrt((b^2)-4*a*c))/(2*a);% This works SMF April 12,2021
Sx=rs*cos(x)*cos(y);
Sy=-rs*sin(x);
Sz=rs*cos(x)*sin(y);
GeodLat=atan(ratio*(Sz/sqrt(((H-Sx)^2)+Sy^2)));
GeodLon=Lon0-atan(Sy/(H-Sx));
GeodLat=(180/pi)*GeodLat;
GeodLon=(180/pi)*GeodLon;
% aerror=100*(at-a)/at;
% berror=100*(bt-b)/bt;
% cerror=100*(ct-c)/ct;
% rerror=100*(rst-rs)/rst;
% sxerror=100*(sxt-Sx)/sxt;
% syerror=100*(syt-Sy)/syt;
% szerror=100*(szt-Sz)/szt;
% dispstr=strcat('a=',num2str(a,11),'-at=',num2str(at,11));
% disp(dispstr)
% dispstr=strcat('b=',num2str(b,11),'-bt=',num2str(bt,11));
% disp(dispstr)
% dispstr=strcat('c=',num2str(c,'%.5E'),'-ct=',num2str(ct,'%.5E'));
% disp(dispstr)
% dispstr=strcat('rs=',num2str(rs,11),'-rst=',num2str(rst,11));
% disp(dispstr)
% dispstr=strcat('aerror=',num2str(aerror,6));
% disp(dispstr);
% dispstr=strcat('berror=',num2str(berror,6));
% disp(dispstr);
% dispstr=strcat('cerror=',num2str(cerror,6));
% disp(dispstr);
% dispstr=strcat('rerror=',num2str(rerror,6));
% disp(dispstr);
% dispstr=strcat('sxerror=',num2str(sxerror,6));
% disp(dispstr);
% dispstr=strcat('syerror=',num2str(syerror,6));
% disp(dispstr);
% dispstr=strcat('szerror=',num2str(szerror,6));
% disp(dispstr);
% LatError=100*(GeodLatTrue-GeodLat)/GeodLatTrue;
% LonError=100*(GeodLonTrue-GeodLon)/GeodLonTrue;
% dispstr=strcat('LatError=',num2str(LatError,6));
% disp(dispstr)
% dispstr=strcat('LonError=',num2str(LonError,6));
% disp(dispstr)
ab=1;
end

