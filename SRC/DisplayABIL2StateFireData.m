function DisplayABIL2StateFireData(FireLats,FireLons,FireHotValues,itype,fireState,fireStateFP,indx,titlestr)
% Display various types of fire data for the ABI-L2-FireData set
% obtains from GOES-16. The plot symbols change color and size based on
% the magnitude of FireHotValues. The symbols are plotted in increasing
% order of the FireHotValues so the most important data is not obscured
% The scale is this map is roughly state sized
% Written By: Stephen Forczyk
% Created: Sept 27,2020
% Revised: Sept 30,2020 made changes to load in state files based on
% selected fire chosen for plotting
% Revised: Oct 2,2020 added separate colors for each county as well as
%          plotting state roads,city limits and lakes as well
%          as scale bar and north arrow  
% Revised: Oct 29,2020 made changes to vary the logo size according to the
%          actual map diemnsions to assure that the logo occupies a
%          relatively constant number of pixels in the latitude dimension
% Revised: Jan 9,2021 Added code to Create PDF Content
% Revised: Jan 10,2021 added code to create a table in the PDF report
% Revised: Jan 15,2021 added code to create TOC entries in PDF report
% Classification: Unclassified

global imatchState;

global xImgS xImgBS SatDataS GeoSpatialS;
global ReflectanceS AlgoS ErrorS EarthSunS VersionContainerS;
global GoesWaveBand ESunS kappa0S PlanckS FocalPlaneS;
global GOESFileName OutlierPS CloudTopTS LZAS LZABS SZAS SZABS;
global TempS Algo2S ProcessParamTS AlgoProductTS Error1S CloudPixelsS;
global WaterPrelimFeatures WaterFinalFeatures WaterSortedFeatures;
global RptGenPresent iCreatePDFReport pdffilename rpt chapter tocc;
global JpegCounter JpegFileList;

global ProcessParamVersionContainerS GOESFileName FireDetails;
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
global orange bubblegum brown brightblue;
global iPrimeRoads iCountyRoads iCommonRoads iStateRecRoads iUSRoads iStateRoads;
global iLakes FlagSelections FlagSelections2;

global widd2 lend2;
global initialtimestr igrid ijpeg ilog imovie;
global vert1 hor1 widd lend;
global vert2 hor2 machine;
global chart_time;
global Fz1 Fz2 fid;
global idirector mov izoom iwindow;
global matpath GOES16path;
global jpegpath ;
global smhrpath excelpath ascpath nationalshapepath;
global ipowerpoint PowerPointFile scaling stretching padding;
global ichartnum;
global ColorList RGBVals ColorList2 xkcdVals LandColors;
% additional paths needed for mapping
global matpath1 mappath tiffpath;
global canadapath stateshapepath topopath;
global trajpath militarypath;
global figpath screencapturepath USshapefilepath;
global shapepath2 countrypath countryshapepath usstateboundariespath;
global GOES16Band1path GOES16Band2path GOES16Band3path GOES16Band4path;
global GOES16Band5path GOES16Band6path GOES16Band7path GOES16Band8path
global GOES16Band9path GOES16Band10path GOES16Band11path GOES16Band12path;
global GOES16Band13path GOES16Band14path GOES16Band15path GOES16Band16path;
global figpath;
global GOES16CloudTopHeightpath shapefilepath;
USshapefilepath='D:\Forczyk\Map_Data\USStateShapeFiles\';
TimeCounter=cell(7,2);
TimeCounter{1,1}='Time To Plot Rivers';
TimeCounter{2,1}='Time To Plot Countries';
TimeCounter{3,1}='Time to Plot Counties';
TimeCounter{4,1}='Time To Plot Primary Roads';
TimeCounter{5,1}='Time To Plot State Roads';
TimeCounter{6,1}='Time To Plot City Areas';
TimeCounter{7,1}='Time To Plot Lakes';
TimeCounter{8,1}='Total Plot Time';
if((iCreatePDFReport==1) && (RptGenPresent==1))
    import mlreportgen.dom.*;
    import mlreportgen.report.*;
