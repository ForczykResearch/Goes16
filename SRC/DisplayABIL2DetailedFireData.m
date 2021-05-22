function DisplayABIL2DetailedFireData(FireLats,FireLons,FireHotValues,itype,titlestr)
% Display various types of fire data for the ABI-L2-FireData set
% obtains from GOES-16. The plot symbols change color and size based on
% the magnitude of FireHotValues. The symbols are plotted in increasing
% order of the FireHotValues so the most important data is not obscured
% 
% Written By: Stephen Forczyk
% Created: Sept 13,2020
% Revised: ------
% Classification: Unclassified



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
% southEdge1=32;
% northEdge1=44;
% westEdge1=-125;
% eastEdge1=-110;
h1=axesm('mercator','Frame','on','Grid','on','MapLatLimit',[southEdge1 northEdge1],...
    'MapLonLimit',[westEdge1 eastEdge1],'meridianlabel','on','parallellabel','on','plabellocation',1,'mlabellocation',1,...
    'MLabelParallel','south','MLineLocation',1,'PLineLocation',1);
set(gcf,'Position',[hor1 vert1 widd lend])
set(gcf,'MenuBar','none');
MidMapLon=(westEdge1+eastEdge1)/2;
MidMapLat=(southEdge1+northEdge1)/2;
rivers = shaperead('worldrivers.shp', 'UseGeoCoords', true);
numrows=length(rivers);
for n=1:numrows % Plot the rivers
   NowLon=rivers(n).Lon;
   NowLat=rivers(n).Lat;
   plotm(NowLat,NowLon,'b');
end
dispstr=strcat('finished plotting-',num2str(numrows),'-rivers');
disp(dispstr)
hold on
eval(['cd ' mappath(1:length(mappath)-1)]);
load('USAHiResBoundaries.mat');
plotm(USALat,USALon,'k');
load('CanadaBoundaries.mat');
plotm(CanadaLat,CanadaLon,'k');
load('MexicoBoundaries.mat');
plotm(MexicoLat,MexicoLon,'k');
cmap = rgbmap('red','blue',12);
minval=min(FireHotValues);
maxval=max(FireHotValues);
[SortFireHotValues,indS]=sort(FireHotValues);
delval=(maxval-minval)/length(cmap);
cmap2=flipud(cmap);
minsize=12;
maxsize=24;
ab=1;
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
    nowColor=[1 0 0];
    nowSize=floor(minsize+nowInd);
    ab=2;
    scatterm(FireLats(mms,1),FireLons(mms,1),nowSize,nowColor,'filled')
    dispstr=strcat('mms=',num2str(mms),'-nowInd=',num2str(nowInd),'-Temp=',...
        num2str(nowFireHotValue,4),'-color-',num2str(nowColor(1,1)),'-',...
        num2str(nowColor(1,2)),'-',num2str(nowColor(1,3)));
    disp(dispstr)
    ab=3;

end
eval(['cd ' USshapefilepath(1:length(USshapefilepath)-1)]);
% start by mapping the California Counties
shapefilename='california_administrative.shp';
S0=shaperead(shapefilename,'UseGeoCoords',true);
numrecords=length(S0);
waitstr=strcat('Plotting File-',RemoveUnderScores(shapefilename));
h=waitbar(0,waitstr);
iplotcount=0;
iskipcount=0;
imiss=0;
for n=1:numrecords
    BoundingBox=S0(n).BoundingBox;
    MidLon=(BoundingBox(1,1)+BoundingBox(2,1))/2;
    MidLat=(BoundingBox(1,2)+BoundingBox(2,2))/2;
    dist=sqrt((MidMapLon-MidLon)^2 + (MidMapLat-MidLat)^2);
    if(dist<5)
        CountyLat=S0(n).Lat;
        CountyLon=S0(n).Lon;
        numpts=length(CountyLat);
        ADMIN_LEVEL=S0(n).ADMIN_LEVE;
        a3=isempty(ADMIN_LEVEL);
        if(a3==1)
            ADMIN_LEVEL=-1;
        end
        a4=isnumeric(ADMIN_LEVEL);
        if(a4==0)
            ADMIN_LEVEL=-1;
        end
        name=S0(n).NAME;
        a0=isempty(name);
        if(a0==0)
            a1=strfind(name,'County');
            a2=double(isempty(a1));
        else
            a0=1;
            name='Empty';
        end
        if((a2==0) || (ADMIN_LEVEL==6))
            plotm(CountyLat,CountyLon,'k--')
            iplotcount=iplotcount+1;
        else
            iskipcount=iskipcount+1;
        end
        
    else
        imiss=imiss+1;
    ab=2;
    end
    waitbar(n/numrecords);
