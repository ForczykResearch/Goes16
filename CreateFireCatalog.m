% This executive script is to read a folder full of fire hot spot data
% generated from the GOES-16 data and create a state level catalog for the
% fires in each file
% Created: Oct 28,2020
% Written By: Stephen Forczyk
% Revised:
% Classification: Unclassified/Public Domain
global Datasets;
global FireResults ExcelCatalogFile icatalogRec FireHeaders TabName;
global FireDetails;
global StateFIPCodeFile StateFIPSCodes; 
global BandDataS MetaDataS;
global CMIS DQFS tS yS xS tBS goesImagerS yImgS yImgBS;
global xImgS xImgBS SatDataS GeoSpatialS;
global ReflectanceS AlgoS ErrorS EarthSunS VersionContainerS;
global GoesWaveBand ESunS kappa0S PlanckS FocalPlaneS;
global GOESFileName;
global GOES16BandPaths;
global isaveGOESLightningData isaveCMI;
global CountyBoundaryFile;
global CountyBoundaries ;
global StateFIPSCodes NationalCountiesShp;
global USAStatesShapeFileList USAStatesFileName;
global UrbanAreasShapeFile NorthAmericaLakes FireSummaryFile;
global idebug isavefiles;
global iPrimeRoads iCountyRoads iCommonRoads iStateRecRoads iUSRoads iStateRoads;
global iLakes;

global fid;
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
global ColorList RGBVals ColorList2 xkcdVals LandColors;
global orange bubblegum brown brightblue;
% additional paths needed for mapping
global matpath1 mappath matlabpath catalogpath;
global firehotspotpath northamericalakespath logpath;
global GOES16Band1path GOES16Band2path GOES16Band3path GOES16Band4path;
global GOES16Band5path GOES16Band6path GOES16Band7path GOES16Band8path
global GOES16Band9path GOES16Band10path GOES16Band11path GOES16Band12path;
global GOES16Band13path GOES16Band14path GOES16Band15path GOES16Band16path;
global GOES16CloudTopHeightpath GOES16CloudTopTemppath GOES16Lightningpath;
global GOES16ConusBand1path shapefilepath Countryshapepath;
global mappath gridpath countyshapepath nationalshapepath summarypath;
global DayMonthNonLeapYear DayMonthLeapYear CalendarFileName;

