function DisplayABIL2CountyFireData(FireLats,FireLons,FireHotValues,itype,fireState,fireStateFP,titlestr)
% Display various types of fire data for the ABI-L2-FireData set
% obtains from GOES-16. The plot symbols change color and size based on
% the magnitude of FireHotValues. The symbols are plotted in increasing
% order of the FireHotValues so the most important data is not obscured
% The scale is this map is roughly county  sized
% Written By: Stephen Forczyk
% Created: Oct 2,2020
% Revised: Oct 4,2020 to include airports and fixes to patch
%          objects that failed to plot because they were outside
%          the map limits
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
global orange;

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
TimeCounter=cell(8,2);
TimeCounter{1,1}='Time To Plot Rivers';
TimeCounter{2,1}='Time To Plot Countries';
TimeCounter{3,1}='Time to Plot Counties';
TimeCounter{4,1}='Time To PLot Primary Roads';
TimeCounter{5,1}='Time To Plot State Roads';
TimeCounter{6,1}='Time To Plot City Areas';
TimeCounter{7,1}='Time To Plot Lakes';
TimeCounter{8,1}='Time To Plot Airports';
disp('Start making Fire Hot Spot map');
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
numMdiv=abs(westEdge1-eastEdge1)/MLineVal;
if(numMdiv>8)
    MLineVal=2;
end
set(gcf,'Position',[hor1 vert1 widd lend])
set(gcf,'MenuBar','none');
h1=axesm('mercator','Frame','on','Grid','on','MapLatLimit',[southEdge1 northEdge1],...
    'MapLonLimit',[westEdge1 eastEdge1],'meridianlabel','on','parallellabel','on','plabellocation',1,'mlabellocation',MLineVal,...
    'MLabelParallel','south','MLineLocation',1,'PLineLocation',1);
% set(gcf,'Position',[hor1 vert1 widd lend])
% set(gcf,'MenuBar','none');
MidMapLon=(westEdge1+eastEdge1)/2;
MidMapLat=(southEdge1+northEdge1)/2;
rivers = shaperead('worldrivers.shp', 'UseGeoCoords', true);
numrows=length(rivers);
tightmap;
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
hold on
tic;
eval(['cd ' mappath(1:length(mappath)-1)]);
load('USAHiResBoundaries.mat');
plotm(USALat,USALon,'k');
load('CanadaBoundaries.mat');
plotm(CanadaLat,CanadaLon,'k');
load('MexicoBoundaries.mat');
plotm(MexicoLat,MexicoLon,'k');
elapsed_time2=toc;
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
% Now plot county roads
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
    '-maxlen=',num2str(maxlen));
disp(dispstr);
if(numcountyroads<400)
    maxplot=numcountyroads;
    pctplt=100;
elseif((numcountyroads>=400) && (numcountyroads<=800))
    maxplot=round(.80*numcountyroads);
    pctplt=80;
elseif(numcountyroads>800)
    maxplot=round(.60*numcountyroads);
    pctplt=60;
end

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
    numpts=length(RoadLat);
    hL(6)=plotm(RoadLat,RoadLon,'g-.','LineWidth',1,'DisplayName','County Roads');
    waitbar(n/numcountyroads);
    if(n>=maxplot)
        igo=0;
    end
end
close(h);
% Now add urban areas
clear S1
tic;
eval(['cd ' USshapefilepath(1:length(USshapefilepath)-1)]);
S1=shaperead(UrbanAreasShapeFile,'UseGeoCoords',true);
numrecords=length(S1);
waitstr=strcat('Plotting Cities-',RemoveUnderScores(UrbanAreasShapeFile));
h=waitbar(0,waitstr);
numurban=0;
iploturban=0;
iskipurban=0;
irestore=0;
XB=[westEdge1 eastEdge1 eastEdge1 westEdge1 westEdge1];
YB=[southEdge1 southEdge1 northEdge1 northEdge1 southEdge1];
for n=1:numrecords
    iplotflag=0;
    STATEFP=(S1(n).StateFIPS);
    CityName=char(S1(n).CityName);
    citynamelen=length(CityName);
    if(citynamelen>10)
        CityName=CityName(1:10);
    end
    ALAND10=S1(n).ALAND10;
    if(STATEFP==fireStateFP)
        CityLat=S1(n).Lat;
        CityLon=S1(n).Lon;
        CityLat2=CityLat;
        CityLon2=CityLon;
        numpts=length(CityLat);
        A1=isnan(CityLat);
        numnan1=sum(A1);
        [xin,yin,Ind]=Inside(XB,YB,CityLon,CityLat);
        numin1=length(xin);
        numtot1=length(CityLon);
        numout1=numtot1-numin1-numnan1;
        goodfrac1=numin1/numtot1;
        ab=1;
        try
            hL(4)=patchm(CityLat,CityLon,'y','DisplayName','UrbanAreas');
            iploturban=iploturban+1;
            iplotflag=1;
        catch
            iskipurban=iskipurban+1;
            if(goodfrac1>.80)% try to repair the polygon and then plot
                CityLat2=CityLat;
                CityLon2=CityLon;
                ab=3;
                for kk=1:numpts
                    if(CityLon2(1,kk)<=westEdge1)
                        CityLon2(1,kk)=westEdge1+.001;
                    end
                    if(CityLon2(1,kk)>=eastEdge1)
                        CityLon2(1,kk)=eastEdge1-0.001;
                    end
                    if(CityLat2(1,kk)<=southEdge1)
                        CityLat2(1,kk)=southEdge1+.001;
                    end
                    if(CityLat2(1,kk)>=northEdge1)
                        CityLat2(1,kk)=northEdge1-.001;
                    end                                       
                end
                [xin2,yin2,Ind2]=Inside(XB,YB,CityLon2,CityLat2);
                A2=isnan(CityLat2);
                numnan2=sum(A2);
                numin2=length(xin2);
                numtot2=length(CityLon2);
                numout2=numtot2-numin2-numnan2;
                goodfrac2=numin2/numtot2;
                try
                    hL(4)=patchm(CityLat2,CityLon2,'y','DisplayName','UrbanAreas');
                    iploturban=iploturban+1;
                    irestore=irestore+1;
                    iplotflag=1;
                catch
                    
                end
            end
            ab=5;
        end
        if((ALAND10>1E7)&& (iplotflag==1))
            delx=0.05;
            dely=0.05;
            medLat=median(CityLat2,'omitnan');
            medLon=median(CityLon2,'omitnan');
            distwBoundary=abs(westEdge1-medLon);
            disteBoundary=abs(eastEdge1-medLon);
            distnBoundary=abs(northEdge1-medLat);
            distsBoundary=abs(southEdge1-medLat);
            if(disteBoundary<distwBoundary)
                delx=-.10;
            end
            if(distnBoundary<distsBoundary)
                dely=-.05;
            end
            textm(medLat+dely,medLon+delx,CityName,'Color',[1 1 1],'FontSize',8,'FontWeight','bold');
        end
        numurban=numurban+1;
        waitbar(n/numrecords);
    end
