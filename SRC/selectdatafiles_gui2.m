function selectdatafiles_gui2(hObject,eventdata,handles)
% created to allow user to set paths
% Written By: Stephen Forczyk
% Created: Sept 20,2016
% Revised:-----
% Classification: Unclassified
% Establish selected run parameters
global Default_View_Az Default_View_El;
global ThreatTraj ThreatType;
global idefault_rot numdatascols numdatasrows currentindex;
global CaseID FlyOutFan;
global plotVarIndex plotVariableName DefaultName;
global Table2D ColValues RowValues;
global ListBoxText ListIndex;
global gCaseID gFlyOutFan gMatFile;
global nTableRows nTableCols nvariables numaz;
global Demarcation VariableList fanType KVTrajList DummyValue;
global TimeTables VelTables FPATables TrajData;
global IntGr IntAlt;
global TrajFit numTimeInc numThreatTimeInc;
global ThreatLaunchLat ThreatLaunchLon ThreatLaunchTime;
global ThreatAimLat ThreatAimLon ThreatImpactTime;
global ThreatGroundRange ThreatTimeStep;
global InterceptorLat InterceptorLon InterceptorAlt;
global InterceptLat InterceptLon InterceptorAzimuth;
global DesiredInterceptAlt DesiredInterceptGRangeKm InterceptorHitTime;
global DesiredInterceptAltKm DesiredInterceptGRangeNm;
global InterceptorLaunchTime InterceptorTaloTimes InterceptorFlightTime;
global InterceptGroundRange InterceptHeading;
global MissDistanceKm KVOrigin OriginFlag OriginLat OriginLon;
global NumberAltRows NumberGRCols NumberPossKVTraj NumberActualKVTraj;
global ActualKVTrajIndices ActualKVIntCond;
global KVInterpTraj InterceptorType;
global ENUIntLat ENUIntLon ENUIntAlt InterceptIndex;
global iKVTraj iTgtTraj;
global AirBaseFile CityFileName MDAFile MaxMDACode MaxCityRank;
global OceanShapeFile RiverShapeFile LakesShapeFile topofile;
global MinorIslandsShapeFile USMilBasesShapeFile DateLineShapeFile;
global MapListFile2 MapListFile3
global MapProjectionType DAMatFileName CountryShapeFileCatalog;
global LakeLat LakeLon DateLineLat DateLineLon;
global DAPolygons;

global GlobalCameraHeightSFactor iplotcities;
global camera_view_angle;
global camlatoffset camlonoffset;
global globeMLineLocation globePLineLocation;
global ichanged1 ichanged2 ichanged3 ichanged4;
global camlighton camlightaz camlightel;
global globemaxcities globecityaltdisp globecitylatdisp globecitylondisp;
global globemapangseplimit;

% Detailed Map Variables
global DetailMapLimits DetailMapChoices DetailMapSelection DetailMapSelectionStr;
global DetailPlotMinorIslands DetailPlotWorldLakes DetailPlotCities;
global DetailDefendedAreas DetailMDAFacilities DetailAirBases;
global DetailRiverShapeFiles DetailRoadShapeFiles DetailRRShapeFiles;
global iBullsEye iBullsEyeStart iBullsEyeInc iDrawBullsEye;

global initialtimestr igrid ijpeg ilog imovie;
global legendstr1 legendstr2 legendstr3;
global fid fid2 fid3;
global vert1 hor1 widd lend;
global vert2 hor2 widd2 lend2;
global chart_time;
global Fz1 Fz2;
global idirector mov izoom iwindow;
global matpath matpath1;
global jpegpath mappath topopath;
global fanpath excelpath trajpath militarypath;
global figpath matlabfanpath screencapturepath;
global shapepath2 countrypath prefpath;
global countryshapepath stateshapepath;
global ipowerpoint PowerPointFile scaling stretching padding;
global statistics_toolbox signal_toolbox;
global ichartnum;
global MatlabVersion;
machine=2;
if(machine==1)
    widd2=720;
    lend2=580;
elseif(machine==2)
    widd2=1080;
    lend2=774;
elseif(machine==3)
    widd2=1200;
    lend2=900;
end
ichanged2=0;
% check to see if selected files exist on this machine
% if the files do not exist alert the user
eval(['cd ' militarypath(1:length(militarypath)-1)]);
a1=exist(AirBaseFile,'file');
eval(['cd ' matpath1(1:length(matpath1)-1)]);
a2=exist(MDAFile,'file');
eval(['cd ' shapepath2(1:length(shapepath2)-1)]);
a3=exist(USMilBasesShapeFile,'file');
eval(['cd ' matpath1(1:length(matpath1)-1)]);
a4=exist(CityFileName,'file');
a5=exist(DAMatFileName,'file');
eval(['cd ' shapepath2(1:length(shapepath2)-1)]);
a6=exist(OceanShapeFile,'file');
a7=exist(RiverShapeFile,'file');
a8=exist(LakesShapeFile,'file');
a9=exist(MinorIslandsShapeFile,'file');
a10=exist(DateLineShapeFile,'file');
eval(['cd ' topopath(1:length(topopath)-1)]);
a11=exist(topofile,'file');
eval(['cd ' matpath1(1:length(matpath1)-1)]);
a12=exist(CountryShapeFileCatalog,'file');
a16=exist(MapListFile2,'file');
a17=exist(MapListFile3,'file');

