function DisplayDetailed3DFireHotSpots(FireLats,FireLons,FireHotTemps,itype,fireState,fireStateFP,indx,titlestr)
% Display fire hot spo locations on top of a DEM map on a 1 x 1 deg 
% segment containg the selected fire
% Written By: Stephen Forczyk
% Created: Oct 8,2020
% Revised: ---      
% Classification: Unclassified

global FireSummaryFile FireDetails;
global idebug;
global FullDTEDFilePaths;


global xImgS xImgBS SatDataS GeoSpatialS;
global ReflectanceS AlgoS ErrorS EarthSunS VersionContainerS;
global GoesWaveBand ESunS kappa0S PlanckS FocalPlaneS;
global GOESFileName OutlierPS CloudTopTS LZAS LZABS SZAS SZABS;
global TempS Algo2S ProcessParamTS AlgoProductTS Error1S CloudPixelsS;

global ProcessParamVersionContainerS GOESFileName;
global AreaS MaskS PowerS DQFS PixelFireDataS;
global FireOutlierPixelS FireTempS FireAreaS FirePowerS AlgoDynamicInputDataS;
global GRB_ErrorsS L0_ErrorsS;
global westEdge eastEdge northEdge southEdge;
global westEdge1 eastEdge1 northEdge1 southEdge1;
global MonthDayStr MonthDayYearStr;
global DayMonthNonLeapYear DayMonthLeapYear CalendarFileName;
global NationalCountiesShp;
global USAStatesShapeFileList USAStatesFileName;
global UrbanAreasShapeFile TimeCounter;

global widd2 lend2;
global initialtimestr igrid ijpeg ilog imovie;
global vert1 hor1 widd lend;
global vert2 hor2 machine;
global chart_time;
global Fz1 Fz2;
global idirector mov izoom iwindow;
global matpath GOES16path;
global jpegpath ;
global smhrpath excelpath ascpath nationalshapepath;
global ipowerpoint PowerPointFile scaling stretching padding;
global ichartnum;
global ColorList RGBVals ColorList2 xkcdVals LandColors;
% additional paths needed for mapping
global matpath1 mappath;
global canadapath stateshapepath topopath;
global trajpath militarypath;
global figpath screencapturepath USshapefilepath;
global shapepath2 countrypath countryshapepath usstateboundariespath;
global GOES16Band1path GOES16Band2path GOES16Band3path GOES16Band4path;
global GOES16Band5path GOES16Band6path GOES16Band7path GOES16Band8path
global GOES16Band9path GOES16Band10path GOES16Band11path GOES16Band12path;
global GOES16Band13path GOES16Band14path GOES16Band15path GOES16Band16path;

global GOES16CloudTopHeightpath shapefilepath;
USshapefilepath='D:\Forczyk\Map_Data\USStateShapeFiles\';
TimeCounter=cell(7,2);
TimeCounter{1,1}='Time To DEM Data';
TimeCounter{2,1}='Time To Plot Countries';
TimeCounter{3,1}='Time to Plot Counties';
TimeCounter{4,1}='Time To PLot Primary Roads';
TimeCounter{5,1}='Time To Plot State Roads';
TimeCounter{6,1}='Time To Plot City Areas';
TimeCounter{7,1}='Time To Plot Lakes';
disp('Start making 3D DEM Map');
numHotPixels=length(FireLats);
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

% MLineVal=1;
% PLineVal=1;
% numMdiv=abs(westEdge1-eastEdge1)/MLineVal;
% if(numMdiv>8)
%     MLineVal=2;
% end
set(gcf,'Position',[hor1 vert1 widd lend])
set(gcf,'MenuBar','none');
% h1=axesm('mercator','Frame','on','Grid','on','MapLatLimit',[southEdge1 northEdge1],...
%     'MapLonLimit',[westEdge1 eastEdge1],'meridianlabel','on','parallellabel','on','plabellocation',1,'mlabellocation',MLineVal,...
%     'MLabelParallel','south','MLineLocation',1,'PLineLocation',1);
% % set(gcf,'Position',[hor1 vert1 widd lend])
% % set(gcf,'MenuBar','none');
% MidMapLon=(westEdge1+eastEdge1)/2;
% MidMapLat=(southEdge1+northEdge1)/2;
% rivers = shaperead('worldrivers.shp', 'UseGeoCoords', true);
% numrows=length(rivers);
% tic;
% for n=1:numrows % Plot the rivers
%    NowLon=rivers(n).Lon;
%    NowLat=rivers(n).Lat;
%    hL(1)=plotm(NowLat,NowLon,'b','DisplayName','rivers');
% end
% dispstr=strcat('finished plotting-',num2str(numrows),'-rivers');
% disp(dispstr)
% elapsed_time1=toc;
% TimeCounter{1,2}=elapsed_time1;

