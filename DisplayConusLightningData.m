function DisplayConusLightningData(titlestr)
% Display the CMI Moisture Data from the GOES16/17 data
% on a texture map for the USA
% Written By: Stephen Forczyk
% Created: Mar 15,2021
% Revised: Mar 20,2021 cleaned up code to have first working version
% Classification: Unclassified

global BandDataS MetaDataS;
global DQF2S tS yS xS tBS goesImagerS yImgS yImgBS;
global xImgS xImgBS SatDataS GeoSpatialS GoesLatLonProjS;
global ReflectanceS AlgoS ErrorS EarthSunS VersionContainerS;
global GoesWaveBand ESunS kappa0S PlanckS FocalPlaneS;
global GOESFileName OutlierPS CloudTopTS LZAS LZABS SZAS SZABS;
global TempS Algo2S ProcessParamTS AlgoProductTS Error1S CloudPixelsS;
global EventIDS EventTimeS EventLocS EventEnergyS;
global GroupIDS GQFS FlashDataS FlashData2S FlashQFS;
global FlashFrTimeOffsetFES FlashFrTimeOffsetLES;
global GroupFrameTimeOffsetS GroupLatS GroupLonS;
global GroupAreaS GroupEnergyS GroupParentFlashIDS ;
global GroupEnergy GroupMinEnergy GroupMaxEnergy;
global EventCountS GroupCountS FlashCountS;
global EventEnergy EventMinEnergy EventMaxEnergy;
global NumFlashes NumGroups NumEvents;
global ProductTimeS LightningWaveS NavL1bS YawFlipFlagS LonFOVS LatFOVS;
global ProcessParamVersionContainerS;
global westEdge eastEdge northEdge southEdge;
global MonthDayStr MonthDayYearStr;
global DayMonthNonLeapYear DayMonthLeapYear CalendarFileName;
global FlashEnergy FlashDuration FlashLats FlashLons;
global FlashMinEnergy FlashMaxEnergy FlashMinDuration FlashMaxDuration;
global FlashStartTimes FlashEndTimes;
global RptGenPresent iCreatePDFReport pdffilename rpt chapter;
global JpegCounter JpegFileList;
global DQFHdr DQFTable MiscHdr MiscTable RqmtsHdr RqmtsTable;
global LightningTable LightningHdr LightningTableS LightningHdrS;
global DQFCauses DQFNormed DQFLabels;
global PhPA rho zPress;
global ColorList RGBVals ColorList2 xkcdVals LandColors;
global orange bubblegum;
global NorthAmericaLakes;

global fid widd2 lend2;
global initialtimestr igrid ijpeg ilog imovie;
global vert1 hor1 widd lend;
global vert2 hor2 machine;
global chart_time;
global Fz1 Fz2;
global idirector mov izoom iwindow;
global matpath GOES16path;
global jpegpath ;
global ipowerpoint PowerPointFile scaling stretching padding;
global ichartnum;
% additional paths needed for mapping
global matpath1 mappath USshapefilepath;
global canadapath stateshapepath topopath;
global trajpath militarypath;
global figpath screencapturepath;
global shapepath2 countrypath countryshapepath usstateboundariespath;
global GOES16Band1path GOES16Band2path GOES16Band3path GOES16Band4path;
global GOES16Band5path GOES16Band6path GOES16Band7path GOES16Band8path
global GOES16Band9path GOES16Band10path GOES16Band11path GOES16Band12path;
global GOES16Band13path GOES16Band14path GOES16Band15path GOES16Band16path;
global GOES16CloudTopHeightpath shapefilepath;
global GOES16CloudTopHeightpath shapefilepath  Countryshapepath;
global northamericalakespath;


if((iCreatePDFReport==1) && (RptGenPresent==1))
    import mlreportgen.dom.*;
    import mlreportgen.report.*;
end
fprintf(fid,'\n');
fprintf(fid,'%s\n','-----Start plot routine Display CONUS Lightning Data-----');
FlashStartTimes=FlashDataS.values2;
FlashEndTimes=FlashDataS.values3;
FlashEnergy=FlashData2S.values4;
numflashes=length(FlashEnergy);
FlashDuration=zeros(numflashes,1);
numnan=0;
for kk=1:numflashes % Replace negative values with NaNs
   nowval=FlashEndTimes(kk,1)-FlashStartTimes(kk,1); 
   if(nowval>0)
       FlashDuration(kk,1)=nowval;
   else
       FlashDuration(kk,1)=NaN;
       numnan=numnan+1;
   end