if(a1==0)
    dispstr=strcat('Sorry but file-',AirBaseFile,'-not found');
    UpdateMessageBox(dispstr,handles);
elseif(a1==2)
    dispstr=strcat('Ok file-',AirBaseFile,'-verified on this machine');
    UpdateMessageBox(dispstr,handles);
end
if(a2==0)
    dispstr=strcat('Sorry but file-',MDAFile,'-not found');
    UpdateMessageBox(dispstr,handles);
elseif(a2==2)
    dispstr=strcat('Ok file-',MDAFile,'-verified on this machine');
    UpdateMessageBox(dispstr,handles);
end
if(a3==0)
    dispstr=strcat('Sorry but file-',USMilBasesShapeFile,'-not found');
    UpdateMessageBox(dispstr,handles);
elseif(a3==2)
    dispstr=strcat('Ok file-',USMilBasesShapeFile,'-verified on this machine');
    UpdateMessageBox(dispstr,handles);
end
if(a4==0)
    dispstr=strcat('Sorry but file-',CityFileName,'-not found');
    UpdateMessageBox(dispstr,handles);
elseif(a4==2)
    dispstr=strcat('Ok file-',CityFileName,'-verified on this machine');
    UpdateMessageBox(dispstr,handles);
end
if(a5==0)
    dispstr=strcat('Sorry but file-',DAMatFileName,'-not found');
    UpdateMessageBox(dispstr,handles);
elseif(a5==2)
    dispstr=strcat('Ok file-',DAMatFileName,'-verified on this machine');
    UpdateMessageBox(dispstr,handles);
end
if(a6==0)
    dispstr=strcat('Sorry but file-',OceanShapeFile,'-not found');
    UpdateMessageBox(dispstr,handles);
elseif(a6==2)
    dispstr=strcat('Ok file-',OceanShapeFile,'-verified on this machine');
    UpdateMessageBox(dispstr,handles);
end
if(a7==0)
    dispstr=strcat('Sorry but file-',RiverShapeFile,'-not found');
    UpdateMessageBox(dispstr,handles);
elseif(a7==2)
    dispstr=strcat('Ok file-',RiverShapeFile,'-verified on this machine');
    UpdateMessageBox(dispstr,handles);
end
if(a8==0)
    dispstr=strcat('Sorry but file-',LakesShapeFile,'-not found');
    UpdateMessageBox(dispstr,handles);
elseif(a8==2)
    dispstr=strcat('Ok file-',LakesShapeFile,'-verified on this machine');
    UpdateMessageBox(dispstr,handles);
end
if(a9==0)
    dispstr=strcat('Sorry but file-',MinorIslandsShapeFile,'-not found');
    UpdateMessageBox(dispstr,handles);
elseif(a9==2)
    dispstr=strcat('Ok file-',MinorIslandsShapeFile,'-verified on this machine');
    UpdateMessageBox(dispstr,handles);
end
if(a10==0)
    dispstr=strcat('Sorry but file-',DateLineShapeFile,'-not found');
    UpdateMessageBox(dispstr,handles);
elseif(a10==2)
    dispstr=strcat('Ok file-',DateLineShapeFile,'-verified on this machine');
    UpdateMessageBox(dispstr,handles);
end
if(a11==0)
    dispstr=strcat('Sorry but file-',topofile,'-not found');
    UpdateMessageBox(dispstr,handles);
elseif(a10==2)
    dispstr=strcat('Ok file-',topofile,'-verified on this machine');
    UpdateMessageBox(dispstr,handles);
end
[hor2,vert2,Fz1,Fz2,machine]=SetScreenCoordinates(widd2,lend2);
% 
%  Create and then hide the UI as it is being constructed.
f = figure('Visible','off','Position',[hor2,vert2,widd2,lend2]);
set(gcf,'Color',[0 0 0]);
set(gcf,'MenuBar','none');
% ------ start building the controls onto the figure--------------------
htext0  = uicontrol('Style','text','String','Specify Various Files Needed',...
           'Position',[400,730,300,30],'BackGroundColor',[0 0 1],'ForeGroundColor',[1 0 0],...
           'FontSize',14,'FontWeight','bold');
%---------------- Show AirBase File Info-------------------------
htext1  = uicontrol('Style','text','String','Air Base File',...
           'Position',[50,690,150,20],'BackGroundColor',[0 0 1],'ForeGroundColor',[1 0 0],...
           'FontSize',12,'FontWeight','bold','TooltipString','Point Source File of Airbase Locations');
