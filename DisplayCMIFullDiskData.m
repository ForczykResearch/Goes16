function DisplayCMIFullDiskData(CMI,titlestr)
% Display the CMI Moisture Data from the GOES16/17 data
% on a texture map for the FullDisk archive for the multiband images
% Written By: Stephen Forczyk
% Created: August 30,2020
% Revised: Sept 6,2020 made changes to producde correct plot
% Revised: Jan 7,2021 to create PDF output
% Revised: Jan 16,2021 add TOC data to PDF Report
% Classification: Unclassified
global BandDataS MetaDataS;
global CMIS DQFS tS yS xS tBS goesImagerS yImgS yImgBS;
global xImgS xImgBS SatDataS GeoSpatialS;
global ReflectanceS AlgoS ErrorS EarthSunS VersionContainerS;
global GoesWaveBand ESunS kappa0S PlanckS FocalPlaneS;
global HTS DQF1S OutlierPS CloudTopS Algo1S ProcessParamS;
global LZAS LZABS SZAS SZABS Error1S CloudPixelsS;
global GOESFileName MapFormFactor;
global westEdge eastEdge northEdge southEdge;
global MonthDayStr MonthDayYearStr;
global DayMonthNonLeapYear DayMonthLeapYear CalendarFileName;
global NumProcFiles ProcFileList;
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
global trajpath militarypath datapath;
global figpath screencapturepath gridpath;
global shapepath2 countrypath countryshapepath usstateboundariespath;
global GOES16Band1path GOES16Band2path GOES16Band3path GOES16Band4path;
global GOES16Band5path GOES16Band6path GOES16Band7path GOES16Band8path
global GOES16Band9path GOES16Band10path GOES16Band11path GOES16Band12path;
global GOES16Band13path GOES16Band14path GOES16Band15path GOES16Band16path;
global GOES16CloudTopHeightpath GOES16BandPaths;
global RasterLats RasterLons;

if((iCreatePDFReport==1) && (RptGenPresent==1))
    import mlreportgen.dom.*;
    import mlreportgen.report.*;
end
fprintf(fid,'%s\n','-----Create Full Disk True Color Image-----');
% Load the Lat lon Values for the Grid Lat/Lon
eval(['cd ' gridpath(1:length(gridpath)-1)]);
GridMatFileName='GOES16-FullDisk-Lat-Lon-Boundaries.mat';
load(GridMatFileName,'RasterLats','RasterLons');
dispstr=strcat('Loaded Grid Raster File-',GridMatFileName);
disp(dispstr)
% Get the size limits
[nrows,ncols]=size(CMI);
% Fetch the map limits
westEdge=double(GeoSpatialS.geospatial_westbound_longitude);
eastEdge=double(GeoSpatialS.geospatial_eastbound_longitude);
southEdge=double(GeoSpatialS.geospatial_southbound_latitude);
northEdge=double(GeoSpatialS.geospatial_northbound_latitude);
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
TotalStr=strcat('Year-',num2str(YearS,4),'-',MonthDayStr,'-Hr-',num2str(HourS,2),'-Min-',num2str(MinuteS,2),'-Sec-',num2str(SecondS));
axesm ('globe','Frame','on','Grid','on','meridianlabel','on','parallellabel','on','plabellocation',10,'mlabellocation',20);
gridm('GLineStyle','-','Gcolor',[.8 .7 .6],'Galtitude',.002,'MLineLocation',10,...
     'PLineLocation',5)
