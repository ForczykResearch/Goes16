function pathdefinition_gui5a(hObject,eventdata,handles)
% created to allow user to set paths for the OSC Tool
% Written By: Stephen Forczyk
% Created: Dec 2,2017
% Revised: Feb 14,2018 Added some new paths
% Revised: Feb 23,2018 changed logic in change path dialog boxes
%          so that for OSC related files the current path will be
%          one folder up from the last folder selected
% Classification: Unclassified
% Establish selected run parameters
global Default_View_Az Default_View_El;


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
global matpath matpath1 facetpath;
global jpegpath mappath topopath shapepath2;
global bandsigspath sumarysigspath excelpath trajpath militarypath;
global tpvfluxpath sumrytrjpath prefpath;
global sumrytmppath sumryshppath;
global gradpath thrmvurpath outputpath;
global figpath thermalpath screencapturepath;
global inputpath librarypath countrypath canadapath;
global countryshapepath stateshapepath usstateboundariespath;
global docpath htmlpath;
global ipowerpoint PowerPointFile scaling stretching padding;
global statistics_toolbox signal_toolbox;
global ichartnum;
global MatlabVersion;
global jetmap;
global pwdnow;
machine=2;
if(machine==1)
    widd2=720;
    lend2=580;
elseif(machine==2)
    widd2=1080;
    lend2=874;
elseif(machine==3)
    widd2=1200;
    lend2=900;
end
ichanged1=0;
% check to see if selected directories exist on this machine
% if the directories do not exist prompt the user to suplly these paths
a1=exist(inputpath,'dir');
a2=exist(bandsigspath,'dir');
a3=exist(sumarysigspath,'dir');
a4=exist(sumrytrjpath,'dir');
a5=exist(screencapturepath,'dir');
a6=exist(mappath,'dir');
a7=exist(topopath,'dir');
a8=exist(matpath1,'dir');
%a9=exist(shapepath2,'dir');
a10=exist(countrypath,'dir');
a11=exist(militarypath,'dir');
a12=exist(countryshapepath,'dir');
a13=exist(stateshapepath,'dir');
a14=exist(canadapath,'dir');
a15=exist(usstateboundariespath,'dir');
a16=exist(docpath,'dir');
a17=exist(htmlpath,'dir');
a18=exist(thermalpath,'dir');
a19=exist(tpvfluxpath,'dir');
a20=exist(librarypath,'dir');
a21=exist(facetpath,'dir');
a22=exist(sumrytmppath,'dir');
a23=exist(sumryshppath,'dir');
a24=exist(thrmvurpath,'dir');
a25=exist(outputpath,'dir');
if(a1==0)
    dispstr=strcat('Sorry but directory-',inputpath,'-does not exist on this machine');
    UpdateMessageBox(dispstr,handles);
elseif(a1==7)
    dispstr=strcat('Ok directory-',inputpath,'-verified on this machine');
    UpdateMessageBox(dispstr,handles);
end 
if(a2==0)
    dispstr=strcat('Sorry but directory-',bandsigspath,'-does not exist on this machine');
    UpdateMessageBox(dispstr,handles);
elseif(a2==7)
    dispstr=strcat('Ok directory-',bandsigspath,'-verified on this machine');
    UpdateMessageBox(dispstr,handles);
end 
if(a3==0)
    dispstr=strcat('Sorry but directory-',sumarysigspath,'-does not exist on this machine');
    UpdateMessageBox(dispstr,handles);
elseif(a3==7)
    dispstr=strcat('Ok directory-',sumarysigspath,'-verified on this machine');
    UpdateMessageBox(dispstr,handles);
end
if(a4==0)
    dispstr=strcat('Sorry but directory-',sumrytrjpath,'-does not exist on this machine');
    UpdateMessageBox(dispstr,handles);
elseif(a4==7)
    dispstr=strcat('Ok directory-',sumrytrjpath,'-verified on this machine');
    UpdateMessageBox(dispstr,handles);
end
if(a5==0)
    dispstr=strcat('Sorry but directory-',screencapturepath,'-does not exist on this machine');
    UpdateMessageBox(dispstr,handles);
elseif(a5==7)
    dispstr=strcat('Ok directory-',screencapturepath,'-verified on this machine');
    UpdateMessageBox(dispstr,handles);
end
if(a6==0)
    dispstr=strcat('Sorry but directory-',mappath,'-does not exit on this machine');
    UpdateMessageBox(dispstr,handles);
elseif(a6==7)
    dispstr=strcat('Ok directory-',mappath,'-verified this machine');
    UpdateMessageBox(dispstr,handles);
end
if(a7==0)
    dispstr=strcat('Sorry but directory-',topopath,'-does not exist on this machine');
    UpdateMessageBox(dispstr,handles);
elseif(a7==7)
    dispstr=strcat('Ok directory-',topopath,'-verified on this machine');
    UpdateMessageBox(dispstr,handles);
end
if(a8==0)
    dispstr=strcat('Sorry but directory-',matpath1,'-does not exist on this machine');
    UpdateMessageBox(dispstr,handles);
elseif(a8==7)
    dispstr=strcat('Ok directory-',matpath1,'-verified on this machine');
    UpdateMessageBox(dispstr,handles);
end
if(a10==0)
    dispstr=strcat('Sorry but directory-',countrypath,'-does not exist on this machine');
    UpdateMessageBox(dispstr,handles);
elseif(a10==7)
    dispstr=strcat('Ok directory-',countrypath,'-verified on this machine');
    UpdateMessageBox(dispstr,handles);
end
if(a11==0)
    dispstr=strcat('Sorry but directory-',militarypath,'-does not exist on this machine');
    UpdateMessageBox(dispstr,handles);
elseif(a11==7)
    dispstr=strcat('Ok directory-',militarypath,'-verified on this machine');
    UpdateMessageBox(dispstr,handles);
end
if(a12==0)
    dispstr=strcat('Sorry but directory-',countryshapepath,'-does not exist on this machine');
    UpdateMessageBox(dispstr,handles);
elseif(a12==7)
    dispstr=strcat('Ok directory-',countryshapepath,'-verified on this machine');
    UpdateMessageBox(dispstr,handles);
end 
if(a13==0)
    dispstr=strcat('Sorry but directory-',stateshapepath,'-does not exist on this machine');
    UpdateMessageBox(dispstr,handles);
elseif(a13==7)
    dispstr=strcat('Ok directory-',stateshapepath,'-verified on this machine');
    UpdateMessageBox(dispstr,handles);
end
if(a14==0)
    dispstr=strcat('Sorry but directory-',canadapath,'-does not exist on this machine');
    UpdateMessageBox(dispstr,handles);
elseif(a14==7)
    dispstr=strcat('Ok directory-',canadapath,'-verified on this machine');
    UpdateMessageBox(dispstr,handles);
end
if(a15==0)
    dispstr=strcat('Sorry but directory-',usstateboundariespath,'-does not exist on this machine');
    UpdateMessageBox(dispstr,handles);