end
FlashMinDuration=min(FlashDuration,[],'omitnan');
FlashMaxDuration=max(FlashDuration,[],'omitnan');
FlashMinEnergy=min(FlashEnergy)/1E-12;
FlashMaxEnergy=max(FlashEnergy)/1E-12;
GroupEnergy=GroupEnergyS.values;
GroupMinEnergy=min(GroupEnergy)/1E-12;
GroupMaxEnergy=max(GroupEnergy)/1E-12;
EventEnergy=EventEnergyS.values1;
EventMinEnergy=min(EventEnergy)/1E-12;
EventMaxEnergy=max(EventEnergy)/1E-12;
NumFlashes=FlashCountS.values;
NumEvents=EventCountS.values;
NumGroups=GroupCountS.values;
% Get some basic data on the lightning flashes
flashstr1=strcat('Number of Lightning Flashes=',num2str(numflashes));
fprintf(fid,'%s\n','***** Start Basic Lightning Flash Data *****');
fprintf(fid,'      %s\n',flashstr1);
flashstr2=strcat('Min Flash Energy=',num2str(FlashMinEnergy,5),'-picoJoules');
fprintf(fid,'      %s\n',flashstr2);
flashstr3=strcat('Max Flash Energy=',num2str(FlashMaxEnergy,5),'-picoJoules');
fprintf(fid,'      %s\n',flashstr3);
flashstr4=strcat('Number Of Flashes=',num2str(NumFlashes,5));
fprintf(fid,'      %s\n',flashstr4);
flashstr5=strcat('Min Flash Duration=',num2str(FlashMinDuration,5));
fprintf(fid,'      %s\n',flashstr5);
flashstr6=strcat('Max Flash Duration=',num2str(FlashMaxDuration,5));
fprintf(fid,'      %s\n',flashstr6);
fprintf(fid,'%s\n','***** End Basic Lightning Flash Data *****');
fprintf(fid,'\n');
fprintf(fid,'%s\n','***** Start Basic Lightning Group Data *****');
groupstr1=strcat('Number of Lightning Groups=',num2str(NumGroups));
fprintf(fid,'      %s\n',groupstr1);
groupstr2=strcat('Min Group Energy=',num2str(GroupMinEnergy,5),'-picoJoules');
fprintf(fid,'      %s\n',groupstr2);
groupstr3=strcat('Max Group Energy=',num2str(GroupMaxEnergy,5),'-picoJoules');
fprintf(fid,'      %s\n',groupstr3);
fprintf(fid,'%s\n','***** End Basic Lightning Group Data *****');
fprintf(fid,'\n');
fprintf(fid,'%s\n','***** Start Basic Lightning Event Data *****');
eventstr1=strcat('Number of Lightning Events=',num2str(NumEvents));
fprintf(fid,'      %s\n',eventstr1);
eventstr2=strcat('Min Event Energy=',num2str(EventMinEnergy,5),'-picoJoules');
fprintf(fid,'      %s\n',eventstr2);
eventstr3=strcat('Max Event Energy=',num2str(EventMaxEnergy,5),'-picoJoules');
fprintf(fid,'      %s\n',eventstr3);
fprintf(fid,'%s\n','***** End Basic Lightning Event Data *****');
fprintf(fid,'\n');
% Get the scan start date and time data based on the file name
[YearS,DayS,HourS,MinuteS,SecondS] = GetGOESDateTimeString(GOESFileName,1);
% Get the scan end date and time data based on the file name
[YearE,DayE,HourE,MinuteE,SecondE] = GetGOESDateTimeString(GOESFileName,2);
result = is_leap_year(YearS);
if(result==0)
    MonthDayStr=char(DayMonthNonLeapYear{DayS,1});
else
    MonthDayStr=char(DayMonthLeapYear{DayS,1});
end
MonthDayYearStr=strcat(MonthDayStr,'-',num2str(YearS));
scalebarlen=2000;
scalebarloc='sw'; % location of scale (sw=southwest)
h1=axesm('mercator','Frame','on','Grid','on','MapLatLimit',[southEdge northEdge],...
    'MapLonLimit',[westEdge eastEdge],'meridianlabel','on','parallellabel','on','plabellocation',10,'mlabellocation',10,...
    'MLabelParallel','south','MLineLocation',10,'PLineLocation',10);
set(gcf,'Position',[hor1 vert1 widd lend])
set(gcf,'MenuBar','none');
set(gca,'Position',[0.0800 0.1100 0.7750 0.8150]);
h1.Color='cyan';
rivers = shaperead('worldrivers.shp', 'UseGeoCoords', true);
numrows=length(rivers);
for n=1:numrows % Plot the rivers
   NowLon=rivers(n).Lon;
   NowLat=rivers(n).Lat;
   plotm(NowLat,NowLon,'b');
end
hold on
warning('off')
eval(['cd ' USshapefilepath(1:length(USshapefilepath)-1)]);
S0 = shaperead('cb_2018_us_state_500k.shp', 'UseGeoCoords', true);
numstates=length(S0);
istate=0;
for n=1:numstates
    istate=istate+1;
    if(istate>16)
        istate=1;
    end
    StateLat=S0(n).Lat;
    StateLon=S0(n).Lon;
    nowColor=[LandColors(istate,1) LandColors(istate,2) LandColors(istate,3)];
    patchm(StateLat,StateLon,nowColor);
end
clear S0;
% Plot Canada
eval(['cd ' Countryshapepath(1:length(Countryshapepath)-1)]);
S1 = shaperead('CAN_adm1.shp', 'UseGeoCoords', true);
numprov=length(S1);
nx=0;
for n=1:numprov
    CanadaLat=S1(n).Lat;
    CanadaLon=S1(n).Lon;
    nx=nx+1;
    if(nx>16)
        nx=1;
    end
    nowColor=[LandColors(nx,1) LandColors(nx,2) LandColors(nx,3)];
    patchm(CanadaLat,CanadaLon,nowColor);
end
% Plot Mexico
clear S1 CanadaLat CanadaLon;
S1 = shaperead('MEX_adm1.shp', 'UseGeoCoords', true);
numprov=length(S1);
nx=0;
for n=1:numprov
    MexicoLat=S1(n).Lat;
    MexicoLon=S1(n).Lon;
    nx=nx+1;
    if(nx>16)
        nx=1;
    end
    nowColor=[LandColors(nx,1) LandColors(nx,2) LandColors(nx,3)];
    patchm(MexicoLat,MexicoLon,nowColor);
