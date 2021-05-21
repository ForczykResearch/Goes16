function  DisplayCloudTopPressureRev3(Pressure,titlestr)
% Display the cloud top pressure from the GOES16/17 data
% Project this data on a equiconic section map
% This uses the CONUS projection
% Note this routine is basically the same as DisplayCloudTopHeightsRev2.,
%Revised from an earlier version that got renamed in error
% Written By: Stephen Forczyk
% Created: Jan 19,2021
% Revised: Jan 20,2021 added additional input to PDF report
% Classification: Unclassified
global BandDataS MetaDataS;
global OutlierPixelsS DQFS tS yS xS tBS goesImagerS yImgS yImgBS;
global xImgS xImgBS SatDataS GeoSpatialS;
global AlgoS ErrorS EarthSunS VersionContainerS;
global GoesWaveBand ESunS kappa0S PlanckS FocalPlaneS;
global CloudTopS Algo1S ProcessParamS;
global LZAS LZABS SZAS SZABS CloudPixelsS;
global DQFHdr DQFTable;
global GOESFileName;
global MonthDayStr MonthDayYearStr;
global DayMonthNonLeapYear DayMonthLeapYear CalendarFileName;
global westEdge eastEdge northEdge southEdge;
global RptGenPresent iCreatePDFReport pdffilename rpt chapter tocc;
global JpegCounter JpegFileList;

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
fprintf(fid,'%s\n');
fprintf(fid,'%s\n','-----Enter plot routine DisplayCloudTopPressureRev3-----');
eval(['cd ' gridpath(1:length(gridpath)-1)]);
%[nrows,ncols]=size(PRES2);
[nrows,ncols]=size(Pressure);
ntotalpixels=nrows*ncols;
if((nrows==500) && (ncols==300))
   GridMatFileName='CONUSCloudTopHeightBoundaries.mat';
else
   GridMatFileName='FullDiskCloudTopHeightBoundaries.mat'; 
end
gridstr1=strcat('Loaded Map Grid From File=',GridMatFileName);
fprintf(fid,'%s\n',gridstr1);
%[GridMatFileName,path]=uigetfile('*mat','Select one Raster Grid File');%
load(GridMatFileName,'RasterLats','RasterLons');
dispstr=strcat('Loaded Grid Raster File-',GridMatFileName);
disp(dispstr)
% Fetch the map limits
westEdge=double(GeoSpatialS.geospatial_westbound_longitude);
eastEdge=double(GeoSpatialS.geospatial_eastbound_longitude);
southEdge=double(GeoSpatialS.geospatial_southbound_latitude);
northEdge=double(GeoSpatialS.geospatial_northbound_latitude);
Press1D=reshape(Pressure,nrows*ncols,1);
PressureSort=sort(Press1D);
[ibad]=isnan(PressureSort);
numnan=sum(ibad);
numvals=length(PressureSort)-numnan;
val01=PressureSort(round(.01*numvals),1);
val50=PressureSort(round(.50*numvals),1);
val99=PressureSort(round(.99*numvals),1);
presmin=PressureSort(1,1);
presmax=PressureSort(numvals,1);
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
axesm ('pcarree','Frame','on','Grid','on','MapLatLimit',[southEdge northEdge],...
     'MapLonLimit',[westEdge eastEdge],'meridianlabel','on','parallellabel','on','plabellocation',5,'mlabellocation',10,...
     'MLabelParallel','south');
