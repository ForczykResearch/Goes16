% This executive script is to read a wide range of GOES16/17 Data products
% Created: July 30,2020
% Written By: Stephen Forczyk
% Revised: Aug 4,2020 added logic for CONUS single band files
% Revised: Oct 2020 added Code to process ABI_L2_Fire data
% Revised: Dec 19,2020 added code to process ABI-L1-Radiance Data
% Revised: Dec 29,2020 revised code to allow processing of a number of
%          of files in sequential order
% Revised: Dec 31,2020 started adding code to use Matlab Report Generator
% Revised: Jan 01,2020 added code to generate PDF Report Header in a
%           separate subroutine
% Revised: Jan 25,2021 added paths 61 thru 70 to accomodate more types of
% Revised: Jan 30,2021 added reader for Cloud Aerosol Particle Size
% Revised: Feb01,2021 added space for more download products items 61-70
% Revised: Feb 04,2021 added routine to read total precipital water
% Revised: Feb 9,2021 added call to check if image processing toolbox is
% present
% data downloads
% Revised: Mar 10,2021 added file StandardArtmosphere.mat based on US
% Standard Atmosphere data assume a standard default temperature
% Revised: April 3,2021 added code to set Fixed program paths using a GUI
% Revised: April 10,2021 added code to create variable paths for Imagery
% data
% Revised: April 19,2021 added routine to read cloud top phase data
% Revised: April 23,2021 added routine to read Reflected Shortwave
% Radiation
% Revised: May 6,2021 added routine to Read SUVI_FE093 data
% Classification: Unclassified/Public Domain
global Datasets;
global BandDataS MetaDataS;
global CMIS DQFS tS yS xS tBS goesImagerS yImgS yImgBS;
global xImgS xImgBS SatDataS GeoSpatialS;
global ReflectanceS AlgoS ErrorS EarthSunS VersionContainerS;
global GoesWaveBand GoesWaveBand2 GoesWaveBandTable ESunS kappa0S PlanckS FocalPlaneS;
global GOESFileName MapFormFactor;
global GOES16BandPaths;
global isaveGOESLightningData isaveCMI;
global CountyBoundaryFile;
global CountyBoundaries StateFIPSFile;
global StateFIPSCodes NationalCountiesShp;
global USAStatesShapeFileList USAStatesFileName;
global UrbanAreasShapeFile NorthAmericaLakes FireSummaryFile;
global idebug isavefiles iDemFlag;
global iPrimeRoads iCountyRoads iCommonRoads iStateRecRoads iUSRoads iStateRoads;
global iLakes;
global NumProcFiles ProcFileList;
global RptGenPresent iCreatePDFReport pdffilename rpt chapter tocc;
global JpegCounter JpegFileList;
global ImageProcessPresent;
global iReport ifixedImagePaths;
global PhPA rho zPress;

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
global baseimagepath selectedImageFolder;
global pwd;