if(a1==2)
    hedit1  = uicontrol('Style','edit','String',AirBaseFile,...
            'Position',[220,690,500,20],'BackGroundColor',[1 1 0],'ForeGroundColor',[1 0 0],...
            'FontSize',12,'FontWeight','bold','TooltipString','This is the Current Folder/File');
elseif(a1==0)
    hedit1  = uicontrol('Style','edit','String','File Not Found-Help Find One !!!',...
            'Position',[220,690,500,20],'BackGroundColor',[1 0 1],'ForeGroundColor',[0 0 0],...
            'FontSize',12,'FontWeight','bold','TooltipString','File Not Found Help Find One !');
end
hbutton1  = uicontrol('Style','pushbutton','String','Select New Airbase File',...
           'Position',[740,690,300,20],'BackGroundColor',[0 1 0],'ForeGroundColor',[1 0 0],...
           'FontSize',12,'FontWeight','bold','Callback',@button1_Callback,'TooltipString',...
           'Push Me to Select New File');
%---------------- Show MDA Facilities File Info-------------------------
htext2  = uicontrol('Style','text','String','MDA Facilities File',...
           'Position',[50,660,150,20],'BackGroundColor',[0 0 1],'ForeGroundColor',[1 0 0],...
           'FontSize',12,'FontWeight','bold','TooltipString','This file is a set of point locations of MDA Facilities');
if(a2==2)
   hedit2  = uicontrol('Style','edit','String',MDAFile,...
           'Position',[220,660,500,20],'BackGroundColor',[1 1 0],'ForeGroundColor',[1 0 0],...
           'FontSize',12,'FontWeight','bold','TooltipString','This is the Current Folder/File');
elseif(a2==0)
   hedit2  = uicontrol('Style','edit','String','File Not Found-Help Find One !!!',...
           'Position',[220,660,500,20],'BackGroundColor',[1 0 1],'ForeGroundColor',[0 0 0],...
           'FontSize',12,'FontWeight','bold');
end
hbutton2  = uicontrol('Style','pushbutton','String','Select MDA File',...
           'Position',[740,660,300,20],'BackGroundColor',[0 1 0],'ForeGroundColor',[1 0 0],...
           'FontSize',12,'FontWeight','bold','Callback',@button2_Callback,...
           'TooltipString','Push Me to Select New File');
%---------------- Show US Military Base ShapeFile Info-------------------------
htext3  = uicontrol('Style','text','String','US MilitaryBase Shape File',...
           'Position',[50,630,150,20],'BackGroundColor',[0 0 1],'ForeGroundColor',[1 0 0],...
           'FontSize',12,'FontWeight','bold','TooltipString','This file has us military base shapefiles');
if(a3==2)
    hedit3  = uicontrol('Style','edit','String',USMilBasesShapeFile,...
           'Position',[220,630,500,20],'BackGroundColor',[1 1 0],'ForeGroundColor',[1 0 0],...
           'FontSize',12,'FontWeight','bold','TooltipString','This is the Current Folder/File');
elseif(a3==0)
    hedit3  = uicontrol('Style','edit','String','File Not Found Help Pick One !!!',...
           'Position',[220,630,500,20],'BackGroundColor',[1 0 1],'ForeGroundColor',[0 0 0],...
           'FontSize',12,'FontWeight','bold');
end
hbutton3  = uicontrol('Style','pushbutton','String','Select US Mil Base ShapeFile',...
           'Position',[740,630,300,20],'BackGroundColor',[0 1 0],'ForeGroundColor',[1 0 0],...
           'FontSize',12,'FontWeight','bold','Callback',@button3_Callback,...
           'TooltipString','Push Me to Select New File');
%---------------- Show CityFileName Info-------------------------
htext4  = uicontrol('Style','text','String','CityFileName',...
           'Position',[50,600,150,20],'BackGroundColor',[0 0 1],'ForeGroundColor',[1 0 0],...
           'FontSize',12,'FontWeight','bold','TooltipString','This file is a list of city positions by population');
if(a4==2)
    hedit4  = uicontrol('Style','edit','String',CityFileName,...
           'Position',[220,600,500,20],'BackGroundColor',[1 1 0],'ForeGroundColor',[1 0 0],...
           'FontSize',12,'FontWeight','bold','TooltipString','This is the Current Folder/File');
elseif(a4==2)
    hedit4  = uicontrol('Style','edit','String','File Not Found Help Pick One !!!',...
           'Position',[220,600,500,20],'BackGroundColor',[1 0 1],'ForeGroundColor',[0 0 0],...
           'FontSize',12,'FontWeight','bold');
end
hbutton4  = uicontrol('Style','pushbutton','String','Select City File Name',...
           'Position',[740,600,300,20],'BackGroundColor',[0 1 0],'ForeGroundColor',[1 0 0],...
           'FontSize',12,'FontWeight','bold','Callback',@button4_Callback,...
           'TooltipString','Push Me to Select New File');
