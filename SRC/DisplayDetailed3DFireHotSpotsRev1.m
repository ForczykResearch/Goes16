function DisplayDetailed3DFireHotSpotsRev1(FireLats,FireLons,itype,fireState,fireStateFP,indx,titlestr)
% Display fire hot spo locations on top of a DEM map on a 1 x 1 deg 
% segment containg the selected fire
% Written By: Stephen Forczyk
% Created: Oct 8,2020
% Revised: Oct 16,2020 added logic to plot Interstate Logo's changed plot
% order
% Revised: Oct 19,2020 rescalled DEM plots to highlight terrain better
% Revised: Oct 20,2020 added new test in plotting some roads to speed up
%                      making the charts. The trick is to add extra road
%                      length to those roads that fall onto the map
%                      ensuring that these will plot first
% Revised: Oct 21,2020 Added selected output from this routine to the Log file
% Classification: Unclassified
% Road Types-Tiger Line
%
%   Code       Description
%    C         County
%    I         Interstate
%    M         Common Name
%    O         Other
%    S         State Recognized
%    U         US

global FireSummaryFile FireDetails;
global idebug;
global imatchState;
global FullDTEDFilePaths;
global orange bubblegum brown brightblue;
global iPrimeRoads iCountyRoads iCommonRoads iStateRecRoads iUSRoads iStateRoads;
global WaterPrelimFeatures WaterFinalFeatures WaterSortedFeatures;
global RptGenPresent iCreatePDFReport pdffilename rpt chapter tocc;
global JpegCounter JpegFileList;

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
global iBullsEye iBullsEyeStart iBullsEyeInc iDrawBullsEye;

global widd2 lend2;
global initialtimestr igrid ijpeg ilog imovie;
global vert1 hor1 widd lend;
global vert2 hor2 machine;
global chart_time;
global Fz1 Fz2;
global fid;
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
global trajpath militarypath tiffpath;
global figpath screencapturepath USshapefilepath;
global shapepath2 countrypath countryshapepath usstateboundariespath;
global GOES16Band1path GOES16Band2path GOES16Band3path GOES16Band4path;
global GOES16Band5path GOES16Band6path GOES16Band7path GOES16Band8path
global GOES16Band9path GOES16Band10path GOES16Band11path GOES16Band12path;
global GOES16Band13path GOES16Band14path GOES16Band15path GOES16Band16path;

global GOES16CloudTopHeightpath shapefilepath;
if((iCreatePDFReport==1) && (RptGenPresent==1))
    import mlreportgen.dom.*;
    import mlreportgen.report.*;
end
USshapefilepath='D:\Forczyk\Map_Data\USStateShapeFiles\';
TimeCounter=cell(10,2);
TimeCounter{1,1}='Time To DEM Data';
TimeCounter{2,1}='Time To Plot Fire';
TimeCounter{3,1}='Time To Plot Primary Roads';
TimeCounter{4,1}='Time To Plot State Roads';
TimeCounter{5,1}='Time To Plot County Roads';
TimeCounter{6,1}='Time To Plot Common Roads';
TimeCounter{7,1}='Time To Plot StateRec Roads';
TimeCounter{8,1}='Time To Plot US Roads';
TimeCounter{9,1}='Time To Plot US Lakes';
TimeCounter{10,1}='Time To Plot County Boundaries';
TimeCounter{11,1}='Time To Plot Airports';
TimeCounter{12,1}='Time To Plot Mt Peaks';
TimeCounter{13,1}='Time To Plot Urban Areas';
TimeCounter{14,1}='Time To Plot Chart';
iBullsEye=3;
iBullsEyeStart=5;
iBullsEyeInc=5;
LatC=FireLats(indx,1);
LonC=FireLons(indx,1);
% TimeCounter{7,1}='Time To Plot Lakes';
iPrimeRoads=1;
iStateRoads=1;
iCountyRoads=1;
iCommonRoads=1;
iStateRecRoads=1;
iUSRoads=1;
disp('Start making 3D DEM Map');
fprintf(fid,'\n');
fprintf(fid,'%s\n','////// Start Executing Routine DisplayDetailed3DFireHotSpotsRev1.m //////');
fprintf(fid,'%s\n','Start making 3D DEM Map');
fprintf(fid,'%s\n','********* Status of Flags follows *******');
iPrimeRoadsstr=strcat('iPrimeRoads=',num2str(iPrimeRoads));
iStateRoadsstr=strcat('iStateRoads=',num2str(iStateRoads));
iCountyRoadsstr=strcat('iCountyRoads=',num2str(iCountyRoads));
iCommonRoadsstr=strcat('iCommonRoads=',num2str(iCommonRoads));
iStateRecRoadsstr=strcat('iStateRecRoads=',num2str(iStateRecRoads));
iUSRoadsstr=strcat('iUSRoads=',num2str(iUSRoads));
fprintf(fid,'%s    %s',iPrimeRoadsstr,iStateRoadsstr);
fprintf(fid,'   %s    %s\n',iCountyRoadsstr,iCommonRoadsstr);
fprintf(fid,'%s    %s\n',iStateRecRoadsstr,iUSRoadsstr);
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
fprintf(fid,'%s\n','******Start Scan Time******');
YearSstr=strcat('Year=',num2str(YearS));
DaySstr=strcat('Day=',num2str(DayS));
HourSstr=strcat('Hour=',num2str(HourS));
MinuteSstr=strcat('Min=',num2str(MinuteS));
SecondSstr=strcat('Sec=',num2str(SecondS));
fprintf(fid,'%s %s %s %s %s\n',YearSstr,DaySstr,HourSstr,MinuteSstr,SecondSstr);
% Set up the map axis
set(gcf,'Position',[hor1 vert1 widd lend])
set(gcf,'MenuBar','none');
h1=axesm('mercator','Frame','on','Grid','on','MapLatLimit',[southEdge1 northEdge1],...
    'MapLonLimit',[westEdge1 eastEdge1],'meridianlabel','on','parallellabel','on','PLabelLocation',.1,'MLabelLocation',.2,...
    'MLabelParallel','south','MLineLocation',.1,'PLineLocation',.1,'MLabelRound',-2, 'PLabelRound',-2,'LabelFormat','signed');