clc;
% Set up some fixed paths for the data. Set the present working directory
% to where the this code is located
pret=which('ReadGoes16Datasets.m');
[islash]=strfind(pret,'\');
numslash=length(islash);
is=1;
ie=islash(2);
pwd=pret(is:ie);
matlabpath=strcat(pwd,'Matlab_Data\');
mappath='D:\Forczyk\Map_Data\Matlab_Maps\';
dtedpath='F:\DTED\';
CalendarFileName='CalendarDays.mat';
shapefilepath='D:\Goes16\ShapeFiles\';
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
baseimagepath='F:\GOES16\Imagery\';
Countryshapepath='D:\Forczyk\Map_Data\CountryShapefiles\';
gridpath='D:\Goes16\Grids\';
% Set some flags to control program execution
iCreatePDFReport=1;
JpegCounter=0;
isavefiles=0;
idebug=1;
ifixedImagePaths=2;

% Start writing a log file and Also look at the current stored image paths
% file
%eval(['cd ' logpath(1:length(logpath)-1)]);
startruntime=deblank(datestr(now));
startrunstr=strcat('Start Run GOES 16 Run at-',startruntime);
logfilename=startruntime;
logfiledbl=double(logfilename);
% find the blank space in the date and replace it with a '-' to make a
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
datetimestr=logfilename;
ImageFileFoldersName=strcat('ImageFolderFiles-',datetimestr,'.mat');
[idash]=strfind(ImageFileFoldersName,'-');
numdash=length(idash);
[iper]=strfind(ImageFileFoldersName,'.');
numper=length(iper);
is=idash(1)+1;
ie=iper(1)-1;
PotentialDatestr=ImageFileFoldersName(is:ie);
idash=strfind(PotentialDatestr,'-');
is=idash(3);
ie=is;

PotentialDatestr(is:ie)=' ';
is=idash(4);
ie=is;
PotentialDatestr(is:ie)=':';
is=idash(5);
ie=is;
PotentialDatestr(is:ie)=':';
pd=datenum(PotentialDatestr,'dd-mmm-yyyy HH:MM:SS');
dirlis=dir(matlabpath);
% Find out how many file start with 'ImageFolderFiles'
numdirfiles=length(dirlis)-2;
maxage=0;
minage=100;
ibest=0;
if(numdirfiles<1)
    iwrite=0;
else
    pattern='ImageFolderFiles';
    FoundFiles=cell(1,4);
    ihit=0;
    ihitbest=1;
    for kk=3:numdirfiles+2
        nowFile=dirlis(kk).name;
        nowDateNum=dirlis(kk).datenum;
        TF = startsWith(nowFile,pattern);
        if(TF==1)
            ihit=ihit+1;
            FoundFiles{ihit,1}=nowFile;
            FoundFiles{ihit,2}=nowDateNum;
            FoundFiles{ihit,3}=pd-nowDateNum;
            FoundFiles{ihit,4}=0;% Keep flag
            nowage=pd-nowDateNum;
            if(nowage>maxage)
                maxage=nowage;
            end
            if(nowage<minage)
                minage=nowage;
                ibest=kk;
                ihitbest=ihit;
            end
        end
    end
    FoundFiles{ihitbest,4}=1;
    if(maxage>1)
        iwrite=1;
    else
        iwrite=0;
    end
    if(ihit>1)
    eval(['cd ' matlabpath(1:length(matlabpath)-1)]);
        for jj=1:ihit
            nowFile=strcat(matlabpath,char(FoundFiles{jj,1}));
            nowFlag=FoundFiles{jj,4};
            if(nowFlag==0)
                delete(nowFile);
            end
        end
    end
end
eval(['cd ' logpath(1:length(logpath)-1)]);
logfilename=strcat('LogFile-',logfilename,'.txt');
pdffilename=strcat('GOES16-',datetimestr);
fid=fopen(logfilename,'w');
dispstr=strcat('Opened Log file-',logfilename,'-for writing');
disp(dispstr);
fprintf(fid,'%50s\n',startrunstr);
if((ifixedImagePaths>2) && (iwrite==1))
    ipathstr1='User has selected the option to set new image data filepaths';
    fprintf(fid,'%s\n',ipathstr1);
    selectedImageFolder=[];
    pret=which('ReadGoes16Datasets.m');
    [islash]=strfind(pret,'\');
    numslash=length(islash);
    is=1;
    ie=islash(numslash);
    pwd=pret(is:ie);
    [inFolderList] = GetSubDirsFirstLevelOnly(baseimagepath);
    [outFolderList] = MakeDateFolderList(baseimagepath,inFolderList);
% Save this list for future use
    eval(['cd ' matlabpath(1:length(matlabpath)-1)]);
    datetimestr2=datetime('now');
    dateID=date;
    actionstr='save';
    varstr='outFolderList dateID';
    qualstr='-v7.3';
    [cmdString]=MyStrcatV73(actionstr,ImageFileFoldersName,varstr,qualstr);
    eval(cmdString)
    dispstr=strcat('Wrote Matlab File-',ImageFileFoldersname);
    disp(dispstr);
    fprintf(fid,'%s\n',dispstr);
    [indx,tf] = listdlg('PromptString',{'Select folder to read'},...
        'SelectionMode','single','ListString',outFolderList,'ListSize',[360,300]);
    a1=isempty(indx);
    if(a1==1)
        ifixedImagePaths=1;
        ipathstr2='User did not select a new filepath-go to default paths';
        fprintf(fid,'%s\n',ipathstr2);
    else
        selectedImageFolder=outFolderList{indx,1};
        ipathstr3=strcat('User selected folder-',selectedImageFolder,'-as the source of image data');
        fprintf(fid,'%s\n',ipathstr3);
    end
elseif((ifixedImagePaths>2) && (iwrite==0))
    eval(['cd ' matlabpath(1:length(matlabpath)-1)]);
    loadfile=dirlis(ibest).name;
    ipathstr2='User has selected the option to select new image data filepaths but no need to recompute available folderlist';
    fprintf(fid,'%s\n',ipathstr2);
    load(loadfile);
    [indx,tf] = listdlg('PromptString',{'Select prev folder to read'},...
        'SelectionMode','single','ListString',outFolderList,'ListSize',[360,300]);
    a1=isempty(indx);
    if(a1==1)
        ifixedImagePaths=1;
        ipathstr2='User did not select a new filepath-go to default paths';
        fprintf(fid,'%s\n',ipathstr2);
    else
        selectedImageFolder=outFolderList{indx,1};
        ipathstr3=strcat('User selected folder-',selectedImageFolder,'-as the source of image data');
        fprintf(fid,'%s\n',ipathstr3);
    end
    
end
if(ifixedImagePaths==1)
    ipathstr1='User has selected the option to go with default image file paths';
    fprintf(fid,'%s\n',ipathstr1);
    GOES16BandPaths=cell(1,1);
    GOES16BandPaths{1,1}='D:\Goes16\Imagery\Aug26_2020\ABI_L2_Cloud_Moisture\Conus\Band01\';
    GOES16BandPaths{2,1}='D:\Goes16\Imagery\Aug26_2020\ABI_L2_Cloud_Moisture\Conus\Band02\';
    GOES16BandPaths{3,1}='D:\Goes16\Imagery\Aug26_2020\ABI_L2_Cloud_Moisture\Conus\Band03\';
    GOES16BandPaths{4,1}='D:\Goes16\Imagery\Aug26_2020\ABI_L2_Cloud_Moisture\Conus\Band04\';
    GOES16BandPaths{5,1}='D:\Goes16\Imagery\Aug26_2020\ABI_L2_Cloud_Moisture\Conus\Band05\';
    GOES16BandPaths{6,1}='D:\Goes16\Imagery\Aug26_2020\ABI_L2_Cloud_Moisture\Conus\Band06\';
    GOES16BandPaths{7,1}='D:\Goes16\Imagery\Aug26_2020\ABI_L2_Cloud_Moisture\Conus\Band07\';
    GOES16BandPaths{8,1}='D:\Goes16\Imagery\Aug26_2020\ABI_L2_Cloud_Moisture\Conus\Band08\';
    GOES16BandPaths{9,1}='D:\Goes16\Imagery\Aug26_2020\ABI_L2_Cloud_Moisture\Conus\Band09\';
    GOES16BandPaths{10,1}='D:\Goes16\Imagery\Aug26_2020\ABI_L2_Cloud_Moisture\Conus\Band10\';
    GOES16BandPaths{11,1}='D:\Goes16\Imagery\Aug26_2020\ABI_L2_Cloud_Moisture\Conus\Band11\';
    GOES16BandPaths{12,1}='D:\Goes16\Imagery\Aug26_2020\ABI_L2_Cloud_Moisture\Conus\Band12\';
    GOES16BandPaths{13,1}='D:\Goes16\Imagery\Aug26_2020\ABI_L2_Cloud_Moisture\Conus\Band13\';
    GOES16BandPaths{14,1}='D:\Goes16\Imagery\Aug26_2020\ABI_L2_Cloud_Moisture\Conus\Band14\';
    GOES16BandPaths{15,1}='D:\Goes16\Imagery\Aug26_2020\ABI_L2_Cloud_Moisture\Conus\Band15\';
    GOES16BandPaths{16,1}='D:\Goes16\Imagery\Aug26_2020\ABI_L2_Cloud_Moisture\Conus\Band16\';
    GOES16BandPaths{17,1}='D:\Goes16\Imagery\Aug26_2020\ABI_L2_Cloud_Top_Height\Conus\';
    GOES16BandPaths{18,1}='D:\Goes16\Imagery\Aug26_2020\ABI_L2_Cloud_Top_Temp\Full_Disk\';
    GOES16BandPaths{19,1}='D:\Goes16\Imagery\Aug26_2020\GLM_L2_Flash\Conus\';
    GOES16BandPaths{20,1}='D:\Goes16\Imagery\Aug26_2020\ABI_L1b_Radiance\Conus\Band01\';
    GOES16BandPaths{21,1}='D:\Goes16\Imagery\Aug26_2020\ABI_L1b_Radiance\Conus\Band02\';
    GOES16BandPaths{22,1}='D:\Goes16\Imagery\Aug26_2020\ABI_L1b_Radiance\Conus\Band03\';
    GOES16BandPaths{23,1}='D:\Goes16\Imagery\Aug26_2020\ABI_L1b_Radiance\Conus\Band04\';
    GOES16BandPaths{24,1}='D:\Goes16\Imagery\Aug26_2020\ABI_L1b_Radiance\Conus\Band05\';
    GOES16BandPaths{25,1}='D:\Goes16\Imagery\Aug26_2020\ABI_L1b_Radiance\Conus\Band06\';
    GOES16BandPaths{26,1}='D:\Goes16\Imagery\Aug26_2020\ABI_L1b_Radiance\Conus\Band07\';
    GOES16BandPaths{27,1}='D:\Goes16\Imagery\Aug26_2020\ABI_L1b_Radiance\Conus\Band08\';
    GOES16BandPaths{28,1}='D:\Goes16\Imagery\Aug26_2020\ABI_L1b_Radiance\Conus\Band09\';
    GOES16BandPaths{29,1}='D:\Goes16\Imagery\Aug26_2020\ABI_L1b_Radiance\Conus\Band10\';
    GOES16BandPaths{30,1}='D:\Goes16\Imagery\Aug26_2020\ABI_L1b_Radiance\Conus\Band11\';
    GOES16BandPaths{31,1}='D:\Goes16\Imagery\Aug26_2020\ABI_L1b_Radiance\Conus\Band12\';
    GOES16BandPaths{32,1}='D:\Goes16\Imagery\Aug26_2020\ABI_L1b_Radiance\Conus\Band13\';
    GOES16BandPaths{33,1}='D:\Goes16\Imagery\Aug26_2020\ABI_L1b_Radiance\Conus\Band14\';
    GOES16BandPaths{34,1}='D:\Goes16\Imagery\Aug26_2020\ABI_L1b_Radiance\Conus\Band15\';
    GOES16BandPaths{35,1}='D:\Goes16\Imagery\Aug26_2020\ABI_L1b_Radiance\Conus\Band16\';
    GOES16BandPaths{36,1}='D:\Goes16\Imagery\Aug26_2020\ABI_L2_Cloud_Top_Phase\Conus\';
    GOES16BandPaths{37,1}='D:\Goes16\Imagery\Aug26_2020\ABI_L1b_Radiance\Meso1\Band01\';
    GOES16BandPaths{38,1}='D:\Goes16\Imagery\Aug26_2020\ABI_L1b_Radiance\Meso1\Band02\';
    GOES16BandPaths{39,1}='D:\Goes16\Imagery\Aug26_2020\ABI_L1b_Radiance\Meso1\Band03\';
    GOES16BandPaths{40,1}='D:\Goes16\Imagery\Aug26_2020\ABI_L1b_Radiance\Meso1\Band04\';
    GOES16BandPaths{41,1}='D:\Goes16\Imagery\Aug26_2020\ABI_L1b_Radiance\Meso1\Band05\';
    GOES16BandPaths{42,1}='D:\Goes16\Imagery\Aug26_2020\ABI_L1b_Radiance\Meso1\Band06\';
    GOES16BandPaths{43,1}='D:\Goes16\Imagery\Aug26_2020\ABI_L1b_Radiance\Meso1\Band07\';
    GOES16BandPaths{44,1}='D:\Goes16\Imagery\Aug26_2020\ABI_L1b_Radiance\Meso1\Band08\';
    GOES16BandPaths{45,1}='D:\Goes16\Imagery\Aug26_2020\ABI_L1b_Radiance\Meso1\Band09\';
    GOES16BandPaths{46,1}='D:\Goes16\Imagery\Aug26_2020\ABI_L1b_Radiance\Meso1\Band10\';
    GOES16BandPaths{47,1}='D:\Goes16\Imagery\Aug26_2020\ABI_L1b_Radiance\Meso1\Band11\';
    GOES16BandPaths{48,1}='D:\Goes16\Imagery\Aug26_2020\ABI_L2_MultiBand_Radiance\Conus\';
    GOES16BandPaths{49,1}='D:\Goes16\Imagery\Aug26_2020\ABI_L2_MultiBand_Radiance\Meso1\';
    GOES16BandPaths{50,1}='D:\Goes16\Imagery\Aug26_2020\ABI_L2_MultiBand_Radiance\Full_Disk\';
    GOES16BandPaths{51,1}='D:\Goes16\Imagery\Aug26_2020\ABI_L2_Cloud_Top_Height\Conus\';
    GOES16BandPaths{52,1}='D:\Goes16\Imagery\Aug26_2020\ABI_L2_Cloud_Top_Height\Full_Disk\';
    GOES16BandPaths{53,1}='D:\Goes16\Imagery\Aug26_2020\ABI_L2_Fire\Conus\';
    GOES16BandPaths{54,1}='D:\Goes16\Imagery\Aug26_2020\ABI_L2_Derived_Motion_Winds\Conus\';
    GOES16BandPaths{55,1}='D:\Goes16\Imagery\Aug26_2020\ABI_L2_Cloud_Top_Pressure\Conus\';
    GOES16BandPaths{56,1}='D:\Goes16\Imagery\Aug26_2020\ABI_L2_Cloud_Top_Temp\Full_Disk\';
    GOES16BandPaths{57,1}='D:\Goes16\Imagery\Aug26_2020\ABI_L2_Clear_Sky_Mask\Conus\';
    GOES16BandPaths{58,1}='D:\Goes16\Imagery\Aug26_2020\ABI_L2_Sea_Surface_Temp\Full_Disk\';
    GOES16BandPaths{59,1}='D:\Goes16\Imagery\Aug26_2020\ABI_L2_Land_Surface_Temp\Conus\';
    GOES16BandPaths{60,1}='D:\Goes16\Imagery\Aug26_2020\ABI_L2_Cloud_Optical_Depth\Conus\';
    GOES16BandPaths{61,1}='D:\Goes16\Imagery\Aug26_2020\ABI_L2_Cloud_Particle_Size\Conus\';
    GOES16BandPaths{62,1}='D:\Goes16\Imagery\Aug26_2020\ABI_L2_Aerosol_Detection\Conus \';
    GOES16BandPaths{63,1}='D:\Goes16\Imagery\Aug26_2020\ABI_L2_Aerosol_Optical_Depth\Conus\';
    GOES16BandPaths{64,1}='D:\Goes16\Imagery\Aug26_2020\ABI_L2_Derived_Stability\Conus\';
    GOES16BandPaths{65,1}='D:\Goes16\Imagery\Aug26_2020\ABI_L2_Downward_ShortWave_Radiation\Conus\';
    GOES16BandPaths{66,1}='D:\Goes16\Imagery\Aug26_2020\ABI_L2_Legacy_Vertical_Moisture_Profile\Conus\';
    GOES16BandPaths{67,1}='D:\Goes16\Imagery\Aug26_2020\ABI_L2_Legacy_Vertical_Temperature_Profile\Conus\';
    GOES16BandPaths{68,1}='D:\Goes16\Imagery\Aug26_2020\ABI_L2_Rainfall_Rate\FullDisk\';
    GOES16BandPaths{69,1}='D:\Goes16\Imagery\Aug26_2020\ABI_L2_Total_Precip_Water\Conus\';
    GOES16BandPaths{70,1}='D:\Goes16\Imagery\Aug26_2020\ABI_L2_Volcanic_Ash\FullDisk\';
    GOES16BandPaths{71,1}='D:\Goes16\Imagery\Aug26_2020\ABI_L2_Reflected_Shortwave_Radiation\Conus\';
    GOES16BandPaths{72,1}='D:\GOES16\Imagery\Aug26_2020\SUV_L1b_Fe093\Conus\';
    GOES16BandPaths{73,1}='D:\GOES16\Imagery\Aug26_2020\SUV_L1b_Fe131\Conus\';
    GOES16BandPaths{74,1}='D:\GOES16\Imagery\Aug26_2020\SUV_L1b_Fe171\Conus\';
    GOES16BandPaths{75,1}='D:\GOES16\Imagery\Aug26_2020\SUV_L1b_Fe195\Conus\';
    GOES16BandPaths{76,1}='D:\GOES16\Imagery\Aug26_2020\SUV_L1b_Fe284\Conus\';
    GOES16BandPaths{77,1}='D:\GOES16\Imagery\Aug26_2020\SUV_L1b_He303\Conus\';
elseif(ifixedImagePaths==2)% This choice is to be used in testing files that will be part of the distribution
    ipathstr1='User has selected the option to go with default image file paths used in distribution';
    fprintf(fid,'%s\n',ipathstr1);
    GOES16BandPaths=cell(1,1);
    GOES16BandPaths{1,1}='F:\GOES16\Code_May15_2020\GOES16ReaderProject\Imagery\Aug26_2020\ABI_L2_Cloud_Moisture\Conus\Band01\';
    GOES16BandPaths{2,1}='F:\GOES16\Code_May15_2020\GOES16ReaderProject\Imagery\Aug26_2020\ABI_L2_Cloud_Moisture\Conus\Band02\';
    GOES16BandPaths{3,1}='F:\GOES16\Code_May15_2020\GOES16ReaderProject\Imagery\Aug26_2020\ABI_L2_Cloud_Moisture\Conus\Band03\';
    GOES16BandPaths{4,1}='F:\GOES16\Code_May15_2020\GOES16ReaderProject\Imagery\Aug26_2020\ABI_L2_Cloud_Moisture\Conus\Band04\';
    GOES16BandPaths{5,1}='F:\GOES16\Code_May15_2020\GOES16ReaderProject\Imagery\Aug26_2020\ABI_L2_Cloud_Moisture\Conus\Band05\';
    GOES16BandPaths{6,1}='F:\GOES16\Code_May15_2020\GOES16ReaderProject\Imagery\Aug26_2020\ABI_L2_Cloud_Moisture\Conus\Band06\';
    GOES16BandPaths{7,1}='F:\GOES16\Code_May15_2020\GOES16ReaderProject\Imagery\Aug26_2020\ABI_L2_Cloud_Moisture\Conus\Band07\';
    GOES16BandPaths{8,1}='F:\GOES16\Code_May15_2020\GOES16ReaderProject\Imagery\Aug26_2020\ABI_L2_Cloud_Moisture\Conus\Band08\';
    GOES16BandPaths{9,1}='F:\GOES16\Code_May15_2020\GOES16ReaderProject\Imagery\Aug26_2020\ABI_L2_Cloud_Moisture\Conus\Band09\';
    GOES16BandPaths{10,1}='F:\GOES16\Code_May15_2020\GOES16ReaderProject\Imagery\Aug26_2020\ABI_L2_Cloud_Moisture\Conus\Band10\';
    GOES16BandPaths{11,1}='F:\GOES16\Code_May15_2020\GOES16ReaderProject\Imagery\Aug26_2020\ABI_L2_Cloud_Moisture\Conus\Band11\';
    GOES16BandPaths{12,1}='F:\GOES16\Code_May15_2020\GOES16ReaderProject\Imagery\Aug26_2020\ABI_L2_Cloud_Moisture\Conus\Band12\';
    GOES16BandPaths{13,1}='F:\GOES16\Code_May15_2020\GOES16ReaderProject\Imagery\Aug26_2020\ABI_L2_Cloud_Moisture\Conus\Band13\';
    GOES16BandPaths{14,1}='F:\GOES16\Code_May15_2020\GOES16ReaderProject\Imagery\Aug26_2020\ABI_L2_Cloud_Moisture\Conus\Band14\';
    GOES16BandPaths{15,1}='F:\GOES16\Code_May15_2020\GOES16ReaderProject\Imagery\Aug26_2020\ABI_L2_Cloud_Moisture\Conus\Band15\';
    GOES16BandPaths{16,1}='F:\GOES16\Code_May15_2020\GOES16ReaderProject\Imagery\Aug26_2020\ABI_L2_Cloud_Moisture\Conus\Band16\';
    GOES16BandPaths{17,1}='F:\GOES16\Code_May15_2020\GOES16ReaderProject\Imagery\Aug26_2020\ABI_L2_Cloud_Top_Height\Conus\';
    GOES16BandPaths{18,1}='F:\GOES16\Code_May15_2020\GOES16ReaderProject\Imagery\Aug26_2020\ABI_L2_Cloud_Top_Temp\Full_Disk\';
    GOES16BandPaths{19,1}='F:\GOES16\Code_May15_2020\GOES16ReaderProject\Imagery\Aug26_2020\GLM_L2_Flash\Conus\';
    GOES16BandPaths{20,1}='F:\GOES16\Code_May15_2020\GOES16ReaderProject\Imagery\Aug26_2020\ABI_L1b_Radiance\Conus\Band01\';
    GOES16BandPaths{21,1}='F:\GOES16\Code_May15_2020\GOES16ReaderProject\Imagery\Aug26_2020\ABI_L1b_Radiance\Conus\Band02\';
    GOES16BandPaths{22,1}='F:\GOES16\Code_May15_2020\GOES16ReaderProject\Imagery\Aug26_2020\ABI_L1b_Radiance\Conus\Band03\';
    GOES16BandPaths{23,1}='F:\GOES16\Code_May15_2020\GOES16ReaderProject\Imagery\Aug26_2020\ABI_L1b_Radiance\Conus\Band04\';
    GOES16BandPaths{24,1}='F:\GOES16\Code_May15_2020\GOES16ReaderProject\Imagery\Aug26_2020\ABI_L1b_Radiance\Conus\Band05\';
    GOES16BandPaths{25,1}='F:\GOES16\Code_May15_2020\GOES16ReaderProject\Imagery\Aug26_2020\ABI_L1b_Radiance\Conus\Band06\';
    GOES16BandPaths{26,1}='F:\GOES16\Code_May15_2020\GOES16ReaderProject\Aug26_2020\ABI_L1b_Radiance\Conus\Band07\';
    GOES16BandPaths{27,1}='F:\GOES16\Code_May15_2020\GOES16ReaderProject\Imagery\Aug26_2020\ABI_L1b_Radiance\Conus\Band08\';
    GOES16BandPaths{28,1}='F:\GOES16\Code_May15_2020\GOES16ReaderProject\Imagery\Aug26_2020\ABI_L1b_Radiance\Conus\Band09\';
    GOES16BandPaths{29,1}='F:\GOES16\Code_May15_2020\GOES16ReaderProject\Imagery\Aug26_2020\ABI_L1b_Radiance\Conus\Band10\';
    GOES16BandPaths{30,1}='F:\GOES16\Code_May15_2020\GOES16ReaderProject\Imagery\Aug26_2020\ABI_L1b_Radiance\Conus\Band11\';
    GOES16BandPaths{31,1}='F:\GOES16\Code_May15_2020\GOES16ReaderProject\Imagery\Aug26_2020\ABI_L1b_Radiance\Conus\Band12\';
    GOES16BandPaths{32,1}='F:\GOES16\Code_May15_2020\GOES16ReaderProject\Imagery\Aug26_2020\ABI_L1b_Radiance\Conus\Band13\';
    GOES16BandPaths{33,1}='F:\GOES16\Code_May15_2020\GOES16ReaderProject\Imagery\Aug26_2020\ABI_L1b_Radiance\Conus\Band14\';
    GOES16BandPaths{34,1}='F:\GOES16\Code_May15_2020\GOES16ReaderProject\Imagery\Aug26_2020\ABI_L1b_Radiance\Conus\Band15\';
    GOES16BandPaths{35,1}='F:\GOES16\Code_May15_2020\GOES16ReaderProject\Imagery\Aug26_2020\ABI_L1b_Radiance\Conus\Band16\';
    GOES16BandPaths{36,1}='F:\GOES16\Code_May15_2020\GOES16ReaderProject\Imagery\Aug26_2020\ABI_L2_Cloud_Top_Phase\Conus\';
    GOES16BandPaths{37,1}='F:\GOES16\Code_May15_2020\GOES16ReaderProject\Imagery\Aug26_2020\ABI_L1b_Radiance\Meso1\Band01\';
    GOES16BandPaths{38,1}='F:\GOES16\Code_May15_2020\GOES16ReaderProject\Imagery\Aug26_2020\ABI_L1b_Radiance\Meso1\Band02\';
    GOES16BandPaths{39,1}='F:\GOES16\Code_May15_2020\GOES16ReaderProject\Imagery\Aug26_2020\ABI_L1b_Radiance\Meso1\Band03\';
    GOES16BandPaths{40,1}='F:\GOES16\Code_May15_2020\GOES16ReaderProject\Imagery\Aug26_2020\ABI_L1b_Radiance\Meso1\Band04\';
    GOES16BandPaths{41,1}='F:\GOES16\Code_May15_2020\GOES16ReaderProject\Imagery\Aug26_2020\ABI_L1b_Radiance\Meso1\Band05\';
    GOES16BandPaths{42,1}='F:\GOES16\Code_May15_2020\GOES16ReaderProject\Imagery\Aug26_2020\ABI_L1b_Radiance\Meso1\Band06\';
    GOES16BandPaths{43,1}='F:\GOES16\Code_May15_2020\GOES16ReaderProject\Imagery\Aug26_2020\ABI_L1b_Radiance\Meso1\Band07\';
    GOES16BandPaths{44,1}='F:\GOES16\Code_May15_2020\GOES16ReaderProject\Imagery\Aug26_2020\ABI_L1b_Radiance\Meso1\Band08\';
    GOES16BandPaths{45,1}='F:\GOES16\Code_May15_2020\GOES16ReaderProject\Imagery\Aug26_2020\ABI_L1b_Radiance\Meso1\Band09\';
    GOES16BandPaths{46,1}='F:\GOES16\Code_May15_2020\GOES16ReaderProject\Imagery\Aug26_2020\ABI_L1b_Radiance\Meso1\Band10\';
    GOES16BandPaths{47,1}='F:\GOES16\Code_May15_2020\GOES16ReaderProject\Imagery\Aug26_2020\ABI_L1b_Radiance\Meso1\Band11\';
    GOES16BandPaths{48,1}='F:\GOES16\Code_May15_2020\GOES16ReaderProject\Imagery\Aug26_2020\ABI_L2_MultiBand_Radiance\Conus\';
    GOES16BandPaths{49,1}='F:\GOES16\Code_May15_2020\GOES16ReaderProject\Imagery\Aug26_2020\ABI_L2_MultiBand_Radiance\Meso1\';
    GOES16BandPaths{50,1}='F:\GOES16\Code_May15_2020\GOES16ReaderProject\Imagery\Aug26_2020\ABI_L2_MultiBand_Radiance\Full_Disk\';
    GOES16BandPaths{51,1}='F:\GOES16\Code_May15_2020\GOES16ReaderProject\Imagery\Aug26_2020\ABI_L2_Cloud_Top_Height\Conus\';
    GOES16BandPaths{52,1}='F:\GOES16\Code_May15_2020\GOES16ReaderProject\Imagery\Aug26_2020\ABI_L2_Cloud_Top_Height\Full_Disk\';
    GOES16BandPaths{53,1}='F:\GOES16\Code_May15_2020\GOES16ReaderProject\Imagery\Aug26_2020\ABI_L2_Fire\Conus\';
    GOES16BandPaths{54,1}='F:\GOES16\Code_May15_2020\GOES16ReaderProject\Imagery\Aug26_2020\ABI_L2_Derived_Motion_Winds\Conus\';
    GOES16BandPaths{55,1}='F:\GOES16\Code_May15_2020\GOES16ReaderProject\Imagery\Aug26_2020\ABI_L2_Cloud_Top_Pressure\Conus\';
    GOES16BandPaths{56,1}='F:\GOES16\Code_May15_2020\GOES16ReaderProject\Imagery\Aug26_2020\ABI_L2_Cloud_Top_Temp\Full_Disk\';
    GOES16BandPaths{57,1}='F:\GOES16\Code_May15_2020\GOES16ReaderProject\Imagery\Aug26_2020\ABI_L2_Clear_Sky_Mask\Conus\';
    GOES16BandPaths{58,1}='F:\GOES16\Code_May15_2020\GOES16ReaderProject\Imagery\Aug26_2020\ABI_L2_Sea_Surface_Temp\Full_Disk\';
    GOES16BandPaths{59,1}='F:\GOES16\Code_May15_2020\GOES16ReaderProject\Imagery\Aug26_2020\ABI_L2_Land_Surface_Temp\Conus\';
    GOES16BandPaths{60,1}='F:\GOES16\Code_May15_2020\GOES16ReaderProject\Imagery\Aug26_2020\ABI_L2_Cloud_Optical_Depth\Conus\';
    GOES16BandPaths{61,1}='F:\GOES16\Code_May15_2020\GOES16ReaderProject\Imagery\Aug26_2020\ABI_L2_Cloud_Particle_Size\Conus\';
    GOES16BandPaths{62,1}='F:\GOES16\Code_May15_2020\GOES16ReaderProject\Imagery\Aug26_2020\ABI_L2_Aerosol_Detection\Conus \';
    GOES16BandPaths{63,1}='F:\GOES16\Code_May15_2020\GOES16ReaderProject\Imagery\Aug26_2020\ABI_L2_Aerosol_Optical_Depth\Conus\';
    GOES16BandPaths{64,1}='F:\GOES16\Code_May15_2020\GOES16ReaderProject\Imagery\Aug26_2020\ABI_L2_Derived_Stability\Conus\';
    GOES16BandPaths{65,1}='F:\GOES16\Code_May15_2020\GOES16ReaderProject\Imagery\Aug26_2020\ABI_L2_Downward_ShortWave_Radiation\Conus\';
    GOES16BandPaths{66,1}='F:\GOES16\Code_May15_2020\GOES16ReaderProject\Imagery\Aug26_2020\ABI_L2_Legacy_Vertical_Moisture_Profile\Conus\';
    GOES16BandPaths{67,1}='F:\GOES16\Code_May15_2020\GOES16ReaderProject\Imagery\Aug26_2020\ABI_L2_Legacy_Vertical_Temperature_Profile\Conus\';
    GOES16BandPaths{68,1}='F:\GOES16\Code_May15_2020\GOES16ReaderProject\Imagery\Aug26_2020\ABI_L2_Rainfall_Rate\Full_Disk\';
    GOES16BandPaths{69,1}='F:\GOES16\Code_May15_2020\GOES16ReaderProject\Imagery\Aug26_2020\ABI_L2_Total_Precip_Water\Conus\';
    GOES16BandPaths{70,1}='F:\GOES16\Code_May15_2020\GOES16ReaderProject\Imagery\Aug26_2020\ABI_L2_Volcanic_Ash\Full_Disk\';
    GOES16BandPaths{71,1}='F:\GOES16\Code_May15_2020\GOES16ReaderProject\Imagery\Aug26_2020\ABI_L2_Reflected_Shortwave_Radiation\Conus\';
    GOES16BandPaths{72,1}='F:\GOES16\Code_May15_2020\GOES16ReaderProject\Imagery\Aug26_2020\SUV_L1b_Fe093\Conus\';
    GOES16BandPaths{73,1}='F:\GOES16\Code_May15_2020\GOES16ReaderProject\Imagery\Aug26_2020\SUV_L1b_Fe131\Conus\';
    GOES16BandPaths{74,1}='F:\GOES16\Code_May15_2020\GOES16ReaderProject\Imagery\Aug26_2020\SUV_L1b_Fe171\Conus\';
    GOES16BandPaths{75,1}='F:\GOES16\Code_May15_2020\GOES16ReaderProject\Imagery\Aug26_2020\SUV_L1b_Fe195\Conus\';
    GOES16BandPaths{76,1}='F:\GOES16\Code_May15_2020\GOES16ReaderProject\Imagery\Aug26_2020\SUV_L1b_Fe284\Conus\';
    GOES16BandPaths{77,1}='F:\GOES16\Code_May15_2020\GOES16ReaderProject\Imagery\Aug26_2020\SUV_L1b_He303\Conus\'; 
    jpegpath='F:\GOES16\Code_May15_2020\GOES16ReaderProject\Imagery\Aug26_2020\Jpeg_Files\';
    pdfpath='F:\GOES16\Code_May15_2020\GOES16ReaderProject\Imagery\Aug26_2020\PDF_Files\';
    logpath='F:\GOES16\Code_May15_2020\GOES16ReaderProject\Log_Files\';
else
% Now set the image paths to the selected folder adding any missing
% subfolders as required
    [output1,output2] = SetImageFolders();
end
MapFormFactor=[];
Datasets=cell(1,1);
Datasets{1,1}='ABI-L2-CMI-Imagery-Band-1*R';
Datasets{2,1}='ABI-L2-CMI-Imagery-Band-2*R';
Datasets{3,1}='ABI-L2-CMI-Imagery-Band-3*R';
Datasets{4,1}='ABI-L2-CMI-Imagery-Band-4*R';
Datasets{5,1}='ABI-L2-CMI-Imagery-Band-5*R';
Datasets{6,1}='ABI-L2-CMI-Imagery-Band-6*R';
Datasets{7,1}='ABI-L2-CMI-Imagery-Band-7*R';
Datasets{8,1}='ABI-L2-CMI-Imagery-Band-8*R';
Datasets{9,1}='ABI-L2-CMI-Imagery-Band-9*R';
Datasets{10,1}='ABI-L2-CMI-Imagery-Band-10*R';
Datasets{11,1}='ABI-L2-CMI-Imagery-Band-11*R';
Datasets{12,1}='ABI-L2-CMI-Imagery-Band-12*R';
Datasets{13,1}='ABI-L2-CMI-Imagery-Band-13*R';
Datasets{14,1}='ABI-L2-CMI-Imagery-Band-14*R';
Datasets{15,1}='ABI-L2-CMI-Imagery-Band-15*R';
Datasets{16,1}='ABI-L2-CMI-Imagery-Band-16*R';
Datasets{17,1}='Do Not Use';
Datasets{18,1}='FullDisk-ABI-Cloud Top Temperature*R';
Datasets{19,1}='CONUS-GLM-L2_Lightning*R';
Datasets{20,1}='CONUS-ABI-L1-Radiance-Band-1*R';
Datasets{21,1}='CONUS-ABI-L1-Radiance-Band-2*R';
Datasets{22,1}='CONUS-ABI-L1-Radiance-Band-3*R';
Datasets{23,1}='CONUS-ABI-L1-Radiance-Band-4*R';
Datasets{24,1}='CONUS-ABI-L1-Radiance-Band-5*R';
Datasets{25,1}='CONUS-ABI-L1-Radiance-Band-6*R';
Datasets{26,1}='CONUS-ABI-L1-Radiance-Band-7*R';
Datasets{27,1}='CONUS-ABI-L1-Radiance-Band-8*R';
Datasets{28,1}='CONUS-ABI-L1-Radiance-Band-9*R';
Datasets{29,1}='CONUS-ABI-L1-Radiance-Band-10*R';
Datasets{30,1}='CONUS-ABI-L1-Radiance-Band-11*R';
Datasets{31,1}='CONUS-ABI-L1-Radiance-Band-12*R';
Datasets{32,1}='CONUS-ABI-L1-Radiance-Band-13*R';
Datasets{33,1}='CONUS-ABI-L1-Radiance-Band-14*R';
Datasets{34,1}='CONUS-ABI-L1-Radiance-Band-15*R';
Datasets{35,1}='CONUS-ABI-L1-Radiance-Band-16*R';
Datasets{36,1}='ABI-L2-Conus-CloudTop-Phase*R';
Datasets{37,1}='MesoScale1-ABI-L1-Radiance-Band01*R';
Datasets{38,1}='MesoScale1-ABI-L1-Radiance-Band02*R';
Datasets{39,1}='MesoScale1-ABI-L1-Radiance-Band03*R';
Datasets{40,1}='MesoScale1-ABI-L1-Radiance-Band04*R';
Datasets{41,1}='MesoScale1-ABI-L1-Radiance-Band05*R';
Datasets{42,1}='MesoScale1-ABI-L1-Radiance-Band06*R';
Datasets{43,1}='MesoScale1-ABI-L1-Radiance-Band07*R';
Datasets{44,1}='MesoScale1-ABI-L1-Radiance-Band08*R';
Datasets{45,1}='MesoScale1-ABI-L1-Radiance-Band09*R';
Datasets{46,1}='MesoScale1-ABI-L1-Radiance-Band10*R';
Datasets{47,1}='MesoScale1-ABI-L1-Radiance-Band11*R';
Datasets{48,1}='CONUS-ABI-L2-Imagery-Multiband*R';
Datasets{49,1}='Meso-ABI-L2_Imagery-Multiband*R';
Datasets{50,1}='FullDisk-ABI-L2-Imagery-Multiband*R';
Datasets{51,1}='CONUS-Cloud-Top-Heights*R';
Datasets{52,1}='FullDisk-Cloud-Top-Heights*R';
Datasets{53,1}='ABI-L2-Fire-Conus*R';
Datasets{54,1}='CONUS-Derived-Winds*R';
Datasets{55,1}='CONUS-CloudTop-Pressure*R';
Datasets{56,1}='Make New Folders For Image Data';
Datasets{57,1}='CONUS-ClearSky-Mask*R';
Datasets{58,1}='FullDisk-SeaSurfaceTemp*R';
Datasets{59,1}='Conus-LandSurfaceTemp*R';
Datasets{60,1}='Conus-CloudOptical-Depth*R';
Datasets{61,1}='Conus-Cloud-Particle-Size*R';
Datasets{62,1}='Conus-Aerosol-Detection*R';
Datasets{63,1}='Conus-Aerosol-Optical-Depth*R';
Datasets{64,1}='Conus-Derived-Stability-Indices*R';
Datasets{65,1}='Conus-Downward-ShortWave-Radiation*R';
Datasets{66,1}='Conus-Legacy-Vert-Moisture-Profile*R';
Datasets{67,1}='Conus-Legacy-Vert-Temp-Profile*R';
Datasets{68,1}='FullDisk-RainFall-Rate*R';
Datasets{69,1}='Conus-Total-Precip-Water*R';
Datasets{70,1}='FullDisk-Volcanic-Ash*R';
Datasets{71,1}='ABI-L2-Reflected ShortWave Radiation-Conus*R';
Datasets{72,1}='SUVI-L1b-Fe-093*R';
Datasets{73,1}='SUVI-L1b-Fe-131*R';
Datasets{74,1}='SUVI-L1b-Fe-171*R';
Datasets{75,1}='SUVI-L1b-Fe-195*R';
Datasets{76,1}='SUVI-L1b-Fe-284*R';
Datasets{77,1}='SUVI-L1b-He-303*R';
Datasets{78,1}='STOP RUN';
iReport=zeros(78,1);

% Set up some initial data
ProcFileList=cell(1,3);
ProcFileList{1,1}='File Type';
ProcFileList{1,2}='File Name';
ProcFileList{1,3}='Source Directory';
JpegFileList=cell(1,2);
JpegFileList{1,1}='Source Directory';
JpegFileList{1,2}='JpegFileName';

SetUpGoesWaveBandData();
toolbox='MATLAB Report Generator';
[RptGenPresent] = ToolboxChecker(toolbox);
toolbox='Image Processing Toolbox';
[ImageProcessPresent]=ToolboxChecker(toolbox);
% Start a PDF report if requested by user and user has the Matlab Report
% Generator Package Installed
if((iCreatePDFReport==1) && (RptGenPresent==1))
    import mlreportgen.dom.*;
    import mlreportgen.report.*;
    import mlreportgen.utils.*
    CreatePDFReportHeaderRev3
else
    fprintf(fid,'%s\n','No PDF report will be created for this run');
end
% Read Some needed data files
eval(['cd ' matlabpath(1:length(matlabpath)-1)]);
load(CalendarFileName);
load('StandardAtmosphere.mat');
% Load in the CountyBoundaryFiles
eval(['cd ' countyshapepath(1:length(countyshapepath)-1)]);
load('CountyBoundingBoxes.mat');
% Load in the list of USAStateShapeFiles
load(USAStatesFileName);
% Set up some colors that will be used in later plots
SetUpExtraColors()
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
igo=1;
NumProcFiles=0;

while igo>0 % This setup up a loop to processing various file until user decides to STOP RUN
    [indx,tf] = listdlg('PromptString',{'Select type of data to read'},...
    'SelectionMode','single','ListString',Datasets,'ListSize',[360,300]);
    a1=isempty(indx);
    if(a1==1)
        igo=0;
    else
        igo=1;
    end
    if(indx==78)
        igo=0;
    end
    if(igo==0)
        break
    end
GOES16path=GOES16BandPaths{indx,1};
% Go to the expected path
    eval(['cd ' GOES16path(1:length(GOES16path)-1)]);
    if(indx<17)
        ReadABIL2CMI()
    elseif(indx==17)
%        ReadCloudTopHeights(indx)
    elseif(indx==18)
        ReadCloudTopTempRev1()
    elseif(indx==19)
        ReadLightningData()    
    elseif((indx>=20) && (indx<=35))
        ReadABIL1Radiance() 
    elseif(indx==36)
        ReadCloudTopPhase()
    elseif((indx>=37) && (indx<=47))
        ReadABIL1Radiance()
    elseif(indx==48)
        ReadABIConusMultiband()  
    elseif(indx==49)
        ReadABIMesoMultiband() 
    elseif(indx==50)
        ReadABIFullDiskMultiband(indx)
    elseif((indx==51)|| (indx==52))
        ReadCloudTopHeightsRev1(indx)
    elseif(indx==53)
        ReadL2Fire()
    elseif(indx==54)
        ReadDerivedMotionWinds()
    elseif(indx==55)
        ReadCloudTopPressureRev1();
    elseif(indx==56)
        MakeNewImageFolder()
    elseif(indx==57)
        ReadClearSkyMask()
    elseif(indx==58)
        ReadSeaSurfaceTemperature()
    elseif(indx==59)
        ReadLandSurfaceTemperature()
    elseif(indx==60)
        ReadCloudOpticalDepth()
    elseif(indx==61)
        ReadCloudParticleSize()
    elseif(indx==62)
        ReadAerosolData()
    elseif(indx==63)
       ReadAerosolOpticalDepthData()
    elseif(indx==64)
       ReadDerivedStabilityIndices()
    elseif(indx==65)
       ReadDownwardShortWaveRadiation()
    elseif(indx==66)
        ReadLVM()
    elseif(indx==67)
        ReadLVT()
    elseif(indx==68)
        ReadRainFallRate()
    elseif(indx==69)
        ReadTotalPrecipWater()
    elseif(indx==70)
        ReadVolcanicAsh()
    elseif(indx==71)
        ReadReflectedShortWaveRadiation()
    elseif(indx==72)
        ReadSUVI_L1b_Fe093()
    elseif(indx==73)
        ReadSUVI_L1b_Fe131()
    elseif(indx==74)
        ReadSUVI_L1b_Fe171()
    elseif(indx==75)
        ReadSUVI_L1b_Fe195()
    elseif(indx==76)
        ReadSUVI_L1b_Fe284()
    elseif(indx==77)
        ReadSUVI_L1b_He303()
    end
end
endruntime=deblank(datestr(now));
endrunstr=strcat('Finished GOES 16 Run at-',endruntime);
fprintf(fid,'%s\n',endrunstr);
fclose(fid);
% Close a PDF report if one is created
a1=exist('rpt','var');
if((iCreatePDFReport==1) && (RptGenPresent==1))
    if(iReport(62,1)==1)
        CreateAerosolDataAlgoDesc
    end
    close(rpt);
    rptview(rpt)
    dispstr=strcat('Closed PDF Report-',pdffilename);
    disp(dispstr)
else
    disp('No pdf report generated by this run');
end