% Set some flags
% isaveGOESLightningData=0;
% isaveCMI=0;
idebug=0;
isavefiles=0;
icatalogRec=0;
ExcelCatalogFile='Aug25_2020_FireCatalog.xlsx';
clc;
% Set up some fixed paths for the data
catalogpath='D:\Goes16\Catalog_Files\';
mappath='D:\Forczyk\Map_Data\';
matlabpath='D:\Goes16\Matlab_Data\';
CalendarFileName='CalendarDays.mat';
shapefilepath='D:\Goes16\ShapeFiles\';
countyshapepath='D:\Forczyk\Map_Data\MAT_Files_Geographic\';
CountyBoundaryFile='CountyBoundingBoxes';
nationalshapepath='D:\Forczyk\Map_Data\NationalShapeFiles\';
NationalCountiesShp='cb_2018_us_county_500k.shp';
UrbanAreasShapeFile='cb_2018_us_ua10M_500k.shp';
USAStatesFileName='USAStatesShapeFileMapListRev4.mat';
northamericalakespath='D:\Forczyk\Map_Data\Natural_Earth\Ten_Meter_Physical\';
NorthAmericaLakes='ne_10m_lakes_north_america.shp';
GOES16path='D:\Goes16\Imagery\July25_2020\Band01\';
GOES16Lightningpath='D:\Goes16\All_Other_Data\GLM_L2_Lightning_Detection\';
jpegpath='D:\Goes16\Imagery\Oct_Jpeg2\';
logpath='D:\Goes16\Log_Files\';
summarypath='D:\Goes16\Summary_Files\';
FireSummaryFile='SummaryFileData.mat';
StateFIPCodeFile='StateFIPCodeDataRev1.mat';
FireResults=cell(1,1);
FireHeaders=cell(1,1);
FireResults{1,1}='File Name';
FireResults{1,2}='Year';
FireResults{1,3}='Day';
FireResults{1,4}='Hour';
FireResults{1,5}='Min';
FireResults{1,6}='Sec';
FireResults{1,7}='MonthDayStr';
FireResults{1,8}='Spare1';
FireResults{1,9}='Spare2';
FireResults{1,10}='Spare3';
FireResults{1,11}='Alabama';
FireResults{1,12}='Alaska';
FireResults{1,13}='Arizona';
FireResults{1,14}='Arkansas';
FireResults{1,15}='California';
FireResults{1,16}='Colorado';
FireResults{1,17}='Connecticut';
FireResults{1,18}='Delaware';
FireResults{1,19}='Florida';
FireResults{1,20}='Georgia';
FireResults{1,21}='Hawaii';
FireResults{1,22}='Idaho';
FireResults{1,23}='Illinois';
FireResults{1,24}='Indiana';
FireResults{1,25}='Iowa';
FireResults{1,26}='Kansas';
FireResults{1,27}='Kentucky';
FireResults{1,28}='Louisiana';
FireResults{1,29}='Maine';
FireResults{1,30}='Maryland';
FireResults{1,31}='Massachusetts';
FireResults{1,32}='Michigan';
FireResults{1,33}='Minnesota';
FireResults{1,34}='Mississippi';
FireResults{1,35}='Missouri';
FireResults{1,36}='Montana';
FireResults{1,37}='Nebraska';
FireResults{1,38}='Nevada';
FireResults{1,39}='New Hampshire';
FireResults{1,40}='New Jersey';
FireResults{1,41}='New Mexico';
FireResults{1,42}='New York';
FireResults{1,43}='North Carolina';
FireResults{1,44}='North Dakota';
FireResults{1,45}='Ohio';
FireResults{1,46}='Oklahoma';
FireResults{1,47}='Oregon';
FireResults{1,48}='Pennsylvania';
FireResults{1,49}='Rhode Island';
FireResults{1,50}='South Carolina';
FireResults{1,51}='South Dakota';
FireResults{1,52}='Tennessee';
FireResults{1,53}='Texas';
FireResults{1,54}='Utah';
FireResults{1,55}='Vermont';
FireResults{1,56}='Virginia';
FireResults{1,57}='Washington';
FireResults{1,58}='West Virginia';
FireResults{1,59}='Wisconsin';
FireResults{1,60}='Wyoming';
FireHeaders=FireResults;
GOES16BandPaths=cell(1,1);
GOES16BandPaths{1,1}='D:\Goes16\Imagery\July25_2020\Band01\';
GOES16BandPaths{2,1}='D:\Goes16\Imagery\July25_2020\Band02\';
GOES16BandPaths{3,1}='D:\Goes16\Imagery\July25_2020\Band03\';
GOES16BandPaths{4,1}='D:\Goes16\Imagery\July25_2020\Band04\';
GOES16BandPaths{5,1}='D:\Goes16\Imagery\July25_2020\Band05\';
GOES16BandPaths{6,1}='D:\Goes16\Imagery\July25_2020\Band06\';
GOES16BandPaths{7,1}='D:\Goes16\Imagery\July25_2020\Band07\';
GOES16BandPaths{8,1}='D:\Goes16\Imagery\July25_2020\Band08\';
GOES16BandPaths{9,1}='D:\Goes16\Imagery\July25_2020\Band09\';
GOES16BandPaths{10,1}='D:\Goes16\Imagery\July25_2020\Band10\';
GOES16BandPaths{11,1}='D:\Goes16\Imagery\July25_2020\Band11\';
GOES16BandPaths{12,1}='D:\Goes16\Imagery\July25_2020\Band12\';
GOES16BandPaths{13,1}='D:\Goes16\Imagery\July25_2020\Band13\';
GOES16BandPaths{14,1}='D:\Goes16\Imagery\July25_2020\Band14\';
GOES16BandPaths{15,1}='D:\Goes16\Imagery\July25_2020\Band15\';
GOES16BandPaths{16,1}='D:\Goes16\Imagery\July25_2020\Band16\';
GOES16BandPaths{17,1}='D:\Goes16\All_Other_Data\CONUS_Cloud_Top_Heights\July25_2020\';
GOES16BandPaths{18,1}='D:\Goes16\All_Other_Data\ABI_L2_Cloud_Top_Temperature\';
GOES16BandPaths{19,1}='D:\Goes16\Imagery\Aug26_2020\CONUS_GLM_Flash_Data\';
GOES16BandPaths{20,1}='D:\Goes16\CONUS_Images\July25_2020\Band01\';
GOES16BandPaths{21,1}='D:\Goes16\CONUS_Images\July25_2020\Band02\';
GOES16BandPaths{22,1}='D:\Goes16\CONUS_Images\July25_2020\Band03\';
GOES16BandPaths{23,1}='D:\Goes16\CONUS_Images\July25_2020\Band04\';
GOES16BandPaths{24,1}='D:\Goes16\CONUS_Images\July25_2020\Band05\';
GOES16BandPaths{25,1}='D:\Goes16\CONUS_Images\July25_2020\Band06\';
GOES16BandPaths{26,1}='D:\Goes16\CONUS_Images\July25_2020\Band07\';
GOES16BandPaths{27,1}='D:\Goes16\CONUS_Images\July25_2020\Band08\';
GOES16BandPaths{28,1}='D:\Goes16\CONUS_Images\July25_2020\Band09\';
GOES16BandPaths{29,1}='D:\Goes16\CONUS_Images\July25_2020\Band10\';
GOES16BandPaths{30,1}='D:\Goes16\CONUS_Images\July25_2020\Band11\';
GOES16BandPaths{31,1}='D:\Goes16\CONUS_Images\July25_2020\Band12\';
GOES16BandPaths{32,1}='D:\Goes16\CONUS_Images\July25_2020\Band13\';
GOES16BandPaths{33,1}='D:\Goes16\CONUS_Images\July25_2020\Band14\';
GOES16BandPaths{34,1}='D:\Goes16\CONUS_Images\July25_2020\Band15\';
GOES16BandPaths{35,1}='D:\Goes16\CONUS_Images\July25_2020\Band16\';
GOES16BandPaths{36,1}='D:\Goes16\CONUS_Images\July25_2020\MultiBand\';
GOES16BandPaths{37,1}='D:\Goes16\MesoScale1\July25_2020\Band01\';
GOES16BandPaths{38,1}='D:\Goes16\MesoScale1\July25_2020\Band02\';
GOES16BandPaths{39,1}='D:\Goes16\MesoScale1\July25_2020\Band03\';
GOES16BandPaths{40,1}='D:\Goes16\MesoScale1\July25_2020\Band04\';
GOES16BandPaths{41,1}='D:\Goes16\MesoScale1\July25_2020\Band05\';
GOES16BandPaths{42,1}='D:\Goes16\MesoScale1\July25_2020\Band06\';
GOES16BandPaths{43,1}='D:\Goes16\MesoScale1\July25_2020\Band07\';
GOES16BandPaths{44,1}='D:\Goes16\MesoScale1\July25_2020\Band08\';
GOES16BandPaths{45,1}='D:\Goes16\MesoScale1\July25_2020\Band09\';
GOES16BandPaths{46,1}='D:\Goes16\MesoScale1\July25_2020\Band10\';
GOES16BandPaths{47,1}='D:\Goes16\MesoScale1\July25_2020\Band11\';
GOES16BandPaths{48,1}='D:\Goes16\Imagery\Aug26_2020\MultiBand_CONUS\';
GOES16BandPaths{49,1}='D:\Goes16\Forczyk_Python\';
GOES16BandPaths{50,1}='D:\Goes16\Imagery\Aug26_2020\MultiBand_FullDisk\';
GOES16BandPaths{51,1}='D:\Goes16\Imagery\Aug25_2020\CONUS_Cloud_Top_Heights\';
GOES16BandPaths{52,1}='D:\Goes16\Imagery\Aug25_2020\FullDisk_Cloud_Top_Heights\';
GOES16BandPaths{53,1}='D:\Goes16\Imagery\Aug26_2020\ABI_L2_Fire\';
GOES16Band1path='D:\Goes16\Imagery\July25_2020\Band01\';
GOES16Band2path='D:\Goes16\Imagery\July25_2020\Band02\';
GOES16Band3path='D:\Goes16\Imagery\July25_2020\Band03\';
GOES16Band4path='D:\Goes16\Imagery\July25_2020\Band04\';
GOES16Band5path='D:\Goes16\Imagery\July25_2020\Band05\';
GOES16Band6path='D:\Goes16\Imagery\July25_2020\Band06\';
GOES16Band7path='D:\Goes16\Imagery\July25_2020\Band07\';
GOES16Band8path='D:\Goes16\Imagery\July25_2020\Band08\';
GOES16Band9path='D:\Goes16\Imagery\July25_2020\Band09\';
GOES16Band10path='D:\Goes16\Imagery\July25_2020\Band10\';
GOES16Band11path='D:\Goes16\Imagery\July25_2020\Band11\';
GOES16Band12path='D:\Goes16\Imagery\July25_2020\Band12\';
GOES16Band13path='D:\Goes16\Imagery\July25_2020\Band13\';
GOES16Band14path='D:\Goes16\Imagery\July25_2020\Band14\';
GOES16Band15path='D:\Goes16\Imagery\July25_2020\Band15\';
GOES16Band16path='D:\Goes16\Imagery\July25_2020\Band16\';
GOES16CloudTopHeightpath='D:\Goes16\All_Other_Data\CONUS_Cloud_Top_Heights\July25_2020\';
GOES16CloudTopTemppath='D:\Goes16\All_Other_Data\ABI_L2_Cloud_Top_Temperature\';
matpath=GOES16path;
Countryshapepath='D:\Forczyk\Map_Data\CountryShapefiles\';
gridpath='D:\Goes16\Grids\';
Datasets=cell(1,1);
Datasets{1,1}='Full-ABI-L2-Imagery-Band-1';
Datasets{2,1}='Full-ABI-L2-Imagery-Band-2';
Datasets{3,1}='Full-ABI-L2-Imagery-Band-3';
Datasets{4,1}='Full-ABI-L2-Imagery-Band-4';
Datasets{5,1}='Full-ABI-L2-Imagery-Band-5';
Datasets{6,1}='Full-ABI-L2-Imagery-Band-6';
Datasets{7,1}='Full-ABI-L2-Imagery-Band-7';
Datasets{8,1}='Full-ABI-L2-Imagery-Band-8';
Datasets{9,1}='Full-ABI-L2-Imagery-Band-9';
Datasets{10,1}='Full-ABI-L2-Imagery-Band-10';
Datasets{11,1}='Full-ABI-L2-Imagery-Band-11';
Datasets{12,1}='Full-ABI-L2-Imagery-Band-12';
Datasets{13,1}='Full-ABI-L2-Imagery-Band-13';
Datasets{14,1}='Full-ABI-L2-Imagery-Band-14';
Datasets{15,1}='Full-ABI-L2-Imagery-Band-15';
Datasets{16,1}='Full-ABI-L2-Imagery-Band-16';
Datasets{17,1}='Do Not Use';
Datasets{18,1}='Full-ABI-Cloud Top Temperature';
Datasets{19,1}='CONUS-GLM-L2_Lightning*';
Datasets{20,1}='CONUS-ABI-L2-Imagery-Band-1';
Datasets{21,1}='CONUS-ABI-L2-Imagery-Band-2';
Datasets{22,1}='CONUS-ABI-L2-Imagery-Band-3';
Datasets{23,1}='CONUS-ABI-L2-Imagery-Band-4';
Datasets{24,1}='CONUS-ABI-L2-Imagery-Band-5';
Datasets{25,1}='CONUS-ABI-L2-Imagery-Band-6';
Datasets{26,1}='CONUS-ABI-L2-Imagery-Band-7';
Datasets{27,1}='CONUS-ABI-L2-Imagery-Band-8';
Datasets{28,1}='CONUS-ABI-L2-Imagery-Band-9';
Datasets{29,1}='CONUS-ABI-L2-Imagery-Band-10';
Datasets{30,1}='CONUS-ABI-L2-Imagery-Band-11';
Datasets{31,1}='CONUS-ABI-L2-Imagery-Band-12';
Datasets{32,1}='CONUS-ABI-L2-Imagery-Band-13';
Datasets{33,1}='CONUS-ABI-L2-Imagery-Band-14';
Datasets{34,1}='CONUS-ABI-L2-Imagery-Band-15';
Datasets{35,1}='CONUS-ABI-L2-Imagery-Band-16';
Datasets{36,1}='CONUS-ABI-L2-Imagery-MultiBand';
Datasets{37,1}='MesoScale1-ABI-L2-Imagery-Band01';
Datasets{38,1}='MesoScale1-ABI-L2-Imagery-Band02';
Datasets{39,1}='MesoScale1-ABI-L2-Imagery-Band03';
Datasets{40,1}='MesoScale1-ABI-L2-Imagery-Band04';
Datasets{41,1}='MesoScale1-ABI-L2-Imagery-Band05';
Datasets{42,1}='MesoScale1-ABI-L2-Imagery-Band06';
Datasets{43,1}='MesoScale1-ABI-L2-Imagery-Band07';
Datasets{44,1}='MesoScale1-ABI-L2-Imagery-Band08';
Datasets{45,1}='MesoScale1-ABI-L2-Imagery-Band09';
Datasets{46,1}='MesoScale1-ABI-L2-Imagery-Band10';
Datasets{47,1}='MesoScale1-ABI-L2-Imagery-Band11';
Datasets{48,1}='CONUS-ABI-L2-Imagery-Multiband*';
Datasets{49,1}='GEOS-Lat-Lon-CONUS-Grid';
Datasets{50,1}='FullDisk-ABI-L2-Imagery-Multiband*';
Datasets{51,1}='CONUS-Cloud-Top-Heights';
Datasets{52,1}='FullDisk-Cloud-Top-Heights';
Datasets{53,1}='ABI-L2-Fire';
% Set up some initial data
% Set up cell to hold generic GOES Waveband Data
GoesWaveBand=cell(17,5);
GoesWaveBand{1,1}='Band Num';
GoesWaveBand{1,2}='Resolution-km';
GoesWaveBand{1,3}='Wavelength-microns';
GoesWaveBand{1,4}='Spectrum';
GoesWaveBand{1,5}='Band Desc';
GoesWaveBand{2,1}=1;
GoesWaveBand{2,2}=1;
GoesWaveBand{2,3}=0.47;
GoesWaveBand{2,4}='Visible';
GoesWaveBand{2,5}='Blue Band';
GoesWaveBand{3,1}=2;
GoesWaveBand{3,2}=0.5;
GoesWaveBand{3,3}=0.64;
GoesWaveBand{3,4}='Visible';
GoesWaveBand{3,5}='Red Band';
GoesWaveBand{4,1}=3;
GoesWaveBand{4,2}=1;
GoesWaveBand{4,3}=0.86;
GoesWaveBand{4,4}='Near IR';
GoesWaveBand{4,5}='Red Band';
GoesWaveBand{5,1}=4;
GoesWaveBand{5,2}=2;
GoesWaveBand{5,3}=1.37;
GoesWaveBand{5,4}='Near-IR';
GoesWaveBand{5,5}='Cirrus Band';
GoesWaveBand{6,1}=5;
GoesWaveBand{6,2}=1;
GoesWaveBand{6,3}=1.60;
GoesWaveBand{6,4}='Near-IR';
GoesWaveBand{6,5}='Snow/Ice Band';
GoesWaveBand{7,1}=6;
GoesWaveBand{7,2}=2;
GoesWaveBand{7,3}=2.24;
GoesWaveBand{7,4}='Near-IR';
GoesWaveBand{7,5}='Cloud Particle Band';
GoesWaveBand{8,1}=7;
GoesWaveBand{8,2}=2;
GoesWaveBand{8,3}=3.90;
GoesWaveBand{8,4}='IR';
GoesWaveBand{8,5}='Short Wave Window Band';
GoesWaveBand{9,1}=8;
GoesWaveBand{9,2}=2;
GoesWaveBand{9,3}=6.20;
GoesWaveBand{9,4}='IR';
GoesWaveBand{9,5}='Upper Troposphere WV Band';
GoesWaveBand{10,1}=9;
GoesWaveBand{10,2}=2;
GoesWaveBand{10,3}=6.90;
GoesWaveBand{10,4}='IR';
GoesWaveBand{10,5}='Mid Level Troposphere WV Band';
GoesWaveBand{11,1}=10;
GoesWaveBand{11,2}=2;
GoesWaveBand{11,3}=7.30;
GoesWaveBand{11,4}='IR';
GoesWaveBand{11,5}='Low Level Troposphere WV Band';
GoesWaveBand{12,1}=11;
GoesWaveBand{12,2}=2;
GoesWaveBand{12,3}=8.40;
GoesWaveBand{12,4}='IR';
GoesWaveBand{12,5}='Cloud Top Phase Band';
GoesWaveBand{13,1}=12;
GoesWaveBand{13,2}=2;
GoesWaveBand{13,3}=9.60;
GoesWaveBand{13,4}='IR';
GoesWaveBand{13,5}='Ozone Band';
GoesWaveBand{14,1}=13;
GoesWaveBand{14,2}=2;
GoesWaveBand{14,3}=10.30;
GoesWaveBand{14,4}='IR';
GoesWaveBand{14,5}='Clean IR Longwave Band';
GoesWaveBand{15,1}=14;
GoesWaveBand{15,2}=2;
GoesWaveBand{15,3}=11.20;
GoesWaveBand{15,4}='IR';
GoesWaveBand{15,5}='IR Longwave Band';
GoesWaveBand{16,1}=15;
GoesWaveBand{16,2}=2;
GoesWaveBand{16,3}=12.30;
GoesWaveBand{16,4}='IR';
GoesWaveBand{16,5}='Dirty IR Longwave Band';
GoesWaveBand{17,1}=16;
GoesWaveBand{17,2}=2;
GoesWaveBand{17,3}=13.30;
GoesWaveBand{17,4}='IR';
GoesWaveBand{17,5}='CO2 IR Longwave Band';
icase=3;
if(icase==1)
    ExcelCatalogFile='Aug25_2020_FireCatalog.xlsx';
    TabName='Aug25_2020';
