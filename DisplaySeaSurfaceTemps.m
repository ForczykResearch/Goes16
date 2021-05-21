function  [SST1DSF,sgoodfrac]=DisplaySeaSurfaceTemps(SSTS,titlestr)
% Display the Sea Surface Temps from the GOES16/17 data
% Project this data on a equiconic section map
% This uses the CONUS projection
% Note this routine is basically the same as DisplayCloudTopHeightsRev2.,
% Written By: Stephen Forczyk
% Created: Dec 11,2020
% Revised: Dec 28,2020 2 output arguments to facilitate histogram plot
% Revised: Jan 21,2021 added code to create inputs to PDF report
% Classification: Unclassified

global MetaDataS;
global DQFS tS yS xS tBS goesImagerS yImgS yImgBS;
global xImgS xImgBS SatDataS GeoSpatialS ;
global TQPixelsS NumDaySSTPixelsS NumNightSSTPixelsS NumTwilightSSTPixelsS;
global AlgoS GoesWaveBand;
global AlgoProdVersionContainerS ProcessParamS;
global RLZAS QLZAS RLZABS QLZABS;
global RSZAS TSZAS RSZABS TSZABS;
global DSZAS NSZAS TSZAS;
global DSZABS NSZABS ;
global SST_EBS;
global GRBErrorsS L0ErrorsS;
global SSTS SeaSurfOutlierPixelS SeaSurfTempS;
global SST_Night_Only_EBS Reynolds_SSTS;
global westEdge eastEdge northEdge southEdge;
global GOESFileName;
global idebug isavefiles;
global RptGenPresent iCreatePDFReport pdffilename rpt chapter;
global JpegCounter JpegFileList;
global DayMonthNonLeapYear DayMonthLeapYear CalendarFileName;
global DQFHdr DQFTable MiscHdr MiscTable;
global RasterLats RasterLons;

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
fprintf(fid,'%s\n','-----Start plot routine DisplaySea Surface Temps-----');
eval(['cd ' gridpath(1:length(gridpath)-1)]);
[nrows,ncols]=size(SSTS.values);
if((nrows==5424) && (ncols==5424))
   GridMatFileName='GOES16-FullDisk-Lat-Lon-Boundaries.mat';
else
   disp('This does not work'); 
end
ntotpixels=nrows*ncols;
gridstr1=strcat('Loaded Map Grid From File=',GridMatFileName);
fprintf(fid,'%s\n',gridstr1);
load(GridMatFileName,'RasterLats','RasterLons');
dispstr=strcat('Loaded Grid Raster File-',GridMatFileName);
disp(dispstr)
ST=SSTS.values;
SST1D=reshape(ST,nrows*ncols,1);
SST1DS=sort(SST1D);
a1=isnan(SST1DS);
numnan=sum(a1);
numvals2=(nrows*ncols)-(numnan+1);
SST1DSF=zeros(numvals2,1);
for k=1:numvals2
    SST1DSF(k,1)=SST1DS(k,1);
end
sgoodfrac=numvals2/(nrows*ncols);
% Get some data relating to the data collection
ab=1;
NumDayPixels=NumDaySSTPixelsS.values;
NumNightPixels=NumNightSSTPixelsS.values;
NumTwilightPixels=NumTwilightSSTPixelsS.values;
NumOutlierPixels=SeaSurfOutlierPixelS.values;
MaxLZARetrievalAngle=RLZAS.value;
GoodQualityLZA=QLZAS.value;
MaxSolarRetrievalAngle=RSZAS.value;
TwilightSA=TSZAS.value;
MiscTable=cell(8,3);
MiscTable{1,1}='Num Of Day Pixels';
MiscTable{1,2}=floor(NumDayPixels);
MiscTable{1,3}='-';
MiscTable{2,1}='Num Of Night Pixels';
MiscTable{2,2}=floor(NumNightPixels);
MiscTable{2,3}='-';
MiscTable{3,1}='Num Of Twilight Pixels';
MiscTable{3,2}=floor(NumTwilightPixels);
MiscTable{3,3}='-';
MiscTable{4,1}='Num Of Out Of Range Pixels';
MiscTable{4,2}=floor(NumOutlierPixels);
MiscTable{4,3}='-';
MiscTable{5,1}='Max LZA Angle';
MiscTable{5,2}=floor(MaxLZARetrievalAngle);
MiscTable{5,3}='Angle In Degrees';
MiscTable{6,1}='Max LZA For Good Quality';
MiscTable{6,2}=floor(GoodQualityLZA);
MiscTable{6,3}='Angle In Degrees';
MiscTable{7,1}='Max Solar Retrieval Angle';
MiscTable{7,2}=floor(MaxSolarRetrievalAngle);
MiscTable{7,3}='Angle In Degrees';
MiscTable{8,1}='Max Solar Angle For Twilight';
MiscTable{8,2}=floor(TwilightSA);
MiscTable{8,3}='Angle In Degrees';
ABINightBand=SST_EBS.values3;
ABINightBandCenter=SST_EBS.values1;
ABIDayNightBands=SST_EBS.values4;
ABIDayNightBandCenter=SST_EBS.values2;
bandnums=ABIDayNightBands';
bandnumstr=strcat(num2str(bandnums(1,1)),'-',num2str(bandnums(1,2)),'-',...
    num2str(bandnums(1,3)),'-',num2str(bandnums(1,4)));
