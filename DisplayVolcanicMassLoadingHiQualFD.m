function DisplayVolcanicMassLoadingHiQualFD(titlestr)
% Display the Volcanic Ash MASS lOADING Data from the GOES16/17 data
% on a texture map for the FullDisk . Multiply by the HiQuality mask
% to show just those pixels that hi quality data for a single ash cloud
% Written By: Stephen Forczyk
% Created: March 06,2021
% Revised: ----------
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
global HiQualSLayerAsh VAM2;

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
fprintf(fid,'%s\n','-----Create Full Disk Volcanic Ash Mass Loading Using Just Hi Quality Data plot-----');
% Load the Lat lon Values for the Grid Lat/Lon
eval(['cd ' gridpath(1:length(gridpath)-1)]);
GridMatFileName='GOES16-FullDisk-Lat-Lon-Boundaries.mat';
load(GridMatFileName,'RasterLats','RasterLons');
% Get the size limits
VAM=VAMLS.values;
[nrows,ncols]=size(VAM);
VAM3=VAM2;
% Now multiply this element by element except do not change negative values
numhicert=0;
for jj=1:nrows
    for kk=1:ncols
        val1=VAM2(jj,kk);
        val2=HiQualSLayerAsh(jj,kk);
        if((val1>0) && (val2>0))
            val3=val1*val2;
            numhicert=numhicert+1;
        else
            val3=-1;
        end
        VAM3(jj,kk)=val3;
    end
end
VAM3min=min(min(VAM3));
VAM3med=median(median(VAM3));
VAM3max=max(max(VAM3));
statstr1=strcat('Minimum Value VAM3=',num2str(VAM3min,4),'-Median Value VAM3=',num2str(VAM3med,4),...
    '-Max Value VAM3=',num2str(VAM3max,4));
fprintf(fid,'%s\n',statstr1);
statstr2=strcat('Number of HiCertainty single layer dust cloud point=',num2str(numhicert));
fprintf(fid,'%s\n',statstr2);
% Get stats on just this high certainty group
VAMHiCert=zeros(numhicert,1);
numhicert2=0;
for jj=1:nrows
    for kk=1:ncols
        val1=VAM2(jj,kk);
        val2=HiQualSLayerAsh(jj,kk);
        if((val1>0) && (val2>0))
            val3=val1*val2;
            numhicert2=numhicert2+1;
            VAMHiCert(numhicert2,1)=val3;
        end

    end
end
VAMHiCertmin=min(VAMHiCert);
VAMHiCertmed=median(VAMHiCert);
VAMHiCertmax=max(VAMHiCert);
statstr3=strcat('Minimum Value VAMHiCert=',num2str(VAMHiCertmin,4),'-Median Value VAMHiCert=',num2str(VAMHiCertmed,4),...
    '-Max Value VAMHiCert=',num2str(VAMHiCertmax,4));
fprintf(fid,'%s\n',statstr3);
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
movie_figure1=figure('position',[hor1 vert1 widd lend],'Color','white');
ha=axesm('globe','Frame','on','Grid','on','meridianlabel','off','parallellabel','on','plabellocation',10,'mlabellocation',[]);
hg=gridm('GLineStyle','-','Gcolor',[.8 .7 .6],'Galtitude',.002,'MLineLocation',10,...
     'PLineLocation',5);
hf=framem('FlineWidth',4,'FEdgeColor','yellow');
set(gcf,'MenuBar','none');
set(gcf,'Position',[hor1 vert1 widd lend]);
% set(ha,'Color',[0.3 0.3 0.3]);
% setm(ha,'fontcolor',[1 0 0]);
geoshow(RasterLats,RasterLons,VAM3,'DisplayType','texturemap');
cmapsea  = [0  0 .5; 0 0.5 .8];
cmapland = [0 1 0; 1 .5 0];
demcmap(VAM3,256,cmapsea,cmapland)
hc=colorbar;
%demcmap(VAM3,256);
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
% Added some labels at the bottom
newaxesh=axes('Position',[0 0 1 1]);
set(newaxesh,'XLim',[0 1],'YLim',[0 1]);
tx1=.16;
ty1=.10;
txtstr1=strcat('Start Scan Time-',TotalStr);
txt1=text(tx1,ty1,txtstr1,'FontWeight','bold','FontSize',10);
tx2=.60;
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
    add(chapter,Section('Volcanic HiQual Dust Cloud Loading'));
    imdata = imread(figstr);
    [nhigh,nwid,ndepth]=size(imdata);
    image = mlreportgen.report.FormalImage();
    image.Image = which(figstr);
    pdftxtstr=strcat('Dust Cloud Loading For File-',GOESShortFileName);
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
    parastr126=strcat('A major difference between this chart and the earlier chart on the VAML is that this one was redrawn to included only those pixels',...
        ' that had high confidence of belonging to a single layer ash cloud.','As a result this chart had only-',num2str(numhicert2),'-ash pixels plotted.');
    parastr129=strcat(parastr121,parastr122,parastr123,parastr124,parastr125,parastr126);
    p13 = Paragraph(parastr129);
    p13.Style = {OuterMargin("0pt", "0pt","10pt","10pt")};
    add(chapter,p13);
%     br = PageBreak();
%     add(chapter,br);
    add(rpt,chapter);
end
fprintf(fid,'%s\n','-----Finished Full Disk Volcanic Ash Mass Loading Using Just Hi Quality Data plot-----');


