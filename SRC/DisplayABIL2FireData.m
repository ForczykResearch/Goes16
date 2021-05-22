function DisplayABIL2FireData(FireLats,FireLons,FireHotValues,itype,titlestr)
% Display various types of fire data for the ABI-L2-FireData set
% obtains from GOES-16. The plot symbols change color and size based on
% the magnitude of FireHotValues. The symbols are plotted in increasing
% order of the FireHotValues so the most important data is not obscured
% 
% Written By: Stephen Forczyk
% Created: Sept 13,2020
% Revised: Oct 5,20202 extensively modified-plotted area type objects as 
%          patches. Turned ocean to appropriate color
% Revised: Jan 8,2021 added code to create PDF report
% Revised: Jan 15,2021 added code to include TOC in PDF report
% Classification: Unclassified



global xImgS xImgBS SatDataS GeoSpatialS;
global ReflectanceS AlgoS ErrorS EarthSunS VersionContainerS;
global GoesWaveBand ESunS kappa0S PlanckS FocalPlaneS;
global GOESFileName OutlierPS CloudTopTS LZAS LZABS SZAS SZABS;
global TempS Algo2S ProcessParamTS AlgoProductTS Error1S CloudPixelsS;

global ProcessParamVersionContainerS GOESFileName;
global AreaS MaskS PowerS DQFS PixelFireDataS;
global FireOutlierPixelS FireTempS FireAreaS FirePowerS AlgoDynamicInputDataS;
global FireDetails;
global GRB_ErrorsS L0_ErrorsS;
global westEdge eastEdge northEdge southEdge;
global MonthDayStr MonthDayYearStr;
global DayMonthNonLeapYear DayMonthLeapYear CalendarFileName;
global RptGenPresent iCreatePDFReport pdffilename rpt chapter tocc;
global JpegCounter JpegFileList;
global FireTable2;
global ColorList RGBVals ColorList2 xkcdVals LandColors;
global orange bubblegum;
global NorthAmericaLakes;

global widd2 lend2;
global initialtimestr igrid ijpeg ilog imovie;
global vert1 hor1 widd lend;
global vert2 hor2 machine;
global chart_time;
global Fz1 Fz2 fid;
global idirector mov izoom iwindow;
global matpath GOES16path;
global jpegpath figpath;
global smhrpath excelpath ascpath;
global ipowerpoint PowerPointFile scaling stretching padding;
global ichartnum;
% additional paths needed for mapping
global matpath1 mappath;
global canadapath stateshapepath topopath;
global trajpath militarypath;
global figpath screencapturepath;
global shapepath2 countrypath countryshapepath usstateboundariespath;
global GOES16Band1path GOES16Band2path GOES16Band3path GOES16Band4path;
global GOES16Band5path GOES16Band6path GOES16Band7path GOES16Band8path
global GOES16Band9path GOES16Band10path GOES16Band11path GOES16Band12path;
global GOES16Band13path GOES16Band14path GOES16Band15path GOES16Band16path;
global GOES16CloudTopHeightpath shapefilepath USshapefilepath Countryshapepath;
global northamericalakespath;
if((iCreatePDFReport==1) && (RptGenPresent==1))
    import mlreportgen.dom.*;
    import mlreportgen.report.*;
end
USshapefilepath='D:\Forczyk\Map_Data\USStateShapeFiles\';
disp('Start making Fire Hot Spot map');
fprintf(fid,'%s\n','*****Start making National Fire Hot Spot map*****');
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
set(gcf,'Position',[hor1 vert1 widd lend])
set(gcf,'MenuBar','none');
h1=axesm('mercator','Frame','on','Grid','on','MapLatLimit',[southEdge northEdge],...
    'MapLonLimit',[westEdge eastEdge],'meridianlabel','on','parallellabel','on','plabellocation',10,'mlabellocation',10,...
    'MLabelParallel','south','PLineLocation',10,'MLineLocation',10);
h1.Color='cyan';
hold on
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
tightmap;
eval(['cd ' mappath(1:length(mappath)-1)]);

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
    nowColor=[LandColors(nx,1) LandColors(nx,2) LandColors(nx,3)];
    patchm(GTMLat,GTMLon,orange);