bandcenters=ABIDayNightBandCenter';
bc1=bandcenters(1,1);
bc2=bandcenters(1,2);
bc3=bandcenters(1,3);
bc4=bandcenters(1,4);
% bandcenterstr=strcat(num2str(bandcenters(1,1),2),'-',num2str(bandcenters(1,2),2),'-',...
%     num2str(bandcenters(1,3),2),'-',num2str(bandcenters(1,4),2));
bandcenterstr=strcat(num2str(bc1,4),'-',num2str(bc2,4),'-',num2str(bc3,4),'-',num2str(bc4,4));
MiscTable{9,1}='ABI Band Used Night Pixels Only';
MiscTable{9,2}=floor(ABINightBand);
MiscTable{9,3}='-';
MiscTable{10,1}='ABI Band Center Night Pixels Only';
MiscTable{10,2}=ABINightBandCenter;
MiscTable{10,3}='microns';
MiscTable{11,1}='ABI Band Used Day/Night Pixels';
MiscTable{11,2}=bandnumstr;
MiscTable{11,3}='-';
MiscTable{12,1}='ABI Band Centers Day/Night Pixels';
MiscTable{12,2}=bandcenterstr;
MiscTable{12,3}='microns';
MiscHdr={'Item' 'Value' 'Units'};
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
geoshow(RasterLats,RasterLons,ST,'DisplayType','texturemap');
demcmap(ST,256,[],cmapland);
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
colorbar;
newaxesh=axes('Position',[0 0 1 1]);
set(newaxesh,'XLim',[0 1],'YLim',[0 1]);
tx1=.13;
ty1=.06;
txtstr1=strcat('Start Scan-Y',num2str(YearS),'-D-',num2str(DayS),'-H-',...
    num2str(HourS),'-M-',num2str(MinuteS),'-S-',num2str(SecondS),'-----',MonthDayYearStr);
txt1=text(tx1,ty1,txtstr1,'FontWeight','bold','FontSize',12);
tx2=.86;
ty2=.86;
txt2=text(tx2,ty2,'Sea Temp-Deg-k','FontWeight','bold','FontSize',12);
set(newaxesh,'Visible','Off');
% Save this chart
figstr=strcat(titlestr,'.jpg');
eval(['cd ' jpegpath(1:length(jpegpath)-1)]);
actionstr='print';
typestr='-djpeg';
[cmdString]=MyStrcat2(actionstr,typestr,figstr);
eval(cmdString);
plotstr1=strcat('Saved Sea Surf Temp Plots as-',figstr);
disp(plotstr1);
fprintf(fid,'%s\n',plotstr1);
pause(chart_time);
if((iCreatePDFReport==1) && (RptGenPresent==1))
    [ibreak]=strfind(GOESFileName,'_e');
    is=1;
    ie=ibreak(1)-1;
    GOESShortFileName=GOESFileName(is:ie);
    headingstr1=strcat('Sea Surface Temperatures For-',GOESShortFileName);
    chapter = Chapter("Title",headingstr1);
    add(chapter,Section('Sea Surface Temp Map'));
    imdata = imread(figstr);
    [nhigh,nwid,ndepth]=size(imdata);
    image = mlreportgen.report.FormalImage();
    image.Image = which(figstr);
    pdftxtstr=strcat('Sea Surface Temp Data For File-',GOESShortFileName);
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
    templowlimit=SSTS.add_offset;
    scalefactor=SSTS.scale_factor;
    temphighlimit=floor(templowlimit+scalefactor*2^16);
    parastr1=strcat('The Data for this chart was taken from file-',GOESShortFileName,'.');
    parastr2='This dataset provides a temperature estimate of ocean pixels.';
    parastr3='The algorithm computation algorithm uses Bands 7/14 and 15 so it can return values day or night.';
    parastr4=strcat('Using these three wavebands, the ABI sensor can return valid results in the range of-',num2str(templowlimit,3),'-to-',...
        num2str(temphighlimit,3),'-deg-K.');
    parastr6=strcat(parastr1,parastr2,parastr3,parastr4);
    p1 = Paragraph(parastr6);
    p1.Style = {OuterMargin("0pt", "0pt","0pt","10pt")};
    add(chapter,p1);
    dqfflag1=100*DQFS.percent_good_quality_qf;
    dqfflag2=100*DQFS.percent_degraded_quality_qf;
    dqfflag3=100*DQFS.percent_severely_degraded_quality_qf;
    dqfflag4=100*DQFS.percent_invalid_due_to_unprocessed_qf;
    parastr10='This table provides the data quality factors for the Sea Temperatures.';
    parastr11=strcat('The total number of pixel values is-',num2str(ntotpixels),'.');
    parastr12=strcat('The % of pixels that returned Sea Surface Temperatures was=',num2str(dqfflag1,6),...
        '-while this scan exhibited-',num2str(dqfflag2,6),'-% pixels with some degradation.');
    parastr13=strcat('Severely degraded pixels comprised-',num2str(dqfflag3,6),'-% of the total pixels.');
    parastr14=strcat('An overlaping metric, shows that overall-',num2str(dqfflag4,6),'-% of the pixels could not be processed.');
    parastr18=strcat(parastr10,parastr11,parastr12,parastr13,parastr14);
    p2 = Paragraph(parastr18);
    p2.Style = {OuterMargin("0pt", "0pt","0pt","10pt")};
    add(chapter,p2);
