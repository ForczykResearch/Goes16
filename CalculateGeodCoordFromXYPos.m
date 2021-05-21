function [GeodLat,GeodLon] = CalculateGeodCoordFromXYPos(x,y)
% This function is intended to calculate the Geodetic Coordinates of the XY
% scan Position valaues for the GOES satelllite series
% 
% Written By: Stephen Forczyk
% Created: March 25,2021
% Revised:------
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

% Variable Values
req=6378137;
finv=298.257222096;
rpol=6356752.31414;
ratio=req^2/rpol^2;
H=42164160;
Lon0=-75/(180/pi);
GeodLat=0.0;
GeodLon=0.0;
% Now compute Sx Sy and Sz
paren=(cos(y))^2 + ratio*(sin(y))^2;
a=(sin(x))^2 + paren*(cos(x))^2;
b=-2*H*cos(x)*cos(y);
c=H^2-req^2;
rs1=-b-sqrt((b^2)-4*a*c);
rs=rs1/2*a;
Sx=rs*cos(x)*cos(y);
Sy=-rs*sin(x);
Sz=rs*cos(x)*sin(y);
GeodLat=atan(ratio*(Sz/sqrt(((H-Sx)^2)+Sy^2)));
GeodLon=Lon0-atan(Sy/(H-Sx));
GeodLat=(180/pi)*GeodLat;
GeodLon=(180/pi)*GeodLon;

end