%---------------- Show The Defended Area ShapeFiles Info-------------------------
htext5  = uicontrol('Style','text','String','Defended Area File',...
           'Position',[50,570,150,20],'BackGroundColor',[0 0 1],'ForeGroundColor',[1 0 0],...
           'FontSize',12,'FontWeight','bold','TooltipString','This file contains the defended area shapefiles');
if(a5==2)
    hedit5  = uicontrol('Style','edit','String',DAMatFileName,...
           'Position',[220,570,500,20],'BackGroundColor',[1 1 0],'ForeGroundColor',[1 0 0],...
           'FontSize',12,'FontWeight','bold','TooltipString','This is the Current Folder/File');
elseif(a5==0)
    hedit5  = uicontrol('Style','edit','String','File Does not exist Help Pixk one!!!',...
           'Position',[220,570,500,20],'BackGroundColor',[1 0 1],'ForeGroundColor',[0 0 0],...
           'FontSize',12,'FontWeight','bold');
end
hbutton5  = uicontrol('Style','pushbutton','String','Select Defended Area Shapefile',...
           'Position',[740,570,300,20],'BackGroundColor',[0 1 0],'ForeGroundColor',[1 0 0],...
           'FontSize',12,'FontWeight','bold','Callback',@button5_Callback,...
           'TooltipString','Push Me to Select New File');
%---------------- Show Ocean Shape File Path Info-------------------------
htext6  = uicontrol('Style','text','String','Ocean Shape File',...
           'Position',[50,540,150,20],'BackGroundColor',[0 0 1],'ForeGroundColor',[1 0 0],...
           'FontSize',12,'FontWeight','bold','TooltipString','This file has a low res world oceans shapefile');
if(a6==2)
    hedit6  = uicontrol('Style','edit','String',OceanShapeFile,...
           'Position',[220,540,500,20],'BackGroundColor',[1 1 0],'ForeGroundColor',[1 0 0],...
           'FontSize',12,'FontWeight','bold','TooltipString','This is the Current Folder/File');
elseif(a6==0)
    hedit6  = uicontrol('Style','edit','String','Path does exist pick a new one !!!',...
           'Position',[220,540,500,20],'BackGroundColor',[1 0 1],'ForeGroundColor',[0 0 0],...
           'FontSize',12,'FontWeight','bold');
end
hbutton6  = uicontrol('Style','pushbutton','String','Select New Path',...
           'Position',[740,540,300,20],'BackGroundColor',[0 1 0],'ForeGroundColor',[1 0 0],...
           'FontSize',12,'FontWeight','bold','Callback',@button6_Callback,...
           'TooltipString','Push Me to Select New File');
%---------------- Show River ShapeFile Path Info-------------------------
htext7  = uicontrol('Style','text','String','Global Lo Res River Shape File',...
           'Position',[50,510,150,20],'BackGroundColor',[0 0 1],'ForeGroundColor',[1 0 0],...
           'FontSize',12,'FontWeight','bold','TooltipString','This file has Lo Res Global River Data');
if(a7==2)
    hedit7  = uicontrol('Style','edit','String',RiverShapeFile,...
           'Position',[220,510,500,20],'BackGroundColor',[1 1 0],'ForeGroundColor',[1 0 0],...
           'FontSize',12,'FontWeight','bold','TooltipString','This is the Current Folder/File');
elseif(a7==0)
    hedit7  = uicontrol('Style','edit','String','Path does exist pick a new one !!!',...
           'Position',[220,510,500,20],'BackGroundColor',[1 0 1],'ForeGroundColor',[0 0 0],...
           'FontSize',12,'FontWeight','bold');
end
hbutton7  = uicontrol('Style','pushbutton','String','Select Global Lo Res River ShapeFile',...
           'Position',[740,510,300,20],'BackGroundColor',[0 1 0],'ForeGroundColor',[1 0 0],...
           'FontSize',12,'FontWeight','bold','Callback',@button7_Callback,...
           'TooltipString','Push Me to Select New File');
%---------------- Show Lakes Shape File Info-------------------------
htext8  = uicontrol('Style','text','String','Lakes ShapeFile',...
           'Position',[50,480,150,20],'BackGroundColor',[0 0 1],'ForeGroundColor',[1 0 0],...
           'FontSize',12,'FontWeight','bold','TooltipString',...
           'This file has Global Lo Res Lake Data');
if(a8==2)
    hedit8  = uicontrol('Style','edit','String',LakesShapeFile,...
           'Position',[220,480,500,20],'BackGroundColor',[1 1 0],'ForeGroundColor',[1 0 0],...
           'FontSize',12,'FontWeight','bold','TooltipString','This is the Current Folder/File');
elseif(a8==0)
    hedit8  = uicontrol('Style','edit','String','File does exist pick a new one !!!',...
           'Position',[220,480,500,20],'BackGroundColor',[1 0 1],'ForeGroundColor',[0 0 0],...
           'FontSize',12,'FontWeight','bold');