end
warning('off')
disp('Start making State LevelFire Hot Spot map');
fprintf(fid,'%s\n','Start making Sate LevelFire Hot Spot map');
jpegstr=strcat('Jpeg file written to path-',jpegpath);
fprintf(fid,'%s\n',jpegstr);
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
MLineVal=1;
PLineVal=1;
numdiv=60;
numMdiv=abs(westEdge1-eastEdge1)/MLineVal;
if(numMdiv>8)
    MLineVal=2;
end
% Set up the map axis
set(gcf,'Position',[hor1 vert1 widd lend])
set(gcf,'MenuBar','none');
h1=axesm('mercator','Frame','on','Grid','on','MapLatLimit',[southEdge1 northEdge1],...
    'MapLonLimit',[westEdge1 eastEdge1],'meridianlabel','on','parallellabel','on','plabellocation',1,'mlabellocation',MLineVal,...
    'MLabelParallel','south','MLineLocation',1,'PLineLocation',1);
MidMapLon=(westEdge1+eastEdge1)/2;
MidMapLat=(southEdge1+northEdge1)/2;
XB=[westEdge1 eastEdge1 eastEdge1 westEdge1 westEdge1];
YB=[southEdge1 southEdge1 northEdge1 northEdge1 southEdge1];
numdiv=50;
igo=1;
InnerPos=get(h1,'InnerPosition');
widd3=InnerPos(1,3);
lend3=InnerPos(1,4);
ictr=0;
while igo>0
    logosizelat=abs(northEdge1-southEdge1)/numdiv;
    logosizelon=abs(westEdge1-eastEdge1)/numdiv;
    logosizeinc=min(logosizelat,logosizelon);
    lonext=abs(eastEdge1-westEdge1);
    latext=abs(northEdge1-southEdge1);
    latfrac=logosizelat/abs(northEdge1-southEdge1);
    logostr1=strcat('Logo size lon=',num2str(logosizelon,5));
    logostr2=strcat('Logo size lat=',num2str(logosizelat,5));
    logostr3=strcat('Selected logisizeinc=',num2str(logosizeinc,6));
    latfrac=logosizelat/abs(northEdge1-southEdge1);
    logostr4=strcat('logolatfrac=',num2str(latfrac,6));
    lonext=abs(eastEdge1-westEdge1);
    latext=abs(northEdge1-southEdge1);
    lonpixperdeg=widd3*widd/lonext;
    latpixperdeg=lend3*lend/latext;
    logolatpixextent=latpixperdeg*logosizelat;
    fprintf(fid,'\n');
    fprintf(fid,'%s\n','----- Logo size calculations-----');
    fprintf(fid,'%s\n',logostr1);
    fprintf(fid,'%s\n',logostr2);
    fprintf(fid,'%s\n',logostr3);
    fprintf(fid,'%s\n',logostr4);
    extstr=strcat('lonpixperdeg=',num2str(lonpixperdeg,6),'-latpixperdeg=',...
        num2str(latpixperdeg,6));
    fprintf(fid,'%s\n',extstr);
    mapaxisstr=strcat('widd3=',num2str(widd3),'-lend3=',num2str(lend3));
    fprintf(fid,'%s\n',mapaxisstr);
    logostr5=strcat('Logo lat size in pixels=',num2str(logolatpixextent,5));
    fprintf(fid,'%s\n',logostr5);
    fprintf(fid,'\n');
    mapstr1=strcat('Map Limits-west =',num2str(westEdge1,4),'-east =',num2str(eastEdge1,4));
    mapstr2=strcat('Map Limits-north =',num2str(northEdge1,4),'-south =',num2str(southEdge1,4));
    fprintf(fid,'%s\n',mapstr1);
    fprintf(fid,'%s\n',mapstr2);
    ictr=ictr+1;
    if ((logolatpixextent>10) && (logolatpixextent<15))
        igo=0;
        passedstr1=strcat('Final logolatpixextent=',num2str(logolatpixextent,5),...
            '-numdiv=',num2str(numdiv));
        fprintf(fid,'%s\n',passedstr1);
    elseif(logolatpixextent>=15)
        numdiv=numdiv+2;
        failedstr1=strcat('Failed big logolatpixextent=',num2str(logolatpixextent,5),...
            '-new numdiv=',num2str(numdiv));
        fprintf(fid,'%s\n',failedstr1);
    elseif(logolatpixextent<=10)
        numdiv=numdiv-2;
        failedstr2=strcat('Failed small logolatpixextent=',num2str(logolatpixextent,5),...
            '-new numdiv=',num2str(numdiv));
        fprintf(fid,'%s\n',failedstr2);
    end
    if(ictr>20)
        igo=0;
    end