elseif(icase==2)
    ExcelCatalogFile='Sept_2020_FireCatalog.xlsx';
    TabName='Sept10_2020';
elseif(icase==3)
    ExcelCatalogFile='Sept_2020_FireCatalog.xlsx';
    TabName='Sept11_2020';
end
% Start writing a log file
eval(['cd ' logpath(1:length(logpath)-1)]);
startruntime=deblank(datestr(now));
startrunstr=strcat('Start Run GOES 16 Run at-',startruntime);
logfilename=startruntime;
logfiledbl=double(logfilename);
% find the blank spacein the date and replace it with a '-' to make a
% legalfilename
[iblank]=find(logfiledbl==32);
numblank=length(iblank);
for n=1:numblank
    is=iblank(n);
    ie=is;
    logfilename(is:ie)='-';
end
[icolon]=strfind(logfilename,':');
numcolon=length(icolon);
for n=1:numcolon
    is=icolon(n);
    ie=is;
    logfilename(is:ie)='-';
end
ab=1;
logfilename=strcat('LogFireFile-',logfilename,'.txt');
ab=2;
fid=fopen(logfilename,'w');
dispstr=strcat('Opened Log file-',logfilename,'-for writing');
disp(dispstr)
fprintf(fid,'%50s\n',startrunstr);