% Now build a DQF Table of key values
    DQFHdr = {'Item' '% Of Pixels'};
    DQFTable=cell(4,2);
    DQFTable{1,1}='Pct Good Quality Pixels';
    dqfflag1=100*DQFS.percent_good_quality_qf;
    dqfflagstr1=num2str(dqfflag1,6);
    DQFTable{1,2}=dqfflagstr1;
    DQFTable{2,1}='Pct Degraded Quality';
    dqfflag2=100*DQFS.percent_degraded_quality_qf;
    dqfflagstr2=num2str(dqfflag2,6);
    DQFTable{2,2}=dqfflagstr2;
    DQFTable{3,1}='Pct Severely Degraded Quality';
    dqfflag3=100*DQFS.percent_severely_degraded_quality_qf;
    dqfflagstr3=num2str(dqfflag3,6);
    DQFTable{3,2}=dqfflagstr3;
    DQFTable{4,1}='Pct Unprocessed Pixels';
    dqfflag4=100*DQFS.percent_invalid_due_to_unprocessed_qf;
    dqfflagstr4=num2str(dqfflag4,6);
    DQFTable{4,2}=dqfflagstr4;
    T4=[DQFHdr;DQFTable];
    tbl4=Table(T4);
    tbl4.Style = [tbl4.Style {Border('solid','black','3px')}];
    tbl4.HAlign='center';
    tbl4.TableEntriesHAlign = 'center';
    tbl4.ColSep = 'single';
    tbl4.RowSep = 'single';
    r = row(tbl4,1);
    r.Style = [r.Style {Color('red'),Bold(true)}];
    bt4 = BaseTable(tbl4);
    tabletitle = Text('DQF Table For Sea Surface Temperatures');
    tabletitle.Bold = false;
    bt4.Title = tabletitle;
    bt4.TableWidth="7in";
    add(chapter,bt4);
    br = PageBreak();
    add(chapter,br);
% Build a table with miscellaneous data related to the data collection
% limits
    T5=[MiscHdr;MiscTable];
    tbl5=Table(T5);
    tbl5.Style = [tbl4.Style {Border('solid','black','3px')}];
    tbl5.HAlign='center';
    tbl5.TableEntriesHAlign = 'center';
    tbl5.ColSep = 'single';
    tbl5.RowSep = 'single';
    r = row(tbl5,1);
    r.Style = [r.Style {Color('red'),Bold(true)}];
    bt5 = BaseTable(tbl5);
    tabletitle = Text('Miscellaneous Data Collection Parameters');
    tabletitle.Bold = false;
    bt5.Title = tabletitle;
    bt5.TableWidth="7in";
    add(chapter,bt5);
% add a descriptive paragraph for bt5
    parastr30='The table above provides additional details on the data collection.';
    parastr31='Inspection of the table shows that the first 3 rows detail how many pixels were viewing day,night or twilight regions of the earth.';
    parastr32='Row 4 shows how many pixels provide out of range (180K-340K) temperature readings.';
    parastr33='Rows 5 through 8 specify the limits for the Local Zenith and Solar Zenith Angles as they relate to measurement quality.';
    parastr34='The last four rows detail which bands were used for night-only or day/night data collection in support of this metric.';
    parastr39=strcat(parastr30,parastr31,parastr32,parastr33,parastr34);
    p3 = Paragraph(parastr39);
    p3.Style = {OuterMargin("0pt", "0pt","10pt","10pt")};
    add(chapter,p3);
%    add(rpt,chapter);
end
close('all');
fprintf(fid,'%s\n','-----Exit plot routine DisplaySeaSurfaceTemps-----');
fprintf(fid,'\n');
end