end
elapsed_time6=toc;
close(h);
dispstr=strcat('For cities plotted-',num2str(iploturban),'-pts-and skipped-',num2str(iskipurban),...
    '-cities-partial cities-',num2str(irestore));
disp(dispstr)
TimeCounter{6,2}=elapsed_time6;
% Now plot lakes
% Select the correct State_water.shp file
tic
shapefilename=char(USAStatesShapeFileList{imatchstate,9});
waitstr=strcat('Plotting Lakes-',RemoveUnderScores(shapefilename));
h=waitbar(0,waitstr);
S2=shaperead(shapefilename,'UseGeoCoords',true);
numwater=length(S2);
iskip=0;
ilakeplotted=0;
irestore=0;
for n=1:numwater
    Natural=char(S2(n).NATURAL);
    LakeName=char(S2(n).NAME);
    a1=strcmp(Natural,'water');
    a2=isempty(LakeName);
    if((a1==1) && (a2==0))
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
            hL(3)=patchm(LakeLat,LakeLon,'b','DisplayName','Lakes');
            ilakeplotted=ilakeplotted+1;
            dispstr=strcat('Plotted Lake-',LakeName,'-which was index-',num2str(n));
            disp(dispstr)
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
                    hL(3)=patchm(LakeLat2,LakeLon2,'b','DisplayName','Lakes');
                    ilakeplotted=ilakeplotted+1;
                    irestore=irestore+1;
                    dispstr=strcat('Restored Lake-',LakeName,'-which was index-',num2str(n));
                    disp(dispstr)
                catch
                    
                end
            end
        end
    end
    waitbar(n/numwater);
end
close(h);
elapsed_time7=toc;
TimeCounter{7,2}=elapsed_time7;
dispstr=strcat('For lakes plotted-',num2str(ilakeplotted),'-pts-and skipped-',num2str(iskip),...
    '-points and-',num2str(irestore),'-pts');
disp(dispstr)
clear S2
% Plot the airports
tic;
eval(['cd ' USshapefilepath(1:length(USshapefilepath)-1)]);
shapefilename=char(USAStatesShapeFileList{imatch,8});
S3=shaperead(shapefilename,'UseGeoCoords',true);
ab=3;
numpts=length(S3);
waitstr=strcat('Plotting Airports-',RemoveUnderScores(shapefilename));
h=waitbar(0,waitstr);
for n=1:numpts
    nowName=char(S3(n).NAME);
    a1=strfind(nowName,'Airport');
    a2=isempty(a1);
    if(a2==0)
        AirportLat=S3(n).Lat;
        AirportLon=S3(n).Lon;
%        hL(7)=plotm(AirportLat,AirportLon,'rd','LineWidth',1,'DisplayName','Airports');
        sz=48;
        hL(7)=scatterm(AirportLat,AirportLon,sz,'d','MarkerEdgeColor',[1 1 1],...
            'MarkerFaceColor',orange,'DisplayName','Airports');
    end
    waitbar(n/numpts);
end
close(h);  
elapsed_time8=toc;
TimeCounter{8,2}=elapsed_time8;
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
scalebarlen=50;
scalebarloc='se';
scalebar('length',scalebarlen,'units','miles','color','k','location',scalebarloc,'fontangle','bold','RulerStyle','patches');
ArrowLat=northEdge1-1;
ArrowLon=eastEdge1+0.3;
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
[cmdString]=MyStrcat2(actionstr,typestr,figstr);
eval(cmdString);
dispstr=strcat('Saved Image To File-',figstr);
disp(dispstr)
pause(chart_time);
disp('Run Time Values For Creating This map');
T=cell2table(TimeCounter);
disp(T);
ab=1;
close('all');
end