elseif(a15==7)
    dispstr=strcat('Ok directory-',usstateboundariespath,'-verified on this machine');
    UpdateMessageBox(dispstr,handles);
end
if(a16==0)
    dispstr=strcat('Sorry but directory-',docpath,'-does not exist on this machine');
    UpdateMessageBox(dispstr,handles);
elseif(a16==7)
    dispstr=strcat('Ok directory-',docpath,'-verified on this machine');
    UpdateMessageBox(dispstr,handles);
end
if(a17==0)
    dispstr=strcat('Sorry but directory-',htmlpath,'-does not exist on this machine');
    UpdateMessageBox(dispstr,handles);
elseif(a17==7)
    dispstr=strcat('Ok directory-',htmlpath,'-verified on this machine');
    UpdateMessageBox(dispstr,handles);
end
if(a18==0)
    dispstr=strcat('Sorry but directory-',thermalpath,'-does not exist on this machine');
    UpdateMessageBox(dispstr,handles);
elseif(a18==7)
    dispstr=strcat('Ok directory-',thermalpath,'-verified on this machine');
    UpdateMessageBox(dispstr,handles);
end
if(a19==0)
    dispstr=strcat('Sorry but directory-',tpvfluxpath,'-does not exist on this machine');
    UpdateMessageBox(dispstr,handles);
elseif(a19==7)
    dispstr=strcat('Ok directory-',tpvfluxpath,'-verified on this machine');
    UpdateMessageBox(dispstr,handles);
end
if(a20==0)
    dispstr=strcat('Sorry but directory-',librarypath,'-does not exist on this machine');
    UpdateMessageBox(dispstr,handles);
elseif(a20==7)
    dispstr=strcat('Ok directory-',librarypath,'-verified on this machine');
    UpdateMessageBox(dispstr,handles);
end
if(a21==0)
    dispstr=strcat('Sorry but directory-',facetpath,'-does not exist on this machine');
    UpdateMessageBox(dispstr,handles);
elseif(a21==7)
    dispstr=strcat('Ok directory-',facetpath,'-verified on this machine');
    UpdateMessageBox(dispstr,handles);
end
if(a22==0)
    dispstr=strcat('Sorry but directory-',sumrytmppath,'-does not exist on this machine');
    UpdateMessageBox(dispstr,handles);
elseif(a22==7)
    dispstr=strcat('Ok directory-',sumrytmppath,'-verified on this machine');
    UpdateMessageBox(dispstr,handles);
end
if(a23==0)
    dispstr=strcat('Sorry but directory-',sumryshppath,'-does not exist on this machine');
    UpdateMessageBox(dispstr,handles);
elseif(a23==7)
    dispstr=strcat('Ok directory-',sumryshppath,'-verified on this machine');
    UpdateMessageBox(dispstr,handles);
end
if(a24==0)
    dispstr=strcat('Sorry but directory-',thrmvurpath,'-does not exist on this machine');
    UpdateMessageBox(dispstr,handles);
elseif(a24==7)
    dispstr=strcat('Ok directory-',thrmvurpath,'-verified on this machine');
    UpdateMessageBox(dispstr,handles);
end
if(a25==0)
    dispstr=strcat('Sorry but directory-',outputpath,'-does not exist on this machine');
    UpdateMessageBox(dispstr,handles);
elseif(a25==7)
    dispstr=strcat('Ok directory-',outputpath,'-verified on this machine');
    UpdateMessageBox(dispstr,handles);
end
[hor2,vert2,Fz1,Fz2,machine]=SetScreenCoordinates(widd2,lend2);
% 
%  Create and then hide the UI as it is being constructed.
f = figure('Visible','off','Position',[hor2,vert2,widd2,lend2]);
set(gcf,'Color',[0 0 0]);
set(gcf,'MenuBar','none');
% ------ start building the controls onto the figure--------------------
htext0  = uicontrol('Style','text','String','Specify Default Paths',...
           'Position',[420,830,250,30],'BackGroundColor',[0 0 1],'ForeGroundColor',[1 0 0],...
           'FontSize',14,'FontWeight','bold');
%---------------- Show OSC Input File Info-------------------------
htext1  = uicontrol('Style','text','String','OSC Input Files',...
           'Position',[50,790,150,20],'BackGroundColor',[0 0 1],'ForeGroundColor',[1 0 0],...
           'FontSize',12,'FontWeight','bold','TooltipString','This folder has the OSC Input Files');
if(a1==7)
    hedit1  = uicontrol('Style','edit','String',inputpath,...
            'Position',[220,790,660,20],'BackGroundColor',[1 1 0],'ForeGroundColor',[1 0 0],...
            'FontSize',12,'FontWeight','bold','TooltipString','This is the Current Folder');
elseif(a1==0)
    hedit1  = uicontrol('Style','edit','String','Path does exist pick a new one !!!',...
            'Position',[220,790,660,20],'BackGroundColor',[1 0 1],'ForeGroundColor',[0 0 0],...
            'FontSize',12,'FontWeight','bold','TooltipString','This is the Current Folder');
end
hbutton1  = uicontrol('Style','pushbutton','String','Select New Path',...
           'Position',[900,790,150,20],'BackGroundColor',[0 1 0],'ForeGroundColor',[1 0 0],...
           'FontSize',12,'FontWeight','bold','Callback',@button1_Callback,'TooltipString',...
           'Push Me to Select New Folder');
%---------------- Show BandSigs File Path Info-------------------------
htext2  = uicontrol('Style','text','String','BandSigs Files',...
           'Position',[50,760,150,20],'BackGroundColor',[0 0 1],'ForeGroundColor',[1 0 0],...
           'FontSize',12,'FontWeight','bold','TooltipString','This folder is where BandSigs Files are stored');
if(a2==7)
   hedit2  = uicontrol('Style','edit','String',bandsigspath,...
           'Position',[220,760,660,20],'BackGroundColor',[1 1 0],'ForeGroundColor',[1 0 0],...
           'FontSize',12,'FontWeight','bold');
elseif(a2==0)
   hedit2  = uicontrol('Style','edit','String','Path does exist pick a new one !!!',...
           'Position',[220,760,660,20],'BackGroundColor',[1 0 1],'ForeGroundColor',[0 0 0],...
           'FontSize',12,'FontWeight','bold');
end
hbutton2  = uicontrol('Style','pushbutton','String','Select New Path',...
           'Position',[900,760,150,20],'BackGroundColor',[0 1 0],'ForeGroundColor',[1 0 0],...
           'FontSize',12,'FontWeight','bold','Callback',@button2_Callback);
%---------------- Show SumarySigs File Path Info-------------------------
htext3  = uicontrol('Style','text','String','SumarySigs Files',...
           'Position',[50,730,150,20],'BackGroundColor',[0 0 1],'ForeGroundColor',[1 0 0],...
           'FontSize',12,'FontWeight','bold','TooltipString','This folder is where the SumarySigs Files are stored');