end
% Now plot Gautemala
clear S1 MexicoLat MexicoLon
S1 = shaperead('GTM_adm1.shp', 'UseGeoCoords', true);
numprov=length(S1);
nx=1;
for n=1:numprov
    GTMLat=S1(n).Lat;
    GTMLon=S1(n).Lon;
    nx=nx+1;
    if(nx>16)
        nx=1;
    end
    nx=2;
    nowColor=[LandColors(nx,1) LandColors(nx,2) LandColors(nx,3)];
    patchm(GTMLat,GTMLon,'FaceColor',nowColor,'EdgeColor',nowColor);
end
clear S1 GTMLat GTMLon
% Plot Belize
S1 = shaperead('BLZ_adm1.shp', 'UseGeoCoords', true);
numprov=length(S1);
nx=1;
for n=1:numprov
    BLZLat=S1(n).Lat;
    BLZLon=S1(n).Lon;
    nx=nx+1;
    if(nx>16)
        nx=1;
    end
    nx=3;
    nowColor=[LandColors(nx,1) LandColors(nx,2) LandColors(nx,3)];
    patchm(BLZLat,BLZLon,'FaceColor',nowColor,'EdgeColor',nowColor);
end
clear S1 BLZLat BLZLon
% Plot Honduras
S1 = shaperead('HND_adm1.shp', 'UseGeoCoords', true);
numprov=length(S1);
nx=1;
for n=1:numprov
    HNDLat=S1(n).Lat;
    HNDLon=S1(n).Lon;
    nx=nx+1;
    if(nx>16)
        nx=1;
    end
    nx=4;
    nowColor=[LandColors(nx,1) LandColors(nx,2) LandColors(nx,3)];
    patchm(HNDLat,HNDLon,'FaceColor',nowColor,'EdgeColor',nowColor);
end
clear S1 HNDLat HNDLon
% Plot Cuba
S1 = shaperead('CUB_adm1.shp', 'UseGeoCoords', true);
numprov=length(S1);
nx=1;
for n=1:numprov
    CUBLat=S1(n).Lat;
    CUBLon=S1(n).Lon;
    nx=nx+1;
    if(nx>16)
        nx=1;
    end
    nx=5;
    nowColor=[LandColors(nx,1) LandColors(nx,2) LandColors(nx,3)];
    patchm(CUBLat,CUBLon,'FaceColor',nowColor,'EdgeColor',nowColor);
end
clear S1 CUBLat CUBLon
% Plot Haiti
S1 = shaperead('HTI_adm1.shp', 'UseGeoCoords', true);
numprov=length(S1);
nx=1;
for n=1:numprov
    HTILat=S1(n).Lat;
    HTILon=S1(n).Lon;
    nx=nx+1;
    if(nx>16)
        nx=1;
    end
    NAME_1=char(S1(n).NAME_1);
    nx=6;
    nowColor=[LandColors(nx,1) LandColors(nx,2) LandColors(nx,3)];
    patchm(HTILat,HTILon,'FaceColor',nowColor,'EdgeColor',nowColor);
end
clear S1 HTILat HTILon
% Plot Dominican Republic
S1 = shaperead('DOM_adm1.shp', 'UseGeoCoords', true);
numprov=length(S1);
nx=1;
for n=1:numprov
    DOMLat=S1(n).Lat;
    DOMLon=S1(n).Lon;
    NAME_1=char(S1(n).NAME_1);
    nx=nx+1;
    if(nx>16)
        nx=1;
    end
    nx=7;
    nowColor=[LandColors(nx,1) LandColors(nx,2) LandColors(nx,3)];
    patchm(DOMLat,DOMLon,'FaceColor',nowColor,'EdgeColor',nowColor);
end
clear S1 DOMLat DOMLon
% Plot Jamaica
S1 = shaperead('JAM_adm1.shp', 'UseGeoCoords', true);
numprov=length(S1);
nx=1;
for n=1:numprov
    JAMLat=S1(n).Lat;
    JAMLon=S1(n).Lon;
    nx=nx+1;
    if(nx>16)
        nx=1;
    end
    nx=8;
    nowColor=[LandColors(nx,1) LandColors(nx,2) LandColors(nx,3)];
    patchm(JAMLat,JAMLon,'FaceColor',nowColor,'EdgeColor',nowColor);
end
clear S1 JAMLat JAMLon
% Plot Bahamas
S1 = shaperead('BHS_adm1.shp', 'UseGeoCoords', true);
numprov=length(S1);
nx=1;
for n=1:numprov
    BHSLat=S1(n).Lat;
    BHSLon=S1(n).Lon;
    NAME_1=char(S1(n).NAME_1);
    nx=nx+1;
    if(nx>16)
        nx=1;
    end
    nx=9;
    nowColor=[LandColors(nx,1) LandColors(nx,2) LandColors(nx,3)];
    patchm(BHSLat,BHSLon,'FaceColor',nowColor,'EdgeColor',nowColor);
end
clear S1 BHSLat BHSLon
% Plot Nicaragua
S1 = shaperead('NIC_adm1.shp', 'UseGeoCoords', true);
numprov=length(S1);
nx=1;
for n=1:numprov
    NICLat=S1(n).Lat;
    NICLon=S1(n).Lon;
    NAME_1=char(S1(n).NAME_1);
    nx=nx+1;
    if(nx>16)
        nx=1;
    end
    nx=10;
    nowColor=[LandColors(nx,1) LandColors(nx,2) LandColors(nx,3)];
    patchm(NICLat,NICLon,'FaceColor',nowColor,'EdgeColor',nowColor);