end
dispstr=strcat('admin area plot-iplotcount=',num2str(iplotcount),'-iskipcount=',...
    num2str(iskipcount),'-imiss=',num2str(imiss));
disp(dispstr)
clear S0
close(h);
shapefilename='california_prisecroads';
S1=shaperead(shapefilename,'UseGeoCoords',true);
numrecords=length(S1);
waitstr=strcat('Plotting File-',RemoveUnderScores(shapefilename));
h=waitbar(0,waitstr);
ictr1=0;
ictr2=0;
ictr3=0;
imissroad=0;
ihitroad=0;
for n=1:numrecords
    BoundingBox=S1(n).BoundingBox;
    MidLon=(BoundingBox(1,1)+BoundingBox(2,1))/2;
    MidLat=(BoundingBox(1,2)+BoundingBox(2,2))/2;
    dist=sqrt((MidMapLon-MidLon)^2 + (MidMapLat-MidLat)^2);
    if(dist<5)
        ihitroad=ihitroad+1;
        RoadLat=S1(n).Lat;
        RoadLon=S1(n).Lon;
        numpts=length(RoadLat);
        RoadType=S1(n).RTTYP;
        a1=strcmp('I',RoadType);
        a2=strcmp('M',RoadType);
        a3=strcmp('S',RoadType);
        if(a1==1)
            plotm(RoadLat,RoadLon,'g')
            ictr1=ictr1+1;
        elseif(a2==1)
            plotm(RoadLat,RoadLon,'g-.')
            ictr2=ictr2+1;
        elseif(a3==1)
            plotm(RoadLat,RoadLon,'c')
            ictr3=ictr3+1;
        else
        
        end
    else
        imissroad=imissroad+1;
    end
    waitbar(n/numrecords);
    ab=2;

end
close(h);
dispstr=strcat('ictr1=',num2str(ictr1),'-ictr2=',num2str(ictr2),...
    '-ictr3=',num2str(ictr3),'-ihitroad=',num2str(ihitroad),'-imissroad=',num2str(imissroad));
disp(dispstr)

title(titlestr)
hold off
newaxesh=axes('Position',[0 0 1 1]);
set(newaxesh,'XLim',[0 1],'YLim',[0 1]);
tx1=.78;
ty1=.18;
txtstr1=strcat('Start Scan-Y',num2str(YearS),'-D-',num2str(DayS),'-H-',...
    num2str(HourS),'-M-',num2str(MinuteS),'-S-',num2str(SecondS));
txt1=text(tx1,ty1,txtstr1,'FontWeight','bold','FontSize',8);
tx2=.78;
ty2=.15;
txtstr2=strcat('End Scan-Y',num2str(YearE),'-D-',num2str(DayE),'-H-',...
    num2str(HourE),'-M-',num2str(MinuteE),'-S-',num2str(SecondE));
txt2=text(tx2,ty2,txtstr2,'FontWeight','bold','FontSize',8);
tx3a=.78;
ty3a=.12;
txtstr3a=strcat('Calendar Date-',MonthDayYearStr);
txt3a=text(tx3a,ty3a,txtstr3a,'FontWeight','bold','FontSize',8);
tx3b=.78;
ty3b=.09;
txtstr3b='--------------------------';
txt3b=text(tx3b,ty3b,txtstr3b,'FontWeight','bold','FontSize',8);
tx3c=.78;
ty3c=.06;
txtstr3c=strcat('Number of HotPixels=',num2str(numHotPixels));
txt3c=text(tx3c,ty3c,txtstr3c,'FontWeight','bold','FontSize',8);
% Get the min and max values of the fire hot values
minval=min(FireHotValues);
maxval=max(FireHotValues);
tx4=.18;
ty4=.12;
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
close('all');
end