if(a3==7)
    hedit3  = uicontrol('Style','edit','String',sumarysigspath,...
           'Position',[220,730,660,20],'BackGroundColor',[1 1 0],'ForeGroundColor',[1 0 0],...
           'FontSize',12,'FontWeight','bold');
elseif(a3==0)
    hedit3  = uicontrol('Style','edit','String','Path does exist pick a new one !!!',...
           'Position',[220,730,660,20],'BackGroundColor',[1 0 1],'ForeGroundColor',[0 0 0],...
           'FontSize',12,'FontWeight','bold');
end
hbutton3  = uicontrol('Style','pushbutton','String','Select New Path',...
           'Position',[900,730,150,20],'BackGroundColor',[0 1 0],'ForeGroundColor',[1 0 0],...
           'FontSize',12,'FontWeight','bold','Callback',@button3_Callback);
%---------------- Show Sumrytrajpath Info-------------------------
htext4  = uicontrol('Style','text','String','SumaryTraj Files',...
           'Position',[50,700,150,20],'BackGroundColor',[0 0 1],'ForeGroundColor',[1 0 0],...
           'FontSize',12,'FontWeight','bold','TooltipString','This folder is OSC summary traj path info is stored');
if(a4==7)
    hedit4  = uicontrol('Style','edit','String',sumrytrjpath,...
           'Position',[220,700,660,20],'BackGroundColor',[1 1 0],'ForeGroundColor',[1 0 0],...
           'FontSize',12,'FontWeight','bold');
elseif(a4==0)
    hedit4  = uicontrol('Style','edit','String','Path does exist pick a new one !!!',...
           'Position',[220,700,660,20],'BackGroundColor',[1 0 1],'ForeGroundColor',[0 0 0],...
           'FontSize',12,'FontWeight','bold');
end
hbutton4  = uicontrol('Style','pushbutton','String','Select New Path',...
           'Position',[900,700,150,20],'BackGroundColor',[0 1 0],'ForeGroundColor',[1 0 0],...
          'FontSize',12,'FontWeight','bold','Callback',@button4_Callback);
%---------------- Show Thermal Path Info-------------------------
htext18  = uicontrol('Style','text','String','Thermal Files',...
           'Position',[50,670,150,20],'BackGroundColor',[0 0 1],'ForeGroundColor',[1 0 0],...
           'FontSize',12,'FontWeight','bold','TooltipString','This folder is OSC Thermal Data is stored');
if(a18==7)
    hedit18  = uicontrol('Style','edit','String',thermalpath,...
           'Position',[220,670,660,20],'BackGroundColor',[1 1 0],'ForeGroundColor',[1 0 0],...
           'FontSize',12,'FontWeight','bold');
elseif(a18==0)
    hedit18  = uicontrol('Style','edit','String','Path does exist pick a new one !!!',...
           'Position',[220,670,660,20],'BackGroundColor',[1 0 1],'ForeGroundColor',[0 0 0],...
           'FontSize',12,'FontWeight','bold');
end
hbutton18  = uicontrol('Style','pushbutton','String','Select New Path',...
           'Position',[900,670,150,20],'BackGroundColor',[0 1 0],'ForeGroundColor',[1 0 0],...
          'FontSize',12,'FontWeight','bold','Callback',@button18_Callback);
%---------------- Show TPVFlux Path Info-------------------------
htext19  = uicontrol('Style','text','String','TPVFlux Files',...
           'Position',[50,640,150,20],'BackGroundColor',[0 0 1],'ForeGroundColor',[1 0 0],...
           'FontSize',12,'FontWeight','bold','TooltipString','This folder is OSC Thermal Data is stored');
if(a19==7)
    hedit19  = uicontrol('Style','edit','String',tpvfluxpath,...
           'Position',[220,640,660,20],'BackGroundColor',[1 1 0],'ForeGroundColor',[1 0 0],...
           'FontSize',12,'FontWeight','bold');
elseif(a19==0)
    hedit19  = uicontrol('Style','edit','String','Path does exist pick a new one !!!',...
           'Position',[220,640,660,20],'BackGroundColor',[1 0 1],'ForeGroundColor',[0 0 0],...
           'FontSize',12,'FontWeight','bold');
end
hbutton19  = uicontrol('Style','pushbutton','String','Select New Path',...
           'Position',[900,640,150,20],'BackGroundColor',[0 1 0],'ForeGroundColor',[1 0 0],...
          'FontSize',12,'FontWeight','bold','Callback',@button19_Callback);
%---------------- Show Facet Path Info-------------------------
htext21  = uicontrol('Style','text','String','Facet Files',...
           'Position',[50,610,150,20],'BackGroundColor',[0 0 1],'ForeGroundColor',[1 0 0],...
           'FontSize',12,'FontWeight','bold','TooltipString','This folder is OSC Facet Data is stored');
if(a21==7)
    hedit21  = uicontrol('Style','edit','String',facetpath,...
           'Position',[220,610,660,20],'BackGroundColor',[1 1 0],'ForeGroundColor',[1 0 0],...
           'FontSize',12,'FontWeight','bold');
elseif(a21==0)
    hedit21  = uicontrol('Style','edit','String','Path does exist pick a new one !!!',...
           'Position',[220,610,660,20],'BackGroundColor',[1 0 1],'ForeGroundColor',[0 0 0],...
           'FontSize',12,'FontWeight','bold');
end
hbutton21  = uicontrol('Style','pushbutton','String','Select New Path',...
           'Position',[900,610,150,20],'BackGroundColor',[0 1 0],'ForeGroundColor',[1 0 0],...
          'FontSize',12,'FontWeight','bold','Callback',@button21_Callback);
%---------------- Show SUMRYTMP Path Info-------------------------
htext22  = uicontrol('Style','text','String','SumryTmp Files',...
           'Position',[50,580,150,20],'BackGroundColor',[0 0 1],'ForeGroundColor',[1 0 0],...
           'FontSize',12,'FontWeight','bold','TooltipString','This folder is OSC SUMRYTMP Data is stored');
if(a22==7)
    hedit22  = uicontrol('Style','edit','String',sumrytmppath,...
           'Position',[220,580,660,20],'BackGroundColor',[1 1 0],'ForeGroundColor',[1 0 0],...
           'FontSize',12,'FontWeight','bold');
elseif(a22==0)
    hedit22  = uicontrol('Style','edit','String','Path does exist pick a new one !!!',...
           'Position',[220,580,660,20],'BackGroundColor',[1 0 1],'ForeGroundColor',[0 0 0],...
           'FontSize',12,'FontWeight','bold');
end
hbutton22  = uicontrol('Style','pushbutton','String','Select New Path',...
           'Position',[900,580,150,20],'BackGroundColor',[0 1 0],'ForeGroundColor',[1 0 0],...
          'FontSize',12,'FontWeight','bold','Callback',@button22_Callback);