end
hbutton8  = uicontrol('Style','pushbutton','String','Select Global Lo Res Lakes ShapeFile',...
           'Position',[740,480,300,20],'BackGroundColor',[0 1 0],'ForeGroundColor',[1 0 0],...
           'FontSize',12,'FontWeight','bold','Callback',@button8_Callback,...
           'TooltipString','Push Me to Select New File');
%---------------- Show Minor Islands ShapeFile Info-------------------------
htext9  = uicontrol('Style','text','String',MinorIslandsShapeFile,...
           'Position',[50,450,150,20],'BackGroundColor',[0 0 1],'ForeGroundColor',[1 0 0],...
           'FontSize',12,'FontWeight','bold','TooltipString','This file is a Global Lo Res Minor Islands Shapefile');
if(a9==2)
    hedit9  = uicontrol('Style','edit','String',MinorIslandsShapeFile,...
           'Position',[220,450,500,20],'BackGroundColor',[1 1 0],'ForeGroundColor',[1 0 0],...
           'FontSize',12,'FontWeight','bold','TooltipString','This is the Current Folder/File');
elseif(a9==0)
    hedit9  = uicontrol('Style','edit','String','File does exist pick a new one !!!',...
           'Position',[220,450,500,20],'BackGroundColor',[1 0 1],'ForeGroundColor',[0 0 0],...
           'FontSize',12,'FontWeight','bold');
end
hbutton9  = uicontrol('Style','pushbutton','String','Select Global Lo Res Minor Islands ShapeFile',...
           'Position',[740,450,300,20],'BackGroundColor',[0 1 0],'ForeGroundColor',[1 0 0],...
           'FontSize',12,'FontWeight','bold','Callback',@button9_Callback,...
           'TooltipString','Push Me to Select New File');
%---------------- Show country Path Info-------------------------
htext10  = uicontrol('Style','text','String',DateLineShapeFile,...
           'Position',[50,420,150,20],'BackGroundColor',[0 0 1],'ForeGroundColor',[1 0 0],...
           'FontSize',12,'FontWeight','bold','TooltipString','This file shows the international dateline');
if(a10==2)
    hedit10  = uicontrol('Style','edit','String',DateLineShapeFile,...
           'Position',[220,420,500,20],'BackGroundColor',[1 1 0],'ForeGroundColor',[1 0 0],...
           'FontSize',12,'FontWeight','bold','TooltipString','This is the Current Folder/File');
elseif(a10==0)
    hedit10  = uicontrol('Style','edit','String','File does exist pick a new one !!!',...
           'Position',[220,420,500,20],'BackGroundColor',[1 0 1],'ForeGroundColor',[0 0 0],...
           'FontSize',12,'FontWeight','bold');
end
hbutton10  = uicontrol('Style','pushbutton','String','Select Lo Res Internation DateLine File',...
           'Position',[740,420,300,20],'BackGroundColor',[0 1 0],'ForeGroundColor',[1 0 0],...
           'FontSize',12,'FontWeight','bold','Callback',@button10_Callback,...
           'TooltipString','Push Me to Select New File');
%---------------- Show the topofile Info-------------------------
htext11  = uicontrol('Style','text','String','Global Topo File',...
           'Position',[50,390,150,20],'BackGroundColor',[0 0 1],'ForeGroundColor',[1 0 0],...
           'FontSize',12,'FontWeight','bold','TooltipString','This file has global topographic DEM data');
if(a11==2)
    hedit11  = uicontrol('Style','edit','String',topofile,...
           'Position',[220,390,500,20],'BackGroundColor',[1 1 0],'ForeGroundColor',[1 0 0],...
           'FontSize',12,'FontWeight','bold','TooltipString','This is the Current Folder/File');
elseif(a11==0)
    hedit11  = uicontrol('Style','edit','String','Path does exist pick a new one !!!',...
           'Position',[220,390,500,20],'BackGroundColor',[1 0 1],'ForeGroundColor',[0 0 0],...
           'FontSize',12,'FontWeight','bold');
end
hbutton11  = uicontrol('Style','pushbutton','String','Select Global Topo File',...
           'Position',[740,390,300,20],'BackGroundColor',[0 1 0],'ForeGroundColor',[1 0 0],...
           'FontSize',12,'FontWeight','bold','Callback',@button11_Callback,...
           'TooltipString','Push Me to Select New File');
%---------------- Show The Country Map Catalog Info -------------------------
htext12  = uicontrol('Style','text','String','Country Map Catalog',...
           'Position',[50,360,150,20],'BackGroundColor',[0 0 1],'ForeGroundColor',[1 0 0],...
           'FontSize',12,'FontWeight','bold','TooltipString',...
           'File has catalog of shapefiles available for each country');