end
clear S1 NICLat NICLon
% Plot Costa Rica
S1 = shaperead('CRI_adm1.shp', 'UseGeoCoords', true);
numprov=length(S1);
nx=1;
for n=1:numprov
    CRILat=S1(n).Lat;
    CRILon=S1(n).Lon;
    NAME_1=char(S1(n).NAME_1);
    nx=nx+1;
    if(nx>16)
        nx=1;
    end
    nx=11;
    nowColor=[LandColors(nx,1) LandColors(nx,2) LandColors(nx,3)];
    patchm(CRILat,CRILon,'FaceColor',nowColor,'EdgeColor',nowColor);
end
clear S1 CRILat CRILon
% Plot Panama
S1 = shaperead('PAN_adm1.shp', 'UseGeoCoords', true);
numprov=length(S1);
nx=1;
for n=1:numprov
    PANLat=S1(n).Lat;
    PANLon=S1(n).Lon;
    NAME_1=char(S1(n).NAME_1);
    nx=nx+1;
    if(nx>16)
        nx=1;
    end
    nx=12;
    nowColor=[LandColors(nx,1) LandColors(nx,2) LandColors(nx,3)];
    patchm(PANLat,PANLon,'FaceColor',nowColor,'EdgeColor',nowColor);
end
clear S1 PANLat PANLon
% Plot El Salvador
S1 = shaperead('SLV_adm1.shp', 'UseGeoCoords', true);
numprov=length(S1);
nx=1;
for n=1:numprov
    SLVLat=S1(n).Lat;
    SLVLon=S1(n).Lon;
    NAME_1=char(S1(n).NAME_1);
    nx=nx+1;
    if(nx>16)
        nx=1;
    end
    nx=13;
    nowColor=[LandColors(nx,1) LandColors(nx,2) LandColors(nx,3)];
    patchm(SLVLat,SLVLon,'FaceColor',nowColor,'EdgeColor',nowColor);
end
clear S1 SLVLat SLVLon
% Plot El Venezuela
S1 = shaperead('VEN_adm1.shp', 'UseGeoCoords', true);
numprov=length(S1);
nx=1;
for n=1:numprov
    VENLat=S1(n).Lat;
    VENLon=S1(n).Lon;
    NAME_1=char(S1(n).NAME_1);
    nx=nx+1;
    if(nx>16)
        nx=1;
    end
    nx=14;
    nowColor=[LandColors(nx,1) LandColors(nx,2) LandColors(nx,3)];
    patchm(VENLat,VENLon,'FaceColor',nowColor,'EdgeColor','k');
end
clear S1 VENLat VENLon
% Plot Columbia
S1 = shaperead('COL_adm1.shp', 'UseGeoCoords', true);
numprov=length(S1);
nx=1;
for n=1:numprov
    COLLat=S1(n).Lat;
    COLLon=S1(n).Lon;
    nx=nx+1;
    if(nx>16)
        nx=1;
    end
    nx=15;
    NAME_1=char(S1(n).NAME_1);
    nowColor=[LandColors(nx,1) LandColors(nx,2) LandColors(nx,3)];
    patchm(COLLat,COLLon,'FaceColor',nowColor,'EdgeColor','k');
end
clear S1 COLLat COLLon
% Plot Brazil
S1 = shaperead('BRA_adm1.shp', 'UseGeoCoords', true);
numprov=length(S1);
nx=1;
for n=1:numprov
    BRALat=S1(n).Lat;
    BRALon=S1(n).Lon;
    nx=nx+1;
    if(nx>16)
        nx=1;
    end
    nx=1;
    NAME_1=char(S1(n).NAME_1);
    nowColor=[LandColors(nx,1) LandColors(nx,2) LandColors(nx,3)];
    patchm(BRALat,BRALon,'FaceColor',nowColor,'EdgeColor','k');
end
clear S1 BRALat BRALon
% Plot Peru
S1 = shaperead('PER_adm1.shp', 'UseGeoCoords', true);
numprov=length(S1);
nx=1;
for n=1:numprov
    PERLat=S1(n).Lat;
    PERLon=S1(n).Lon;
    nx=nx+1;
    if(nx>16)
        nx=1;
    end
    nx=2;
    NAME_1=char(S1(n).NAME_1);
    nowColor=[LandColors(nx,1) LandColors(nx,2) LandColors(nx,3)];
    patchm(PERLat,PERLon,'FaceColor',nowColor,'EdgeColor','k');
end
clear S1 PERLat PERLon
% Plot Equador
S1 = shaperead('ECU_adm1.shp', 'UseGeoCoords', true);
numprov=length(S1);
nx=1;
for n=1:numprov
    ECULat=S1(n).Lat;
    ECULon=S1(n).Lon;
    nx=nx+1;
    if(nx>16)
        nx=1;
    end
    nx=3;
    NAME_1=char(S1(n).NAME_1);
    nowColor=[LandColors(nx,1) LandColors(nx,2) LandColors(nx,3)];
    patchm(ECULat,ECULon,'FaceColor',nowColor,'EdgeColor',nowColor);
end
clear S1 ECULat ECULon
% Plot Chile
S1 = shaperead('CHL_adm1.shp', 'UseGeoCoords', true);
numprov=length(S1);
nx=1;
for n=1:numprov
    CHLLat=S1(n).Lat;
    CHLLon=S1(n).Lon;
    nx=nx+1;
    if(nx>16)
        nx=1;
    end
    nx=4;
    NAME_1=char(S1(n).NAME_1);
    nowColor=[LandColors(nx,1) LandColors(nx,2) LandColors(nx,3)];
    patchm(CHLLat,CHLLon,'FaceColor',nowColor,'EdgeColor','k');