%---------------- Show SUMRYSHP Path Info-------------------------
htext23  = uicontrol('Style','text','String','SumryShp Files',...
           'Position',[50,550,150,20],'BackGroundColor',[0 0 1],'ForeGroundColor',[1 0 0],...
           'FontSize',12,'FontWeight','bold','TooltipString','This folder is OSC SUMRYSHP Data is stored');
if(a23==7)
    hedit23  = uicontrol('Style','edit','String',sumryshppath,...
           'Position',[220,550,660,20],'BackGroundColor',[1 1 0],'ForeGroundColor',[1 0 0],...
           'FontSize',12,'FontWeight','bold');
elseif(a23==0)
    hedit23  = uicontrol('Style','edit','String','Path does exist pick a new one !!!',...
           'Position',[220,550,660,20],'BackGroundColor',[1 0 1],'ForeGroundColor',[0 0 0],...
           'FontSize',12,'FontWeight','bold');
end
hbutton23  = uicontrol('Style','pushbutton','String','Select New Path',...
           'Position',[900,550,150,20],'BackGroundColor',[0 1 0],'ForeGroundColor',[1 0 0],...
          'FontSize',12,'FontWeight','bold','Callback',@button23_Callback);
%---------------- Show ScreenCapturePath Path Info-------------------------
htext5  = uicontrol('Style','text','String','Screen Capture Files',...
           'Position',[50,520,150,20],'BackGroundColor',[0 0 1],'ForeGroundColor',[1 0 0],...
           'FontSize',12,'FontWeight','bold','TooltipString','This folder is where screen grabs are stored');
if(a5==7)
    hedit5  = uicontrol('Style','edit','String',screencapturepath,...
           'Position',[220,520,660,20],'BackGroundColor',[1 1 0],'ForeGroundColor',[1 0 0],...
           'FontSize',12,'FontWeight','bold');
elseif(a5==0)
    hedit5  = uicontrol('Style','edit','String','Path does exist pick a new one !!!',...
           'Position',[220,520,660,20],'BackGroundColor',[1 0 1],'ForeGroundColor',[0 0 0],...
           'FontSize',12,'FontWeight','bold');
end
hbutton5  = uicontrol('Style','pushbutton','String','Select New Path',...
           'Position',[900,520,150,20],'BackGroundColor',[0 1 0],'ForeGroundColor',[1 0 0],...
           'FontSize',12,'FontWeight','bold','Callback',@button5_Callback);
%---------------- Show THRMVUR Path Info-------------------------
htext24  = uicontrol('Style','text','String','THRMVUR Files',...
           'Position',[50,490,150,20],'BackGroundColor',[0 0 1],'ForeGroundColor',[1 0 0],...
           'FontSize',12,'FontWeight','bold','TooltipString','This folder is where THRMVUR Files are stored');
if(a24==7)
    hedit24  = uicontrol('Style','edit','String',thrmvurpath,...
           'Position',[220,490,660,20],'BackGroundColor',[1 1 0],'ForeGroundColor',[1 0 0],...
           'FontSize',12,'FontWeight','bold');
elseif(a24==0)
    hedit24  = uicontrol('Style','edit','String','Path does exist pick a new one !!!',...
           'Position',[220,490,660,20],'BackGroundColor',[1 0 1],'ForeGroundColor',[0 0 0],...
           'FontSize',12,'FontWeight','bold');
end
hbutton24  = uicontrol('Style','pushbutton','String','Select New Path',...
           'Position',[900,490,150,20],'BackGroundColor',[0 1 0],'ForeGroundColor',[1 0 0],...
           'FontSize',12,'FontWeight','bold','Callback',@button24_Callback);
%---------------- Show Output Path Info-------------------------
htext25  = uicontrol('Style','text','String','Output Files',...
           'Position',[50,460,150,20],'BackGroundColor',[0 0 1],'ForeGroundColor',[1 0 0],...
           'FontSize',12,'FontWeight','bold','TooltipString','This folder is where Output Files are stored');
if(a25==7)
    hedit25  = uicontrol('Style','edit','String',outputpath,...
           'Position',[220,460,660,20],'BackGroundColor',[1 1 0],'ForeGroundColor',[1 0 0],...
           'FontSize',12,'FontWeight','bold');
elseif(a25==0)
    hedit25  = uicontrol('Style','edit','String','Path does exist pick a new one !!!',...
           'Position',[220,460,660,20],'BackGroundColor',[1 0 1],'ForeGroundColor',[0 0 0],...
           'FontSize',12,'FontWeight','bold');
end
hbutton25  = uicontrol('Style','pushbutton','String','Select New Path',...
           'Position',[900,460,150,20],'BackGroundColor',[0 1 0],'ForeGroundColor',[1 0 0],...
           'FontSize',12,'FontWeight','bold','Callback',@button25_Callback);
%---------------- Show Library Path Info-------------------------
htext20  = uicontrol('Style','text','String','OSC Library Files',...
           'Position',[50,430,150,20],'BackGroundColor',[0 0 1],'ForeGroundColor',[1 0 0],...
           'FontSize',12,'FontWeight','bold','TooltipString','This folder is OSC Thermal Data is stored');
if(a20==7)
    hedit20  = uicontrol('Style','edit','String',librarypath,...
           'Position',[220,430,660,20],'BackGroundColor',[1 1 0],'ForeGroundColor',[1 0 0],...
           'FontSize',12,'FontWeight','bold');
elseif(a20==0)
    hedit20  = uicontrol('Style','edit','String','Path does exist pick a new one !!!',...
           'Position',[220,430,660,20],'BackGroundColor',[1 0 1],'ForeGroundColor',[0 0 0],...
           'FontSize',12,'FontWeight','bold');
end
hbutton20  = uicontrol('Style','pushbutton','String','Select New Path',...
           'Position',[900,430,150,20],'BackGroundColor',[0 1 0],'ForeGroundColor',[1 0 0],...
          'FontSize',12,'FontWeight','bold','Callback',@button20_Callback);
%---------------- Show MapPath Path Info-------------------------
htext6  = uicontrol('Style','text','String','Map Files',...
           'Position',[50,400,150,20],'BackGroundColor',[0 0 1],'ForeGroundColor',[1 0 0],...
           'FontSize',12,'FontWeight','bold','TooltipString','This folder has country boundary files');
if(a6==7)
    hedit6  = uicontrol('Style','edit','String',mappath,...
           'Position',[220,400,660,20],'BackGroundColor',[1 1 0],'ForeGroundColor',[1 0 0],...
           'FontSize',12,'FontWeight','bold');
elseif(a6==0)
    hedit6  = uicontrol('Style','edit','String','Path does exist pick a new one !!!',...
           'Position',[220,400,660,20],'BackGroundColor',[1 0 1],'ForeGroundColor',[0 0 0],...
           'FontSize',12,'FontWeight','bold');