end
hold on
tightmap;
tic;
elapsed_time2=0;
TimeCounter{2,2}=elapsed_time2;
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
imatch=imatchState;
shapefilename=char(USAStatesShapeFileList{imatch,6});
S1=shaperead(shapefilename,'UseGeoCoords',true);
numrecords=length(S1);
% Get the quick list of roads by type
RTTYP=cell(numrecords,1);
RTTYPNUM=zeros(numrecords,1);
RTTYPLen=zeros(numrecords,1);
RTTYPCTS=zeros(6,1);
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
        RTTYPCTS(1,1)=RTTYPCTS(1,1)+1;
    elseif(a2==1)
        RTTYPNUM(n,1)=2;
        RTTYPCTS(2,1)=RTTYPCTS(2,1)+1;
    elseif(a3==1)
        RTTYPNUM(n,1)=3;
        RTTYPCTS(3,1)=RTTYPCTS(3,1)+1;
    elseif(a4==1)
        RTTYPNUM(n,1)=4;
        RTTYPCTS(4,1)=RTTYPCTS(4,1)+1;
    elseif(a5==1)
        RTTYPNUM(n,1)=5;
        RTTYPCTS(5,1)=RTTYPCTS(5,1)+1;
    else
        RTTYPNUM(n,1)=6;
        RTTYPCTS(6,1)=RTTYPCTS(6,1)+1;
    end
end
fprintf(fid,'\n');
fprintf(fid,'%s\n','-Distribution of road types');
rdstr1=strcat('Road Type C had-',num2str(RTTYPCTS(1,1)),'-cases');
fprintf(fid,'%s\n',rdstr1);
rdstr2=strcat('Road Type I had-',num2str(RTTYPCTS(2,1)),'-cases');
fprintf(fid,'%s\n',rdstr2);
rdstr3=strcat('Road Type M had-',num2str(RTTYPCTS(3,1)),'-cases');
fprintf(fid,'%s\n',rdstr3);
rdstr4=strcat('Road Type O had-',num2str(RTTYPCTS(4,1)),'-cases');
fprintf(fid,'%s\n',rdstr4);
rdstr5=strcat('Road Type S had-',num2str(RTTYPCTS(5,1)),'-cases');
fprintf(fid,'%s\n',rdstr5);
rdstr6=strcat('Road Type U had-',num2str(RTTYPCTS(6,1)),'-cases');
fprintf(fid,'%s\n',rdstr6);
fprintf(fid,'\n');
uniqueRoads=unique(RTTYP);
numuniqueRoads=length(uniqueRoads);
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
    if(numstateroads<100)
        maxplot=numstateroads;
    elseif((numstateroads>=100) && (numstateroads<=400))
        maxplot=100+round(0.4*(numstateroads-100));
    elseif(numstateroads>400)
        maxplot=220+round(0.25*(numstateroads-220));
    end
    if(iStateRoads==0)
        maxplot=1;
    end
    roadstr1=strcat('Total State Roads=',num2str(numstateroads),'-maxplot=',num2str(maxplot));
    fprintf(fid,'%s\n',roadstr1);
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
        hL(1)=plotm(RoadLat,RoadLon,'Color',orange,'LineWidth',2,'DisplayName','State Roads');
        waitbar(n/maxplot);
        if(n>=maxplot)
            igo=0;
        end
    end
    close(h);
    elapsed_time5=toc;
