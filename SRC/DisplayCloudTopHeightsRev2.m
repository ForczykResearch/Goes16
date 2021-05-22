function  DisplayCloudTopHeightsRev2(HT,titlestr)
% Display the cloud top heights from the GOES16/17 data
% Project this data on a equiconic section map
% This uses the CONUS projection
% Written By: Stephen Forczyk
% Created: Sept 2,2020
% Revised: Jan 4,2021 added code to create PDF reports
% Revised: Added TOC entry to PDF Reports
% Revised: Mar 31,2021 changed to tightmap display and added logic
%          to place text below image according to location of colorbar
% Classification: Unclassified
global BandDataS MetaDataS;
global CMIS DQFS tS yS xS tBS goesImagerS yImgS yImgBS;
global xImgS xImgBS SatDataS GeoSpatialS;
global ReflectanceS AlgoS ErrorS EarthSunS VersionContainerS;
global GoesWaveBand ESunS kappa0S PlanckS FocalPlaneS;
global HTS DQF1S OutlierPS CloudTopS Algo1S ProcessParamS;
global LZAS LZABS SZAS SZABS Error1S CloudPixelsS;
global xImgS xImgBS SatDataS GeoSpatialS;
global GOESFileName HTS MapFormFactor;
global MonthDayStr MonthDayYearStr;
global DayMonthNonLeapYear DayMonthLeapYear CalendarFileName;
global westEdge eastEdge northEdge southEdge;
global RptGenPresent iCreatePDFReport pdffilename rpt chapter;
global JpegCounter JpegFileList;

global widd2 lend2;
global initialtimestr igrid ijpeg ilog imovie;
global vert1 hor1 widd lend;
global vert2 hor2 machine;
global chart_time;
global Fz1 Fz2 fid;
global idirector mov izoom iwindow;
global matpath GOES16path;
global jpegpath ;
global smhrpath excelpath ascpath;
global ipowerpoint PowerPointFile scaling stretching padding;
global ichartnum;
% additional paths needed for mapping
global matpath1 mappath;
global canadapath stateshapepath topopath;
global trajpath militarypath pdfpath govjpegpath;
global figpath screencapturepath gridpath;
global shapepath2 countrypath countryshapepath usstateboundariespath;
global GOES16Band1path GOES16Band2path GOES16Band3path GOES16Band4path;
global GOES16Band5path GOES16Band6path GOES16Band7path GOES16Band8path
global GOES16Band9path GOES16Band10path GOES16Band11path GOES16Band12path;
global GOES16Band13path GOES16Band14path GOES16Band15path GOES16Band16path;
global GOES16CloudTopHeightpath GOES16BandPaths;
if((iCreatePDFReport==1) && (RptGenPresent==1))
    import mlreportgen.dom.*;
    import mlreportgen.report.*;
end

fprintf(fid,'%s\n','------- Plot Cloud Top Data For CONUS ------');
eval(['cd ' gridpath(1:length(gridpath)-1)]);
[nrows,ncols]=size(HT);
if((nrows==500) && (ncols==300))
   GridMatFileName='CONUSCloudTopHeightBoundaries.mat';
else
   GridMatFileName='FullDiskCloudTopHeightBoundaries.mat'; 
end
gridstr1=strcat('Loaded Map Grid From File=',GridMatFileName);
fprintf(fid,'%s\n',gridstr1);
ab=1;
%[GridMatFileName,path]=uigetfile('*mat','Select one Raster Grid File');%
load(GridMatFileName,'RasterLats','RasterLons');
dispstr=strcat('Loaded Grid Raster File-',GridMatFileName);
disp(dispstr)
% Fetch the map limits
westEdge=double(GeoSpatialS.geospatial_westbound_longitude);
eastEdge=double(GeoSpatialS.geospatial_eastbound_longitude);
southEdge=double(GeoSpatialS.geospatial_southbound_latitude);
northEdge=double(GeoSpatialS.geospatial_northbound_latitude);
% Reset any height values below zero to zero. Also divide by 1000 to reset
% the units to km
[nrows,ncols]=size(HT);

HT=HT/1000;
HTS1D=reshape(HT,nrows*ncols,1);
HTSort=sort(HTS1D);
[ibad]=isnan(HTSort);
numnan=sum(ibad);
numvals=length(HTSort)-numnan;
val01=HTSort(round(.01*numvals),1);
val50=HTSort(round(.50*numvals),1);
val99=HTSort(round(.99*numvals),1);
maxHT=max(HTSort);
heightstr1=strcat('HT 1 ptile=',num2str(val01,6),'-Max HT=',num2str(maxHT,6),'-in Km');
fprintf(fid,'%s\n',heightstr1);
% Find the pixel with the max cloud top
[ix,iy]=find(HT==maxHT);
numloc=length(ix);
if(numloc>0)
    HLat=RasterLats(iy(1),ix(1));
    HLon=RasterLons(iy(1),ix(1));
    heightstr2=strcat('Max Cloud Height=',num2str(maxHT,6),'-Km At Lat=',...
        num2str(HLat,6),'-Lon=',num2str(HLon,6));
    fprintf(fid,'%s\n',heightstr2);
end

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
eastEdge=-60;
% axesm ('eqaconic','Frame','on','Grid','on','MapLatLimit',[southEdge northEdge],...
%     'MapLonLimit',[westEdge eastEdge],'meridianlabel','on','parallellabel','on','plabellocation',5,'mlabellocation',20);
axesm ('pcarree','Frame','on','Grid','on','MapLatLimit',[southEdge northEdge],...
     'MapLonLimit',[westEdge eastEdge],'meridianlabel','on','parallellabel','on','plabellocation',5,'mlabellocation',10,...
     'MLabelParallel','south','Frame','on','FontColor','b');