MidMapLon=(westEdge1+eastEdge1)/2;
MidMapLat=(southEdge1+northEdge1)/2;
XB=[westEdge1 eastEdge1 eastEdge1 westEdge1 westEdge1];
YB=[southEdge1 southEdge1 northEdge1 northEdge1 southEdge1];
fprintf(fid,'%s\n','************* Map Limits *************');
MapLatLimStr=strcat('NorthEdge=',num2str(northEdge1),'-SouthEdge=',num2str(southEdge1));
MapLonLimStr=strcat('westEdge=',num2str(westEdge1),'-eastEdge=',num2str(eastEdge1));
fprintf(fid,'%s\n',MapLatLimStr);
fprintf(fid,'%s\n',MapLonLimStr);
tic;
dtedfile=char(FullDTEDFilePaths{1,1});
[Z,R] = readgeoraster(dtedfile,'OutputType','double');
ZP=Z;
[latRef,lonRef] = meshgrat(Z,R);
% Remove the NaN values which are coded as -32767 and replace with 0
[ifill,jfill]=find(ZP==-32768);
numfill=length(ifill);
[ilow,jlow]=find(ZP<0);
numlowdem=length(ilow);
ZP(ilow,jlow)=0;
[ihigh,jhigh]=find(ZP>0);
numhigh=length(ihigh);
% Now get better limits for the DEM Map
[nrows,ncols]=size(ZP);
ZP1=reshape(ZP,nrows*ncols,1);
ZP1=sort(ZP1);
medianfill=median(ZP1,'omitnan');
numpts=nrows*ncols;
numpts01=round(.01*numpts);
val01=round(ZP1(numpts01,1));
minval=val01-mod(val01,100);

if(minval<0)
    minval=0;
end
maxval=max(max(ZP));
if(maxval-minval<100)
    maxval=minval+100;
end
maxval=maxval-mod(maxval,100)+100;
demstr1=strcat('Num default DEM pixels=',num2str(numfill),'-num Pix <0=',num2str(numlowdem),...
    '-num Pix >0=',num2str(numhigh),'-val01=',num2str(val01));
fprintf(fid,'%s\n',demstr1);
demstr2=strcat('Final DEM Limits minval=',num2str(minval),'-maxval=',num2str(maxval),'-medianfill=',num2str(medianfill));
fprintf(fid,'%s\n',demstr2);
clear ZP1
Zlimits=[minval  maxval];
h1=surfm(latRef,lonRef,ZP);
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
tic;
LatC=FireLats(indx,1);
LonC=FireLons(indx,1);
TempC=FireDetails{indx+1,5};
AreaC=FireDetails{indx+1,6};
FireCounty=char(FireDetails{indx+1,2});
% Plot the fire pixels
[numHotPixelsp1,numcols]=size(FireDetails);
numHotPixels=numHotPixelsp1-1;
FireHotValues=zeros(numHotPixels,1);
ind=0;
for kk=2:numHotPixelsp1
    ind=ind+1;
    FireHotValues(ind,1)=FireDetails{kk,5};
end
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

% Now calculate the altitude of the fire
[FireHeight,indLat,indLon] = GetFireHeightFromDEM(LatC,LonC,latRef,lonRef,ZP);
elapsed_time2=toc;
firestr1=strcat('Selected Fire at Lat=',num2str(LatC),'-Lon=',num2str(LonC),...
    '-At Altitude=',num2str(FireHeight),'-meters');
fprintf(fid,'%s\n',firestr1);
TimeCounter{2,2}=elapsed_time2;
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
warning('off')
imatch=imatchState;
shapefilename=char(USAStatesShapeFileList{imatch,6});
S1=shaperead(shapefilename,'UseGeoCoords',true);
numrecords=length(S1);
shapefilestr=strcat('-----Roads defined Using ShapeFile-----',shapefilename);
% Specify which shapefile used to define roads
fprintf(fid,'%s\n',shapefilestr);
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
hold on

tic;
% Now plot the state highways
[StateRoads]=find(RTTYPNUM==5);
numstateroads=length(StateRoads);
StateRoadData=zeros(numstateroads,8);

for n=1:numstateroads
    ind=StateRoads(n,1);
    StateRoadData(n,1)=ind;
    StateRoadData(n,2)=RTTYPLen(ind,1);
    BoundingBox=S1(ind).BoundingBox;
    StateRoadData(n,3)=BoundingBox(1,1);
    StateRoadData(n,4)=BoundingBox(1,2);
    StateRoadData(n,5)=BoundingBox(2,1);
    StateRoadData(n,6)=BoundingBox(2,2);
    try
        [xinL,yinL,IndL]=Inside(XB,YB,StateRoadData(n,3),StateRoadData(n,4));
        numxin=length(xinL);
        numyin=length(yinL);
    catch
            numxin=0;
            numyin=0;
    end

    StateRoadData(n,7)=numxin+numyin;
    StateRoadData(n,8)=StateRoadData(n,2)+StateRoadData(n,2)*(numxin+numyin);
end
[SortedLen,isort]=sort(StateRoadData(:,8),'descend');
maxlen=SortedLen(1,1);
minlen=SortedLen(numstateroads,1);
meanlen=mean(SortedLen);
dispstr=strcat('State Road min len=',num2str(minlen),'-mean len=',num2str(meanlen),...
    '-maxlen=',num2str(maxlen),'-numstateroads-',num2str(numstateroads));
disp(dispstr);
if(numstateroads<200)
    maxplot=numstateroads;
elseif((numstateroads>=200) && (numstateroads<=400))
    maxplot=200+round(.50*(numstateroads-200));
elseif((numstateroads>=400) && (numstateroads<=600))
    maxplot=300+round(.40*(numstateroads-400));
elseif(numstateroads>600)
    maxplot=460;
end
if(iStateRoads==0)
    numstateroads=1;