end
clear S1 CHLLat CHLLon
% Plot Bolivia
S1 = shaperead('BOL_adm1.shp', 'UseGeoCoords', true);
numprov=length(S1);
nx=1;
for n=1:numprov
    BOLLat=S1(n).Lat;
    BOLLon=S1(n).Lon;
    nx=nx+1;
    if(nx>16)
        nx=1;
    end
    nx=5;
    NAME_1=char(S1(n).NAME_1);
    nowColor=[LandColors(nx,1) LandColors(nx,2) LandColors(nx,3)];
    patchm(BOLLat,BOLLon,'FaceColor',nowColor,'EdgeColor','k');
end
clear S1 BOLLat BOLLon
% Plot Paraguay
S1 = shaperead('PRY_adm1.shp', 'UseGeoCoords', true);
numprov=length(S1);
nx=1;
for n=1:numprov
    PRYLat=S1(n).Lat;
    PRYLon=S1(n).Lon;
    nx=nx+1;
    if(nx>16)
        nx=1;
    end
    nx=6;
    NAME_1=char(S1(n).NAME_1);
    nowColor=[LandColors(nx,1) LandColors(nx,2) LandColors(nx,3)];
    patchm(PRYLat,PRYLon,'FaceColor',nowColor,'EdgeColor','k');
end
clear S1 PRYLat PRYLon
% Plot Uraguay
S1 = shaperead('URY_adm1.shp', 'UseGeoCoords', true);
numprov=length(S1);
nx=1;
for n=1:numprov
    URYLat=S1(n).Lat;
    URYLon=S1(n).Lon;
    nx=nx+1;
    if(nx>16)
        nx=1;
    end
    nx=7;
    NAME_1=char(S1(n).NAME_1);
    nowColor=[LandColors(nx,1) LandColors(nx,2) LandColors(nx,3)];
    patchm(URYLat,URYLon,'FaceColor',nowColor,'EdgeColor',nowColor);
end
clear S1 URYLat URYLon
% Plot Argentina
S1 = shaperead('ARG_adm1.shp', 'UseGeoCoords', true);
numprov=length(S1);
nx=1;
for n=1:numprov
    ARGLat=S1(n).Lat;
    ARGLon=S1(n).Lon;
    nx=nx+1;
    if(nx>16)
        nx=1;
    end
    nx=8;
    NAME_1=char(S1(n).NAME_1);
    nowColor=[LandColors(nx,1) LandColors(nx,2) LandColors(nx,3)];
    patchm(ARGLat,ARGLon,'FaceColor',nowColor,'EdgeColor','k');
end
clear S1 ARGLat ARGLon
% Plot Guyanna
S1 = shaperead('GUY_adm1.shp', 'UseGeoCoords', true);
numprov=length(S1);
nx=1;
for n=1:numprov
    GUYLat=S1(n).Lat;
    GUYLon=S1(n).Lon;
    nx=nx+1;
    if(nx>16)
        nx=1;
    end
    nx=9;
    NAME_1=char(S1(n).NAME_1);
    nowColor=[LandColors(nx,1) LandColors(nx,2) LandColors(nx,3)];
    patchm(GUYLat,GUYLon,'FaceColor',nowColor,'EdgeColor',nowColor);
end
clear S1 GUYLat GUYLon
% Plot Suriname
S1 = shaperead('SUR_adm1.shp', 'UseGeoCoords', true);
numprov=length(S1);
nx=1;
for n=1:numprov
    SURLat=S1(n).Lat;
    SURLon=S1(n).Lon;
    nx=nx+1;
    if(nx>16)
        nx=1;
    end
    nx=10;
    NAME_1=char(S1(n).NAME_1);
    nowColor=[LandColors(nx,1) LandColors(nx,2) LandColors(nx,3)];
    patchm(SURLat,SURLon,'FaceColor',nowColor,'EdgeColor',nowColor);
end
clear S1 SURLat SURLon
% Plot French Guiana
S1 = shaperead('GUF_adm1.shp', 'UseGeoCoords', true);
numprov=length(S1);
nx=1;
for n=1:numprov
    GUFLat=S1(n).Lat;
    GUFLon=S1(n).Lon;
    nx=nx+1;
    if(nx>16)
        nx=1;
    end
    nx=11;
    NAME_1=char(S1(n).NAME_1);
    nowColor=[LandColors(nx,1) LandColors(nx,2) LandColors(nx,3)];
    patchm(GUFLat,GUFLon,'FaceColor',nowColor,'EdgeColor',nowColor);
end
clear S1 GUFLat GUFLon
eval(['cd ' mappath(1:length(mappath)-1)]);
tightmap;
eval(['cd ' mappath(1:length(mappath)-1)]);
plotm(FlashLats,FlashLons,'gd','MarkerSize',6,'MarkerEdgeColor','g',...
    'MarkerFaceColor','y')
numflashes=length(FlashLats);
title(titlestr)
hold off
scalebar('length',scalebarlen,'units','km','color','r','location',scalebarloc,'fontangle','bold','RulerStyle','patches');
warning('on')
newaxesh=axes('Position',[0 0 1 1]);
set(newaxesh,'XLim',[0 1],'YLim',[0 1]);
tx1=.73;
ty1=.86;
txtstr1=strcat('Start Scan-Y',num2str(YearS),'-D-',num2str(DayS),'-H-',...
    num2str(HourS),'-M-',num2str(MinuteS),'-S-',num2str(SecondS));