% Read Some needed data files
eval(['cd ' matlabpath(1:length(matlabpath)-1)]);
load(CalendarFileName);
% Load in the CountyBoundaryFiles
eval(['cd ' countyshapepath(1:length(countyshapepath)-1)]);
load('CountyBoundingBoxes.mat');
% Load in the list of USAStateShapeFiles
load(USAStatesFileName);
% Load in the State FIP Code data
load(StateFIPCodeFile);
% Set up some colors that will be used in later plots
[ColorList,RGBVals] = colornames('dvips');
[ColorList2,xkcdVals] = colornames('xkcd');
orange=[.9765 .4510 .0235];
bubblegum=[1 .4235 .7098];
brown=[.396 .263 .129];
brightblue=[.0039 .3961 .9882];
LandColors=zeros(16,3);
LandColors(1,1)=xkcdVals(6,1);% Almond
LandColors(1,2)=xkcdVals(6,2);
LandColors(1,3)=xkcdVals(6,3);
LandColors(2,1)=xkcdVals(10,1);% Apricot
LandColors(2,2)=xkcdVals(10,2);
LandColors(2,3)=xkcdVals(10,3);
LandColors(3,1)=xkcdVals(41,1);% Beige
LandColors(3,2)=xkcdVals(41,2);
LandColors(3,3)=xkcdVals(41,3);
LandColors(4,1)=xkcdVals(899,1);% Very Light Brown
LandColors(4,2)=xkcdVals(899,2);
LandColors(4,3)=xkcdVals(899,3);
LandColors(5,1)=xkcdVals(928,1);% Wheat
LandColors(5,2)=xkcdVals(928,2);
LandColors(5,3)=xkcdVals(928,3);
LandColors(6,1)=xkcdVals(45,1);% Bland
LandColors(6,2)=xkcdVals(45,2);
LandColors(6,3)=xkcdVals(45,3);
% LandColors(6,1)=xkcdVals(104,1);% Bronze
% LandColors(6,2)=xkcdVals(104,2);
% LandColors(6,3)=xkcdVals(104,3);
LandColors(7,1)=xkcdVals(110,1);% Brown Yellow
LandColors(7,2)=xkcdVals(110,2);
LandColors(7,3)=xkcdVals(110,3);
LandColors(8,1)=xkcdVals(136,1);% Butterscotch
LandColors(8,2)=xkcdVals(136,2);
LandColors(8,3)=xkcdVals(136,3);
LandColors(9,1)=xkcdVals(70,1);% Blush
LandColors(9,2)=xkcdVals(70,2);
LandColors(9,3)=xkcdVals(70,3);
% LandColors(9,1)=xkcdVals(177,1);% Copper
% LandColors(9,2)=xkcdVals(177,2);
% LandColors(9,3)=xkcdVals(177,3);
LandColors(10,1)=xkcdVals(947,1);% Yellowish Tan
LandColors(10,2)=xkcdVals(947,2);
LandColors(10,3)=xkcdVals(947,3);
LandColors(11,1)=xkcdVals(620,1);% Orange Yellow
LandColors(11,2)=xkcdVals(620,2);
LandColors(11,3)=xkcdVals(620,3);
LandColors(12,1)=xkcdVals(692,1);% Pinkish Tan
LandColors(12,2)=xkcdVals(692,2);
LandColors(12,3)=xkcdVals(692,3);
LandColors(13,1)=xkcdVals(854,1);% Tan Brown
LandColors(13,2)=xkcdVals(854,2);
LandColors(13,3)=xkcdVals(854,3);
LandColors(14,1)=xkcdVals(793,1);% Sandstone
LandColors(14,2)=xkcdVals(793,2);
LandColors(14,3)=xkcdVals(793,3);
LandColors(15,1)=xkcdVals(836,1);% Squash
LandColors(15,2)=xkcdVals(836,2);
LandColors(15,3)=xkcdVals(836,3);
LandColors(16,1)=xkcdVals(853,1);% Tan
LandColors(16,2)=xkcdVals(853,2);
LandColors(16,3)=xkcdVals(853,3);
ab=1;
% Establish selected run parameters
imachine=2;
if(imachine==1)
    widd=720;
    lend=580;
    widd2=1000;
    lend2=700;