end
fprintf(fid,'%s\n','****** Distribution of Roads Found on Shapefile *******');
stateroadstr1=strcat('# State Roads.......',num2str(numstateroads),'-plot limit=',num2str(maxplot),'-roads');
fprintf(fid,'%s\n',stateroadstr1);
stateroadstr2=strcat('Min Road Length.......',num2str(minlen),'-Mean Length=',num2str(meanlen),...
    '-Max Length=',num2str(maxlen));
fprintf(fid,'%s\n',stateroadstr2);
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
    hL(2)=plotm(RoadLat,RoadLon,'Color',orange,'LineWidth',2,'DisplayName','State Roads');
    waitbar(n/maxplot);
    if(n>=maxplot)
        igo=0;
    end
end
close(h);
elapsed_time4=toc;
TimeCounter{4,2}=elapsed_time4;
% Now plot county roads
tic;
[CountyRoads]=find(RTTYPNUM==1);
numcountyroads=length(CountyRoads);
CountyRoadData=zeros(numcountyroads,2);
for n=1:numcountyroads
    ind=CountyRoads(n,1);
    CountyRoadData(n,1)=ind;
    CountyRoadData(n,2)=RTTYPLen(ind,1);
end
[SortedLen,isort]=sort(CountyRoadData(:,2),'descend');
maxlen=SortedLen(1,1);
minlen=SortedLen(numcountyroads,1);
meanlen=mean(SortedLen);
dispstr=strcat('County Road min len=',num2str(minlen),'-mean len=',num2str(meanlen),...
    '-maxlen=',num2str(maxlen),'-numcountyyroads-',num2str(numcountyroads));
disp(dispstr);
if(numcountyroads<800)
    maxplot=numcountyroads;
elseif((numcountyroads>=800) && (numcountyroads<=1200))
    maxplot=round(.80*numcountyroads);
elseif(numcountyroads>1200)
    maxplot=round(.60*numcountyroads);
end
if(iCountyRoads==0)
    numcountyroads=1;
end
countyroadstr1=strcat('# County Roads.......',num2str(numcountyroads),'-plot limit=',num2str(maxplot),'-roads');
fprintf(fid,'%s\n',countyroadstr1);
countyroadstr2=strcat('Min Road Length.......',num2str(minlen),'-Mean Length=',num2str(meanlen),...
    '-Max Length=',num2str(maxlen));
fprintf(fid,'%s\n',countyroadstr2);
waitstr=strcat('Plotting CountyRoads-',RemoveUnderScores(shapefilename));
h=waitbar(0,waitstr);
igo=1;
n=0;
while igo>0
    n=n+1;
    ind=isort(n,1);
    ind2=CountyRoadData(ind,1);
    RoadLat=S1(ind2).Lat;
    RoadLon=S1(ind2).Lon;
    hL(3)=plotm(RoadLat,RoadLon,'g-.','LineWidth',1,'DisplayName','County Roads');
    waitbar(n/numcountyroads);
    if(n>=maxplot)
        igo=0;
    end
end
close(h);
elapsed_time5=toc;
TimeCounter{5,2}=elapsed_time5;
% Now plot common roads
tic;
[CommonRoads]=find(RTTYPNUM==4);
numcommonroads=length(CommonRoads);
CommonRoadData=zeros(numcommonroads,2);
if(numcommonroads>1)
    for n=1:numcommonroads
        ind=CommonRoads(n,1);
        CommonRoadData(n,1)=ind;
        CommonRoadData(n,2)=RTTYPLen(ind,1);
    end
    [SortedLen,isort]=sort(CommonRoadData(:,2),'descend');
    maxlen=SortedLen(1,1);
    minlen=SortedLen(numcommonroads,1);
    meanlen=mean(SortedLen);
    dispstr=strcat('Common Road min len=',num2str(minlen),'-mean len=',num2str(meanlen),...
    '-maxlen=',num2str(maxlen),'-numcommonroads-',num2str(numcommonroads));
    disp(dispstr);
    if(numcommonroads<800)
        maxplot=numcommonroads;
    elseif((numcommonroads>=800) && (numcommonroads<=1200))
        maxplot=round(.80*numcommonroads);
    elseif(numcommonroads>1200)
        maxplot=round(.60*numcommonroads);
    end
    commonroadstr1=strcat('# Common Roads.......',num2str(numcommonroads),'-plot limit=',num2str(maxplot),'-roads');
    fprintf(fid,'%s\n',commonroadstr1);
    commonroadstr2=strcat('Min Road Length.......',num2str(minlen),'-Mean Length=',num2str(meanlen),...
        '-Max Length=',num2str(maxlen));
    fprintf(fid,'%s\n',commonroadstr2);
    if(iCommonRoads==0)
        numcommonroads=1;
    end
    waitstr=strcat('Plotting CommonRoads-',RemoveUnderScores(shapefilename));
    h=waitbar(0,waitstr);
    igo=1;
    n=0;
    while igo>0
        n=n+1;
        ind=isort(n,1);
        ind2=CommonRoadData(ind,1);
        RoadLat=S1(ind2).Lat;
        RoadLon=S1(ind2).Lon;
        numpts=length(RoadLat);
        hL(4)=plotm(RoadLat,RoadLon,'c-.','LineWidth',1,'DisplayName','Common Roads');
        waitbar(n/numcommonroads);
        if(n>=maxplot)
            igo=0;
        end
    end
    close(h);
else
    fprintf(fid,'%s\n','No common roads so plotinkipped');