txt1=text(tx1,ty1,txtstr1,'FontWeight','bold','FontSize',12);
tx2=tx1;
ty2=.83;
txtstr2=strcat('End Scan-Y',num2str(YearE),'-D-',num2str(DayE),'-H-',...
    num2str(HourE),'-M-',num2str(MinuteE),'-S-',num2str(SecondE));
txt2=text(tx2,ty2,txtstr2,'FontWeight','bold','FontSize',12);
tx3a=tx1;
ty3a=.80;
txtstr3a=strcat('Calendar Date-',MonthDayYearStr);
txt3a=text(tx3a,ty3a,txtstr3a,'FontWeight','bold','FontSize',12);
tx3b=tx1;
ty3b=.76;
txtstr3b='------------------------------';
txt3b=text(tx3b,ty3b,txtstr3b,'FontWeight','bold','FontSize',12);
tx3c=tx1;
ty3c=.73;
txtstr3c=strcat('Number of Lighting Flashes=',num2str(numflashes));
txt3c=text(tx3c,ty3c,txtstr3c,'FontWeight','bold','FontSize',12);
tx4=tx1;
ty4=.70;
txtstr4=strcat('Min Flash Duration-Sec=',num2str(FlashMinDuration));
txt4=text(tx4,ty4,txtstr4,'FontWeight','bold','FontSize',12);
tx5=tx1;
ty5=.67;
txtstr5=strcat('Max Flash Duration-Sec=',num2str(FlashMaxDuration));
txt5=text(tx5,ty5,txtstr5,'FontWeight','bold','FontSize',12);
tx6=tx1;
ty6=.64;
txtstr6=strcat('Min Flash Energy-picoJ=',num2str(FlashMinEnergy));
txt6=text(tx6,ty6,txtstr6,'FontWeight','bold','FontSize',12);
tx7=tx1;
ty7=.61;
txtstr7=strcat('Max Flash Energy-picoJ=',num2str(FlashMaxEnergy));
txt7=text(tx7,ty7,txtstr7,'FontWeight','bold','FontSize',12);
tx3d=tx1;
ty3d=.58;
txt3d=text(tx3d,ty3d,txtstr3b,'FontWeight','bold','FontSize',12);
tx10=tx1;
ty10=.55;
txtstr10=strcat('Number of Lighting Groups=',num2str(NumGroups));
txt10=text(tx10,ty10,txtstr10,'FontWeight','bold','FontSize',12);
tx11=tx1;
ty11=.52;
txtstr11=strcat('Min Group Energy-picoJ=',num2str(GroupMinEnergy));
txt11=text(tx11,ty11,txtstr11,'FontWeight','bold','FontSize',12);
tx12=tx1;
ty12=.49;
txtstr12=strcat('Max Group Energy-picoJ=',num2str(GroupMaxEnergy));
txt12=text(tx12,ty12,txtstr12,'FontWeight','bold','FontSize',12);
tx3f=tx1;
ty3f=.46;
txt3f=text(tx3f,ty3f,txtstr3b,'FontWeight','bold','FontSize',12);
tx13=tx1;
ty13=.43;
txtstr13=strcat('Number of Lightning Events=',num2str(NumEvents));
txt13=text(tx13,ty13,txtstr13,'FontWeight','bold','FontSize',12);
tx14=tx1;
ty14=.40;
txtstr14=strcat('Min Event Energy-picoJ=',num2str(EventMinEnergy));
txt14=text(tx14,ty14,txtstr14,'FontWeight','bold','FontSize',12);
tx15=tx1;
ty15=.37;
txtstr15=strcat('Max Event Energy-picoJ=',num2str(EventMaxEnergy));
txt15=text(tx15,ty15,txtstr15,'FontWeight','bold','FontSize',12);
tx3g=tx1;
ty3g=.34;
txt3g=text(tx3g,ty3g,txtstr3b,'FontWeight','bold','FontSize',12);
set(newaxesh,'Visible','Off');
% Save this chart
figstr=strcat('LightningFlashes-GLM-L2-LCFA-','Y',num2str(YearS),'D',...
    num2str(DayS),'H',num2str(HourS),'M',num2str(MinuteS),'S',num2str(SecondS),...
    '.jpg');
eval(['cd ' jpegpath(1:length(jpegpath)-1)]);
actionstr='print';
typestr='-djpeg';
[cmdString]=MyStrcat2(actionstr,typestr,figstr);
eval(cmdString);
dispstr=strcat('Saved Jpeg Image To File-',figstr);
disp(dispstr)
pause(chart_time);
JpegCounter=JpegCounter+1;
JpegFileList{JpegCounter+1,1}=figstr;
JpegFileList{JpegCounter+1,2}=jpegpath;
close('all');
if((iCreatePDFReport==1) && (RptGenPresent==1))
    [ibreak]=strfind(GOESFileName,'_e');
    is=1;
    ie=ibreak(1)-1;
    GOESShortFileName=GOESFileName(is:ie);
    headingstr1=strcat('GLM Lighting Data For-',GOESShortFileName);
    chapter = Chapter("Title",headingstr1);
    sectionstr=strcat('CONUS-GLM-Lightning');
    add(chapter,Section(sectionstr));
    imdata = imread(figstr);
    [nhigh,nwid,ndepth]=size(imdata);
    image = mlreportgen.report.FormalImage();
    image.Image = which(figstr);% Use the screen grab image to preserve the background
    pdftxtstr=strcat('GLM Lightning Data-For File-',GOESShortFileName);
    pdftext = Text(pdftxtstr);
    pdftext.Color = 'red';
    image.Caption = pdftext;
    nhighs=floor(nhigh/2.5);
    nwids=floor(nwid/2.5);
    heightstr=strcat(num2str(nhighs),'px');
    widthstr=strcat(num2str(nwids),'px');
    image.Height = heightstr;
    image.Width = widthstr;
    image.ScaleToFit=0;
    add(chapter,image);
