function  [DSR1DSF,sgoodfrac]=DisplayConusDSR(titlestr)
% Display the Downwards Short Wave Radiation on CONUS scale
% Project this data on a equiconic section map
% Note this routine is basically the same as DisplayCloudTopHeightsRev2.,
% Written By: Stephen Forczyk
% Created: Feb 25,2021
% Revised: Feb 26,2021 continued development of this routine
% Classification: Unclassified

global MetaDataS;
global DSRS DSRWaveS DSRWaveBS ImageCloudFracS;
global DQFS;
global RetPixelCountS LZAPixelCountS OutlierPixelCountS;
global LatS LonS;
global tS yS xS tBS goesImagerS LatImgS LatImgBS;
global LonImgS LonImgBS SatDataS GeoSpatialS;
global AlgoS GoesWaveBand;
global AlgoProdVersionContainerS ProcessParamS;
global QLZAS  QLZABS;
global RSZAS QSZAS RSZABS QSZABS;
global RLZAS RLZABS;
global SZAStatS DSRStatS;
global GRBErrorsS L0ErrorsS;
global westEdge eastEdge northEdge southEdge;
global GOESFileName;
global RasterLats RasterLons;
global idebug isavefiles;
global RptGenPresent iCreatePDFReport pdffilename rpt chapter;
global JpegCounter JpegFileList;
global DayMonthNonLeapYear DayMonthLeapYear CalendarFileName;
global DQFHdr DQFTable MiscHdr MiscTable RqmtsHdr RqmtsTable;
global DQFCauses DQFNormed DQFLabels;


global widd2 lend2;
global initialtimestr igrid ijpeg ilog imovie;
global vert1 hor1 widd lend;
global vert2 hor2 machine;
global chart_time;
global Fz1 Fz2;
global idirector mov izoom iwindow;
global matpath GOES16path;
global jpegpath fid;
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
fprintf(fid,'\n');
fprintf(fid,'%s\n','-----Start plot routine Display CONUS Downwards ShortWave Radiation-----');
eval(['cd ' gridpath(1:length(gridpath)-1)]);
Latvals=LatS.values;
Lonvals=LonS.values;
[nrows,ncols]=size(DSRS.values);
RasterLats=zeros(nrows,ncols);
RasterLons=zeros(nrows,ncols);
% now build the RasterLat and RasterLon arrays from this data
for i=1:nrows
    nowlat=Latvals(1,i);
    for j=1:ncols
        RasterLats(i,j)=nowlat;
        nowlon=Lonvals(1,j);
        RasterLons(i,j)=nowlon;
    end
end
bounds=DSRWaveBS.values;
lb=bounds(1,1);
ub=bounds(2,1);
CloudFrac=ImageCloudFracS.values;
ntotpixels=nrows*ncols;
gridstr1=strcat('Built Map Grid From LatS and LonS data which had nrows=',num2str(nrows),'-and-',num2str(ncols),'-cols of data');
fprintf(fid,'%s\n',gridstr1);
infostr1=strcat('WaveBand Lower Limit=',num2str(lb,4),'-Upper Limit=',num2str(ub,4),'-in microns');
fprintf(fid,'%s\n',infostr1);
infostr2=strcat('Cloud Fraction=',num2str(CloudFrac,5));
fprintf(fid,'%s\n',infostr2);
DSR=DSRS.values;
DSR1D=reshape(DSR,nrows*ncols,1);
DSR1DS=sort(DSR1D);
[ilow]=find(DSR1DS<0);
a1=isempty(ilow);
if(a1==0)
    numlow=length(ilow);
else
    numlow=0;
end
a1=isnan(DSR1DS);
numnan=sum(a1);
numvals2=(nrows*ncols)-(numnan+1);
DSR1DSF=zeros(numvals2,1);
for k=1:numvals2
    DSR1DSF(k,1)=DSR1DS(k,1);
