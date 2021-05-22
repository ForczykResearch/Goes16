function DisplayCMIConusDataRev1(CMI,GeoRef,titlestr)
% Display the CMI Moisture Data from the GOES16/17 data
% on a texture map for the USA
% Written By: Stephen Forczyk
% Created: August 5,2020
% Revised: -----
% Classification: Unclassified
global BandDataS MetaDataS;
global CMIS DQFS tS yS xS tBS goesImagerS yImgS yImgBS;
global xImgS xImgBS SatDataS GeoSpatialS;
global ReflectanceS AlgoS ErrorS EarthSunS VersionContainerS;
global GoesWaveBand ESunS kappa0S PlanckS FocalPlaneS;
global HTS DQF1S OutlierPS CloudTopS Algo1S ProcessParamS;
global LZAS LZABS SZAS SZABS Error1S CloudPixelsS;
global GOESFileName;
global westEdge eastEdge northEdge southEdge;
global MonthDayStr MonthDayYearStr;
global DayMonthNonLeapYear DayMonthLeapYear CalendarFileName;

global widd2 lend2;
global initialtimestr igrid ijpeg ilog imovie;
global vert1 hor1 widd lend;
global vert2 hor2 machine;
global chart_time;
global Fz1 Fz2;
global idirector mov izoom iwindow;
global matpath GOES16path;
global jpegpath ;
global smhrpath excelpath ascpath;
global ipowerpoint PowerPointFile scaling stretching padding;
global ichartnum;
% additional paths needed for mapping
global matpath1 mappath;
global canadapath stateshapepath topopath;
global trajpath militarypath;
global figpath screencapturepath;
global shapepath2 countrypath countryshapepath usstateboundariespath;
global GOES16Band1path GOES16Band2path GOES16Band3path GOES16Band4path;
global GOES16Band5path GOES16Band6path GOES16Band7path GOES16Band8path
global GOES16Band9path GOES16Band10path GOES16Band11path GOES16Band12path;
global GOES16Band13path GOES16Band14path GOES16Band15path GOES16Band16path;
global GOES16CloudTopHeightpath;

% Now plot the CMI as a texture map
% worldmap(CMI,GeoRef);
% geoshow(CMI,GeoRef,'DisplayType','texturemap')
% demcmap(CMI)
% hold on
% eval(['cd ' jpegpath(1:length(jpegpath)-1)]);
% load('USAHiResBoundaries.mat');
% plotm(USALat,USALon,'r');
% set(gcf,'Position',[hor1 vert1 widd lend])
% axesm ('ortho', 'Frame', 'on', 'Grid', 'on');

axesm ('mercator','Frame','on','Grid','on','MapLatLimit',[southEdge northEdge],...
    'MapLonLimit',[westEdge eastEdge],'meridianlabel','on','parallellabel','on','plabellocation',2,'mlabellocation',2);
gridm('GLineStyle','-','Gcolor',[.8 .7 .6],'Galtitude',.002,'MLineLocation',2,...
    'PLineLocation',2)
geoshow(CMI,GeoRef,'DisplayType','texturemap')
demcmap(CMI)
hold on
eval(['cd ' mappath(1:length(mappath)-1)]);
load('USAHiResBoundaries.mat');
plotm(USALat,USALon,'r');
load('CanadaBoundaries.mat');
plotm(CanadaLat,CanadaLon,'w');
load('MexicoBoundaries.mat');
plotm(MexicoLat,MexicoLon,'y');
load('CubaBoundaries.mat');
plotm(CubaLat,CubaLon,'r-');
load('DominicanRepublicBoundaries.mat');
plotm(DRLat,DRLon,'r-');
load('HaitiBoundaries.mat');
plotm(HaitiLat,HaitiLon,'y-');
load('BelizeBoundaries.mat');
plotm(BelizeLat,BelizeLon,'y-');
load('GautemalaBoundaries.mat');
plotm(GautemalaLat,GautemalaLon,'g')
load('JamaicaBoundaries.mat');
plotm(JamaicaLat,JamaicaLon,'r')
set(gcf,'Position',[hor1 vert1 widd lend])
title(titlestr)
hold off
colorbar;
% Save this chart
figstr=strcat(titlestr,'.jpg');
eval(['cd ' jpegpath(1:length(jpegpath)-1)]);
actionstr='print';
typestr='-djpeg';
[cmdString]=MyStrcat2(actionstr,typestr,figstr);
eval(cmdString);
pause(chart_time);
close('all');
end