% Now add some text -start by decribing the GLM2 Lightning
    parastr11=strcat('The Data for this chart was taken from file-',GOESShortFileName,'.');
    parastr12='Plotted on the chart is the a number of lighting flashes as detected by the GLM sensor.';
    parastr13='The GLM sensor output is inherently different from the data produced by the ABI sensor which is a true imager.';
    parastr14='Instead,the output consists of lat lon position data for pixels which have lighting events on them along with intensity data.';
    parastr15='Terminalogy is important and the distinctions are not self evident.';
    parastr16='At the lowest level are event detections-for this a single pixel breaches an intensity threshold.';
    parastr17='False alarms are expected so the software will attempt to connect multiple event into a group detection.';
    parastr18='A group detection stitches together event detections that occurred in neighboring pixels in the same integration period.';
    parastr19='Finally flash detections occur when the group detections are extended to cover multiple integration periods up to 330 mSec.';
    parastr20='This final step helps to eliminate spurious detections and is called a Flash detection.';
    parastr21='The colored diamond symbols drawn on the chart are the locations of the comined flash data detected-these are the highest confidence detections.';
    parastr29=strcat(parastr11,parastr12,parastr13,parastr14,parastr15,parastr16,parastr17,parastr18,parastr19,parastr20,parastr21);
    p1 = Paragraph(parastr29);
    p1.Style = {OuterMargin("0pt", "0pt","10pt","10pt")};
    add(chapter,p1);
% Now build a Lightning Table With Key Data
    LightningHdr = {'Type' '# Pixels'  '# Detections'  'Integration Period' 'Extent' 'False Alarms'};
    LightningTable=cell(3,6);
    LightningTable{1,1}='Event';
    LightningTable{1,2}=' 1 ';
    LightningTable{1,3}=' 1 ';
    LightningTable{1,4}=' 2 mSec';
    LightningTable{1,5}=' 1 Pixel';
    LightningTable{1,6}='High';
    LightningTable{2,1}='Group';
    LightningTable{2,2}='>1';
    LightningTable{2,3}='>1';
    LightningTable{2,4}=' 2 mSec';
    LightningTable{2,5}='>1 or 16 kM';
    LightningTable{2,6}='Medium';
    LightningTable{3,1}='Flash';
    LightningTable{3,2}='>1';
    LightningTable{3,3}='>1';
    LightningTable{3,4}=' <330 mSec';
    LightningTable{3,5}='>1 or 16 kM';
    LightningTable{3,6}='Low ';
    T1=[LightningHdr;LightningTable];
    tbl=Table(T1);
    tbl.Style = [tbl.Style {Border('solid','black','3px')}];
    tbl.HAlign='center';
    tbl.TableEntriesHAlign = 'center';
    tbl.ColSep = 'single';
    tbl.RowSep = 'single';
    r = row(tbl,1);
    r.Style = [r.Style {Color('red'),Bold(true)}];
    bt1 = BaseTable(tbl);
    tabletitle = Text('Lightning Classification');
    tabletitle.Bold = false;
    bt1.Title = tabletitle;
    bt1.TableWidth="7in";
    add(chapter,bt1);
% Add some text to describe the table
    parastr31='The table above is meant to define lightning data reported from the GLM sensor.';
    parastr32='Column 1 indicates whether the entry belong to one of 3 type reports-event,group,or flash.';
    parastr33='A key determinant of the type of report is the number of pixel outputs needed to create this type of report and is shown in Column 2.';
    parastr34=strcat('Detections are shown in column 3.','Note that the integration period is 2mSec but a typical lightning stroke lasts only 400 microSec.',...
        'This means that any detector could respond to multiple strokes in a single integration period.');
    parastr35='The integration period is shown in Column 4 and corresponds to 2 mSec for event and group reports-flash reports sum up data from a much longer period.';
    parastr36='In the same fashion event reports cover a single pixel footprint of about 2 km,since groups associate multiple detections they are larger.';
    parastr37='Flash reports are integrated in both time and space-as such they can span 330 mSec and up to 16 km in extent.';
    parastr38='The final comment is a qualitative and describes the false alarm rate which is highest for single pixel events and lowest for flashes.';
    parastr39=strcat(parastr31,parastr32,parastr33,parastr34,parastr35,parastr36,parastr37,parastr38);
    p3 = Paragraph(parastr39);
    p3.Style = {OuterMargin("0pt", "0pt","10pt","10pt")};
    add(chapter,p3);
    br = PageBreak();
    add(chapter,br);
