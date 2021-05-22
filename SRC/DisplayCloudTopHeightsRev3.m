function  DisplayCloudTopHeightsRev3(HT,titlestr)
% Display the cloud top heights from the GOES16/17 data
% Project this data on a equiconic section map
% This uses the Full Disk data projection
% Written By: Stephen Forczyk
% Created: Sept 3,2020
% Revised: Nov 25,2020 made many changes to make the display just like
%          DisplayCloudTopHeightsRev2 execept for the full disk
% Revised: Jan 8,2021 added code to create PDF input
% Revised: Mar 31,2021 added tightmap command and plotted an adjusted
% Height array where NaN values were turned slightly negative
% Classification: Unclassified
global BandDataS MetaDataS;
global HTS DQFS tS yS xS tBS goesImagerS yImgS yImgBS;
global xImgS xImgBS SatDataS GeoSpatialS;
global ReflectanceS AlgoS ErrorS EarthSunS VersionContainerS;
global GoesWaveBand ESunS kappa0S PlanckS FocalPlaneS;
global HTS DQF1S OutlierPS CloudTopS Algo1S ProcessParamS;
global LZAS LZABS SZAS SZABS Error1S CloudPixelsS;
global GOESFileName MapFormFactor;
global MonthDayStr MonthDayYearStr;
global DayMonthNonLeapYear DayMonthLeapYear CalendarFileName;
global westEdge eastEdge northEdge southEdge;
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
global trajpath militarypath;
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
fprintf(fid,'%s\n','------- Plot Cloud Top Data For Full Disk ------');
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

% Get data about the height array
[nrows,ncols]=size(HT);
HT=HT/1000;
HTAdj=HT;
HTL=isnan(HT);
for i=1:nrows
    for j=1:ncols
       nowval=HTL(i,j);
       if(nowval==1)
           HTAdj(i,j)=-0.1;
       end
    end
end
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
% Set up the map axis
axesm ('globe','Frame','on','Grid','on','meridianlabel','off','parallellabel','on',...
    'plabellocation',[-60 -50 -40 -30 -20 -10 0 10 20 30 40 50 60],'mlabellocation',[]);
%setm(handle, 'MlabelParallel', 'south');
set(gcf,'MenuBar','none');
set(gcf,'Position',[hor1 vert1 widd lend])
geoshow(RasterLats,RasterLons,HTAdj','DisplayType','texturemap');
demcmap(HTAdj',256);
hold on
camposm(0,-75,3);
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
title(titlestr)
hold off
tightmap;
hc=colorbar;
% Set up another axis to write additional data
newaxesh=axes('Position',[0 0 1 1]);
set(newaxesh,'XLim',[0 1],'YLim',[0 1]);
Pos=get(hc,'Position');
PosyL=.80*Pos(1,2);
PosyU=1.03*(Pos(1,2)+Pos(1,4));
tx2=.99*Pos(1,1);
ty2=PosyU;
txt2=text(tx2,ty2,'Alt-km','FontWeight','bold','FontSize',12);
tx4=.13;
ty4=PosyL-.04;
txtstr4=strcat('HT-Km 1%-',num2str(val01,3),'-HT-Km 50%-',...
    num2str(val50,3),'-HT-Km 99%-',num2str(val99,3),'-----',MonthDayYearStr);
txt4=text(tx4,ty4,txtstr4,'FontWeight','bold','FontSize',12);
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
    headingstr1=strcat('Cloud Top Heights For File-',GOESShortFileName);
    chapter = Chapter("Title",headingstr1);
    add(chapter,Section('Full Disk Cloud Top Heights'));
    imdata = imread(figstr);
    [nhigh,nwid,ndepth]=size(imdata);
    image = mlreportgen.report.FormalImage();
    image.Image = which(figstr);
    pdftxtstr=strcat('Cloud Top Heights For File-',GOESShortFileName);
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
% Now add some text 
    parastr1=strcat('The Data for this chart was from file-',GOESShortFileName,'.');
    parastr2=' This chart shows the cloud top heights for cloudy pixels in km.';
    parastr3=' Clear pixels or pixels that have no measured values map into light blue.';
    parastr4='This adjustment was primarily accomplished by turning values to a small negative number-this does not affect the statistics.';
    parastr9=strcat(parastr1,parastr2,parastr3,parastr4);
    p1 = Paragraph(parastr9);
    p1.Style = {OuterMargin("0pt", "0pt","0pt","10pt")};
    add(chapter,p1);
end
fprintf(fid,'%s\n','------- Finished Plotting Cloud Top Data For Full Disk ------');

end