set(gcf,'MenuBar','none');
cmapland=colormap('jet');
geoshow(RasterLats,RasterLons,Pressure','DisplayType','texturemap');
demcmap(Pressure',256,[],cmapland);
hold on
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
plotm(JamaicaLat,JamaicaLon,'r')
set(gcf,'Position',[hor1 vert1 widd lend])
title(titlestr)
hold off
colorbar;
newaxesh=axes('Position',[0 0 1 1]);
set(newaxesh,'XLim',[0 1],'YLim',[0 1]);
tx1=.13;
ty1=.28;
txtstr1=strcat('Start Scan-Y',num2str(YearS),'-D-',num2str(DayS),'-H-',...
    num2str(HourS),'-M-',num2str(MinuteS),'-S-',num2str(SecondS),'-----',MonthDayYearStr);
txt1=text(tx1,ty1,txtstr1,'FontWeight','bold','FontSize',12);
tx2=.84;
ty2=.77;
txt2=text(tx2,ty2,'Pressure-hPA','FontWeight','bold','FontSize',12);
tx4=.13;
ty4=.24;
txtstr4=strcat('PRES-1%-',num2str(val01,6),'-PRES-50%-',...
    num2str(val50,6),'-PRES-99%-',num2str(val99,6),'-minPres-',...
    num2str(presmin,6),'-maxPres=',num2str(presmax,6),'-in hPa');
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
if((iCreatePDFReport==1) && (RptGenPresent==1))
    [ibreak]=strfind(GOESFileName,'_e');
    is=1;
    ie=ibreak(1)-1;
    GOESShortFileName=GOESFileName(is:ie);
    headingstr1=strcat('Cloud Top Pressure Data From File-',GOESShortFileName);
    chapter = Chapter("Title",headingstr1);
    add(chapter,Section('CONUS Level View Cloud Top Pressure'));
    imdata = imread(figstr);
    [nhigh,nwid,ndepth]=size(imdata);
    image = mlreportgen.report.FormalImage();
    image.Image = which(figstr);
    pdftxtstr=strcat('Cloud Top Pressure Data Found On File-',GOESShortFileName);
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
    parastr3='The Cloud Top Pressure parameter is calculated using an algorithm and is not observed as a direct mesurement of the GOES platform.';
    parastr4='In order that this quantity is available at all times, only data from the IR channels of the ABI sensor is used.';
    parastr5=strcat('This algorithm is called the ABI Cloud Height Algorithm (ACHA) and uses measurements of the could top temperature,',...
             'which the ABI sensor can directly measure along with models that relate this measument to features such as cloud top height and pressure.');
    parastr6='The unit of pressure hPa stands for hectopascal which equals 1 milliBar(mB). Standard atmospheric pressure at sea level is 1000 mB or 1 bar.';
    parastr10=strcat(parastr3,parastr4,parastr5,parastr6);
    p2 = Paragraph(parastr10);
    p2.Style = {OuterMargin("0pt", "0pt","0pt","10pt")};
    add(chapter,p2);
    parastr11='The chart above shows a CONUS level plot of cloud top pressure as a heatmap. The larger values of pressure correspond to the lower denser levels of the atmosphere.';
    parastr12='Conversely,the lower pressure levels refer to higher level clouds. Typically storm areas have higher clouds tops which exhibit lower pressures.';
    parastr13='The user may note that some areas of the charts are not filled in,this is because no valid cloud top pressures can be returned in this area.';
    parastr14='The Data Quality Factors (DQF) provides some details on this phenomenon and is shown in the next table.';
    parastr15=strcat(parastr11,parastr12,parastr13,parastr14);
    p3 = Paragraph(parastr15);
    p3.Style = {OuterMargin("0pt", "0pt","0pt","10pt")};
    add(chapter,p3);
    parastr30='Some basic factors about the data collection limits follow.';
    p5 = Paragraph(parastr30);
    p5.Style = {OuterMargin("0pt", "0pt","0pt","10pt")};
    add(chapter,p5);
    LZAval1=LZABS.values(1,1);
    LZAval2=LZABS.values(2,1);
    SZAval1=SZABS.values(1,1);
    SZAval2=SZABS.values(2,1);
    NumCloudPix=CloudPixelsS.values;
    NumOutlierPix=OutlierPixelsS.values;
    liststr1=strcat('Local Zenith Angle Viewing Limits-',num2str(LZAval1,4),'-to-',num2str(LZAval2,4),'-Deg');
    liststr2=strcat('Solar Zenith Angle Viewing Limits-',num2str(SZAval1,4),'-to-',num2str(SZAval2,4),'-Deg');
    liststr3=strcat('Number Of Cloudy Pixels-',num2str(NumCloudPix));
    liststr4=strcat('Number Of Outlier Pixels-',num2str(NumOutlierPix));
    liststr5=strcat('Number Of Reporting Pixels-',num2str(ntotalpixels));
    Lists=cell(5,1);
    Lists{1,1}=liststr1;
    Lists{2,1}=liststr2;
    Lists{3,1}=liststr3;
    Lists{4,1}=liststr4;
    Lists{5,1}=liststr5;
    ul = UnorderedList(Lists);
    add(chapter,ul);
% Now build a DQF Table of key values
    DQFHdr = {'Item' '% Of Pixels'};
    DQFTable=cell(7,2);
    DQFTable{1,1}='Good Quality Pixels';
    dqfflag1=100*DQFS.percent_good_quality_qf;
    dqfflagstr1=num2str(dqfflag1,6);
    DQFTable{1,2}=dqfflagstr1;
    DQFTable{2,1}='Failed GeoLocation';
    dqfflag2=100*DQFS.percent_invalid_due_to_not_geolocated_qf;
    dqfflagstr2=num2str(dqfflag2,6);
    DQFTable{2,2}=dqfflagstr2;
    DQFTable{3,1}='Exceeded LZ Threshold';
    dqfflag3=100*DQFS.percent_invalid_due_to_LZA_threshold_exceeded_qf;
    dqfflagstr3=num2str(dqfflag3,6);
    DQFTable{3,2}=dqfflagstr3;
    DQFTable{4,1}='Missing BrightNess Temp';
    dqfflag4=100*DQFS.percent_invalid_due_to_bad_or_missing_brightness_temp_data_qf;
    dqfflagstr4=num2str(dqfflag4,6);
    DQFTable{4,2}=dqfflagstr4;
    DQFTable{5,1}='Missing Due To Clear Skies';
    dqfflag5=100*DQFS.percent_invalid_due_to_clear_or_probably_clear_sky_qf;
    dqfflagstr5=num2str(dqfflag5,6);
    DQFTable{5,2}=dqfflagstr5;
    DQFTable{6,1}='Missing Due Unknown Cloud Type';
    dqfflag6=100*DQFS.percent_invalid_due_to_unknown_cloud_type_qf;
    dqfflagstr6=num2str(dqfflag6,6);
    DQFTable{6,2}=dqfflagstr6;
    DQFTable{7,1}='Non Convergent Retrieval';
    dqfflag7=100*DQFS.percent_invalid_due_to_nonconvergent_retrieval_qf;
    dqfflagstr7=num2str(dqfflag7,6);
    DQFTable{7,2}=dqfflagstr7;
    parastr20='There are a total of 7 data quality factors (DQF) that directly relate to the cloud top pressure data and these are shown in the table below.';
    parastr21=strcat('The first DQF is just the number of pixels returning good data-',num2str(dqfflag1,4),'-per cent,since this is well below 100% there are gaps in the picture.');
    parastr22=strcat('Another DQF,is the failure to assign a good geolocation for the data,this value is seen to be-',num2str(dqfflag2,4),'-per cent.');
    parastr23=strcat('A third factor relates to local zenith angle (LZA) of the reporting pixel,if it is too great the values could be unreliable,in this case this value is-',...
        num2str(dqfflag3,4),'-per cent.');
    parastr24=strcat('The algorithm needs the brightness temperature for each pixel,if this is missing or unreliable no valid cloud top pressure estimate can be made.',...
        'This value is-',num2str(dqfflag4,4),'-per cent.');
    parastr25=strcat('The 5th DQF relates to clear skies-simply put the procedure needs to look at clouds to work.',...
        'This item provides the per centage of pixels looking at clear skies and therefore unusable which is-',num2str(dqfflag5,4),'-per cent.');
    parastr26=strcat('The model atmosphere used in the calculation requires knowledge of the cloud type.',...
        'The 6th DQF provides a measure of the failure rate in assigning the correct type to an observed cloud which was-',num2str(dqfflag6,4),'-per cent.');
    parastr27=strcat('The 7th and final DQF provides information on the per centage of pixels that returned data which did not fit the atmospheric model well enough to produce a result.',...
        'In this measurement, the result was-',num2str(dqfflag7,4),'-per cent.');
    parastr29=strcat(parastr20,parastr21,parastr22,parastr23,parastr24,parastr25,parastr26,parastr27);
    p4 = Paragraph(parastr29);
    p4.Style = {OuterMargin("0pt", "0pt","0pt","10pt")};
    add(chapter,p4);
    br = PageBreak();
    add(chapter,br);
    T4=[DQFHdr;DQFTable];
    tbl4=Table(T4);
    tbl4.Style = [tbl4.Style {Border('solid','black','3px')}];
    tbl4.HAlign='center';
    tbl4.ColSep = 'single';
    tbl4.RowSep = 'single';
    tb14.TableEntriesHAlign='middle';
    r = row(tbl4,1);
    r.Style = [r.Style {Color('red'),Bold(true)}];
    bt4 = BaseTable(tbl4);
    tabletitle = Text('DQF Table for Cloud Top Pressures');
    tabletitle.Bold = false;
    bt4.Title = tabletitle;
    bt4.TableWidth="7in";
    add(chapter,bt4);
%    add(rpt,chapter);
end
close('all');
fprintf(fid,'%s\n','-----Exit plot routine DisplayCloudTopPressureRev3-----');
fprintf(fid,'%s\n');
end


