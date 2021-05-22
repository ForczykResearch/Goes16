function [VAM1DSF,sgoodfrac]=DisplayVolcanicMassLoadingFullDiskData(titlestr)
% Display the Volcanic Ash MASS lOADING Data from the GOES16/17 data
% on a texture map for the FullDisk 
% Written By: Stephen Forczyk
% Created: March 04,2021
% Revised: 
% Classification: Unclassified
global MetaDataS;
global VAHS VAMLS ;
global AshMassLoadTotMassS CountAttAshRetS;
global AshHtOutlierPixCountS AshMassOutlierPixCountS;
global AshCloudHtStatS AshMassStatS AshExistConfAngS;
global DET_DQFS RET_DQFS;
global tS yS xS tBS goesImagerS;
global SatDataS GeoSpatialS;
global AlgoS GoesWaveBand;
global AlgoProdVersionContainerS ProcessParamS;
global QLZAS  QLZABS;
global RLZAS RLZABS;
global SZAS SZABS;
global GRBErrorsS L0ErrorsS;
global GOESFileName;
global RasterLats RasterLons;
global westEdge eastEdge northEdge southEdge;
global MonthDayStr MonthDayYearStr;
global DayMonthNonLeapYear DayMonthLeapYear CalendarFileName;
global NumProcFiles ProcFileList;
global RptGenPresent iCreatePDFReport pdffilename rpt chapter;
global JpegCounter JpegFileList;
global DQFHdr DQFTable MiscHdr MiscTable RqmtsHdr RqmtsTable;
global DQFCauses DQFNormed DQFLabels;
global DQFHdr2 DQFTable2 AshHdr AshSizeTable;
global VAM2;

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
fprintf(fid,'%s\n','-----Create Full Disk Volcanic Ash Mass Loading plot-----');
% Load the Lat lon Values for the Grid Lat/Lon
eval(['cd ' gridpath(1:length(gridpath)-1)]);
GridMatFileName='GOES16-FullDisk-Lat-Lon-Boundaries.mat';
load(GridMatFileName,'RasterLats','RasterLons');
% Get the size limits
VAM=VAMLS.values;
[nrows,ncols]=size(VAM);
VAM1D=reshape(VAM,nrows*ncols,1);
VAM1DS=sort(VAM1D);
[ilow]=find(VAM1DS<0);
a1=isempty(ilow);
if(a1==0)
    numlow=length(ilow);
else
    numlow=0;
end
a1=isnan(VAM1DS);
numnan=sum(a1);
numvals2=(nrows*ncols)-(numnan+1);
VAM1DSF=zeros(numvals2,1);
for k=1:numvals2
    VAM1DSF(k,1)=VAM1DS(k,1);
end
sgoodfrac=numvals2/(nrows*ncols);
VAMmin=VAM1DSF(1,1);
VAMmax=VAM1DSF(numvals2,1);
VAM2=VAM;
[ilow,jlow]=find(VAM2<=0.2);
a1=isempty(ilow);
if(a1==0)
    for ii=1:ilow
        for jj=1:jlow
            val=VAM2(ii,jj);
            if(val<=0.2)
                val=val-0.5;
                VAM2(ii,jj)=val;
            end
        end
    end
end
statstr1=strcat('Minimum Value VAM=',num2str(VAMmin,4),'-Max Value VAM=',num2str(VAMmax,4));
fprintf(fid,'%s\n',statstr1);
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
ha=axesm('globe','Frame','on','Grid','on','meridianlabel','off','parallellabel','on','plabellocation',10,'mlabellocation',[]);
gridm('GLineStyle','-','Gcolor',[.8 .7 .6],'Galtitude',.002,'MLineLocation',10,...
     'PLineLocation',5);
framem('FlineWidth',4,'FEdgeColor','yellow')
set(gcf,'MenuBar','none');
set(gcf,'Position',[hor1 vert1 widd lend])
geoshow(RasterLats,RasterLons,VAM2,'DisplayType','texturemap');
demcmap(VAM2,256);
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

tx5=.86;
ty5=.95;
txt5=text(tx5,ty5,'VAM-tons/m^2','FontWeight','bold','FontSize',10);
set(newaxesh,'Visible','Off');
% Save this chart
figstr=strcat(titlestr,'.jpg');
eval(['cd ' jpegpath(1:length(jpegpath)-1)]);
actionstr='print';
typestr='-djpeg';
[cmdString]=MyStrcat2(actionstr,typestr,figstr);
eval(cmdString);
pause(chart_time);
JpegCounter=JpegCounter+1;
JpegFileList{JpegCounter+1,1}=figstr;
JpegFileList{JpegCounter+1,2}=jpegpath;
close('all');
if((iCreatePDFReport==1) && (RptGenPresent==1))
    [ibreak]=strfind(GOESFileName,'_e');
    is=1;
    ie=ibreak(1)-1;
    GOESShortFileName=GOESFileName(is:ie);
%     headingstr1=strcat('Volcanic Dust Data For File-',GOESShortFileName);
%     chapter = Chapter("Title",headingstr1);
    add(chapter,Section('Volcanic Dust Cloud Mass Loading'));
    imdata = imread(figstr);
    [nhigh,nwid,ndepth]=size(imdata);
    image = mlreportgen.report.FormalImage();
    image.Image = which(figstr);
    pdftxtstr=strcat('Dust Cloud Mass Loading For File-',GOESShortFileName);
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
    parastr121=strcat('The Data for this chart was from file-',GOESShortFileName,'.');
    parastr122=strcat('The image is made up of-',num2str(nrows),'-rows and-',num2str(ncols),'-cols of data.');
    parastr123='Volcanic Dust Mass Loading (VAML) is calculated from the ABI image data and uses the VAA or Volcanic Ash Algorithm.';
    parastr124=strcat('Primarily the VAA uses data from 5 ABI channels which are 10,11,14,15 and 16.','These are in the LWIR region and thus can operate day or night.');
    parastr125='The VAA uses this data to estimate pixels likely to have volcanic ash and then proceeds to calculate the height of the cloud and the mass per unit area.';
    parastr129=strcat(parastr121,parastr122,parastr123,parastr124,parastr125);
    p13 = Paragraph(parastr129);
    p13.Style = {OuterMargin("0pt", "0pt","10pt","10pt")};
    add(chapter,p13);
%     br = PageBreak();
%     add(chapter,br);
%    add(rpt,chapter);
end
fprintf(fid,'%s\n','-----Finished Full Disk Volcanic Ash Cloud Mass Loading plot-----');