end
elapsed_time6=toc;
TimeCounter{6,2}=elapsed_time6;
% Now plot state recognized roads
tic;
[StateRecRoads]=find(RTTYPNUM==5);
numstaterecroads=length(StateRecRoads);
StateRecRoadData=zeros(numstaterecroads,8);
for n=1:numstaterecroads
    ind=StateRecRoads(n,1);
    StateRecRoadData(n,1)=ind;
    StateRecRoadData(n,2)=RTTYPLen(ind,1);
    BoundingBox=S1(ind).BoundingBox;
    StateRecRoadData(n,3)=BoundingBox(1,1);
    StateRecRoadData(n,4)=BoundingBox(1,2);
    StateRecRoadData(n,5)=BoundingBox(2,1);
    StateRecRoadData(n,6)=BoundingBox(2,2);
    try
        [xinL,yinL,IndL]=Inside(XB,YB,StateRecRoadData(n,3),StateRecRoadData(n,4));
        numxinL=length(xinL);
        numyinL=length(yinL);
    catch
        numxinL=0;
        numyinL=0;
    end
    try
        [xinR,yinR,IndR]=Inside(XB,YB,StateRecRoadData(n,5),StateRecRoadData(n,6));
        numxinR=length(xinR);
        numyinR=length(yinR);
    catch
        numxinR=0;
        numyinR=0;
    end
    StateRecRoadData(n,7)=numxinL+numyinL + numxinR + numyinR;
    StateRecRoadData(n,8)=StateRecRoadData(n,2)+StateRecRoadData(n,2)*StateRecRoadData(n,7)/2;
end
[SortedLen,isort]=sort(StateRecRoadData(:,8),'descend');
maxlen=SortedLen(1,1);
minlen=SortedLen(numstaterecroads,1);
meanlen=mean(SortedLen);
dispstr=strcat('State Rec Road min len=',num2str(minlen),'-mean len=',num2str(meanlen),...
    '-maxlen=',num2str(maxlen),'-numstaterecroads-',num2str(numstaterecroads));
disp(dispstr);
if(numstaterecroads<200)
    maxplot=numstaterecroads;
elseif((numstaterecroads>=200) && (numstaterecroads<=400))
    maxplot=round(.80*numstaterecroads);
elseif((numstaterecroads>=400) && (numstaterecroads<=600))
    maxplot=round(.80*numstaterecroads);
elseif(numstaterecroads>600)
    maxplot=round(.20*numstaterecroads);
end
if(iStateRecRoads==0)
    numstaterecroads=1;
    maxplot=1;
end
StateRecroadstr1=strcat('# StateRec Roads.......',num2str(numstaterecroads),'-plot limit=',num2str(maxplot),'-roads');
fprintf(fid,'%s\n',StateRecroadstr1);
StateRecroadstr2=strcat('Min Road Length.......',num2str(minlen),'-Mean Length=',num2str(meanlen),...
    '-Max Length=',num2str(maxlen));
fprintf(fid,'%s\n',StateRecroadstr2);
waitstr=strcat('Plotting StateRecRoads-',RemoveUnderScores(shapefilename));
h=waitbar(0,waitstr);
igo=1;
n=0;
while igo>0
    n=n+1;
    ind=isort(n,1);
    ind2=StateRecRoadData(ind,1);
    RoadLat=S1(ind2).Lat;
    RoadLon=S1(ind2).Lon;
    hL(5)=plotm(RoadLat,RoadLon,'y','LineWidth',2,'DisplayName','StateRec Roads');
    waitbar(n/maxplot);
    if(n>=maxplot)
        igo=0;
    end
end
close(h);
elapsed_time7=toc;
TimeCounter{7,2}=toc;
% Now plot US  roads
tic;
[USRoads]=find(RTTYPNUM==6);
numusroads=length(USRoads);
USRoadData=zeros(numusroads,8);
for n=1:numusroads
    ind=USRoads(n,1);
    USRoadData(n,1)=ind;
    USRoadData(n,2)=RTTYPLen(ind,1);
    BoundingBox=S1(ind).BoundingBox;
    USRoadData(n,3)=BoundingBox(1,1);
    USRoadData(n,4)=BoundingBox(1,2);
    USRoadData(n,5)=BoundingBox(2,1);
    USRoadData(n,6)=BoundingBox(2,2);
    try
        [xinL,yinL,IndL]=Inside(XB,YB,USRoadData(n,3),USRoadData(n,4));
        numxinL=length(xinL);
        numyinL=length(yinL);
    catch
        numxinL=0;
        numyinL=0;
    end
    try
        [xinR,yinR,IndR]=Inside(XB,YB,USRoadData(n,5),USRoadData(n,6));
        numxinR=length(xinR);
        numyinR=length(yinR);
    catch
        numxinR=0;
        numyinR=0;
    end
    USRoadData(n,7)=numxinL+numyinL + numxinR + numyinR;
    USRoadData(n,8)=USRoadData(n,2)+USRoadData(n,2)*USRoadData(n,7)/2;
end
[SortedLen,isort]=sort(USRoadData(:,8),'descend');
maxlen=SortedLen(1,1);
minlen=SortedLen(numusroads,1);
meanlen=mean(SortedLen);
dispstr=strcat('US Road min len=',num2str(minlen),'-mean len=',num2str(meanlen),...
    '-maxlen=',num2str(maxlen),'-numusroads=',num2str(numusroads));
disp(dispstr);
if(numusroads<200)
    maxplot=numusroads;
elseif((numusroads>=200) && (numusroads<=400))
    maxplot=round(.80*numusroads);
elseif((numusroads>=400) && (numusroads<=600))
    maxplot=round(.50*numusroads);
elseif(numusroads>600)
    maxplot=round(.20*numusroads);
end
if(iUSRoads==0)
    numusroads=1;
    maxplot=1;
end
USroadstr1=strcat('# US Roads.......',num2str(numusroads),'-plot limit=',num2str(maxplot),'-roads');
fprintf(fid,'%s\n',USroadstr1);
USroadstr2=strcat('Min Road Length.......',num2str(minlen),'-Mean Length=',num2str(meanlen),...
    '-Max Length=',num2str(maxlen));
fprintf(fid,'%s\n',USroadstr2);
waitstr=strcat('Plotting USRoads-',RemoveUnderScores(shapefilename));
h=waitbar(0,waitstr);
igo=1;
n=0;
while igo>0
    n=n+1;
    ind=isort(n,1);
    ind2=USRoadData(ind,1);
    RoadLat=S1(ind2).Lat;
    RoadLon=S1(ind2).Lon;
    hL(5)=plotm(RoadLat,RoadLon,'y','LineWidth',1,'DisplayName','StateRec Roads');
    waitbar(n/maxplot);
    if(n>=maxplot)
        igo=0;
    end