% Add a table to show key stats for the lightning data from this data set
    LightningHdrS = {'Type' 'Count'  'Min Duration'  'Max Duration' 'Min Energy' 'Max Energy'};
    LightningTableS=cell(3,6);
    LightningTableS{1,1}='Event';
    LightningTableS{1,2}=num2str(NumEvents);
    LightningTableS{1,3}='<2 mSec';
    LightningTableS{1,4}='2 mSec';
    LightningTableS{1,5}=num2str(EventMinEnergy,5);
    LightningTableS{1,6}=num2str(EventMaxEnergy,5);
    LightningTableS{2,1}='Group';
    LightningTableS{2,2}=num2str(NumGroups);
    LightningTableS{2,3}='<2 mSec';
    LightningTableS{2,4}='2 mSec';
    LightningTableS{2,5}=num2str(GroupMinEnergy,5);
    LightningTableS{2,6}=num2str(GroupMaxEnergy,5);
    LightningTableS{3,1}='Flash';
    LightningTableS{3,2}=num2str(numflashes);
    LightningTableS{3,3}='2 mSec';
    LightningTableS{3,4}='330 mSec';
    LightningTableS{3,5}=num2str(FlashMinEnergy,5);
    LightningTableS{3,6}=num2str(FlashMaxEnergy,5);
    if(numflashes>0)
        selectionratio=NumEvents/numflashes;
    else
        selectionratio=0;
    end
    T2=[LightningHdrS;LightningTableS];
    tb2=Table(T2);
    tb2.Style = [tb2.Style {Border('solid','black','3px')}];
    tb2.HAlign='center';
    tb2.TableEntriesHAlign = 'center';
    tb2.ColSep = 'single';
    tb2.RowSep = 'single';
    r = row(tb2,1);
    r.Style = [r.Style {Color('red'),Bold(true)}];
    bt2 = BaseTable(tb2);
    tabletitle = Text('Lightning Classification');
    tabletitle.Bold = false;
    bt2.Title = tabletitle;
    bt2.TableWidth="7in";
    add(chapter,bt2);
% Add some text to describe the table
    parastr41='The table above is meant to provide some key statistics related to the lightning detections. Each row is for one of the 3 types of report.';
    parastr42='Column 1 indicates which type of report is shown and it can be 1 of only 3 types-event,group,or flash.';
    parastr43='A count of each of these types of report is depicted in column 2-notice that event detections far exceeed flash detections.';
    parastr44='The time duration of the report is shown in columns 3 and 4.For events and group reports this is no more than 2 mSec but can be much longer for flashes.';
    parastr45='The integration period establishes the value of column 4 and corresponds to 2 mSec for event and group reports-flash reports sum up data from a much longer period.';
    parastr46=strcat('Columns 5 and 6 show the min and max energy for each type of lightning report in units of picoJoules.',...
        'Since spatial summing of the events data and additional temporal summing is performed on the group data it is not surrpising the flash max energy is largest.');
    parastr47=strcat('In going from events to flashes, most events are either eliminated or associated with other events-the selection ratio is-',...
        num2str(selectionratio,4),'.','For this reason flashes are much more likely to be real observations.');
    parastr49=strcat(parastr41,parastr42,parastr43,parastr44,parastr45,parastr46,parastr47);
    p4 = Paragraph(parastr49);
    p4.Style = {OuterMargin("0pt", "0pt","10pt","10pt")};
    add(chapter,p4);
% Now build a small data quality table
    dqfflag1=100*FlashQFS.percent_good_quality_qf;
    dqfflagstr1=num2str(dqfflag1,6);
    dqfflag2=100*FlashQFS.pct_degraded_due_flash_events_out_of_time_order_qf;
    dqfflagstr2=num2str(dqfflag2,6);
    dqfflag3=100*FlashQFS.pct_degraded_due_to_flash_event_count_exceeds_thresh_qf;
    dqfflagstr3=num2str(dqfflag3,6);
    dqfflag4=100*FlashQFS.pct_degraded_due_to_flash_duration_exceeds_threshold_qf;
    dqfflagstr4=num2str(dqfflag4,6);
    DQFHdr={'Item' '% of Pixels'};
    DQFTable=cell(4,2);
    DQFTable{1,1}='Pct Qood Quality Pixel';
    DQFTable{1,2}=dqfflagstr1;
    DQFTable{2,1}='Pct Degraded Due To Out Of Order Flash Events';
    DQFTable{2,2}=dqfflagstr2;
    DQFTable{3,1}='Pct Degraded Due To Flash Event Counts Exceeds Threshold';
    DQFTable{3,2}=dqfflagstr3;
    DQFTable{4,1}='Pct Degraded Due To Flash Duration Exceeds Threshold';
    DQFTable{4,2}=dqfflagstr4;
    br = PageBreak();
    add(chapter,br);
    T4=[DQFHdr;DQFTable];
    tbl4=Table(T4);
    tbl4.Style = [tbl4.Style {Border('solid','black','3px')}];
    tbl4.HAlign='center';
    tbl4.TableEntriesHAlign = 'center';
    tbl4.ColSep = 'single';
    tbl4.RowSep = 'single';
    r = row(tbl4,1);
    r.Style = [r.Style {Color('red'),Bold(true)}];
    bt4 = BaseTable(tbl4);
    tabletitle = Text('DQF Table Flash Detections');
    tabletitle.Bold = false;
    bt4.Title = tabletitle;
    bt4.TableWidth="7in";
    add(chapter,bt4);
% add a text paragraph for this table
    parastr51='This table specifies the values for 4 different quality metrics relating to the lightning data.';
    parastr52='On row 1 the first measure of quality is the per cent of pixel values-that had events-were accepted.';
    parastr53='The next 3 rows show the fraction of pixels that were rejected and the cause-typically nearly all the pixels with events were accepted.';
    parastr59=strcat(parastr51,parastr52,parastr53);
    p5 = Paragraph(parastr59);
    p5.Style = {OuterMargin("0pt", "0pt","10pt","10pt")};
    add(chapter,p5);    
end
fprintf(fid,'%s\n','-----End plot routine Display CONUS Lightning Data-----');
fprintf(fid,'\n');
%add(rpt,chapter);
end


