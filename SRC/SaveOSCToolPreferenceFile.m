function SaveOSCToolPreferenceFile(handles)
% This function will save the Fan Analysis program preference file whenever
% called
% Written By: Stephen Forczyk
% Created: Dec 2,2017
% Revised: Feb 14,2018 added facetpath sumrytmppath and sumryshp paths
% Revised: March 5,2018 added thrmvurpath and outputpath and place for
% gradpath
% Classification: Unclassified


global GlobalCameraHeightSFactor iplotcities;
global camera_view_angle;
global camlatoffset camlonoffset;
global globeMLineLocation globePLineLocation;
global ichanged1 ichanged2 ichanged3 ichanged4;
global camlighton camlightaz camlightel;
global globemaxcities globecityaltdisp globecitylatdisp globecitylondisp;
global globemapangseplimit;
% File Name Variables
global AirBaseFile CityFileName MDAFile MaxMDACode MaxCityRank;
global OceanShapeFile RiverShapeFile LakesShapeFile topofile;
global MinorIslandsShapeFile USMilBasesShapeFile DateLineShapeFile;
global MapListFile2 MapListFile3;

% Detailed Map Variables
global DetailMapLimits DetailMapChoices DetailMapSelection DetailMapSelectionStr;
global DetailPlotMinorIslands DetailPlotWorldLakes DetailPlotCities;
global DetailDefendedAreas DetailMDAFacilities DetailAirBases;
global DetailRiverShapeFiles DetailRoadShapeFiles DetailRRShapeFiles;
global iBullsEye iBullsEyeStart iBullsEyeInc iDrawBullsEye;
% The following preferences are specifically for the Asset Map only
global MapProjectionTypeAsset AssetPlotMinorIslands AssetPlotWorldLakes;
global AssetPlotCities AssetDefendedAreas AssetMDAFacilities;
global AssetAirBases AssetRiverShapeFiles AssetRoadShapeFiles;
global AssetRRShapeFiles;

global initialtimestr igrid ijpeg ilog imovie;
global legendstr1 legendstr2 legendstr3;
global fid fid2 fid3;
global vert1 hor1 widd lend;
global vert2 hor2 widd2 lend2 machine;
global chart_time;
global Fz1 Fz2;
global idirector mov izoom iwindow;
global matpath matpath1;
global jpegpath mappath topopath;
global fanpath excelpath trajpath militarypath;
global figpath matlabfanpath screencapturepath;
global shapepath2 countrypath prefpath;
global docpath htmlpath libarypath;
global countryshapepath stateshapepath;
global sumrytmppath sumryshppath facetpath;
global ipowerpoint PowerPointFile scaling stretching padding;
global statistics_toolbox signal_toolbox;
global ichartnum;
global MatlabVersion;
global CurrentPrefFile;

global bandsigspath sumarysigspath;
global tpvfluxpath sumrytrjpath;
global thermalpath ;
global inputpath librarypath ;
global gradpath thrmvurpath outputpath;
runtimestr=datestr(now);
eval(['cd ' librarypath(1:length(librarypath))]);
actionstr='save';
varstr1='matpath matpath1 mappath topopath librarypath';
varstr2=' trajpath militarypath inputpath';
varstr3=' screencapturepath shapepath2 countrypath';
varstr4=' countryshapepath stateshapepath';
varstr5=' bandsigspath inputpath sumarysigspath';
varstr6=' tpvfluxpath sumrytrjpath thermalpath';
varstr7=' sumrytmppath sumryshppath facetpath';
varstr8=' thrmvurpath outputpath';
varstr9=' AirBaseFile CityFileName MDAFile MaxMDACode MaxCityRank';
varstr10=' OceanShapeFile RiverShapeFile LakesShapeFile topofile';
varstr11=' MinorIslandsShapeFile USMilBasesShapeFile DateLineShapeFile';
varstr12=' MapListFile2 MapListFile3';
varstr13=' GlobalCameraHeightSFactor iplotcities';
varstr14=' camera_view_angle camlatoffset camlonoffset';
varstr15=' globeMLineLocation globePLineLocation';
varstr16=' camlighton camlightaz camlightel';
varstr17=' globemaxcities globecityaltdisp globecitylatdisp globecitylondisp';
varstr18=' globemapangseplimit';
varstr19=' DetailMapLimits DetailMapChoices DetailMapSelection DetailMapSelectionStr';
varstr20=' DetailPlotMinorIslands DetailPlotWorldLakes DetailPlotCities';
varstr21=' DetailDefendedAreas DetailMDAFacilities DetailAirBases';
varstr22=' DetailRiverShapeFiles DetailRoadShapeFiles DetailRRShapeFiles';
varstr23=' iDrawBullsEye';
FilterSpec='*PreferenceFile.mat';
DialogTitle='Save a Preference File';
DefaultName='MyPreferenceFile.mat';
[FileName,PathName,FilterIndex] = uiputfile(FilterSpec,DialogTitle,CurrentPrefFile);
CurrentPrefFile=FileName;
varstr=strcat(varstr1,varstr2,varstr3,varstr4,varstr5,varstr6,varstr7,varstr8);
varstr=strcat(varstr,varstr9,varstr10,varstr11,varstr12);
varstr=strcat(varstr,varstr13,varstr14,varstr15,varstr16,varstr17,varstr18);
varstr=strcat(varstr,varstr19,varstr20,varstr21,varstr22,varstr23);
eval(['cd ' PathName(1:length(PathName))]);
[cmdString]=MyStrcat(actionstr,FileName,varstr);
eval(cmdString);
outstr1=strcat('Saved OSCToolPreferenceFile-',FileName);
UpdateMessageBox(outstr1,handles);
end