end
sgoodfrac=numvals2/(nrows*ncols);
DSRmin=DSR1DSF(1,1);
DSRmax=DSR1DSF(numvals2,1);
statstr1=strcat('Minimum Value DSR=',num2str(DSRmin,6),'-Max Value DSR=',num2str(DSRmax,6));
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
axesm ('pcarree','Frame','on','Grid','on','MapLatLimit',[southEdge northEdge],...
     'MapLonLimit',[westEdge eastEdge],'meridianlabel','on','parallellabel','on','plabellocation',10,'mlabellocation',20,...
     'MLabelParallel','south');
set(gcf,'MenuBar','none');
cmapland=colormap('jet');
geoshow(RasterLats,RasterLons,DSR,'DisplayType','texturemap');
% zlimits = [min(LI(:)) max(LI(:))];
% demcmap(zlimits);
demcmap(DSR,256,[],cmapland);
hold on
eval(['cd ' mappath(1:length(mappath)-1)]);
load('USAHiResBoundaries.mat','USALat','USALon');
plotm(USALat,USALon,'y');
load('CanadaBoundaries.mat','CanadaLat','CanadaLon');
plotm(CanadaLat,CanadaLon,'y');
load('MexicoBoundaries.mat','MexicoLat','MexicoLon');
plotm(MexicoLat,MexicoLon,'y');
load('CubaBoundaries.mat','CubaLat','CubaLon');
plotm(CubaLat,CubaLon,'y');
load('DominicanRepublicBoundaries.mat','DRLat','DRLon');
plotm(DRLat,DRLon,'y');
load('HaitiBoundaries.mat','HaitiLat','HaitiLon');
plotm(HaitiLat,HaitiLon,'y');
load('BelizeBoundaries.mat','BelizeLat','BelizeLon');
plotm(BelizeLat,BelizeLon,'y');
load('GautemalaBoundaries.mat','GautemalaLat','GautemalaLon');
plotm(GautemalaLat,GautemalaLon,'y')
load('JamaicaBoundaries.mat','JamaicaLat','JamaicaLon');
plotm(JamaicaLat,JamaicaLon,'y');
load('NicaraguaBoundaries.mat','NicaraguaLat','NicaraguaLon');
plotm(NicaraguaLat,NicaraguaLon,'y')
load('HondurasBoundaries.mat','HondurasLat','HondurasLon');
plotm(HondurasLat,HondurasLon,'y')
load('ElSalvadorBoundaries.mat','ElSalvadorLat','ElSalvadorLon');
plotm(ElSalvadorLat,ElSalvadorLon,'y');
load('PanamaBoundaries.mat','PanamaLat','PanamaLon');
plotm(PanamaLat,PanamaLon,'y');
load('ColumbiaBoundaries.mat','ColumbiaLat','ColumbiaLon');
plotm(ColumbiaLat,ColumbiaLon,'y');
load('VenezuelaBoundaries.mat','VenezuelaLat','VenezuelaLon');
plotm(VenezuelaLat,VenezuelaLon,'y')
load('PeruBoundaries.mat','PeruLat','PeruLon');
plotm(PeruLat,PeruLon,'y');
load('EcuadorBoundaries.mat','EcuadorLat','EcuadorLon');
plotm(EcuadorLat,EcuadorLon,'y')
load('BrazilBoundaries.mat','BrazilLat','BrazilLon');
plotm(BrazilLat,BrazilLon,'y');
load('BoliviaBoundaries.mat','BoliviaLat','BoliviaLon');
plotm(BoliviaLat,BoliviaLon,'y')
load('ChileBoundaries.mat','ChileLat','ChileLon');
plotm(ChileLat,ChileLon,'y');
load('ArgentinaBoundaries.mat','ArgentinaLat','ArgentinaLon');
plotm(ArgentinaLat,ArgentinaLon,'y');
load('UruguayBoundaries.mat','UruguayLat','UruguayLon');
plotm(UruguayLat,UruguayLon,'y');
load('CostaRicaBoundaries.mat','CostaRicaLat','CostaRicaLon');
plotm(CostaRicaLat,CostaRicaLon,'y');
load('FrenchGuianaBoundaries.mat','FrenchGuianaLat','FrenchGuianaLon');
plotm(FrenchGuianaLat,FrenchGuianaLon,'y');
load('GuyanaBoundaries.mat','GuyanaLat','GuyanaLon');
plotm(GuyanaLat,GuyanaLon,'y');
load('SurinameBoundaries.mat','SurinameLat','SurinameLon');
plotm(SurinameLat,SurinameLon,'y');
set(gcf,'Position',[hor1 vert1 widd lend])
title(titlestr)
hold off
tightmap;
colorbar;
newaxesh=axes('Position',[0 0 1 1]);
set(newaxesh,'XLim',[0 1],'YLim',[0 1]);
tx1=.13;
ty1=.25;
txtstr1=strcat('Start Scan-Y',num2str(YearS),'-D-',num2str(DayS),'-H-',...
    num2str(HourS),'-M-',num2str(MinuteS),'-S-',num2str(SecondS),'-----',MonthDayYearStr);