TimeCounter{5,2}=elapsed_time5;
%tiffpath='D:\Forczyk\Map_Data\InterstateSigns\';
tic;
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
fprintf(fid,'%s\n','Unique Interstates Follow');
for n=1:numUniqueInterStates
    UniqueInterStateList{n,1}=UniqueInterStates{n,1};
    UniqueInterStateList{n,2}=0;
    UniqueInterStateList{n,3}=[];
    UniqueInterStateList{n,4}=0;
    instatestr=strcat('UniqueInterstate-',num2str(n),'-',UniqueInterStates{n,1});
    fprintf(fid,'%s\n',instatestr);
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
% Loop over the unique interstate list one more time to prevent logos being
% written for routes that have additional qualifiers for the interstate
% name 
       for jj=1:numUniqueInterStates
           nowCompareInterState= char(UniqueInterStateList{jj,1});
           nowlen=length(nowCompareInterState);
           is=nowlen;
           ie=nowlen;
           lastchar=nowCompareInterState(is:ie);
           lastdbl=double(lastchar);
           if((lastdbl<48) || (lastdbl>57))
               UniqueInterStateList{jj,4}=1;
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
    numpts=length(RoadLat);
    hL(2)= plotm(RoadLat,RoadLon,'g','LineWidth',2,'DisplayName','Interstates');
    waitbar(n/numinterstates);
    if(n>=maxplot)
        igo=0;
    end
    RoadCtrLat=mean(RoadLat,'omitnan')-logosizeinc/2;
    RoadCtrLon=mean(RoadLon,'omitnan')+logosizeinc/2;
    [xin,yin,Ind]=Inside(XB,YB,RoadCtrLon,RoadCtrLat);
    a1=isempty(xin);
    if((a1==0) && (alreadylabelled==0) && (kmatchinter>0))
        tiffname=char(UniqueInterStateList{kmatchinter,3});
        eval(['cd ' tiffpath(1:length(tiffpath)-1)]);
        latlim = [(RoadCtrLat-logosizeinc) (RoadCtrLat+logosizeinc)];
        lonlim = [(RoadCtrLon-logosizeinc) (RoadCtrLon+logosizeinc)];
        info=imfinfo(tiffname);
        rasterSize = [info.Width info.Height];
        Rpix = georefcells(latlim,lonlim,rasterSize,'ColumnsStartFrom','north');
        RGB = imread(tiffname);
        geoshow(RGB,Rpix);
        UniqueInterStateList{kmatchinter,4}=1;
        dispstr=strcat('Displayed Logo-',tiffname,'-at Lat=',num2str(RoadCtrLat),...
            '-Lon=',num2str(RoadCtrLon),'-taken from record-',num2str(ind2),'-for RoadName=',...
            RoadName);
        fprintf(fid,'%s\n',dispstr);
        disp(dispstr);
        ilogo=ilogo+1;
    end
end
close(h);
elapsed_time4=toc;
TimeCounter{4,2}=elapsed_time4;
dispstr=strcat('Time required to plot all interstates=',num2str(elapsed_time4),'-sec');
disp(dispstr)
% Now add urban areas
clear S1
tic;
eval(['cd ' USshapefilepath(1:length(USshapefilepath)-1)]);
S1=shaperead(UrbanAreasShapeFile,'UseGeoCoords',true);
numrecords=length(S1);
citystr1=strcat('Total Cities=',num2str(numrecords),'-on shapefile-',UrbanAreasShapeFile);
fprintf(fid,'%s\n',citystr1);
CityData=zeros(numrecords,1);
numinstate=0;
for n=1:numrecords
    stateFIP=S1(n).StateFIPS;
    if(stateFIP==fireStateFP)
        numinstate=numinstate+1;
    end
