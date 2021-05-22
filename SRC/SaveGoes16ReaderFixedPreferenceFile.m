function SaveGoes16ReaderFixedPreferenceFile(handles)
% This function will save the fixed paths for the GOES 16 Reader
% Written By: Stephen Forczyk
% Created: April 3,2021
% Revised: ---
% Classification: Unclassified




global initialtimestr igrid ijpeg ilog imovie;
global legendstr1 legendstr2 legendstr3;
global fid fid2 fid3;
global vert1 hor1 widd lend;
global vert2 hor2 widd2 lend2 machine;
global chart_time;
global Fz1 Fz2;
global idirector mov izoom iwindow;
global idirector mov izoom iwindow;
global matpath1 mappath matlabpath USshapefilepath dtedpath;
global jpegpath northamericalakespath logpath pdfpath govjpegpath;
global GOES16Band1path GOES16Band2path GOES16Band3path GOES16Band4path;
global GOES16Band5path GOES16Band6path GOES16Band7path GOES16Band8path
global GOES16Band9path GOES16Band10path GOES16Band11path GOES16Band12path;
global GOES16Band13path GOES16Band14path GOES16Band15path GOES16Band16path;
global GOES16CloudTopHeightpath GOES16CloudTopTemppath GOES16Lightningpath;
global GOES16ConusBand1path shapefilepath countryshapepath figpath;
global gridpath countyshapepath nationalshapepath summarypath;
global pwdnow;


runtimestr=datestr(now);
eval(['cd ' matlabpath(1:length(matlabpath))]);
actionstr='save';
varstr1='mappath matlabpath USshapefilepath';
varstr2=' dtedpath countyshapepath nationalshapepath northamericalakespath';
varstr3='govjpegpath logpath';
% varstr3=' screencapturepath shapepath2 countrypath';
% varstr4=' countryshapepath stateshapepath';
% varstr5=' bandsigspath inputpath sumarysigspath';
% varstr6=' tpvfluxpath sumrytrjpath thermalpath';
% varstr7=' sumrytmppath sumryshppath facetpath';
% varstr8=' thrmvurpath outputpath';
% varstr9=' AirBaseFile CityFileName MDAFile MaxMDACode MaxCityRank';
% varstr10=' OceanShapeFile RiverShapeFile LakesShapeFile topofile';
% varstr11=' MinorIslandsShapeFile USMilBasesShapeFile DateLineShapeFile';
% varstr12=' MapListFile2 MapListFile3';
% varstr13=' GlobalCameraHeightSFactor iplotcities';
% varstr14=' camera_view_angle camlatoffset camlonoffset';
% varstr15=' globeMLineLocation globePLineLocation';
% varstr16=' camlighton camlightaz camlightel';
% varstr17=' globemaxcities globecityaltdisp globecitylatdisp globecitylondisp';
% varstr18=' globemapangseplimit';
% varstr19=' DetailMapLimits DetailMapChoices DetailMapSelection DetailMapSelectionStr';
% varstr20=' DetailPlotMinorIslands DetailPlotWorldLakes DetailPlotCities';
% varstr21=' DetailDefendedAreas DetailMDAFacilities DetailAirBases';
% varstr22=' DetailRiverShapeFiles DetailRoadShapeFiles DetailRRShapeFiles';
% varstr23=' iDrawBullsEye';
FilterSpec='*PreferenceFile.mat';
DialogTitle='Save a Preference File';
DefaultName='Goes16PreferenceFile.mat';
[FileName,PathName,FilterIndex] = uiputfile(FilterSpec,DialogTitle,DefaultName);
CurrentPrefFile=FileName;
% varstr=strcat(varstr1,varstr2,varstr3,varstr4,varstr5,varstr6,varstr7,varstr8);
% varstr=strcat(varstr,varstr9,varstr10,varstr11,varstr12);
% varstr=strcat(varstr,varstr13,varstr14,varstr15,varstr16,varstr17,varstr18);
% varstr=strcat(varstr,varstr19,varstr20,varstr21,varstr22,varstr23);
varstr=strcat(varstr1,varstr2,varstr3);
eval(['cd ' PathName(1:length(PathName))]);
[cmdString]=MyStrcat(actionstr,FileName,varstr);
eval(cmdString);
dispstr=strcat('Saved GOES16ReaderPreferenceFile-',FileName);
disp(dispstr)
end