end
hbutton6  = uicontrol('Style','pushbutton','String','Select New Path',...
           'Position',[900,400,150,20],'BackGroundColor',[0 1 0],'ForeGroundColor',[1 0 0],...
           'FontSize',12,'FontWeight','bold','Callback',@button6_Callback);
%---------------- Show Topo Path Info-------------------------
htext7  = uicontrol('Style','text','String','Topographic Files',...
           'Position',[50,370,150,20],'BackGroundColor',[0 0 1],'ForeGroundColor',[1 0 0],...
           'FontSize',12,'FontWeight','bold','TooltipString','This folder has Topographic DEM Files');
if(a7==7)
    hedit7  = uicontrol('Style','edit','String',topopath,...
           'Position',[220,370,660,20],'BackGroundColor',[1 1 0],'ForeGroundColor',[1 0 0],...
           'FontSize',12,'FontWeight','bold');
elseif(a7==0)
    hedit7  = uicontrol('Style','edit','String','Path does exist pick a new one !!!',...
           'Position',[220,370,660,20],'BackGroundColor',[1 0 1],'ForeGroundColor',[0 0 0],...
           'FontSize',12,'FontWeight','bold');
end
hbutton7  = uicontrol('Style','pushbutton','String','Select New Path',...
           'Position',[900,370,150,20],'BackGroundColor',[0 1 0],'ForeGroundColor',[1 0 0],...
           'FontSize',12,'FontWeight','bold','Callback',@button7_Callback);
%---------------- Show matpath1 Path Info-------------------------
htext8  = uicontrol('Style','text','String','Geographic Files',...
           'Position',[50,340,150,20],'BackGroundColor',[0 0 1],'ForeGroundColor',[1 0 0],...
           'FontSize',12,'FontWeight','bold','TooltipString',...
           'Here is variety of Matlab files such as City data,Defended Area and Map Lists');
if(a8==7)
    hedit8  = uicontrol('Style','edit','String',matpath1,...
           'Position',[220,340,660,20],'BackGroundColor',[1 1 0],'ForeGroundColor',[1 0 0],...
           'FontSize',12,'FontWeight','bold');
elseif(a8==0)
    hedit8  = uicontrol('Style','edit','String','Path does exist pick a new one !!!',...
           'Position',[220,340,660,20],'BackGroundColor',[1 0 1],'ForeGroundColor',[0 0 0],...
           'FontSize',12,'FontWeight','bold');
end
hbutton8  = uicontrol('Style','pushbutton','String','Select New Path',...
           'Position',[900,340,150,20],'BackGroundColor',[0 1 0],'ForeGroundColor',[1 0 0],...
           'FontSize',12,'FontWeight','bold','Callback',@button8_Callback);
%---------------- Show country Path Info-------------------------
htext10  = uicontrol('Style','text','String','Country Files',...
           'Position',[50,310,150,20],'BackGroundColor',[0 0 1],'ForeGroundColor',[1 0 0],...
           'FontSize',12,'FontWeight','bold','TooltipString','This folder has country borders in matlab format');
if(a10==7)
    hedit10  = uicontrol('Style','edit','String',countrypath,...
           'Position',[220,310,660,20],'BackGroundColor',[1 1 0],'ForeGroundColor',[1 0 0],...
           'FontSize',12,'FontWeight','bold');
elseif(a10==0)
    hedit10  = uicontrol('Style','edit','String','Path does exist pick a new one !!!',...
           'Position',[220,310,660,20],'BackGroundColor',[1 0 1],'ForeGroundColor',[0 0 0],...
           'FontSize',12,'FontWeight','bold');
end
hbutton10  = uicontrol('Style','pushbutton','String','Select New Path',...
           'Position',[900,310,150,20],'BackGroundColor',[0 1 0],'ForeGroundColor',[1 0 0],...
           'FontSize',12,'FontWeight','bold','Callback',@button10_Callback);
%---------------- Show military Path Info-------------------------
htext11  = uicontrol('Style','text','String','Military Base Files',...
           'Position',[50,280,150,20],'BackGroundColor',[0 0 1],'ForeGroundColor',[1 0 0],...
           'FontSize',12,'FontWeight','bold','TooltipString','This folder has military base locations in matlab format');
if(a11==7)
    hedit11  = uicontrol('Style','edit','String',militarypath,...
           'Position',[220,280,660,20],'BackGroundColor',[1 1 0],'ForeGroundColor',[1 0 0],...
           'FontSize',12,'FontWeight','bold');
elseif(a11==0)
    hedit11  = uicontrol('Style','edit','String','Path does exist pick a new one !!!',...
           'Position',[220,280,660,20],'BackGroundColor',[1 0 1],'ForeGroundColor',[0 0 0],...
           'FontSize',12,'FontWeight','bold');
end
hbutton11  = uicontrol('Style','pushbutton','String','Select New Path',...
           'Position',[900,280,150,20],'BackGroundColor',[0 1 0],'ForeGroundColor',[1 0 0],...
           'FontSize',12,'FontWeight','bold','Callback',@button11_Callback);
%---------------- Show country shape Path Info-------------------------
htext12  = uicontrol('Style','text','String','Country Shape Files',...
           'Position',[50,250,150,20],'BackGroundColor',[0 0 1],'ForeGroundColor',[1 0 0],...
           'FontSize',12,'FontWeight','bold','TooltipString',...
           'This folder has additional country geographic data in shapefile format');
if(a12==7)
    hedit12  = uicontrol('Style','edit','String',countryshapepath,...
           'Position',[220,250,660,20],'BackGroundColor',[1 1 0],'ForeGroundColor',[1 0 0],...
           'FontSize',12,'FontWeight','bold');
elseif(a12==0)
    hedit12  = uicontrol('Style','edit','String','Path does exist pick a new one !!!',...
           'Position',[220,250,660,20],'BackGroundColor',[1 0 1],'ForeGroundColor',[0 0 0],...
           'FontSize',12,'FontWeight','bold');
end
hbutton12  = uicontrol('Style','pushbutton','String','Select New Path',...
           'Position',[900,250,150,20],'BackGroundColor',[0 1 0],'ForeGroundColor',[1 0 0],...
           'FontSize',12,'FontWeight','bold','Callback',@button12_Callback);
%---------------- Show us states shape Path Info-------------------------
htext13  = uicontrol('Style','text','String','State ShapeFiles',...
           'Position',[50,220,150,20],'BackGroundColor',[0 0 1],'ForeGroundColor',[1 0 0],...
           'FontSize',12,'FontWeight','bold','TooltipString',...
           'This folder has additional us state geographic data in shapefile format');
if(a13==7)
    hedit13  = uicontrol('Style','edit','String',stateshapepath,...
           'Position',[220,220,660,20],'BackGroundColor',[1 1 0],'ForeGroundColor',[1 0 0],...
           'FontSize',12,'FontWeight','bold');