tightmap;
set(gcf,'MenuBar','none');
%geoshow(HT,GeoRef,'DisplayType','texturemap');
%hd=demcmap(HT,256);
geoshow(RasterLats,RasterLons,HT','DisplayType','texturemap');
demcmap(HT',256);
hold on
eval(['cd ' mappath(1:length(mappath)-1)]);
load('USAHiResBoundaries.mat');
plotm(USALat,USALon,'r');
load('CanadaBoundaries.mat');
plotm(CanadaLat,CanadaLon,'w');
load('MexicoBoundaries.mat');
plotm(MexicoLat,MexicoLon,'y');
load('CubaBoundaries.mat');
plotm(CubaLat,CubaLon,'r-');
load('DominicanRepublicBoundaries.mat');
plotm(DRLat,DRLon,'r-');
load('HaitiBoundaries.mat');
plotm(HaitiLat,HaitiLon,'y-');
load('BelizeBoundaries.mat');
plotm(BelizeLat,BelizeLon,'y-');
load('GautemalaBoundaries.mat');
plotm(GautemalaLat,GautemalaLon,'g');
load('JamaicaBoundaries.mat');
plotm(JamaicaLat,JamaicaLon,'r');
if(numloc>0)
   plotm(HLat,HLon,'rs'); 
end
set(gcf,'Position',[hor1 vert1 widd lend])
title(titlestr)
hold off
hc=colorbar;
newaxesh=axes('Position',[0 0 1 1]);
set(newaxesh,'XLim',[0 1],'YLim',[0 1]);
% Set text position based on location of colorbar
Pos=get(hc,'Position');
PosyL=.80*Pos(1,2);
PosyU=1.03*(Pos(1,2)+Pos(1,4));
ty1=PosyL;
tx2=.97*Pos(1,1);
ty2=PosyU;
txt2=text(tx2,ty2,'Alt-km','FontWeight','bold','FontSize',12);
tx4=.13;
ty4=ty1-.04;
txtstr4=strcat('HT-Km 1%-',num2str(val01,5),'-HT-Km 50%-',...
    num2str(val50,5),'-HT-Km 99%-',num2str(val99,5),'-max HT=',...
    num2str(maxHT,5),'-Km','------',MonthDayYearStr);
txt4=text(tx4,ty4,txtstr4,'FontWeight','bold','FontSize',12);
if(numloc>0)
    tx5=.13;
    ty5=ty4-.04;
    txtstr5=strcat('Max Ht Cloud Located At Lat=',num2str(HLat,6),...
        '-Lon=',num2str(HLon,6));
    txt5=text(tx5,ty5,txtstr5,'FontWeight','bold','FontSize',12);
end
set(newaxesh,'Visible','Off');
% Save this chart
figstr=strcat(titlestr,'.jpg');
eval(['cd ' jpegpath(1:length(jpegpath)-1)]);
actionstr='print';
typestr='-djpeg';
[cmdString]=MyStrcat2(actionstr,typestr,figstr);
eval(cmdString);
pause(chart_time);

if((iCreatePDFReport==1) && (RptGenPresent==1))
    headingstr1='Cloud Top Height-Conus Map';
    chapter = Chapter("Title",headingstr1);
    imgPath = which(figstr);
    img1 = Image(imgPath);
    img1.Style=[img1.Style {ScaleToFit}];
    add(chapter,img1);
    add(chapter,Section('CONUS Level Cloud Top Heights'));
    parastr1='The Data for this chart was from file-';
    parastr2=strcat(parastr1,GOESFileName,'.');
    parastr3='The Cloud Top Height is calculated by an algorithm that uses data from Bands 11,12 and 13 which are all IR Bands.';
    parastr4='This method was selected to prodvide a consistent methodology over a full 24 cycle.';
    parastr5=strcat(parastr1,parastr2,parastr3,parastr4);
    p2 = Paragraph(parastr5);
    p2.Style = {OuterMargin("0pt", "0pt","0pt","10pt")};
    add(chapter,p2);
    eval(['cd ' govjpegpath(1:length(govjpegpath)-1)]);
    imdata = imread('CloudTopHeightsRqmts.jpg');
    [nhigh,nwid,ndepth]=size(imdata);
    image = mlreportgen.report.FormalImage();
    image.Image = which('CloudTopHeightsRqmts.jpg');
    textpdf = Text('Cloud Top Heights Algorithm Characteristics');
    textpdf.Color = 'red';
    image.Caption = textpdf;
    heightstr=strcat(num2str(nhigh/2),'px');
    widthstr=strcat(num2str(nwid/2),'px');
    image.Height = heightstr;
    image.Width = widthstr;
    image.ScaleToFit=0;
    add(chapter,image); 
    parastr1='The Table shown above shows some of the key charcteristics that are used in calculating';
    parastr2=' the cloud top heights for full disk or Conus only image scans.';
    parastr3=strcat(parastr1,parastr2);
    p1 = Paragraph(parastr3);
    p1.Style = {OuterMargin("0pt", "0pt","0pt","10pt")};
    add(chapter,p1);
end
JpegCounter=JpegCounter+1;
JpegFileList{JpegCounter+1,1}=figstr;
JpegFileList{JpegCounter+1,2}=jpegpath;
close('all');
fprintf(fid,'%s\n','------- Finished Plotting Cloud Top Data For CONUS ------');
end