txt1=text(tx1,ty1,txtstr1,'FontWeight','bold','FontSize',12);
tx2=.85;
ty2=.75;
txtstr2='DSR- w/m^2';
txt2=text(tx2,ty2,txtstr2,'FontWeight','bold','FontSize',12);
tx3=.13;
ty3=.21;
txtstr3=strcat('Minimum DSR value=',num2str(DSRmin),...
     '-Max DSR=',num2str(DSRmax),'-in W/m^2','-CloudFraction=',num2str(CloudFrac,5));
txt3=text(tx3,ty3,txtstr3,'FontWeight','bold','FontSize',12);
tx4=.13;
ty4=.17;
txtstr4=strcat('Band Lower Bound=',num2str(lb,4),'-Upper Bound=',num2str(ub,4),'-in microns');
txt4=text(tx4,ty4,txtstr4,'FontWeight','bold','FontSize',12);
set(newaxesh,'Visible','Off');
% Save this chart
figstr=strcat(titlestr,'.jpg');
eval(['cd ' jpegpath(1:length(jpegpath)-1)]);
actionstr='print';
typestr='-djpeg';
[cmdString]=MyStrcat2(actionstr,typestr,figstr);
eval(cmdString);
plotstr1=strcat('Saved DSR Plots as-',figstr);
disp(plotstr1);
fprintf(fid,'%s\n',plotstr1);
pause(chart_time);
JpegCounter=JpegCounter+1;
JpegFileList{JpegCounter+1,1}=figstr;
JpegFileList{JpegCounter+1,2}=jpegpath;
if((iCreatePDFReport==1) && (RptGenPresent==1))
    [ibreak]=strfind(GOESFileName,'_e');
    is=1;
    ie=ibreak(1)-1;
    GOESShortFileName=GOESFileName(is:ie);
    headingstr1=strcat('Downwards Shortwave Radiation-',GOESShortFileName);
    chapter = Chapter("Title",headingstr1);
    add(chapter,Section('DSR Map'));
    imdata = imread(figstr);
    [nhigh,nwid,ndepth]=size(imdata);
    image = mlreportgen.report.FormalImage();
    image.Image = which(figstr);
    pdftxtstr=strcat('DSR For File-',GOESShortFileName);
    pdftext = Text(pdftxtstr);
    pdftext.Color = 'red';
    image.Caption = pdftext;
    nhighs=floor(nhigh/2.5);
    nwids=floor(nwid/2.5);
    heightstr=strcat(num2str(nhighs),'px');
    widthstr=strcat(num2str(nwids),'px');
    image.Height = heightstr;
    image.Width = widthstr;
    image.ScaleToFit=0;
    add(chapter,image);