tic;
dtedfile=char(FullDTEDFilePaths{1,1});
[Z,R] = readgeoraster(dtedfile,'OutputType','double');
ZP=Z;
% Remove the NaN values which are coded as -32767 and replace with 0
[i,j]=find(Z==-32767);
ZP(i,j)=0;
minval=0;
maxval=max(max(ZP));
Zlimits=[0  maxval];
usamap(R.LatitudeLimits,R.LongitudeLimits);
h1=geoshow(Z,R,'DisplayType','surface');
demcmap(Zlimits);
h2=colorbar;
h2.Label.String='Elevation in meters';
daspectm('m',20)
cornerlat = R.LatitudeLimits(2);
cornerlon = R.LongitudeLimits(1);
lightm(cornerlat,cornerlon);
ambient = 0.7; 
diffuse = 1;
specular = 0.6;
material([ambient diffuse specular])
elapsed_time1=toc;
TimeCounter{1,2}=elapsed_time1;
tightmap;
hold on
LatC=FireLats(indx,1);
LonC=FireLons(indx,1);
pointcolors = makesymbolspec('Point',{'default','Marker','*'});
ab=1;
%geoshow(LatC,LonC,'DisplayType','Point','Color','r','Marker','*','MarkerSize',12);
plotm(LatC,LonC,'rd');
ab=2;
hold off
eval(['cd ' nationalshapepath(1:length(nationalshapepath)-1)]);
% start by mapping the Counties from a national file
shapefilename=NationalCountiesShp;
tic;
S0=shaperead(shapefilename,'UseGeoCoords',true);
numrecords=length(S0);
waitstr=strcat('Plotting File-',RemoveUnderScores(shapefilename));
h=waitbar(0,waitstr);
iplotcount=0;
iskipcount=0;
imiss=0;
brown=[.396 .263 .129];
icounty=0;
for n=1:numrecords
    BoundingBox=S0(n).BoundingBox;
    MidLon=(BoundingBox(1,1)+BoundingBox(2,1))/2;
    MidLat=(BoundingBox(1,2)+BoundingBox(2,2))/2;
    dist=sqrt((MidMapLon-MidLon)^2 + (MidMapLat-MidLat)^2);
    STATEFP=str2num(S0(n).STATEFP);
    if(STATEFP==fireStateFP)
        CountyLat=S0(n).Lat;
        CountyLon=S0(n).Lon;
        numpts=length(CountyLat);
        icounty=icounty+1;
        if(icounty>16)
            icounty=1;
        end
        nowColor=[LandColors(icounty,1) LandColors(icounty,2) LandColors(icounty,3)];
        patchm(CountyLat,CountyLon,nowColor);
        iplotcount=iplotcount+1;        
    else
        imiss=imiss+1;
    end
    waitbar(n/numrecords);
end
clear S0
close(h);
elapsed_time3=toc;
TimeCounter{3,2}=elapsed_time3;
rivers = shaperead('worldrivers.shp', 'UseGeoCoords', true);
numrows=length(rivers);
tic;
for n=1:numrows % Plot the rivers
   NowLon=rivers(n).Lon;
   NowLat=rivers(n).Lat;
   hL(1)=plotm(NowLat,NowLon,'b','DisplayName','rivers');
end
dispstr=strcat('finished plotting-',num2str(numrows),'-rivers');
disp(dispstr)
elapsed_time1=toc;
TimeCounter{1,2}=elapsed_time1;
eval(['cd ' USshapefilepath(1:length(USshapefilepath)-1)]);
numshapefiles=length(USAStatesShapeFileList);
tic;
for kk=2:numshapefiles
    nowState=char(USAStatesShapeFileList{kk,1});
    a1=strcmpi(fireState,nowState);
    if(a1==1)
        imatch=kk;
        imatchstate=kk;
    end
end
shapefilename=char(USAStatesShapeFileList{imatch,6});
S1=shaperead(shapefilename,'UseGeoCoords',true);
numrecords=length(S1);
% Get the quick list of roads by type
RTTYP=cell(numrecords,1);
RTTYPNUM=zeros(numrecords,1);
RTTYPLen=zeros(numrecords,1);
for n=1:numrecords
    nowType=char(S1(n).RTTYP);
    RTTYP{n,1}=nowType;
    a1=strcmp(nowType,'C');
    a2=strcmp(nowType,'I');
    a3=strcmp(nowType,'M');
    a4=strcmp(nowType,'O');
    a5=strcmp(nowType,'S');
    a6=strcmp(nowType,'U');
    numpts=length(S1(n).Lat);
    RTTYPLen(n,1)=numpts;
    if(a1==1)
        RTTYPNUM(n,1)=1;
    elseif(a2==1)
        RTTYPNUM(n,1)=2;
    elseif(a3==1)
        RTTYPNUM(n,1)=3;
    elseif(a4==1)
        RTTYPNUM(n,1)=4;
    elseif(a5==1)
        RTTYPNUM(n,1)=5;
    else
        RTTYPNUM(n,1)=6;
    end