end
close(h);
elapsed_time8=toc;
TimeCounter{8,2}=elapsed_time8;
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
elseif((numinterstates>=200) && (numinterstates<=400))
    maxplot=round(.80*numinterstates);
elseif(numinterstates>400)
    maxplot=round(.60*numinterstates);
end
if(iPrimeRoads==0)
    numinterstates=1;
end
InterStateNames=cell(numinterstates,1);
for n=1:numinterstates
    ind2=InterstateData(n,1);
    RoadName=char(S1(ind2).FULLNAME);
    RoadLat=S1(ind2).Lat;
    RoadLon=S1(ind2).Lon;
    InterStateNames{n,1}=RoadName;
end
Interstateroadstr1=strcat('# Interstate Roads.......',num2str(numinterstates),'-plot limit=',num2str(maxplot),'-roads');
fprintf(fid,'%s\n',Interstateroadstr1);
% Get the number of UniqueInterstates
UniqueInterStates=unique(InterStateNames);
numUniqueInterStates=length(UniqueInterStates);
UniqueInterStateList=cell(numUniqueInterStates,4);
for n=1:numUniqueInterStates
    UniqueInterStateList{n,1}=UniqueInterStates{n,1};
    UniqueInterStateList{n,2}=0;
    UniqueInterStateList{n,3}=[];
    UniqueInterStateList{n,4}=0;
end
% Now find out the total number of hits for each name
    for j=1:numinterstates
        ind2=InterstateData(j,1);
        nowRoad=char(S1(ind2).FULLNAME);
        for jj=1:numUniqueInterStates
            nowCompareInterState= char(UniqueInterStateList{jj,1});
            a1=strcmp(nowRoad,nowCompareInterState);
            if(a1==1)
                [outstr] = RemoveBlanks(nowRoad);
                tifffilename=strcat('I-',outstr,'.tif');
                UniqueInterStateList{jj,2}=UniqueInterStateList{jj,2}+1;
                UniqueInterStateList{jj,3}=tifffilename;
            end
        end
   end
waitstr=strcat('Plotting Interstates-',RemoveUnderScores(shapefilename));
h=waitbar(0,waitstr);
igo=1;
n=0;
ilogo=0;
while igo>0
    n=n+1;
    ind=isort(n,1);
    ind2=InterstateData(ind,1);
    RoadName=char(S1(ind2).FULLNAME);
% Establish what unique road this is
    kmatchinter=0;
    for kk=1:numUniqueInterStates
        nowUniqueInterState=char(UniqueInterStateList{kk,1});
        a1=strcmp(RoadName,nowUniqueInterState);
        if(a1==1)
            kmatchinter=kk;
            alreadylabelled=UniqueInterStateList{kk,4};
        end
    end
    RoadLat=S1(ind2).Lat;
    RoadLon=S1(ind2).Lon;
    hL(1)= plotm(RoadLat,RoadLon,'g','LineWidth',2,'DisplayName','Interstates');
    waitbar(n/numinterstates);
    if(n>=maxplot)
        igo=0;
    end
    RoadCtrLat=mean(RoadLat,'omitnan');
    RoadCtrLon=mean(RoadLon,'omitnan');
    try
        [xin,yin,Ind]=Inside(XB,YB,RoadCtrLon,RoadCtrLat);
        a1=isempty(xin);
        if((a1==0) && (alreadylabelled==0) && (kmatchinter>0))
            tiffname=char(UniqueInterStateList{kmatchinter,3});
            eval(['cd ' tiffpath(1:length(tiffpath)-1)]);
            latlim = [(RoadCtrLat-.020) (RoadCtrLat+.020)];
            lonlim = [(RoadCtrLon-.020) (RoadCtrLon+.020)];
            info=imfinfo(tiffname);
            rasterSize = [info.Width info.Height];
            Rpix = georefcells(latlim,lonlim,rasterSize,'ColumnsStartFrom','north');
            [RGB,RGBMap] = imread(tiffname);
            geoshow(RGB,RGBMap,Rpix);
            UniqueInterStateList{kmatchinter,4}=1;
            dispstr=strcat('Displayed Logo-',tiffname,'-at Lat=',num2str(RoadCtrLat),...
                '-Lon=',num2str(RoadCtrLon));
            fprintf(fid,'%s\n',dispstr);
            disp(dispstr);
            ilogo=ilogo+1;           
        end
    catch
    end
end
close(h);
elapsed_time3=toc;
TimeCounter{3,2}=elapsed_time3;
dispstr=strcat('Plotted-',num2str(ilogo),'-Road Logos');
disp(dispstr);
dispstr=strcat('Time required to plot all interstates=',num2str(elapsed_time3),'-sec');
disp(dispstr)
% Select the correct State_water.shp file
tic
XB=[westEdge1 eastEdge1 eastEdge1 westEdge1 westEdge1];
YB=[southEdge1 southEdge1 northEdge1 northEdge1 southEdge1];
shapefilename=char(USAStatesShapeFileList{imatch,9});
watershapestr=strcat('Plot lakes using shapefile-',shapefilename);
fprintf(fid,'%s\n',watershapestr);
waitstr=strcat('Plotting Lakes-',RemoveUnderScores(shapefilename));
h=waitbar(0,waitstr);
S2=shaperead(shapefilename,'UseGeoCoords',true);
numwater=length(S2);
% make a list of those water features that are defined but with the 'water'
% designator and a name
WaterPrelimFeatures=cell(numwater,3);
ind=0;
for n=1:numwater
    Natural=char(S2(n).NATURAL);
    LakeName=char(S2(n).NAME);
    LakeLat=S2(n).Lat;
    numpts=length(LakeLat);
    a1=strcmp(Natural,'water');
    a2=isempty(LakeName);
    if((a1==1) && (a2==0))
        ind=ind+1;
        WaterPrelimFeatures{ind,1}=n;
        WaterPrelimFeatures{ind,2}=LakeName;
        WaterPrelimFeatures{ind,3}=numpts;
    end
end
WaterFinalFeatures=zeros(ind,2);
numlakes=ind;
for n=1:ind
    WaterFinalFeatures(n,1)=WaterPrelimFeatures{n,1};
    WaterFinalFeatures(n,2)=WaterPrelimFeatures{n,3};
