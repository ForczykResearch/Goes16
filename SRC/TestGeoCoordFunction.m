% This script will test the CalculateGeoCoord Function

% Written By:Stephen Forczyk
% Created: Mar 28,2021
% Revised: April 12,2021 lookimng for source of minor inaccuracies
% Classification: Unclassified
clc
GeodLatTrue=33.846162;
GeodLonTrue=-84.690932;
x=-0.024052;
y= 0.095340;
[GeodLat,GeodLon] = CalculateGeodCoordFromXYPos(x,y);
LatError=100*(GeodLatTrue-GeodLat)/GeodLatTrue;
LonError=100*(GeodLonTrue-GeodLon)/GeodLonTrue;
dispstr=strcat('LatError=',num2str(LatError,6));
disp(dispstr)
dispstr=strcat('LonError=',num2str(LonError,6));
disp(dispstr)
dispstr=strcat('GeodLatTrue=',num2str(GeodLatTrue,6),'-GeoLatCalc=',num2str(GeodLat,6));
disp(dispstr)
dispstr=strcat('GeodLonTrue=',num2str(GeodLonTrue,6),'-GeoLonCalc=',num2str(GeodLon,6));
disp(dispstr)