end
CityData=zeros(numinstate,4);
indp=0;
for n=1:numrecords
    stateFIP=S1(n).StateFIPS;
    if(stateFIP==fireStateFP)
        indp=indp+1;
        CityName=char(S1(n).CityName);
        CityData(indp,1)=length(S1(n).Lon);
        CityData(indp,2)=S1(n).ALAND10;
        CityData(indp,3)=stateFIP;
        CityData(indp,4)=n;
        citystr3=strcat('Instate City#',num2str(indp),'-City Name-',CityName,'-stateFIP=',...
            num2str(stateFIP),'-n=',num2str(n));
        fprintf(fid,'%s\n',citystr3);
    end
end
% Now make a smaller list if just the in-state cities dorted in descending
% order of size

[SortedCities,indc]=sort(CityData(:,1),'descend');
numinstate=length(indc);
fprintf(fid,'%s\n','In-State Cities in Descending size order-');

for nx=1:numinstate
    nx2=indc(nx);
    n=CityData(nx2,4);
    CityName=char(S1(n).CityName);
    citylen=length(S1(n).Lon);
    cityarea=S1(n).ALAND10;
    STATEFP=(S1(n).StateFIPS);
    citystr4=strcat('Sorted Instate City#',num2str(nx),'-City Name-',CityName,...
        '-Citylen=',num2str(citylen),'-CityArea=',num2str(cityarea),'-stateFIP=',num2str(STATEFP),...
        '-n=',num2str(n));
    fprintf(fid,'%s\n',citystr4);
end
waitstr=strcat('Plotting Cities-',RemoveUnderScores(UrbanAreasShapeFile));
h=waitbar(0,waitstr);
numurban=0;
if(numinstate>20)
    numinstatep=20;
else
    numinstatep=numinstate;
end
for nx=1:numinstatep
    nx2=indc(nx);
    n=CityData(nx2,4);
    STATEFP=(S1(n).StateFIPS);
    CityName=char(S1(n).CityName);
    Citynamelen=length(CityName);
    if(Citynamelen>12)
        CityName=CityName(1:12);
    end
    if(STATEFP==fireStateFP)
        CityLat=S1(n).Lat;
        CityLon=S1(n).Lon;
        numpts=length(CityLat);
        hL(3)=patchm(CityLat,CityLon,'y','DisplayName','UrbanAreas');
        medLat=median(CityLat,'omitnan');
        medLon=median(CityLon,'omitnan');
        textm(medLat+.1,medLon+.1,CityName,'Color',[1 0 0],'FontSize',8,'FontWeight','bold');
        numurban=numurban+1;
        citystr2=strcat('Plotted city-',num2str(nx),'-named-',CityName);
        fprintf(fid,'%s\n',citystr2);
        waitbar(n/numinstatep);
    end
end
elapsed_time6=toc;
close(h);
TimeCounter{6,2}=elapsed_time6;
% Now plot lakes
% Select the correct State_water.shp file
tic
shapefilename=char(USAStatesShapeFileList{imatchState,9});
waitstr=strcat('Plotting Lakes-',RemoveUnderScores(shapefilename));
h=waitbar(0,waitstr);
S2=shaperead(shapefilename,'UseGeoCoords',true);
numallwater=length(S2);
numwater=numallwater;
if(iLakes==0)
    numwater=5;
end
% make a list of those water features that are defined but with the 'water'
% designator and a name
WaterPrelimFeatures=cell(numwater,3);
ind=0;
for n=1:numallwater
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
[WaterSortedFeatures,indxl]=sort(WaterFinalFeatures(:,2),'descend');
iskip=0;
ilakeplotted=0;
irestore=0;
if((iLakes==0) && (numlakes>10))
    numlakes=10;
