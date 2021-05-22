% This script will set up the fixed paths to use in the ReadGOES16Datasets
% script
% Created: April 3,2021
% Written By: Stephen Forczyk
% Revised: -----
% Classification: Unclassified

global fid;
global widd2 lend2;
global initialtimestr igrid ijpeg ilog imovie;
global vert1 hor1 widd lend;
global vert2 hor2 machine;
global chart_time;
global Fz1 Fz2;
global idirector mov izoom iwindow;

global matpath GOES16path;
global jpegpath tiffpath;
global smhrpath excelpath ascpath;
global ipowerpoint PowerPointFile scaling stretching padding;
global ichartnum;
global ColorList RGBVals ColorList2 xkcdVals LandColors;
global orange bubblegum brown brightblue;
% globals related to fixed files
global CountyBoundaryFile NationalCountiesShp UrbanAreasShapeFile;
global USAStatesFileName NorthAmericaLakes
% additional paths needed for mapping
global matpath1 mappath matlabpath USshapefilepath dtedpath;
global jpegpath northamericalakespath logpath pdfpath govjpegpath;
global GOES16Band1path GOES16Band2path GOES16Band3path GOES16Band4path;
global GOES16Band5path GOES16Band6path GOES16Band7path GOES16Band8path
global GOES16Band9path GOES16Band10path GOES16Band11path GOES16Band12path;
global GOES16Band13path GOES16Band14path GOES16Band15path GOES16Band16path;
global GOES16CloudTopHeightpath GOES16CloudTopTemppath GOES16Lightningpath;
global GOES16ConusBand1path shapefilepath Countryshapepath figpath;
global mappath gridpath countyshapepath nationalshapepath summarypath;
global DayMonthNonLeapYear DayMonthLeapYear CalendarFileName;
global pwd;
clc
% Set up some fixed paths for the data
mappath='D:\Forczyk\Map_Data\Matlab_Maps\';
matlabpath='D:\Goes16\Matlab_Data\';
CalendarFileName='CalendarDays.mat';
shapefilepath='D:\Goes16\ShapeFiles\';
dtedpath='F:\DTED\';
countyshapepath='D:\Forczyk\Map_Data\MAT_Files_Geographic\';
CountyBoundaryFile='CountyBoundingBoxes';
nationalshapepath='D:\Forczyk\Map_Data\NationalShapeFiles\';
NationalCountiesShp='cb_2018_us_county_500k.shp';
UrbanAreasShapeFile='cb_2018_us_ua10M_500k.shp';
USAStatesFileName='USAStatesShapeFileMapListRev4.mat';
USshapefilepath='D:\Forczyk\Map_Data\USStateShapeFiles\';
northamericalakespath='D:\Forczyk\Map_Data\Natural_Earth\Ten_Meter_Physical\';
NorthAmericaLakes='ne_10m_lakes_north_america.shp';
GOES16path='D:\Goes16\Imagery\July25_2020\Band01\';
GOES16Lightningpath='D:\Goes16\All_Other_Data\GLM_L2_Lightning_Detection\';
jpegpath='D:\Goes16\Imagery\Aug26_2020\Jpeg_Files\';
pdfpath='D:\Goes16\Imagery\Aug26_2020\PDF_Files\';
govjpegpath='D:\Goes16\Documents\Jpeg\';
figpath='D:\Goes16\Imagery\Oct_FigFiles\';
logpath='D:\Goes16\Log_Files\';
summarypath='D:\Goes16\Summary_Files\';
tiffpath='D:\Forczyk\Map_Data\InterstateSigns\';
FireSummaryFile='SummaryFileData.mat';
pret=which('ReadGoes16Datasets.m');
[islash]=strfind(pret,'\');
numslash=length(islash);
is=1;
ie=islash(numslash);
pwd=pret(is:ie);

Fixedpathdefinition_gui();