end
uniqueRoads=unique(RTTYP);
numuniqueRoads=length(uniqueRoads);
% Plot just the interstates
[Interstates]=find(RTTYPNUM==2);
numinterstates=length(Interstates);
InterstateData=zeros(numinterstates,2);
for n=1:numinterstates
    ind=Interstates(n,1);
    InterstateData(n,1)=ind;
    InterstateData(n,2)=RTTYPLen(ind,1);
end
[SortedLen,isort]=sort(InterstateData(:,2),'descend');
maxlen=SortedLen(1,1);
minlen=SortedLen(numinterstates,1);
meanlen=mean(SortedLen);

if(numinterstates<200)
    maxplot=numinterstates;
    pctplt=100;
elseif((numinterstates>=200) && (numinterstates<=400))
    maxplot=round(.80*numinterstates);
    pctplt=80;
elseif(numinterstates>400)
    maxplot=round(.60*numinterstates);
    pctplt=60;
end
waitstr=strcat('Plotting Interstates-',RemoveUnderScores(shapefilename));
h=waitbar(0,waitstr);

igo=1;
n=0;
while igo>0
    n=n+1;
    ind=isort(n,1);
    ind2=InterstateData(ind,1);
    RoadLat=S1(ind2).Lat;
    RoadLon=S1(ind2).Lon;
    numpts=length(RoadLat);
    hL(2)= plotm(RoadLat,RoadLon,'g','LineWidth',2,'DisplayName','Interstates');
    waitbar(n/numinterstates);
    if(n>=maxplot)
        igo=0;
    end
end
close(h);
elapsed_time4=toc;
TimeCounter{4,2}=elapsed_time4;
dispstr=strcat('Time required to plot all interstates=',num2str(elapsed_time4),'-sec');
disp(dispstr)
tic;
% Now plot the state highways
[StateRoads]=find(RTTYPNUM==5);
numstateroads=length(StateRoads);
StateRoadData=zeros(numstateroads,2);
for n=1:numstateroads
    ind=StateRoads(n,1);
    StateRoadData(n,1)=ind;
    StateRoadData(n,2)=RTTYPLen(ind,1);
end
[SortedLen,isort]=sort(StateRoadData(:,2),'descend');
maxlen=SortedLen(1,1);
minlen=SortedLen(numstateroads,1);
meanlen=mean(SortedLen);
dispstr=strcat('State Road min len=',num2str(minlen),'-mean len=',num2str(meanlen),...
    '-maxlen=',num2str(maxlen));
disp(dispstr);
if(numstateroads<400)
    maxplot=numstateroads;
    pctplt=100;
elseif((numstateroads>=400) && (numstateroads<=800))
    maxplot=round(.80*numstateroads);
    pctplt=80;
elseif(numstateroads>800)
    maxplot=round(.60*numstateroads);
    pctplt=60;
end

waitstr=strcat('Plotting StateRoads-',RemoveUnderScores(shapefilename));
h=waitbar(0,waitstr);
igo=1;
n=0;
while igo>0
    n=n+1;
    ind=isort(n,1);
    ind2=StateRoadData(ind,1);
    RoadLat=S1(ind2).Lat;
    RoadLon=S1(ind2).Lon;
    numpts=length(RoadLat);
    hL(5)=plotm(RoadLat,RoadLon,'k-.','LineWidth',1,'DisplayName','State Roads');
    waitbar(n/numstateroads);
    if(n>=maxplot)
        igo=0;
    end
end
close(h);
elapsed_time5=toc;
TimeCounter{5,2}=elapsed_time5;
% Now add urban areas
clear S1
tic;
eval(['cd ' USshapefilepath(1:length(USshapefilepath)-1)]);
S1=shaperead(UrbanAreasShapeFile,'UseGeoCoords',true);
numrecords=length(S1);
waitstr=strcat('Plotting Cities-',RemoveUnderScores(UrbanAreasShapeFile));
h=waitbar(0,waitstr);
numurban=0;
for n=1:numrecords
    STATEFP=(S1(n).StateFIPS);
    CityName=char(S1(n).CityName);
    Citynamelen=length(CityName);
    if(Citynamelen>12)
        CityName=CityName(1:12);
    end
    ALAND10=S1(n).ALAND10;
    if(STATEFP==fireStateFP)
        CityLat=S1(n).Lat;
        CityLon=S1(n).Lon;
        numpts=length(CityLat);
        hL(4)=patchm(CityLat,CityLon,'y','DisplayName','UrbanAreas');
        if(ALAND10>1E8)
            ab=1;
            medLat=median(CityLat,'omitnan');
            medLon=median(CityLon,'omitnan');
            textm(medLat+.1,medLon+.1,CityName,'Color',[1 1 1],'FontSize',8,'FontWeight','bold');
        end
        numurban=numurban+1;
        waitbar(n/numrecords);
    end