if(a12==2)
    hedit12  = uicontrol('Style','edit','String',CountryShapeFileCatalog,...
           'Position',[220,360,500,20],'BackGroundColor',[1 1 0],'ForeGroundColor',[1 0 0],...
           'FontSize',12,'FontWeight','bold','TooltipString','This is the Current Catalog File');
elseif(a12==0)
    hedit12  = uicontrol('Style','edit','String','File does exist pick a new one !!!',...
           'Position',[220,360,500,20],'BackGroundColor',[1 0 1],'ForeGroundColor',[0 0 0],...
           'FontSize',12,'FontWeight','bold');
end
hbutton12  = uicontrol('Style','pushbutton','String','Select Country Catalog',...
           'Position',[740,360,300,20],'BackGroundColor',[0 1 0],'ForeGroundColor',[1 0 0],...
           'FontSize',12,'FontWeight','bold','Callback',@button12_Callback,...
           'TooltipString','Push Me to Select New File');
%---------------- USA State Catalog  -------------------------
htext16  = uicontrol('Style','text','String','US State Catalog',...
           'Position',[50,330,150,20],'BackGroundColor',[0 0 1],'ForeGroundColor',[1 0 0],...
           'FontSize',12,'FontWeight','bold','TooltipString',...
           'List Of USA State Maps');
if(a16==2)
    hedit16  = uicontrol('Style','edit','String',MapListFile2,...
           'Position',[220,330,500,20],'BackGroundColor',[1 1 0],'ForeGroundColor',[1 0 0],...
           'FontSize',12,'FontWeight','bold','TooltipString','This is the Current USA Map List');
elseif(a16==0)
    hedit16  = uicontrol('Style','edit','String','File does exist pick a new one !!!',...
           'Position',[220,330,500,20],'BackGroundColor',[1 0 1],'ForeGroundColor',[0 0 0],...
           'FontSize',12,'FontWeight','bold');
end
hbutton16  = uicontrol('Style','pushbutton','String','Select USA State Catalog',...
           'Position',[740,330,300,20],'BackGroundColor',[0 1 0],'ForeGroundColor',[1 0 0],...
           'FontSize',12,'FontWeight','bold','Callback',@button16_Callback,...
           'TooltipString','Push Me to Select New File');
%---------------- Canada Province Catalog  -------------------------
htext17  = uicontrol('Style','text','String','Canada Province Catalog',...
           'Position',[50,300,150,20],'BackGroundColor',[0 0 1],'ForeGroundColor',[1 0 0],...
           'FontSize',12,'FontWeight','bold','TooltipString',...
           'List Of Canada Province Maps');
if(a17==2)
    hedit17  = uicontrol('Style','edit','String',MapListFile3,...
           'Position',[220,300,500,20],'BackGroundColor',[1 1 0],'ForeGroundColor',[1 0 0],...
           'FontSize',12,'FontWeight','bold','TooltipString','This is the Current Canda Map List');
elseif(a17==0)
    hedit17  = uicontrol('Style','edit','String','File does exist pick a new one !!!',...
           'Position',[220,300,500,20],'BackGroundColor',[1 0 1],'ForeGroundColor',[0 0 0],...
           'FontSize',12,'FontWeight','bold');
end
hbutton17  = uicontrol('Style','pushbutton','String','Select Canada Province Catalog',...
           'Position',[740,300,300,20],'BackGroundColor',[0 1 0],'ForeGroundColor',[1 0 0],...
           'FontSize',12,'FontWeight','bold','Callback',@button17_Callback,...
           'TooltipString','Push Me to Select New File');
% --------------- Specify Max City Rank -------------------------
htext14  = uicontrol('Style','text','String','Max City Rank',...
           'Position',[50,220,150,20],'BackGroundColor',[0 0 1],'ForeGroundColor',[1 0 0],...
           'FontSize',12,'FontWeight','bold','TooltipString',...
           'Specify highest allowable city rank which goes from 1(large pop) thru 7 (small pop');
hedit14  = uicontrol('Style','edit','String','4',...
           'Position',[220,220,50,20],'BackGroundColor',[1 1 0],'ForeGroundColor',[1 0 0],...
           'FontSize',12,'FontWeight','bold','TooltipString','Maximum City Rank',...
           'Callback',@edit14_Callback,'Units','normalized');
% --------------- Specify Max MDA Facility Code Rank -------------------------
htext15  = uicontrol('Style','text','String','Max MDA Facility Code',...
           'Position',[50,190,150,20],'BackGroundColor',[0 0 1],'ForeGroundColor',[1 0 0],...
           'FontSize',12,'FontWeight','bold','TooltipString',...
           'Specify highest allowable MDA facility category 1 thru 9');
hedit15  = uicontrol('Style','edit','String','8',...
           'Position',[220,190,50,20],'BackGroundColor',[1 1 0],'ForeGroundColor',[1 0 0],...
           'FontSize',12,'FontWeight','bold','TooltipString','Maximum MDA Facility Category',...
           'Callback',@edit15_Callback,'Units','normalized');