end
% Now sort in order of decreasing length
[WaterSortedFeatures,indx]=sort(WaterFinalFeatures(:,2),'descend');
iskip=0;
ilakeplotted=0;
irestore=0;
numlakes2=round(numlakes/2);
for nx=1:numlakes2
    nxx=indx(nx,1);
    n=WaterFinalFeatures(nxx,1);
    Natural=char(S2(n).NATURAL);
    LakeName=char(S2(n).NAME);
    a1=strcmp(Natural,'water');
    a2=isempty(LakeName);
    if((a1==1) && (a2<2))
        LakeLat=S2(n).Lat;
        LakeLon=S2(n).Lon;
        LakeLat2=LakeLat;
        LakeLon2=LakeLon;
        numpts=length(LakeLat);
        A1=isnan(LakeLat);
        numnan1=sum(A1);
        [xin,yin,Ind]=Inside(XB,YB,LakeLon,LakeLat);
        numin1=length(xin);
        numtot1=length(LakeLon);
        numout1=numtot1-numin1-numnan1;
        goodfrac1=numin1/numtot1;
        try
            hL(4)=patchm(LakeLat,LakeLon,'FaceColor',brightblue,...
                'EdgeColor',brightblue,'FaceAlpha',1,'DisplayName','Lakes');
            ilakeplotted=ilakeplotted+1;
            lakestr=strcat('Plotted Lake-',num2str(LakeName));
            fprintf(fid,'%s\n',lakestr);
        catch
            iskip=iskip+1;
            if(goodfrac1>.70)% try to repair the polygon and then plot
                LakeLat2=LakeLat;
                LakeLon2=LakeLon;
                for kk=1:numpts
                    if(LakeLon2(1,kk)<=westEdge1)
                        LakeLon2(1,kk)=westEdge1+.001;
                    end
                    if(LakeLon2(1,kk)>=eastEdge1)
                        LakeLon2(1,kk)=eastEdge1-0.001;
                    end
                    if(LakeLat2(1,kk)<=southEdge1)
                        LakeLat2(1,kk)=southEdge1+.001;
                    end
                    if(LakeLat2(1,kk)>=northEdge1)
                        LakeLat2(1,kk)=northEdge1-.001;
                    end                                       
                end
                [xin2,yin2,Ind2]=Inside(XB,YB,LakeLon2,LakeLat2);
                A2=isnan(LakeLat2);
                numnan2=sum(A2);
                numin2=length(xin2);
                numtot2=length(LakeLon2);
                numout2=numtot2-numin2-numnan2;
                goodfrac2=numin2/numtot2;
                try
                    %hL(4)=patchm(LakeLat2,LakeLon2,'c','DisplayName','Lakes');
                    hL(4)=patchm(LakeLat,LakeLon,'FaceColor',brightblue,...
                    'EdgeColor',brightblue,'FaceAlpha',1,'DisplayName','Lakes');
                    ilakeplotted=ilakeplotted+1;
                    irestore=irestore+1;
                catch
                    
                end
            end
        end
    end
    waitbar(nx/numlakes2);
end
close(h);
elapsed_time9=toc;
TimeCounter{9,2}=elapsed_time9;
elapsed_time10=0;
TimeCounter{10,2}=elapsed_time10;
% Plot the airports
tic;
eval(['cd ' USshapefilepath(1:length(USshapefilepath)-1)]);
shapefilename=char(USAStatesShapeFileList{imatch,8});
S3=shaperead(shapefilename,'UseGeoCoords',true);
ab=3;
numpts=length(S3);
AirportLats=zeros(numpts,1);
AirportLons=zeros(numpts,1);
for n=1:numpts
    AirportLats(n,1)=S3(n).Lat;
    AirportLons(n,1)=S3(n).Lon;
end
% Now sort in order of latitude
[ihit1]=find(AirportLats>= southEdge1 & AirportLats<=northEdge1);
numhit1=length(ihit1);
[ihit2]=find(AirportLons>= westEdge1 & AirportLons<=eastEdge1);
numhit2=length(ihit2);
Lia=ismember(ihit1,ihit2);
numcommon=sum(Lia);
nsearch=max(numhit1,numhit2);
[nsearch,ncols2]=size(Lia);
indc=zeros(numcommon,1);
ictr=0;
for n=1:nsearch
    if(Lia(n)>0)
        ictr=ictr+1;
        if(numhit1>=numhit2)
            indc(ictr,1)=ihit1(n,1);
        else
            indc(ictr,1)=ihit2(n,1);
        end
    end
end
airportstr=strcat('Plotting Airports From file-',shapefilename);
fprintf(fid,'%s\n',airportstr);
waitstr=strcat('Plotting Airports-',RemoveUnderScores(shapefilename));
h=waitbar(0,waitstr);
for n=1:numcommon
    nx=indc(n,1);
    nowName=char(S3(nx).NAME);
    a1=strfind(nowName,'Airport');
    a2=isempty(a1);
    a3=strfind(nowName,'Aerodrome');
    a4=isempty(a3);
    if((a2==0) && (a4==0))
        AirportLat=S3(nx).Lat;
        AirportLon=S3(nx).Lon;
        sz=48;
        hL(6)=scatterm(AirportLat,AirportLon,sz,'d','MarkerEdgeColor',[1 1 1],...
            'MarkerFaceColor',orange,'DisplayName','Airports');
        airportstr2=strcat('Added Airport-',nowName,'-to map');
        fprintf(fid,'%s\n',airportstr2);
    end
    waitbar(n/numcommon);
end
close(h);  
elapsed_time11=toc;
TimeCounter{11,2}=elapsed_time11;
clear S3
% Now plot mountain peaks
eval(['cd ' USshapefilepath(1:length(USshapefilepath)-1)]);
shapefilename=char(USAStatesShapeFileList{imatch,10});
S4=shaperead(shapefilename,'UseGeoCoords',true);
numpts=length(S4);
mountainstr1=strcat('Read Mountain data from shapefile-',shapefilename,...
    '-total peaks on file=',num2str(numpts));