elseif(a13==0)
    hedit13  = uicontrol('Style','edit','String','Path does exist pick a new one !!!',...
           'Position',[220,220,660,20],'BackGroundColor',[1 0 1],'ForeGroundColor',[0 0 0],...
           'FontSize',12,'FontWeight','bold');
end
hbutton13  = uicontrol('Style','pushbutton','String','Select New Path',...
           'Position',[900,220,150,20],'BackGroundColor',[0 1 0],'ForeGroundColor',[1 0 0],...
           'FontSize',12,'FontWeight','bold','Callback',@button13_Callback);
%---------------- Show us Canada Provinces shape Path Info-------------------------
htext14  = uicontrol('Style','text','String','Canada Provinces shapefile Data Path',...
           'Position',[50,190,150,20],'BackGroundColor',[0 0 1],'ForeGroundColor',[1 0 0],...
           'FontSize',12,'FontWeight','bold','TooltipString',...
           'This folder has additional us state geographic data in shapefile format');
if(a14==7)
    hedit14  = uicontrol('Style','edit','String',canadapath,...
           'Position',[220,190,660,20],'BackGroundColor',[1 1 0],'ForeGroundColor',[1 0 0],...
           'FontSize',12,'FontWeight','bold');
elseif(a14==0)
    hedit14  = uicontrol('Style','edit','String','Path does exist pick a new one !!!',...
           'Position',[220,190,660,20],'BackGroundColor',[1 0 1],'ForeGroundColor',[0 0 0],...
           'FontSize',12,'FontWeight','bold');
end
hbutton14  = uicontrol('Style','pushbutton','String','Select New Path',...
           'Position',[900,190,150,20],'BackGroundColor',[0 1 0],'ForeGroundColor',[1 0 0],...
           'FontSize',12,'FontWeight','bold','Callback',@button14_Callback);
%---------------- Show us US State Boundaries Path Info-------------------------
htext15  = uicontrol('Style','text','String','State Boundaries',...
           'Position',[50,160,150,20],'BackGroundColor',[0 0 1],'ForeGroundColor',[1 0 0],...
           'FontSize',12,'FontWeight','bold','TooltipString',...
           'This folder has additional us state geographic data in shapefile format');
if(a15==7)
    hedit15  = uicontrol('Style','edit','String',usstateboundariespath,...
           'Position',[220,160,660,20],'BackGroundColor',[1 1 0],'ForeGroundColor',[1 0 0],...
           'FontSize',12,'FontWeight','bold');
elseif(a15==0)
    hedit15  = uicontrol('Style','edit','String','Path does exist pick a new one !!!',...
           'Position',[220,160,660,20],'BackGroundColor',[1 0 1],'ForeGroundColor',[0 0 0],...
           'FontSize',12,'FontWeight','bold');
end
hbutton15  = uicontrol('Style','pushbutton','String','Select New Path',...
           'Position',[900,160,150,20],'BackGroundColor',[0 1 0],'ForeGroundColor',[1 0 0],...
           'FontSize',12,'FontWeight','bold','Callback',@button15_Callback);
%---------------- Show us the Documentation Path Info-------------------------
htext16  = uicontrol('Style','text','String','Doc Files',...
           'Position',[50,130,150,20],'BackGroundColor',[0 0 1],'ForeGroundColor',[1 0 0],...
           'FontSize',12,'FontWeight','bold','TooltipString',...
           'This folder has program documentation in word format');
if(a16==7)
    hedit16  = uicontrol('Style','edit','String',docpath,...
           'Position',[220,130,660,20],'BackGroundColor',[1 1 0],'ForeGroundColor',[1 0 0],...
           'FontSize',12,'FontWeight','bold');
elseif(a16==0)
    hedit16  = uicontrol('Style','edit','String','Path does exist pick a new one !!!',...
           'Position',[220,130,660,20],'BackGroundColor',[1 0 1],'ForeGroundColor',[0 0 0],...
           'FontSize',12,'FontWeight','bold');
end
hbutton16  = uicontrol('Style','pushbutton','String','Select New Path',...
           'Position',[900,130,150,20],'BackGroundColor',[0 1 0],'ForeGroundColor',[1 0 0],...
           'FontSize',12,'FontWeight','bold','Callback',@button16_Callback);
%---------------- Show us the HTML Path Info-------------------------
htext17  = uicontrol('Style','text','String','HTML Files',...
           'Position',[50,100,150,20],'BackGroundColor',[0 0 1],'ForeGroundColor',[1 0 0],...
           'FontSize',12,'FontWeight','bold','TooltipString',...
           'This folder has program documentation in html format');
if(a17==7)
    hedit17  = uicontrol('Style','edit','String',htmlpath,...
           'Position',[220,100,660,20],'BackGroundColor',[1 1 0],'ForeGroundColor',[1 0 0],...
           'FontSize',12,'FontWeight','bold');
elseif(a17==0)
    hedit17  = uicontrol('Style','edit','String','Path does exist pick a new one !!!',...
           'Position',[220,100,660,20],'BackGroundColor',[1 0 1],'ForeGroundColor',[0 0 0],...
           'FontSize',12,'FontWeight','bold');
end
hbutton17  = uicontrol('Style','pushbutton','String','Select New Path',...
           'Position',[900,100,150,20],'BackGroundColor',[0 1 0],'ForeGroundColor',[1 0 0],...
           'FontSize',12,'FontWeight','bold','Callback',@button17_Callback);

%-----------------Save and Close Button-----------------------
hclosebutton  = uicontrol('Style','pushbutton','String','Close And Save Changes',...
           'Position',[840,20,220,40],'BackGroundColor',[0 1 0],'ForeGroundColor',[1 0 0],...
           'FontSize',12,'FontWeight','bold','Callback',@closebutton_Callback,'Units','normalized');
%-----------------Set Next preference Button-----------------------
% hnextprefbutton  = uicontrol('Style','pushbutton','String','Set Next Preference',...
%            'Position',[780,30,220,40],'BackGroundColor',[0 1 0],'ForeGroundColor',[1 0 0],...
%            'FontSize',12,'FontWeight','bold','Callback',@nextprefbutton_Callback,'Units','normalized');
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
f.Name = 'Path Selection GUI';

% Move the window to the center of the screen.
movegui(f,'center')