end
numlakes2=round(numlakes/4);
if(numlakes2>300)
    numlakes2=300;
end
maxplot=numlakes2;
lakestr1=strcat('Total Lakes=',num2str(numlakes),'-maxplot=',num2str(maxplot));
fprintf(fid,'%s\n',lakestr1);
for nx=1:numlakes2
    nxx=indxl(nx,1);
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
elapsed_time7=toc;
TimeCounter{7,2}=elapsed_time7;
% Plot the fire hot spot locations
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
% Now plot the BullsEye on the selected Fire
LatC=FireLats(indx,1);
LonC=FireLons(indx,1);
TempC=FireDetails{indx+1,5};
AreaC=FireDetails{indx+1,6};
FireState=FireDetails{indx+1,1};
FireCounty=char(FireDetails{indx+1,2});
latext=abs(northEdge1-southEdge1);
if(latext<8)
    iBullsEye=3;
    iBullsEyeStart=10;
    iBullsEyeInc=10;
elseif(latext>=8)
    iBullsEye=5;
    iBullsEyeStart=20;
    iBullsEyeInc=20;
end
LatC=FireLats(indx,1);
LonC=FireLons(indx,1);
for m=1:iBullsEye
    iBullRadius=iBullsEyeStart+(m-1)*iBullsEyeInc;
    [latc,longc] = scircle1(LatC,LonC,iBullRadius,[],earthRadius('km'));
    plotm(latc,longc,'r-.','LineWidth',2);
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
try
    hll=legend(hL,'location','southeastoutside');
    set(hll,'Color',[0.7 0.7 0.7])
catch
    ab=1;
end
%set(hll,'Color',[0.7 0.7 0.7])
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
dispstr=strcat('Saved Image To File-',figstr,'-at location-',jpegpath);
disp(dispstr)
disp('Run Time Values For Creating This map');
TimeCounter{8,2}=TimeCounter{1,2}+TimeCounter{2,2}+TimeCounter{3,2}+TimeCounter{4,2}...
    +TimeCounter{5,2}+TimeCounter{6,2}+TimeCounter{7,2};
TimeCounter{1,2}=num2str(TimeCounter{1,2},6);
TimeCounter{2,2}=num2str(TimeCounter{2,2},6);
TimeCounter{3,2}=num2str(TimeCounter{3,2},6);
TimeCounter{4,2}=num2str(TimeCounter{4,2},6);
TimeCounter{5,2}=num2str(TimeCounter{5,2},6);
TimeCounter{6,2}=num2str(TimeCounter{6,2},6);
TimeCounter{7,2}=num2str(TimeCounter{7,2},6);
TimeCounter{8,2}=num2str(TimeCounter{8,2},6);
T=cell2table(TimeCounter);
disp(T);
pause(chart_time);
% Make a table listing the Flag Selections
fprintf(fid,'%s\n','Finished making State Level Fire Hot Spot map');
fprintf(fid,'\n');
fprintf(fid,'%s\n','*************** Run Time Summary *************');
[nrows,ncols]=size(TimeCounter);
for k=1:nrows
    str1=char(TimeCounter{k,1});
    etime=TimeCounter{k,2};
    timestr=strcat(str1,'-',num2str(etime),'-sec');
    fprintf(fid,'%s\n',timestr);