fprintf(fid,'%s\n',mountainstr1);
MountainPeaks=zeros(numpts,3);
PeakLats=zeros(numpts,1);
PeakLons=zeros(numpts,1);
for n=1:numpts
    MountainPeaks(n,1)=S4(n).Lat;
    MountainPeaks(n,2)=S4(n).Lon;
    PeakLats(n,1)=S4(n).Lat;
    PeakLons(n,1)=S4(n).Lon;
    try
        PeakHeight=S4(n).Height;
    catch
        PeakHeight=S4(n).Height1;
    end
    MountainPeaks(n,3)=PeakHeight;
end
% get the number of peaks at least 200 meters high
[ihigh]=find(MountainPeaks(:,3)>200);
numhigh=length(ihigh);
a1=isempty(ihigh);
if(a1==1)
    numhigh=0;
end
highpeaksstr1=strcat('Number of peaks over 200 meters=',num2str(numhigh));
fprintf(fid,'%s\n',highpeaksstr1);
if(numhigh>0)
% Now sort in order of latitude
    [ihit1]=find(PeakLats>= southEdge1 & PeakLats<=northEdge1);
    numhit1=length(ihit1);
    [ihit2]=find(PeakLons>= westEdge1 & PeakLons<=eastEdge1);
    numhit2=length(ihit2);
    Lia=ismember(ihit1,ihit2);
    numcommon=sum(Lia);
    nsearch=min(numhit1,numhit2);
    indc=zeros(numcommon,1);
    ictr=0;
    for n=1:nsearch
        if(Lia(n)>0)
            ictr=ictr+1;
            if(numhit1>=numhit2)
                indc(ictr,1)=ihit1(n,1);
            else
                indc(ictr,1)=ihit2(n,1);
            end
        end
    end
    indclen=length(indc);
    tic;
    waitstr=strcat('Plotting Mountain Peaks-',RemoveUnderScores(shapefilename));
    h=waitbar(0,waitstr);
    if(numpts>400)
        numpeaks=400;
    else
        numpeaks=numpts;
    end
    peakstr1=strcat('Number of peaks to plot-',num2str(numcommon),'-indclen=',num2str(indclen));
    fprintf(fid,'%s\n',peakstr1);
% Now eliminate values of indc that are zero or less
    [ibig]=find(indc>0);
    numbig=length(ibig);
    for n=1:numbig
        nx=indc(n,1);
        peakstr2=strcat('n=',num2str(n),'nx=',num2str(nx));
        fprintf(fid,'%s\n',peakstr2);
        PeakName=char(S4(nx).ShortName);
        PeakLat=S4(nx).Lat;
        PeakLon=S4(nx).Lon;
        try
            PeakHeight=S4(nx).Height;
        catch
            PeakHeight=S4(nx).Height1;
        end
        sz=36;
        hL(7)=scatterm(PeakLat,PeakLon,sz,'x','MarkerEdgeColor',orange,...
                'MarkerFaceColor',orange,'DisplayName','Mountain');
        mountainstr2=strcat('Added Peak-',PeakName,'-to map at Lat=',num2str(PeakLat),...
            '-Lon',num2str(PeakLon),'-with height of-',num2str(PeakHeight));
        fprintf(fid,'%s\n',mountainstr2);
        incy=.02;
        incx=.02;
        delyN=abs(northEdge1-PeakLat);
        delyS=abs(PeakLat-southEdge1);
        delxW=abs(PeakLon-westEdge1);
        delxE=abs(PeakLon-eastEdge1);
        if(delyN<delyS)
            incy=-incy;
        end
        if(delxE<delxW)
            incx=-incx;
        end
        if(PeakHeight>3000)
            textm(PeakLat+incy,PeakLon+incx,PeakName,'Color',[1 1 1],'FontSize',8,'FontWeight','bold')
        elseif((PeakHeight>1500) && (mod(n,4)==0))
            textm(PeakLat+incy,PeakLon+incx,PeakName,'Color',[1 1 1],'FontSize',8,'FontWeight','bold')
        end
        waitbar(n/numbig);
    
    end
    close(h); 
    elapsed_time12=toc;
else
    elapsed_time12=0;
end

TimeCounter{12,2}=elapsed_time12;
% Now plot the BullsEye on the selected Fire
for m=1:iBullsEye
    iBullRadius=iBullsEyeStart+(m-1)*iBullsEyeInc;
    [latc,longc] = scircle1(LatC,LonC,iBullRadius,[],earthRadius('km'));
    plotm(latc,longc,'r-.','LineWidth',2);
end
clear S4
% Now add urban areas
clear S1
tic;
eval(['cd ' USshapefilepath(1:length(USshapefilepath)-1)]);
S1=shaperead(UrbanAreasShapeFile,'UseGeoCoords',true);
citystr1=strcat('Read City Data from file-',shapefilename);
fprintf(fid,'%s\n',citystr1);
numrecords=length(S1);
waitstr=strcat('Plotting Cities-',RemoveUnderScores(UrbanAreasShapeFile));
h=waitbar(0,waitstr);
numurban=0;
icitycount=0;
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
        try
            hL(8)=patchm(CityLat,CityLon,'y','FaceAlpha',1,'DisplayName','UrbanAreas');
            icitycount=icitycount+1;
            citystr2=strcat('Added City-',CityName,'-to map');
            fprintf(fid,'%s\n',citystr2);
            if(ALAND10>1E8)
                medLat=median(CityLat,'omitnan');
                medLon=median(CityLon,'omitnan');
                textm(medLat+.02,medLon+.02,CityName,'Color',[1 1 1],'FontSize',8,'FontWeight','bold');
            elseif(icitycount<10)
                medLat=median(CityLat,'omitnan');
                medLon=median(CityLon,'omitnan');
                textm(medLat+.02,medLon+.02,CityName,'Color',[1 1 1],'FontSize',8,'FontWeight','bold');
            end
        catch
            
        end
        numurban=numurban+1;
        waitbar(n/numrecords);
    end