% Make the window visible.
f.Visible = 'on';

  function button1_Callback(source,eventdata)
        folder_name = uigetdir(inputpath,'Select OSC Input File Path');
        inputpath=strcat(folder_name,'\');
        set(hedit1,'String',inputpath);
        ichanged1=ichanged1+1;
        dispstr=strcat('Selected OSC Input Path as-',inputpath);
        UpdateMessageBox(dispstr,handles);
        eval(['cd ' inputpath(1:length(inputpath)-1)]);
        [islash]=strfind(inputpath,'\');
        numslash=length(islash);
        is=1;
        ie=islash(numslash-1)-1;
        pwdnow=inputpath(is:ie);
        set(hbutton1,'BackGroundColor',[0 0 1]);
  end
  function button2_Callback(source,eventdata)
        folder_name = uigetdir(pwdnow,'Select OSC BandSigs File Path');
        bandsigspath=strcat(folder_name,'\');
        set(hedit2,'String',bandsigspath);
        ichanged1=ichanged1+1;
        dispstr=strcat('Selected OSC Bandsigs File path as-',bandsigspath);
        UpdateMessageBox(dispstr,handles);
        [islash]=strfind(bandsigspath,'\');
        numslash=length(islash);
        is=1;
        ie=islash(numslash-1)-1;
        pwdnow=bandsigspath(is:ie);
        set(hbutton2,'BackGroundColor',[0 0 1]);
  end
  function button3_Callback(source,eventdata)
        folder_name = uigetdir(pwdnow,'Select OSC SumrySigs File Path');
        sumarysigspath=strcat(folder_name,'\');
        set(hedit3,'String',sumarysigspath);
        ichanged1=ichanged1+1;
        dispstr=strcat('Selected OSC SumarySigs File path as-',sumarysigspath);
        UpdateMessageBox(dispstr,handles);
        [islash]=strfind(sumarysigspath,'\');
        numslash=length(islash);
        is=1;
        ie=islash(numslash-1)-1;
        pwdnow=sumarysigspath(is:ie);
        set(hbutton3,'BackGroundColor',[0 0 1]);
  end
  function button4_Callback(source,eventdata)
        folder_name = uigetdir(pwdnow,'Select Path to Load SumaryTraj Files');
        sumrytrjpath=strcat(folder_name,'\');
        set(hedit4,'String',sumrytrjpath);
        ichanged1=ichanged1+1;
        dispstr=strcat('Selected path to SumryTraj data as-',sumrytrjpath);
        UpdateMessageBox(dispstr,handles);
        [islash]=strfind(sumrytrjpath,'\');
        numslash=length(islash);
        is=1;
        ie=islash(numslash-1)-1;
        pwdnow=sumrytrjpath(is:ie);
        set(hbutton4,'BackGroundColor',[0 0 1]);
  end
  function button5_Callback(source,eventdata)
        folder_name = uigetdir(pwdnow,'Select Path to Save Screen Captures');
        screencapturepath=strcat(folder_name,'\');
        set(hedit5,'String',screencapturepath);
        ichanged1=ichanged1+1;
        dispstr=strcat('Selected path to save screencapture figures as-',screencapturepath);
        UpdateMessageBox(dispstr,handles);
        [islash]=strfind(screencapturepath,'\');
        numslash=length(islash);
        is=1;
        ie=islash(numslash-1)-1;
        pwdnow=screencapturepath(is:ie);
        set(hbutton5,'BackGroundColor',[0 0 1]);
  end
  function button6_Callback(source,eventdata)
        folder_name = uigetdir(mappath,'Select Path For Map Boundary Files');
        mappath=strcat(folder_name,'\');
        set(hedit6,'String',mappath);
        ichanged1=ichanged1+1;
        dispstr=strcat('Selected path to save screencapture figures as-',mappath);
        UpdateMessageBox(dispstr,handles);
  end
  function button7_Callback(source,eventdata)
        folder_name = uigetdir(topopath,'Select Path To Load Topographic Data Files');
        topopath=strcat(folder_name,'\');
        set(hedit7,'String',topopath);
        ichanged1=ichanged1+1;
        dispstr=strcat('Selected path to load Topographic Data files as-',topopath);
        UpdateMessageBox(dispstr,handles);
  end
  function button8_Callback(source,eventdata)
        folder_name = uigetdir(matpath1,'Select Path To Load matpath1 Data Files');
        matpath1=strcat(folder_name,'\');
        set(hedit8,'String',matpath1);
        ichanged1=ichanged1+1;
        dispstr=strcat('Selected path to matpath1 Data files as-',topopath);
        UpdateMessageBox(dispstr,handles);
  end
  function button9_Callback(source,eventdata)
        folder_name = uigetdir(shapepath2,'Select Path To Load shapepath2 Data Files');
        shapepath2=strcat(folder_name,'\');
        set(hedit9,'String',shapepath2);
        ichanged1=ichanged1+1;
        dispstr=strcat('Selected path to shapepath2 Data files as-',shapepath2);
        UpdateMessageBox(dispstr,handles);
  end
  function button10_Callback(source,eventdata)
        folder_name = uigetdir(countrypath,'Select Path To Load country boundary Files');
        countrypath=strcat(folder_name,'\');
        set(hedit10,'String',countrypath);
        ichanged1=ichanged1+1;
        dispstr=strcat('Selected path to countrypath Data files as-',countrypath);
        UpdateMessageBox(dispstr,handles);
  end
  function button11_Callback(source,eventdata)
        folder_name = uigetdir(militarypath,'Select Path To Load military base point location files');
        militarypath=strcat(folder_name,'\');
        set(hedit11,'String',militarypath);
        ichanged1=ichanged1+1;
        dispstr=strcat('Selected path to military Data files as-',militarypath);
        UpdateMessageBox(dispstr,handles);
  end
  function button12_Callback(source,eventdata)
        folder_name = uigetdir(countryshapepath,'Select Path To Load country shapefiles');
        countryshapepath=strcat(folder_name,'\');
        set(hedit12,'String',countrypath);
        ichanged1=ichanged1+1;
        dispstr=strcat('Selected path to country shapefiles as-',countryshapepath);
        UpdateMessageBox(dispstr,handles);
  end
  function button13_Callback(source,eventdata)
        folder_name = uigetdir(stateshapepath,'Select Path To Load US states shapefiles');
        stateshapepath=strcat(folder_name,'\');
        set(hedit13,'String',stateshapepath);
        ichanged1=ichanged1+1;
        dispstr=strcat('Selected path to US states shapefiles as-',stateshapepath);
        UpdateMessageBox(dispstr,handles);
  end
  function button14_Callback(source,eventdata)
        folder_name = uigetdir(canadapath,'Select Path To Load Canada Province shapefiles');
        canadapath=strcat(folder_name,'\');
        set(hedit14,'String',canadapath);
        ichanged1=ichanged1+1;
        dispstr=strcat('Selected path to Canada Province Shapefiles as-',canadapath);
        UpdateMessageBox(dispstr,handles);
  end
  function button15_Callback(source,eventdata)
        folder_name = uigetdir(usstateboundariespath,'Select Path To Load US State Boundaries');
        usstateboundariespath=strcat(folder_name,'\');
        set(hedit15,'String',usstateboundariespath);
        ichanged1=ichanged1+1;
        dispstr=strcat('Selected path to US State Boundary Files as-',usstateboundariespath);
        UpdateMessageBox(dispstr,handles);
  end
  function button16_Callback(source,eventdata)
        folder_name = uigetdir(docpath,'Select Path To Load User Guide-Word Format');
        docpath=strcat(folder_name,'\');
        set(hedit16,'String',docpath);
        ichanged1=ichanged1+1;
        dispstr=strcat('Selected path to Word Documentation Files as-',docpath);
        UpdateMessageBox(dispstr,handles);
  end
  function button17_Callback(source,eventdata)
        folder_name = uigetdir(htmlpath,'Select Path To Load User Guide-HTML Format');
        htmlpath=strcat(folder_name,'\');
        set(hedit17,'String',htmlpath);
        ichanged1=ichanged1+1;
        dispstr=strcat('Selected path to HTML Documentation Files as-',htmlpath);
        UpdateMessageBox(dispstr,handles);
  end
  function button18_Callback(source,eventdata)
        folder_name = uigetdir(pwdnow,'Select Path to Load Thermal Files');
        thermalpath=strcat(folder_name,'\');
        set(hedit18,'String',thermalpath);
        ichanged1=ichanged1+1;
        dispstr=strcat('Selected path to Thermal Files as-',thermalpath);
        UpdateMessageBox(dispstr,handles);
        [islash]=strfind(thermalpath,'\');
        numslash=length(islash);
        is=1;
        ie=islash(numslash-1)-1;
        pwdnow=thermalpath(is:ie);
        set(hbutton18,'BackGroundColor',[0 0 1]);
  end
  function button19_Callback(source,eventdata)
        folder_name = uigetdir(pwdnow,'Select Path To Load TPVFlux Data');
        tpvfluxpath=strcat(folder_name,'\');
        set(hedit19,'String',tpvfluxpath);
        ichanged1=ichanged1+1;
        dispstr=strcat('Selected path to TPV Flux Files-',tpvfluxpath);
        UpdateMessageBox(dispstr,handles);
        [islash]=strfind(tpvfluxpath,'\');
        numslash=length(islash);
        is=1;
        ie=islash(numslash-1)-1;
        pwdnow=tpvfluxpath(is:ie);
        set(hbutton19,'BackGroundColor',[0 0 1]);
  end
  function button20_Callback(source,eventdata)
        folder_name = uigetdir(librarypath,'Select Path To Load OSC Library Data');
        librarypath=strcat(folder_name,'\');
        set(hedit20,'String',librarypath);
        ichanged1=ichanged1+1;
        dispstr=strcat('Selected path to OSC Library-',librarypath);
        UpdateMessageBox(dispstr,handles);
        set(hbutton20,'BackGroundColor',[0 0 1]);
  end
 function button21_Callback(source,eventdata)
        folder_name = uigetdir(pwdnow,'Select Path To Load OSC Facet Data');
        facetpath=strcat(folder_name,'\');
        set(hedit21,'String',facetpath);
        ichanged1=ichanged1+1;
        dispstr=strcat('Selected path to OSC Facet Files-',facetpath);
        UpdateMessageBox(dispstr,handles);
        [islash]=strfind(facetpath,'\');
        numslash=length(islash);
        is=1;
        ie=islash(numslash-1)-1;
        pwdnow=facetpath(is:ie);
        set(hbutton21,'BackGroundColor',[0 0 1]);
 end
 function button22_Callback(source,eventdata)
        folder_name = uigetdir(pwdnow,'Select Path To Load OSC SUMRYTMP Data');
        sumrytmppath=strcat(folder_name,'\');
        set(hedit22,'String',sumrytmppath);
        ichanged1=ichanged1+1;
        dispstr=strcat('Selected path to OSC SUMRYTMP Files-',sumrytmppath);
        UpdateMessageBox(dispstr,handles);
        [islash]=strfind(sumrytmppath,'\');
        numslash=length(islash);
        is=1;
        ie=islash(numslash-1)-1;
        pwdnow=sumrytmppath(is:ie);
        set(hbutton22,'BackGroundColor',[0 0 1]);
 end
 function button23_Callback(source,eventdata)
        folder_name = uigetdir(pwdnow,'Select Path To Load OSC SUMRYSHP Data');
        sumryshppath=strcat(folder_name,'\');
        set(hedit23,'String',sumryshppath);
        ichanged1=ichanged1+1;
        dispstr=strcat('Selected path to OSC SUMRYSHP Files-',sumryshppath);
        UpdateMessageBox(dispstr,handles);
        [islash]=strfind(sumryshppath,'\');
        numslash=length(islash);
        is=1;
        ie=islash(numslash-1)-1;
        pwdnow=sumryshppath(is:ie);
        set(hbutton23,'BackGroundColor',[0 0 1]);
 end
function button24_Callback(source,eventdata)
        folder_name = uigetdir(pwdnow,'Select Path To Load OSC THRMVUR Data');
        thrmvurpath=strcat(folder_name,'\');
        set(hedit24,'String',thrmvurpath);
        ichanged1=ichanged1+1;
        dispstr=strcat('Selected path to OSC THRMVUR Files-',thrmvurpath);
        UpdateMessageBox(dispstr,handles);
        [islash]=strfind(thrmvurpath,'\');
        numslash=length(islash);
        is=1;
        ie=islash(numslash-1)-1;
        pwdnow=thrmvurpath(is:ie);
        set(hbutton24,'BackGroundColor',[0 0 1]);
end
function button25_Callback(source,eventdata)
        folder_name = uigetdir(pwdnow,'Select Path To Load OSC Output Data');
        outputpath=strcat(folder_name,'\');
        set(hedit25,'String',outputpath);
        ichanged1=ichanged1+1;
        dispstr=strcat('Selected path to OSC Output Files-',outputpath);
        UpdateMessageBox(dispstr,handles);
        [islash]=strfind(outputpath,'\');
        numslash=length(islash);
        is=1;
        ie=islash(numslash-1)-1;
        pwdnow=outputpath(is:ie);
        set(hbutton25,'BackGroundColor',[0 0 1]);
 end
 function closebutton_Callback(source,eventdata)
    set(handles.Set_Paths_Tag,'Checked','On');
    eval(['cd ' librarypath(1:length(librarypath))]);
    if(ichanged1>0)
        SaveOSCToolPreferenceFile(handles)
        dispstr=strcat('Saved OSC Tool Preferences-',num2str(ichanged1),'-paths were changed');
        UpdateMessageBox(dispstr,handles);
    else
        dispstr='No paths were changed so no new preference file written';
        UpdateMessageBox(dispstr,handles); 
    end
    close(gcf);
  end
  function nextprefbutton_Callback(source,eventdata)
    set(handles.Set_Paths_Tag,'Checked','On');
    if(ichanged1>0)
        eval(['cd ' prefpath(1:length(prefpath))]);
        SaveOSCToolPreferenceFile(handles)
        dispstr='Saved File Preferences because changed at least 1 preference from this tab';
        UpdateMessageBox(dispstr,handles);    
    end
    close(gcf);
    dispstr='Going to File Selection Preferences';
    UpdateMessageBox(dispstr,handles);
    selectdatafiles_gui2(hObject,eventdata,handles)
    
  end
end