% Now add some text -start by decribing the DSR Metric
    parastr1=strcat('The Data for this chart was taken from file-',GOESShortFileName,'.');
    parastr2='This plot is of the Downward Shortwave Radiation (DSR) metric which is one of two components in the earth Solar Radiation Budget (SRB).';
    parastr3='Comining the DSR metric along with the Reflection Shortwave Radiation (RSR) at the top of the atmosphere allow estimationof the SRB.';
    parastr4=strcat('For the image shown above the values of the DSR range from-',num2str(DSRmin),'-to-',num2str(DSRmax),'w/m^2.');
    parastr5='Values below ~50 W/m^2 are indicative of night conditions.';
    parastr6=strcat('The cloud fraction in this scene was-',num2str(CloudFrac,5),'.');
    parastr7=strcat('Band pass lower limit=',num2str(lb,4),'-Upper limit=',num2str(ub,4),'-in microns.');
    parastr9=strcat(parastr1,parastr2,parastr3,parastr4,parastr5,parastr6,parastr7);
    p1 = Paragraph(parastr9);
    p1.Style = {OuterMargin("0pt", "0pt","10pt","10pt")};
    add(chapter,p1);
% Build a KeyRqmts List
    RqmtsHdr={'Item'  'Requirement'};
    RqmtsTable=cell(11,2);
    RqmtsTable{1,1}='Geographic Coverage';
    RqmtsTable{1,2}='Conus/FullDisk/MesoScale';
    RqmtsTable{2,1}='Vertical Resolution';
    RqmtsTable{2,2}='N/A';
    RqmtsTable{3,1}='Horizontal Resolution';
    RqmtsTable{3,2}='Conus-25 km/FD-50 km/M-5 Km';
    RqmtsTable{4,1}='Mapping Accuracy';
    RqmtsTable{4,2}='Conus-2 Km/FD-4 km/M-1 km';
    RqmtsTable{5,1}='Measurement Range';
    RqmtsTable{5,2}='0-1500 w/m^2';
    RqmtsTable{6,1}='Measurement Accuracy High ';
    RqmtsTable{6,2}='85 w/m^2 above 500 w/m^2';
    RqmtsTable{7,1}='Measurement Accuracy Medium ';
    RqmtsTable{7,2}='65 w/m^2 >200 to < 500 w/m^2';
    RqmtsTable{8,1}='Measurement Accuracy Low';
    RqmtsTable{8,2}='110 w/m^2  < 200 w/m^2';
    RqmtsTable{9,1}='Refresh Rate';
    RqmtsTable{9,2}='60 min';
    RqmtsTable{10,1}='Minimum Good SZA';
    RqmtsTable{10,2}='25 Deg';
    RqmtsTable{11,1}='Maximum Good LHA';
    RqmtsTable{11,2}='70 deg';
    T1=[RqmtsHdr;RqmtsTable];
    tbl1=Table(T1);
    tbl1.Style = [tbl1.Style {Border('solid','black','3px')}];
    tbl1.HAlign='center';
    tbl1.TableEntriesHAlign = 'center';
    tbl1.ColSep = 'single';
    tbl1.RowSep = 'single';
    r = row(tbl1,1);
    r.Style = [r.Style {Color('red'),Bold(true)}];
    bt1 = BaseTable(tbl1);
    tabletitle = Text('Requirements for DSR');
    tabletitle.Bold = false;
    bt1.Title = tabletitle;
    bt1.TableWidth="7in";
    add(chapter,bt1);
    parastr11='The table above defines key requirements on the GOES system related to the DSR metric.';
    parastr12='Inspection of the table reveals that this quantity is available in Meso/Conus and Full Disk versions-however all versions refresh only once per hour.';
    parastr13='The horizontal resolution on the earth varies from 5 to 50 km depending on the coverage mode which is at a lower resolution than many other metrics.';
    parastr14='Measurment accuracy of the DSR is also dependent on the value-at low levels the accuracy might be as low as 50% and at best modes is only ~10%.';
    parastr15='Best results are obtained if the Solar Zenith Angle (SZA) exceeds 25 deg and The Local Horizontal Angle (LHA) is less than 70 deg.';
    parastr19=strcat(parastr11,parastr12,parastr13,parastr14,parastr15);
    p2 = Paragraph(parastr19);
    p2.Style = {OuterMargin("0pt", "0pt","10pt","10pt")};
    add(chapter,p2);
    close('all');
end
fprintf(fid,'%s\n','-----Exit Display CONUS Downwards ShortWave Radiation-----');
fprintf(fid,'\n');
end