end
clear S1 GTMLat GTMLon
% Plot Belize
S1 = shaperead('BLZ_adm1.shp', 'UseGeoCoords', true);
numprov=length(S1);
nx=1;
for n=1:numprov
    BLZLat=S1(n).Lat;
    BLZLon=S1(n).Lon;
    nowColor=[LandColors(nx,1) LandColors(nx,2) LandColors(nx,3)];
    patchm(BLZLat,BLZLon,'g');
end
clear S1 BLZLat BLZLon
% Plot Honduras
S1 = shaperead('HND_adm1.shp', 'UseGeoCoords', true);
numprov=length(S1);
nx=1;
for n=1:numprov
    HNDLat=S1(n).Lat;
    HNDLon=S1(n).Lon;
    nowColor=[LandColors(nx,1) LandColors(nx,2) LandColors(nx,3)];
    patchm(HNDLat,HNDLon,'y');
end
clear S1 HNDLat HNDLon
% Plot Cuba
S1 = shaperead('CUB_adm1.shp', 'UseGeoCoords', true);
numprov=length(S1);
nx=1;
for n=1:numprov
    CUBLat=S1(n).Lat;
    CUBLon=S1(n).Lon;
    nowColor=[LandColors(nx,1) LandColors(nx,2) LandColors(nx,3)];
    patchm(CUBLat,CUBLon,orange);
end
clear S1 CUBLat CUBLon
% Plot Haiti
S1 = shaperead('HTI_adm1.shp', 'UseGeoCoords', true);
numprov=length(S1);
nx=1;
for n=1:numprov
    HTILat=S1(n).Lat;
    HTILon=S1(n).Lon;
    NAME_1=char(S1(n).NAME_1);
    nowColor=[LandColors(nx,1) LandColors(nx,2) LandColors(nx,3)];
    patchm(HTILat,HTILon,'g');
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
    nowColor=[LandColors(nx,1) LandColors(nx,2) LandColors(nx,3)];
    patchm(DOMLat,DOMLon,'y');
end
clear S1 DOMLat DOMLon
% Plot Jamaica
S1 = shaperead('JAM_adm1.shp', 'UseGeoCoords', true);
numprov=length(S1);
nx=1;
for n=1:numprov
    JAMLat=S1(n).Lat;
    JAMLon=S1(n).Lon;
    nowColor=[LandColors(nx,1) LandColors(nx,2) LandColors(nx,3)];
    patchm(JAMLat,JAMLon,bubblegum);
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
    nowColor=[LandColors(nx,1) LandColors(nx,2) LandColors(nx,3)];
    patchm(BHSLat,BHSLon,bubblegum);
end
clear S1 BHSLat BHSLon
eval(['cd ' mappath(1:length(mappath)-1)]);
% Plot world rivers
rivers = shaperead('worldrivers.shp', 'UseGeoCoords', true);
numrows=length(rivers);
for n=1:numrows % Plot the rivers
   NowLon=rivers(n).Lon;
   NowLat=rivers(n).Lat;
   plotm(NowLat,NowLon,'b');
end
dispstr=strcat('finished plotting-',num2str(numrows),'-Nationalrivers');
disp(dispstr)
% Plot North American Lakes
clear rivers
clear S1
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
    nowSize=floor(minsize+nowInd);
    scatterm(FireLats(mms,1),FireLons(mms,1),nowSize,nowColor,'filled')
