function DisplayCMIMesoDataRev2(CMI,titlestr)
% Display the CMI Moisture Data from the GOES16/17 data
% on a texture map for the USA for the multiband images
% Written By: Stephen Forczyk
% Created: April 13,2021
% Revised: ------
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
global minCMI meanCMI maxCMI CMI99;
global NumProcFiles ProcFileList;
global RptGenPresent iCreatePDFReport pdffilename rpt chapter;
global JpegCounter JpegFileList isavefiles;

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
global trajpath militarypath gridpath;
global figpath screencapturepath;
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
numrasterlon=length(xS.values);
numrasterlat=length(yS.values);
numvals=numrasterlon*numrasterlat;
xx=xS.values;
yy=yS.values;
RasterLats=zeros(numrasterlon,numrasterlat);
RasterLons=RasterLats;
waitstr='Calculating Geographic Raster';
h=waitbar(0,waitstr);
tic;
for jj=1:numrasterlat
    for kk=1:numrasterlon
        [GeodLat,GeodLon] = CalculateGeodCoordFromXYPosRev1(xx(kk,1),yy(jj,1));
        RasterLats(jj,kk)=GeodLat;
        RasterLons(jj,kk)=GeodLon;
    end
    waitbar(jj/numrasterlat);
end
close(h);
elapsed_time=toc;
dispstr=strcat('Calculating the Raster took-',num2str(elapsed_time,5),'-sec');
disp(dispstr)
GridMatFileName='ComputedInPlace';
% eval(['cd ' gridpath(1:length(gridpath)-1)]);
% %[GridMatFileName,path]=uigetfile('*mat','Select one Raster Grid File');%
% GridMatFileName='GOES16-CONUS-Lat-Lon-Boundaries.mat';
% load(GridMatFileName,'RasterLats','RasterLons');
% dispstr=strcat('Loaded Grid Raster File-',GridMatFileName);
% disp(dispstr)
gridstr1=strcat('Computed Mapping Grid for Meso data-time required=',num2str(elapsed_time,6),'-sec');
fprintf(fid,'%s\n',gridstr1);
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
scalebarlen=300;
scalebarloc='sw'; % location of scale (sw=southwest)
TotalStr=strcat('Year-',num2str(YearS,4),'-',MonthDayStr,'-Hr-',num2str(HourS,2),'-Min-',num2str(MinuteS,2),'-Sec-',num2str(SecondS));
axesm ('mercator','Frame','on','Grid','on','MapLatLimit',[southEdge northEdge],...
     'MapLonLimit',[westEdge eastEdge],'meridianlabel','on','parallellabel','on','plabellocation',2,'mlabellocation',2,...
     'MLabelParallel','south','Frame','on','FontColor','b');
gridm('GLineStyle','-','Gcolor',[.8 .7 .6],'Galtitude',.002,'MLineLocation',2,...
     'PLineLocation',2)
set(gcf,'MenuBar','none');
set(gcf,'Position',[hor1 vert1 widd lend])
RasterLats=RasterLats';
RasterLons=RasterLons';
geoshow(RasterLats,RasterLons,CMI,'DisplayType','texturemap');
demcmap(CMI,256)
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
set(gcf,'Position',[hor1 vert1 widd lend])
title(titlestr)
hold off
scalebar('length',scalebarlen,'units','mi','color','r','location',scalebarloc,'fontangle','bold','RulerStyle','patches');
tightmap;
hc=colorbar;
% Added some labels at the bottom
newaxesh=axes('Position',[0 0 1 1]);
set(newaxesh,'XLim',[0 1],'YLim',[0 1]);
Pos=get(hc,'Position');
PosyL=.80*Pos(1,2);
PosyU=1.03*(Pos(1,2)+Pos(1,4));
tx1=.13;
ty1=PosyL-.045;
tx3=tx1;
ty3=ty1-.02;
txtstr1=strcat('Start Scan Time-',TotalStr);
txt1=text(tx1,ty1,txtstr1,'FontWeight','bold','FontSize',10);
tx2=.58;
ty2=ty1;
txtstr2=strcat('Day Of Year-',num2str(DayS),'-Calendar Date-',MonthDayYearStr);
txt2=text(tx2,ty2,txtstr2,'FontWeight','bold','FontSize',10);
tx3=tx1;
ty3=ty2-.03;
txtstr3=strcat('westEdge-',num2str(westEdge,6),'-eastEdge',num2str(eastEdge,6),'-in Deg Lon');
txt3=text(tx3,ty3,txtstr3,'FontWeight','bold','FontSize',10);
tx4=.58;
ty4=ty3;
txtstr4=strcat('southEdge-',num2str(southEdge,6),'-northEdge',num2str(northEdge,6),'-in Deg Lat');
txt4=text(tx4,ty4,txtstr4,'FontWeight','bold','FontSize',10);
tx5=.825;
ty5=PosyU+.01;
txt5=text(tx5,ty5,'CMI-RGB','FontWeight','bold','FontSize',10);
set(newaxesh,'Visible','Off');

figstr=strcat(titlestr,'.jpg');
eval(['cd ' jpegpath(1:length(jpegpath)-1)]);
actionstr='print';
typestr='-djpeg';
[cmdString]=MyStrcat2(actionstr,typestr,figstr);
eval(cmdString);
pause(chart_time);
if((iCreatePDFReport==1) && (RptGenPresent==1))
    [ibreak]=strfind(GOESFileName,'_e');
    is=1;
    ie=ibreak(1)-1;
    GOESShortFileName=GOESFileName(is:ie);
    headingstr1=strcat('ABI CMI True Color Output For File-',GOESShortFileName);
    chapter = Chapter("Title",headingstr1);
    add(chapter,Section('True Color CONUS Level Earth Image'));
    imdata = imread(figstr);
    [nhigh,nwid,ndepth]=size(imdata);
    image = mlreportgen.report.FormalImage();
    image.Image = which(figstr);
    pdftxtstr=strcat('True Color Image For File-',GOESShortFileName);
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
% Now add some text 
    parastr1=strcat('The Data for this chart was from file-',GOESShortFileName,'.');
    parastr2=strcat(' This product uses the CMI Reflectance values in 3 separate wavebands 2,3 and 1 to produce a',...
        ' Composite True Color Image from three separate images.','The purpose is to create a scene representative of',...
        ' an RGB image in visible light.','Band 2 is used for the R values,Band 3 for the G values and the Band 1 for B.');
    parastr3=strcat(parastr1,parastr2);
    p1 = Paragraph(parastr3);
    p1.Style = {OuterMargin("0pt", "0pt","0pt","10pt")};
    add(chapter,p1);
    parastr4='In making this image the R ,G and B values have been clipped so that their values range from 0 to 1.';
    parastr5='The Final RGB image will be the sum of these three components with corrections so the final value must between 0 and 3.';
    parastr6='Prior to summing the RGB components they are individually divided by a gamma correction factor of 2.2 .';
    parastr7='To get the final image the final RGB value= 0.45 * R + 0.1 * G + 0.45 * B .';
    parastr8='Representing the data in this way and with the selected color map the most dense clouds appear a reddish brown.';
    parastr9=strcat(parastr4,parastr5,parastr6,parastr7,parastr8);
    p2 = Paragraph(parastr9);
    p2.Style = {OuterMargin("0pt", "0pt","0pt","10pt")};
    add(chapter,p2);
end
close('all');
end