elseif(imachine==2)
    widd=1080;
    lend=812;
    widd2=1000;
    lend2=700;
elseif(imachine==3)
    widd=1296;
    lend=974;
    widd2=1200;
    lend2=840;
end
% Set a specific color order
set(0,'DefaultAxesColorOrder',[1 0 0;
    1 1 0;0 1 0;0 0 1;0.75 0.50 0.25;
    0.5 0.75 0.25; 0.25 1 0.25;0 .50 .75]);
% Set up some defaults for a PowerPoint presentationwhos
scaling='true';
stretching='false';
padding=[75 75 75 75];
igrid=1;
% Set up paramters for graphs that will center them on the screen
[hor1,vert1,Fz1,Fz2,machine]=SetScreenCoordinates(widd,lend);
[hor2,vert2,Fz1,Fz2,machine]=SetScreenCoordinates(widd2,lend2);
chart_time=5;
idirector=1;
initialtimestr=datestr(now);
indx=53;
GOES16path=GOES16BandPaths{indx,1};
% Go to the expected path
eval(['cd ' GOES16path(1:length(GOES16path)-1)]);
isavefiles=0;
idebug=0;
title='Select Directory With Fire Hot Spot Data';
selpath = uigetdir(path,title);
firehotspotpath=strcat(selpath,'\');
% Set up the Catalog File
eval(['cd ' catalogpath(1:length(catalogpath)-1)]);
%TabName='Aug25_2020';
[status1,msg1]=xlswrite(ExcelCatalogFile,FireHeaders,TabName,'a1');
% Navigate to this directory
eval(['cd ' firehotspotpath(1:length(firehotspotpath)-1)]);
[ FileList ] = getfilelist(firehotspotpath,'.nc',false );
numfiles=length(FileList);
nfiles=numfiles;
tic;
waitstr='Processing FireHot Spot Files-';
h=waitbar(0,waitstr);
for n=1:nfiles
    eval(['cd ' firehotspotpath(1:length(firehotspotpath)-1)]);
    waitbar(n/nfiles);
    nowFile=FileList{n,1};
    [filepath,hotspotfile,ext] = fileparts(nowFile);
    nowFile2=strcat(hotspotfile,ext);
    dispstr=strcat('now decoding file-',nowFile2,'-which is-',num2str(n),'-of-',....
        num2str(nfiles),'-total files');
    disp(dispstr)
    ab=1;
    ReadManyL2FireFiles(nowFile2)
    [YearS,DayS,HourS,MinuteS,SecondS] = GetGOESDateTimeString(nowFile2,1);
    result = is_leap_year(YearS);
    if(result==0)
        MonthDayStr=char(DayMonthNonLeapYear{DayS,1});
    else
        MonthDayStr=char(DayMonthLeapYear{DayS,1});
    end
    MonthDayYearStr=strcat(MonthDayStr,'-',num2str(YearS));
    [numfiresp1,ncols]=size(FireDetails);
    numfires=numfiresp1-1;
    if(numfires>0)
        icatalogRec=icatalogRec+1;
        for kk=1:60
            FireResults{icatalogRec,kk}=0;
        end
        FireResults{icatalogRec,1}=nowFile2;
        FireResults{icatalogRec,2}=YearS;
        FireResults{icatalogRec,3}=DayS;
        FireResults{icatalogRec,4}=HourS;
        FireResults{icatalogRec,5}=MinuteS;
        FireResults{icatalogRec,6}=SecondS;
        FireResults{icatalogRec,7}=MonthDayStr;
% Get a list of states hit
        StatesHit=cell(1,1);
        for j=1:numfires
            nowState=FireDetails{1+j,1};
            StatesHit{j,1}=nowState;
        end
% Get a List of Unique States
        UniqueStates=unique(StatesHit);
        numUniqueStates=length(UniqueStates);
% Now go back through this list of unique states and find out how many
% fires are present
        HitsByState=zeros(numUniqueStates,1);
        for j=1:numUniqueStates
            nowUState=char(UniqueStates{j,1});
            for jj=1:numfires
                nowFState=char(FireDetails{1+jj,1});
                a1=strcmp(nowUState,nowFState);
                if(a1==1)
                    HitsByState(j,1)=HitsByState(j,1)+1;
                end
            end
        end
        for j=1:numUniqueStates
            nowState=char(UniqueStates{j,1});
            nowFIPS=0;
            nowHits=HitsByState(j,1);
            for nn=1:50
                currState=char(StateFIPSCodes{nn,1});
                a1=strcmp(nowState,currState);
                if(a1==1)
                   nowFIPS=StateFIPSCodes{nn,4};
                   nowCol=10+nowFIPS;
                   FireResults{icatalogRec,nowCol}=nowHits;
                end
                
            end
        end
    end
end
close(h);
% Now compute some summary data
icatalogLast=icatalogRec;
icatalogRec=icatalogRec+1;
FireResults{icatalogRec,1}='Fire Present';
FireResults{icatalogRec,2}='---';
FireResults{icatalogRec,3}='---';
FireResults{icatalogRec,4}='---';
FireResults{icatalogRec,5}='---';
FireResults{icatalogRec,6}='---';
FireResults{icatalogRec,7}='---';
FireResults{icatalogRec,8}='---';
FireResults{icatalogRec,9}='---';
FireResults{icatalogRec,10}='---';
FireResults{icatalogRec+1,1}='Fire Counts';
FireResults{icatalogRec+1,2}='---';
FireResults{icatalogRec+1,3}='---';
FireResults{icatalogRec+1,4}='---';
FireResults{icatalogRec+1,5}='---';
FireResults{icatalogRec+1,6}='---';
FireResults{icatalogRec+1,7}='---';
FireResults{icatalogRec+1,8}='---';
FireResults{icatalogRec+1,9}='---';
FireResults{icatalogRec+1,10}='---';
for n=11:60
    sumval=0;
    for j=1:icatalogLast
        sumval=sumval+FireResults{j,n};
    end
    if(sumval>0)
        FireResults{icatalogRec,n}=1;
        FireResults{icatalogRec+1,n}=sumval;
    else
        FireResults{icatalogRec,n}=0;
        FireResults{icatalogRec+1,n}=sumval;
    end
end
% Now write data to the excel sheet
eval(['cd ' catalogpath(1:length(catalogpath)-1)]);
[status2,msg2]=xlswrite(ExcelCatalogFile,FireResults,TabName,'a2');
fclose(fid);
elapsed_time=toc;
dispstr=strcat('Processing-',num2str(numfiles),'-took-',num2str(elapsed_time),'-sec');
disp(dispstr)
ab=1;