end
title(titlestr)
hold off
scalebarlen=1000;
scalebarloc='se';
scalebar('length',scalebarlen,'units','miles','color','k','location',scalebarloc,'fontangle','bold','RulerStyle','patches');
ArrowLat=northEdge-2;
ArrowLon=eastEdge+5;
northarrow('latitude',ArrowLat,'longitude',ArrowLon);
harrow=handlem('NorthArrow');
set(harrow,'FaceColor',[1 1 0],'EdgeColor',[1 0 0]);
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
% Save this chart as a jpeg
set(gcf,'MenuBar','none');
figstr2=strcat(titlestr,'.jpg');
figstr=strcat('NationalFireHotSpots-ABI-L2-Fire','Y',num2str(YearS),'D',...
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
if((iCreatePDFReport==1) && (RptGenPresent==1))
    [ibreak]=strfind(GOESFileName,'_e');
    is=1;
    ie=ibreak(1)-1;
    GOESShortFileName=GOESFileName(is:ie);
    headingstr1=strcat('Hot Spot From File-',GOESShortFileName);
    chapter = Chapter("Title",headingstr1);
    add(chapter,Section('CONUS Level View Of Fire Hot Spots'));
    imdata = imread(figstr);
    [nhigh,nwid,ndepth]=size(imdata);
    image = mlreportgen.report.FormalImage();
    image.Image = which(figstr);
    pdftxtstr=strcat('Hot Spots Found On File-',GOESShortFileName);
    pdftext = Text(pdftxtstr);
    pdftext.Color = 'red';
    image.Caption = pdftext;
    nhighs=floor(nhigh/2.2);
    nwids=floor(nwid/2.2);
    heightstr=strcat(num2str(nhighs),'px');
    widthstr=strcat(num2str(nwids),'px');
    image.Height = heightstr;
    image.Width = widthstr;
    image.ScaleToFit=0;
    add(chapter,image);
    parastr1='The Data for this chart was from file-';
    parastr2=strcat(parastr1,GOESFileName);
    p1 = Paragraph(parastr2);
    p1.Style = {OuterMargin("0pt", "0pt","0pt","10pt")};
    add(chapter,p1);
% Create a fire Table
    tbl_header = {'Fire #' 'State Name' 'County Name' 'Lat' 'Lon'  'Deg-K'  'Area-Km2'};
    FireTable2=cell(numHotPixels,7);
    for kk=1:numHotPixels
        FireTable2{kk,1}=kk;
        FireTable2{kk,2}=FireDetails{1+kk,1};
        FireTable2{kk,3}=FireDetails{1+kk,2};
        nowLatVal=(FireDetails{1+kk,3});
        nowLatStr=num2str(nowLatVal,6);
        FireTable2{kk,4}=nowLatStr;
        nowLonVal=(FireDetails{1+kk,5});
        nowLonStr=num2str(nowLonVal,6);
        FireTable2{kk,5}=nowLonStr;
        nowTempVal=(FireDetails{1+kk,5});
        nowTempStr=num2str(nowTempVal,6);
        FireTable2{kk,6}=nowTempStr;
        nowAreaVal=FireDetails{1+kk,6}/1E4;
        nowAreaStr=num2str(nowAreaVal,6);
        FireTable2{kk,7}=nowAreaStr;
    end
    FireTable3=[tbl_header; FireTable2];
    tbl_data=FireTable3;
    tbl=Table(tbl_data);
    tbl.TableEntriesStyle = {BackgroundColor('white')};
    tbl.Style = [tbl.Style {Border('solid','black','3px')}];
    tbl.ColSep = 'single';
    tbl.RowSep = 'single';
    tbl.HAlign='center';
    r = row(tbl,1);
    r.Style = [r.Style {Color('red'),Bold(true)}];
    bt = BaseTable(tbl);
    tabletitle = Text('GOES Detected Hot Spots');
    tabletitle.Bold = false;
    bt.Title=tabletitle;
    bt.TableWidth="7in";
    add(chapter,bt);
    parastr3='Table Above shows Hot spots Detected By GOES';
    p2 = Paragraph(parastr3);
    p2.Style = {OuterMargin("0pt", "0pt","10pt","10pt")};
    add(chapter,p2);
    parastr4=strcat('GOES detected a total of-',num2str(numHotPixels),'-Hot Spots above 500K.');
    parastr5=strcat('The temperatures ranged from-',num2str(minval,4),'-to-',num2str(maxval,4),'-Deg-K .');
    parastr6=strcat(parastr4,parastr5);
    p3 = Paragraph(parastr6);
    p3.Style = {OuterMargin("0pt", "0pt","10pt","10pt")};
    add(chapter,p3);
%    add(rpt,chapter);
end
close('all');
fprintf(fid,'%s\n','*****Finish making National Fire Hot Spot map*****');
end