%-----------------Save and Close Button-----------------------
hclosebutton  = uicontrol('Style','pushbutton','String','Close And Save Changes',...
           'Position',[780,80,220,40],'BackGroundColor',[0 1 0],'ForeGroundColor',[1 0 0],...
           'FontSize',12,'FontWeight','bold','Callback',@closebutton_Callback,'Units','normalized',...
           'TooltipString','This file will close the window and save any changes to the preference file');
%-----------------Set Next preference Button-----------------------
hnextprefbutton  = uicontrol('Style','pushbutton','String','Set Next Preference',...
           'Position',[780,30,220,40],'BackGroundColor',[0 1 0],'ForeGroundColor',[1 0 0],...
           'FontSize',12,'FontWeight','bold','Callback',@nextprefbutton_Callback,'Units','normalized',...
           'TooltipString','This file will close the window and move to the next preference window');
% Initialize the UI.
% Change units to normalized so components resize automatically.
f.Units = 'normalized';

htext0.Units='normalized';
htext1.Units = 'normalized';
hedit1.Units='normalized';
hbutton1.Units='normalized';
htext2.Units = 'normalized';
hedit2.Units='normalized';
hbutton2.Units='normalized';
htext3.Units = 'normalized';
hedit3.Units='normalized';
hbutton3.Units='normalized';



% Assign the a name to appear in the window title.
f.Name = 'File Selection GUI';

% Move the window to the center of the screen.
movegui(f,'center')