end
if((iCreatePDFReport==1) && (RptGenPresent==1))
    [ibreak]=strfind(GOESFileName,'_e');
    is=1;
    ie=ibreak(1)-1;
    GOESShortFileName=GOESFileName(is:ie);
    add(chapter,Section('State Level Hot Spots'));
    imdata = imread(figstr2);
    [nhigh,nwid,ndepth]=size(imdata);
    image = mlreportgen.report.FormalImage();
    image.Image = which(figstr2);
    pdftxtstr=strcat('Hot Spots For File-',GOESShortFileName);
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
    parastr10='The Data for this chart was from file-';
    parastr11=strcat(parastr10,GOESFileName,'.');
    parastr12=strcat(parastr10,parastr11);
    p4 = Paragraph(parastr12);
    p4.Style = {OuterMargin("0pt", "0pt","0pt","10pt")};
    add(chapter,p4);
    parastr13='The data plotted on this chart depicts a single, user selected "Hot Spot" on a state level map.';
    parastr14=strcat('The user selected fire is in the state of-',FireState,'-and County of-',FireCounty,'-with a max temp of-',...
        num2str(TempC,6),'-Deg-k.');
    parastr15='This map is feature rich in order to allow the user to see the location of hot spots in relation to signigficant geographic features.';
    parastr16='For example, the map displays the selected state with the individual counties color-coded for clarity.';
    parastr17='The user does have some control of the features to be plotted such as roads,river,lakes and cities.';
    parastr18='This feature was added because plotting all these items is quite time consuming so the user can selectively turn some features off.';
    parastr19='The actual hot spot detected by GOES is identified by a colored dot at the fire center and a set of concentric bullseye rings to provide a distance scale.';
    parastr20=strcat('The size of the bullseye is dependent on the latitude extent of the state,in this example there are-',num2str(iBullsEye),'-rings spaced-',...
        num2str(iBullsEyeInc),'-km apart.');
    parastr21=strcat(parastr13,parastr14,parastr15,parastr16,parastr17,parastr18,parastr19,parastr20);
    p5 = Paragraph(parastr21);
    p5.Style = {OuterMargin("0pt", "0pt","0pt","10pt")};
    add(chapter,p5);
    br = PageBreak();
    add(chapter,br);
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
    tabletitle = Text('Map Creation Feature Times');
    tabletitle.Bold = false;
    bt3.Title = tabletitle;
    bt3.TableWidth="7in";
    add(chapter,bt3);
    parastr25='This table shows how much time was used to plot the features listed above.';
    parastr26=strcat('Inspection of this table shows that the majority of the time required to plot the chart',...
        ' is taken up plotting the roads.');
    timeprimeroads=TimeCounter{4,2};
    timestateroads=TimeCounter{5,2};
    timeplot=char(TimeCounter(8,2));
    parastr27=strcat('For example,plotting the interstates required-',timeprimeroads,'-sec while the state roads took-',...
        timestateroads,'-and the total time for the plot was-',timeplot,'-seconds.');
    parastr28=strcat('In order to give precendence to key map features,the typical scheme applied was to create of list of the selected feature',...
        ' and then to created a list of just this feature and sort it in descending order of points available to map that feature and finally',...
        ' to apply a maximum number of items to this feature list to plot-if this approach is not adopted plot times would be excessive.');
    parastr29=strcat(parastr25,parastr26,parastr27,parastr28);
    p6 = Paragraph(parastr29);
    p6.Style = {OuterMargin("0pt", "0pt","10pt","10pt")};
    add(chapter,p6);
    FlagSelections=cell(6,4);
    FlagSelections{1,1}='iPrimeRoads';
    FlagSelections{1,2}=iPrimeRoads;
    FlagSelections{1,3}='Plot Interstates';
    FlagSelections{1,4}='All Up To 200';
    FlagSelections{2,1}='iCountyRoads';
    FlagSelections{2,2}=iCountyRoads';
    FlagSelections{2,3}='Plot County Roads';
    FlagSelections{2,4}='0 For this Map';
    FlagSelections{3,1}='iCommonRoads';
    FlagSelections{3,2}=iCommonRoads;
    FlagSelections{3,3}='Plot Common Roads';
    FlagSelections{3,4}='0 For this Map';
    FlagSelections{4,1}='iStateRecRoads';
    FlagSelections{4,2}=iStateRecRoads;
    FlagSelections{4,3}='Plot State Recognized Roads';
    FlagSelections{4,4}='0 For this Map';
    FlagSelections{5,1}='iUSRoads';
    FlagSelections{5,2}=iUSRoads;
    FlagSelections{5,3}='Plot Other State Roads';
    FlagSelections{5,4}='0 For this Map';
    FlagSelections{6,1}='iStateRoads';
    FlagSelections{6,2}=iStateRoads;
    FlagSelections{6,3}='Plot State Roads';
    FlagSelections{6,4}='All Up To 100';
    FlagSelections2=cell(7,4);
    FlagSelections2{1,1}='Flag';
    FlagSelections2{1,2}='Variable';
    FlagSelections2{1,3}='Purpose';
    FlagSelections2{1,4}='Initial Plot Limit';
    FlagSelections2{2,1}='iPrimeRoads';
    FlagSelections2{2,2}=iPrimeRoads;
    FlagSelections2{2,3}='Plot Interstates';
    FlagSelections2{2,4}='All Up To 200';
    FlagSelections2{3,1}='iCountyRoads';
    FlagSelections2{3,2}=iCountyRoads';
    FlagSelections2{3,3}='Plot County Roads';
    FlagSelections2{3,4}='0 For this Map';
    FlagSelections2{4,1}='iCommonRoads';
    FlagSelections2{4,2}=iCommonRoads;
    FlagSelections2{4,3}='Plot Common Roads';
    FlagSelections2{4,4}='0 For this Map';
    FlagSelections2{5,1}='iStateRecRoads';
    FlagSelections2{5,2}=iStateRecRoads;
    FlagSelections2{5,3}='Plot State Recognized Roads';
    FlagSelections2{5,4}='0 For this Map';
    FlagSelections2{6,1}='iUSRoads';
    FlagSelections2{6,2}=iUSRoads;
    FlagSelections2{6,3}='Plot Other State Roads';
    FlagSelections2{6,4}='0 For this Map';
    FlagSelections2{7,1}='iStateRoads';
    FlagSelections2{7,2}=iStateRoads;
    FlagSelections2{7,3}='Plot State Roads';
    FlagSelections2{7,4}='All Up To 100';
    tbl=Table(FlagSelections2);
    tbl.Style = [tbl.Style {Border('solid','black','3px')}];
    tbl.HAlign='center';
    tbl.ColSep = 'single';
    tbl.RowSep = 'single';
    r = row(tbl,1);
    r.Style = [r.Style {Color('red'),Bold(true)}];
    bt = BaseTable(tbl);
    tabletitle = Text('State Level Plot Flags');
    tabletitle.Bold = false;
    bt.Title = tabletitle;
    bt.TableWidth="7in";
    add(chapter,br);
    add(chapter, bt);
    parastr30='This table displays the settings used the state level plot of the Hot spot detected by GOES.';
    parastr31='The first column of the table lists the Flag Variable name,the second the current value for this flag,';
    parastr32='while the third column designates the feature controlled and the last column the initial plot limit.';
    parastr33='The value in column 4 provides the maximum value of fetures that can be plotted without skipping points,';
    parastr34='if more features than this type are in the sorted list then they will be subjected to a decimation feature-';
    parastr35='This has the effect of speeding up the plot and emphasizing the most important features.';
    parastr36=strcat(parastr30,parastr31,parastr32,parastr33,parastr34,parastr35);
    p7 = Paragraph(parastr36);
    p7.Style = {OuterMargin("0pt", "0pt","10pt","10pt")};
    add(chapter,p7);
end
close('all');
fprintf(fid,'%s\n','*************** End Run Time Summary State Level Fire Hot Spots *************');
fprintf(fid,'%s\n','////// Finished Executing Routine DisplayDetailed3DFireHotSpotsRev1.m //////');
warning('on')
end