CMI=CMI-1;
set(gcf,'MenuBar','none');
set(gcf,'Position',[hor1 vert1 widd lend])
geoshow(RasterLats,RasterLons,CMI,'DisplayType','texturemap');
demcmap(CMI,256);
hold on
eval(['cd ' mappath(1:length(mappath)-1)]);
% load the country borders and plot them
eval(['cd ' mappath(1:length(mappath)-1)]);
load('USAHiResBoundaries.mat','USALat','USALon');
plotm(USALat,USALon,'r');
load('CanadaBoundaries.mat','CanadaLat','CanadaLon');
plotm(CanadaLat,CanadaLon,'r');
load('MexicoBoundaries.mat','MexicoLat','MexicoLon');
plotm(MexicoLat,MexicoLon,'r');
load('CubaBoundaries.mat','CubaLat','CubaLon');
plotm(CubaLat,CubaLon,'r');
load('DominicanRepublicBoundaries.mat','DRLat','DRLon');
plotm(DRLat,DRLon,'r');
load('HaitiBoundaries.mat','HaitiLat','HaitiLon');
plotm(HaitiLat,HaitiLon,'r');
load('BelizeBoundaries.mat','BelizeLat','BelizeLon');
plotm(BelizeLat,BelizeLon,'r');
load('GautemalaBoundaries.mat','GautemalaLat','GautemalaLon');
plotm(GautemalaLat,GautemalaLon,'r')
load('JamaicaBoundaries.mat','JamaicaLat','JamaicaLon');
plotm(JamaicaLat,JamaicaLon,'r');
load('NicaraguaBoundaries.mat','NicaraguaLat','NicaraguaLon');
plotm(NicaraguaLat,NicaraguaLon,'r')
load('HondurasBoundaries.mat','HondurasLat','HondurasLon');
plotm(HondurasLat,HondurasLon,'r')
load('ElSalvadorBoundaries.mat','ElSalvadorLat','ElSalvadorLon');
plotm(ElSalvadorLat,ElSalvadorLon,'r');
load('PanamaBoundaries.mat','PanamaLat','PanamaLon');
plotm(PanamaLat,PanamaLon,'r');
load('ColumbiaBoundaries.mat','ColumbiaLat','ColumbiaLon');
plotm(ColumbiaLat,ColumbiaLon,'r');
load('VenezuelaBoundaries.mat','VenezuelaLat','VenezuelaLon');
plotm(VenezuelaLat,VenezuelaLon,'r')
load('PeruBoundaries.mat','PeruLat','PeruLon');
plotm(PeruLat,PeruLon,'r');
load('EcuadorBoundaries.mat','EcuadorLat','EcuadorLon');
plotm(EcuadorLat,EcuadorLon,'r')
load('BrazilBoundaries.mat','BrazilLat','BrazilLon');
plotm(BrazilLat,BrazilLon,'r');
load('BoliviaBoundaries.mat','BoliviaLat','BoliviaLon');
plotm(BoliviaLat,BoliviaLon,'r')
load('ChileBoundaries.mat','ChileLat','ChileLon');
plotm(ChileLat,ChileLon,'r');
load('ArgentinaBoundaries.mat','ArgentinaLat','ArgentinaLon');
plotm(ArgentinaLat,ArgentinaLon,'r');
load('UruguayBoundaries.mat','UruguayLat','UruguayLon');
plotm(UruguayLat,UruguayLon,'r');
load('CostaRicaBoundaries.mat','CostaRicaLat','CostaRicaLon');
plotm(CostaRicaLat,CostaRicaLon,'r');
load('FrenchGuianaBoundaries.mat','FrenchGuianaLat','FrenchGuianaLon');
plotm(FrenchGuianaLat,FrenchGuianaLon,'r');
load('GuyanaBoundaries.mat','GuyanaLat','GuyanaLon');
plotm(GuyanaLat,GuyanaLon,'r');
load('SurinameBoundaries.mat','SurinameLat','SurinameLon');
plotm(SurinameLat,SurinameLon,'r');
camposm(0,-75,3);
set(gcf,'Position',[hor1 vert1 widd lend])
title(titlestr)
hold off
hc=colorbar;
% Added some labels at the bottom
newaxesh=axes('Position',[0 0 1 1]);
set(newaxesh,'XLim',[0 1],'YLim',[0 1]);
tx1=.16;
ty1=.10;
txtstr1=strcat('Start Scan Time-',TotalStr);
txt1=text(tx1,ty1,txtstr1,'FontWeight','bold','FontSize',10);
tx2=.54;
ty2=.10;
txtstr2=strcat('Day Of Year-',num2str(DayS));
txt2=text(tx2,ty2,txtstr2,'FontWeight','bold','FontSize',10);
tx3=.16;
ty3=.08;
txtstr3=strcat('westEdge-',num2str(westEdge,6),'-eastEdge',num2str(eastEdge,6),'-in Deg Lon');
txt3=text(tx3,ty3,txtstr3,'FontWeight','bold','FontSize',10);
tx4=.16;
ty4=.06;
txtstr4=strcat('southEdge-',num2str(southEdge,6),'-northEdge',num2str(northEdge,6),'-in Deg Lat');
txt4=text(tx4,ty4,txtstr4,'FontWeight','bold','FontSize',10);
tx5=.86;
ty5=.95;
txt5=text(tx5,ty5,'RGB-1','FontWeight','bold','FontSize',10);
set(newaxesh,'Visible','Off');
% Save this chart
figstr=strcat(titlestr,'.jpg');
eval(['cd ' jpegpath(1:length(jpegpath)-1)]);
actionstr='print';
typestr='-djpeg';
[cmdString]=MyStrcat2(actionstr,typestr,figstr);
eval(cmdString);
pause(chart_time);
close('all');
if((iCreatePDFReport==1) && (RptGenPresent==1))
    [ibreak]=strfind(GOESFileName,'_e');
    is=1;
    ie=ibreak(1)-1;
    GOESShortFileName=GOESFileName(is:ie);
    headingstr1=strcat('ABI True Color Full Disk Output For File-',GOESShortFileName);
    chapter = Chapter("Title",headingstr1);
    add(chapter,Section('Full Disk True Color Earth Image'));
    imdata = imread(figstr);
    [nhigh,nwid,ndepth]=size(imdata);
    image = mlreportgen.report.FormalImage();
    image.Image = which(figstr);
    pdftxtstr=strcat('Earth Surface RGB For File-',GOESShortFileName);
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
    parastr2=strcat(parastr1,GOESShortFileName,'.');
    parastr3=strcat('The CMI dataset has-',num2str(nrows),'-rows and-',num2str(ncols),'-columns of data.');
    parastr4=strcat('The mapping grid used was from file-',GridMatFileName,'.');
    parastr5=strcat(parastr2,parastr3,parastr4);
    p1 = Paragraph(parastr5);
    p1.Style = {OuterMargin("0pt", "0pt","0pt","10pt")};
    add(chapter,p1);
%     parastr3=strcat('The CMI dataset has-',num2str(nrows),'-rows and-',num2str(ncols),'-columns of data.');
%     parastr4=strcat('The mapping grid used was from file-',GridMatFileName,'.');
%     parastr5=strcat(parastr3,parastr4);
%     p2 = Paragraph(parastr5);
%     p2.Style = {OuterMargin("0pt", "0pt","0pt","10pt")};
%     add(chapter,p2);
    parastr10='This chart shows the Cloud Moisture Data taken from bands 2 3 and 1 to make an RGB true color image.';
    parastr11=' The first line provides the time the scan was created and the scan boundaries are shown below that.';
    parastr12=strcat(' The Map Scale is-',MapFormFactor);
    parastr13=' The color scale is based on the composite-3 color RGB values-1,this was done to make the non sunlight areas black';
    parastr=strcat(parastr10,parastr11,parastr12,parastr13);
    p3 = Paragraph(parastr);
    p3.Style = {OuterMargin("0pt", "0pt","0pt","10pt")};
    add(chapter,p3);
end
fprintf(fid,'%s\n','-----Finished Full Disk True Color Image-----');