% Make the window visible.
f.Visible = 'on';

  function button1_Callback(source,eventdata)
       eval(['cd ' militarypath(1:length(militarypath)-1)]);
        [AirBaseFile PathName] = uigetfile({'*.mat'},'Select AirBase File');
        set(hedit1,'String',AirBaseFile);
        ichanged2=ichanged2+1;
        dispstr=strcat('Selected AirBaseFile as-',AirBaseFile);
        UpdateMessageBox(dispstr,handles);
  end

  function button2_Callback(source,eventdata)
        eval(['cd ' matpath1(1:length(matpath1)-1)]);
        [MDAFile PathName] = uigetfile({'*.mat'},'Select MDA Facilities File');
        set(hedit2,'String',MDAFile);
        ichanged2=ichanged2+1;
        dispstr=strcat('Selected MDAFile as-',MDAFile);
        UpdateMessageBox(dispstr,handles);
  end
  function button3_Callback(source,eventdata)
        eval(['cd ' shapepath2(1:length(shapepath2)-1)]);
       [USMilBasesShapeFile PathName] = uigetfile({'*.shp'},'Select US Miliary Base ShapeFile');
        set(hedit3,'String',USMilBasesShapeFile);
        ichanged2=ichanged2+1;
        dispstr=strcat('Selected US Military Base ShapeFile As-',USMilBasesShapeFile);
        UpdateMessageBox(dispstr,handles);
  end
  function button4_Callback(source,eventdata)
        eval(['cd ' matpath(1:length(matpath)-1)]);
        [CityFileName PathName] = uigetfile({'*.mat'},'Select World City File');
        set(hedit4,'String',CityFileName);
        ichanged2=ichanged2+1;
        dispstr=strcat('Selected World City Data File as-',CityFileName);
        UpdateMessageBox(dispstr,handles);
  end
  function button5_Callback(source,eventdata)
        eval(['cd ' matpath(1:length(matpath)-1)]);
        [DAMatFileName PathName] = uigetfile({'*.mat'},'Select Defended Area Shapefile');
        set(hedit5,'String',DAMatFileName);
        ichanged2=ichanged2+1;
        dispstr=strcat('Selected Defended Area ShapeFile as-',DAMatFileName);
        UpdateMessageBox(dispstr,handles);
  end
  function button6_Callback(source,eventdata)
        eval(['cd ' shapepath2(1:length(shapepath2)-1)]);
        [OceanShapeFile PathName] = uigetfile({'*.shp'},'Select Global Low Res Ocean ShapeFile');
        set(hedit6,'String',OceanShapeFile);
        ichanged2=ichanged2+1;
        dispstr=strcat('Selected Global Lo Res Ocean ShapeFile as-',OceanShapeFile);
        UpdateMessageBox(dispstr,handles);
  end
  function button7_Callback(source,eventdata)
        eval(['cd ' shapepath2(1:length(shapepath2)-1)]);
        [RiverShapeFile PathName] = uigetfile({'*.shp'},'Select Global Low Res River ShapeFile');
        set(hedit7,'String',RiverShapeFile);
        ichanged2=ichanged2+1;
        dispstr=strcat('Selected Global Lo Res River ShapeFile as-',RiverShapeFile);
        UpdateMessageBox(dispstr,handles);
  end
  function button8_Callback(source,eventdata)
        eval(['cd ' shapepath2(1:length(shapepath2)-1)]);
        [LakesShapeFile PathName] = uigetfile({'*.shp'},'Select Global Low Res Lake ShapeFile');
        set(hedit8,'String',matpath1);
        ichanged2=ichanged2+1;
        dispstr=strcat('Selected Global Lo Res Lake ShapeFile as-',LakesShapeFile);
        UpdateMessageBox(dispstr,handles);
  end
  function button9_Callback(source,eventdata)
        eval(['cd ' shapepath2(1:length(shapepath2)-1)]);
        [MinorIslandsShapeFile PathName] = uigetfile({'*.shp'},'Select Global Low Res Minor Islands ShapeFile');
        set(hedit9,'String',MinorIslandsShapeFile);
        ichanged2=ichanged2+1;
        dispstr=strcat('Selected Global Lo Res Minor Islands ShapesFile as-',MinorIslandsShapeFile);
        UpdateMessageBox(dispstr,handles);
  end
  function button10_Callback(source,eventdata)
        eval(['cd ' shapepath2(1:length(shapepath2)-1)]);
        [DateLineShapeFile PathName] = uigetfile({'*.shp'},'Select Lo Res International DateLine ShapeFile');
        set(hedit10,'String',DateLineShapeFile);
        ichanged2=ichanged2+1;
        dispstr=strcat('Selected International DateLine ShapeFile as-',DateLineShapeFile);
        UpdateMessageBox(dispstr,handles);
  end
  function button11_Callback(source,eventdata)
        eval(['cd ' topopath(1:length(topopath)-1)]);
        [topofile PathName] = uigetfile({'*.mat'},'Select a Global Topo DEM File');
        set(hedit11,'String',topofile);
        ichanged2=ichanged2+1;
        dispstr=strcat('Selected Global Topo File as-',topofile);
        UpdateMessageBox(dispstr,handles);
  end
  function button12_Callback(source,eventdata)
        eval(['cd ' matpath1(1:length(matpath1)-1)]);
        [CountryShapeFileCatalog PathName] = uigetfile({'*.mat'},'Select the Country ShapeFile Catalog');
        set(hedit12,'String',CountryShapeFileCatalog);
        ichanged2=ichanged2+1;
        dispstr=strcat('Selected Country ShapeFile Catalog-',CountryShapeFileCatalog);
        UpdateMessageBox(dispstr,handles);
  end
  function button13_Callback(source,eventdata)
        set(hedit13,'String','Not Assigned');
        ichanged2=ichanged2+1;
        dispstr=strcat('Not Assigned-','None');
        UpdateMessageBox(dispstr,handles);
  end
  function edit14_Callback(source,eventdata)
        maxcityrankstr=get(hedit14,'String');
        MaxCityRank=str2num(maxcityrankstr);
        ichanged2=ichanged2+1;
        dispstr=strcat('MaxCityRank-',maxcityrankstr);
        UpdateMessageBox(dispstr,handles);
  end
  function edit15_Callback(source,eventdata)
        maxmdacategorystr=get(hedit15,'String');
        MaxMDACode=str2num(maxmdacategorystr);
        ichanged2=ichanged2+1;
        dispstr=strcat('MaxMDACategory-',maxmdacategorystr);
        UpdateMessageBox(dispstr,handles);
  end

  function button16_Callback(source,eventdata)
        eval(['cd ' matpath1(1:length(matpath1)-1)]);
        [MapFileList2 PathName] = uigetfile({'*.mat'},'Select US State Maps Catalog');
        set(hedit16,'String',MapFileList2);
        ichanged2=ichanged2+1;
        dispstr=strcat('US State Calatog-',MapListFile2);
        UpdateMessageBox(dispstr,handles);
  end

  function button17_Callback(source,eventdata)
        eval(['cd ' matpath1(1:length(matpath1)-1)]);
        [MapFileList3 PathName] = uigetfile({'*.mat'},'Select Canda Province Maps Catalog');
        set(hedit17,'String',MapFileList3);
        ichanged2=ichanged2+1;
        dispstr=strcat('Canada Province Calatog-',MapListFile3);
        UpdateMessageBox(dispstr,handles);
  end

  function closebutton_Callback(source,eventdata)
    set(handles.Set_Paths_Tag,'Checked','On');
    eval(['cd ' prefpath(1:length(prefpath))]);
    SaveFanPreferenceFile(handles)
    dispstr='Saved File Preferences From File Selection Tab';
    UpdateMessageBox(dispstr,handles);
    close(gcf);
  end
  function nextprefbutton_Callback(source,eventdata)
    set(handles.Set_Paths_Tag,'Checked','On');
    if(ichanged2>0)
        eval(['cd ' prefpath(1:length(prefpath))]);
        SaveFanPreferenceFile(handles)
        dispstr='Saved File Preferences because at least 1  preference was changed from this tab';
        UpdateMessageBox(dispstr,handles);    
    end
    close(gcf);
    dispstr='Going to Global Map Preferences';
    UpdateMessageBox(dispstr,handles);
    globalmap_gui2(hObject,eventdata,handles)
  end
end