end
elapsed_time6=toc;
close(h);
TimeCounter{6,2}=elapsed_time6;
% Now plot lakes
% Select the correct State_water.shp file
tic
shapefilename=char(USAStatesShapeFileList{imatchstate,9});
waitstr=strcat('Plotting Lakes-',RemoveUnderScores(shapefilename));
h=waitbar(0,waitstr);
S2=shaperead(shapefilename,'UseGeoCoords',true);
numwater=length(S2);
for n=1:numwater
    Natural=char(S2(n).NATURAL);
    LakeName=char(S2(n).NAME);
    a1=strcmp(Natural,'water');
    a2=isempty(LakeName);
    if((a1==1) && (a2==0))
        LakeLat=S2(n).Lat;
        LakeLon=S2(n).Lon;
        hL(3)=patchm(LakeLat,LakeLon,'b','DisplayName','Lakes');
    end
    waitbar(n/numwater);
end
close(h);
elapsed_time7=toc;
TimeCounter{7,2}=elapsed_time7;
% Plot the fire pixels
cmap = rgbmap('red','blue',12);
minval=min(FireHotValues);
maxval=max(FireHotValues);
[SortFireHotValues,indS]=sort(FireHotValues);
delval=(maxval-minval)/length(cmap);
cmap2=flipud(cmap);
minsize=12;
maxsize=24;
for mm=1:numHotPixels
    mms=indS(mm,1);
    nowFireHotValue=FireHotValues(mms,1);
    diffnow=nowFireHotValue-minval;
    numinc=floor(diffnow/delval);
    nowInd=1+numinc;
    if(nowInd>length(cmap))
        nowInd=length(cmap);
    end
    nowColor=[cmap2(nowInd,1) cmap2(nowInd,2) cmap2(nowInd,3)];
    nowSize=floor(minsize+nowInd);
    scatterm(FireLats(mms,1),FireLons(mms,1),nowSize,nowColor,'filled')
end
title(titlestr)
hold off
scalebarlen=200;
scalebarloc='se';
scalebar('length',scalebarlen,'units','mi','color','k','location',scalebarloc,'fontangle','bold','RulerStyle','patches');
ArrowLat=northEdge1-2;
ArrowLon=eastEdge1+0.5;
northarrow('latitude',ArrowLat,'longitude',ArrowLon);
harrow=handlem('NorthArrow');
set(harrow,'FaceColor',[1 1 0],'EdgeColor',[1 0 0]);
legend(hL);
newaxesh=axes('Position',[0 0 1 1]);
set(newaxesh,'XLim',[0 1],'YLim',[0 1]);
tx1=.78;
ty1=.08;
txtstr1=strcat('Start Scan-Y',num2str(YearS),'-D-',num2str(DayS),'-H-',...
    num2str(HourS),'-M-',num2str(MinuteS),'-S-',num2str(SecondS));
txt1=text(tx1,ty1,txtstr1,'FontWeight','bold','FontSize',8);

tx3a=.78;
ty3a=.04;
txtstr3a=strcat('Calendar Date-',MonthDayYearStr);
txt3a=text(tx3a,ty3a,txtstr3a,'FontWeight','bold','FontSize',8);
% Get the min and max values of the fire hot values
minval=min(FireHotValues);
maxval=max(FireHotValues);
tx4=.18;
ty4=.04;
if(itype==1)
    txtstr4=strcat('Hot Spots had min Temp=',num2str(minval,4),'-to-',...
        'max Temp=',num2str(maxval,4),'-DegK');
    txt4=text(tx4,ty4,txtstr4,'FontWeight','bold','FontSize',8);
end
set(newaxesh,'Visible','Off');
% Save this chart
figstr2=strcat(titlestr,'.jpg');
figstr=strcat('FireHotSpots-ABI-L2-Fire','Y',num2str(YearS),'D',...
    num2str(DayS),'H',num2str(HourS),'M',num2str(MinuteS),'S',num2str(SecondS),...
    '.jpg');
eval(['cd ' jpegpath(1:length(jpegpath)-1)]);
actionstr='print';
typestr='-djpeg';
[cmdString]=MyStrcat2(actionstr,typestr,figstr2);
eval(cmdString);
dispstr=strcat('Saved Image To File-',figstr);
disp(dispstr)
pause(chart_time);
disp('Run Time Values For Creating This map');
T=cell2table(TimeCounter);
disp(T);
close('all');
end