end
elapsed_time13=toc;
close(h);
TimeCounter{13,2}=elapsed_time6;
hold off
scalebarlen=30;
scalebarloc='se';
scalebar('length',scalebarlen,'units','mi','color',bubblegum,'location',scalebarloc,'fontangle','bold','RulerStyle','patches');
ArrowLat=northEdge1-0.1;
ArrowLon=eastEdge1+0.3;
northarrow('latitude',ArrowLat,'longitude',ArrowLon);
harrow=handlem('NorthArrow');
set(harrow,'FaceColor',[1 1 0],'EdgeColor',[1 0 0]);
try
    hll=legend(hL,'location','southeastoutside');
    set(hll,'Color',[0.7 0.7 0.7])
catch
    ab=1;
end
titlestr=RemoveUnderScores(titlestr);
ht=title(titlestr);
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
% Now write out the details on the selected fire
tx5=.01;
ty5=.30;
txtstr5='Selected Fire Data';
txt5=text(tx5,ty5,txtstr5,'FontWeight','bold','FontSize',8);
tx6=.01;
ty6=.27;
txtstr6=strcat('Lat=',num2str(LatC,4));
txt6=text(tx6,ty6,txtstr6,'FontWeight','bold','FontSize',8);
tx7=.01;
ty7=.24;
txtstr7=strcat('Lon=',num2str(LonC,4));
txt7=text(tx7,ty7,txtstr7,'FontWeight','bold','FontSize',8);
tx8=.01;
ty8=.21;
txtstr8=strcat('Temp=',num2str(TempC,4));
txt8=text(tx8,ty8,txtstr8,'FontWeight','bold','FontSize',8);
tx9=.01;
ty9=.18;
txtstr9=strcat('Area=',num2str(AreaC,4));
txt9=text(tx9,ty9,txtstr9,'FontWeight','bold','FontSize',8);
tx10=.01;
ty10=.15;
txtstr10=strcat('Alt=',num2str(FireHeight));
txt10=text(tx10,ty10,txtstr10,'FontWeight','bold','FontSize',8);
tx11=.01;
ty11=.12;
txtstr11=strcat('County-',FireCounty);
txt11=text(tx11,ty11,txtstr11,'FontWeight','bold','FontSize',8);
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
% Sum all the times
sum_time=elapsed_time1 + elapsed_time2 + elapsed_time3 + elapsed_time4;
sum_time=sum_time + elapsed_time5 + elapsed_time6 + elapsed_time7 + elapsed_time8;
sum_time=sum_time + elapsed_time9 + elapsed_time10 + elapsed_time11 + elapsed_time12;
sum_time=sum_time + elapsed_time13;
TimeCounter{14,2}=sum_time;
disp('Run Time Values For Creating This map');
T=cell2table(TimeCounter);

disp(T);
fprintf(fid,'\n');

fprintf(fid,'%s\n','*************** Run Time Summary *************');
[nrows,ncols]=size(TimeCounter);
for k=1:nrows
    str1=char(TimeCounter{k,1});
    etime=TimeCounter{k,2};
    TimeCounter{k,2}=num2str(etime,5);
    timestr=strcat(str1,'-',num2str(etime),'-sec');
    fprintf(fid,'%s\n',timestr);
end
warning('on')
fprintf(fid,'%s\n','*************** End Run Time Summary For Detailed 3D FireHot Spots *************');
fprintf(fid,'%s\n','////// Finished Executing Routine DisplayDetailed3DFireHotSpotsRev1.m //////');
if((iCreatePDFReport==1) && (RptGenPresent==1))
    [ibreak]=strfind(GOESFileName,'_e');
    is=1;
    ie=ibreak(1)-1;
    add(chapter,Section('Detailed Hot Spot Geography'));
    GOESShortFileName=GOESFileName(is:ie);
    imdata = imread(figstr2);
    [nhigh,nwid,ndepth]=size(imdata);
    image = mlreportgen.report.FormalImage();
    image.Image = which(figstr2);
    pdftxtstr=strcat('Hot Spot Detailed Location For File-',GOESShortFileName);
    pdftext = Text(pdftxtstr);
    pdftext.Color = 'red';
    image.Caption = pdftext;
    nhighs=floor(nhigh/2.4);
    nwids=floor(nwid/2.4);
    heightstr=strcat(num2str(nhighs),'px');
    widthstr=strcat(num2str(nwids),'px');
    image.Height = heightstr;
    image.Width = widthstr;
    image.ScaleToFit=0;
    add(chapter,image);
    br = PageBreak();
    add(chapter,br);
    parastr1='This image above provides a detailed view of a 1 deg x 1 deg area contaning the user selected Hot Spot.';
    parastr2=strcat('The image was created using a Digital Elevation Map taken from the file-',dtedfile,'-which is a level 1 mapping.');
    parastr2a='Level 1 dted files typically have a resolution of about 90 meters.';
    parastr3='The colorbar at the right side of the image provides the height in meters.';
    parastr4='Selected roads,urban areas,lakes and airports are also depicted along with the bullseye centered on the hot spot itself.';
    parastr5='Note that the DEM files are not perfect, and can contain some data gaps which can be quite evident in some datasets.';
    parastr6=strcat(parastr1,parastr2,parastr2a,parastr3,parastr4,parastr5);
    p7 = Paragraph(parastr6);
    p7.Style = {OuterMargin("0pt", "0pt","10pt","10pt")};
    add(chapter,p7);
    % Create a Run Time Table
    tbl_header = {'Item' 'Run Time-sec'};
    T3=[tbl_header;TimeCounter];
    tbl3=Table(T3);
    tbl3.Style = [tbl3.Style {Border('solid','black','3px')}];
    tbl3.HAlign='center';
    tbl3.ColSep = 'single';
    tbl3.RowSep = 'single';
    r = row(tbl3,1);
    r.Style = [r.Style {Color('red'),Bold(true)}];
    bt3 = BaseTable(tbl3);
    tabletitle = Text('Detailed Map Creation Feature Times');
    tabletitle.Bold = false;
    bt3.Title = tabletitle;
    bt3.TableWidth="7in";
    add(chapter,bt3);
    add(rpt,chapter);
    close('all');

end


