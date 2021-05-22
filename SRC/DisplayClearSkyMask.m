function  DisplayClearSkyMask(BCM,titlestr)
% Display the clear sky mask from the GOES16/17 data
% Project this data on a equiconic section map
% This uses the CONUS projection
% Note this routine is basically the same as DisplayCloudTopHeightsRev2.,
% Written By: Stephen Forczyk
% Created: Dec 2,2020
% Revised: 
% Classification: Unclassified

global MetaDataS;
global DQFS tS yS xS tBS goesImagerS yImgS yImgBS;
global xImgS xImgBS SatDataS GeoSpatialS;
global CloudTopPressureS CloudMaskPtsS;
global NumClearPixelsS NumProbClearPixelsS NumProbCloudyPixelsS;
global NumCloudyPixelsS;
global PctClearPixelsS PctProbClearPixelsS PctProbCloudyPixelsS;
global PctCloudyPixelsS PctTerminatorPixelsS;
global RTM_BT_AllSkyS RTM_BT_ClearSkyS;
global AlgoS GoesWaveBand;
global AlgoProdVersionContainerS ProcessParamS;
global RLZAS QLZAS RLZABS QLZABS;
global RSZAS TSZAS RSZABS TSZABS;
global RTMBT_CWS RTMBT_BIDS;
global GRBErrorsS L0ErrorsS;
global BCMS;
global DQFHdr DQFTable;
global GOESFileName;
global MonthDayStr MonthDayYearStr;
global DayMonthNonLeapYear DayMonthLeapYear CalendarFileName;
global westEdge eastEdge northEdge southEdge;
global pctclearpix pctprobclearpix pctprobcloudypix pctcloudypix;
global RptGenPresent iCreatePDFReport pdffilename rpt chapter;
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
fprintf(fid,'\n');
fprintf(fid,'%s\n','-----Start plot routine DisplayClearSkyMask-----');
eval(['cd ' gridpath(1:length(gridpath)-1)]);
[nrows,ncols]=size(BCM);
if((nrows==2500) && (ncols==1500))
   GridMatFileName='GOES16-CONUS-Lat-Lon-Boundaries.mat';
else
   disp('This does not work'); 
end
gridstr1=strcat('Loaded Map Grid From File=',GridMatFileName);
fprintf(fid,'%s\n',gridstr1);
load(GridMatFileName,'RasterLats','RasterLons');
dispstr=strcat('Loaded Grid Raster File-',GridMatFileName);
disp(dispstr)
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
     'MapLonLimit',[westEdge eastEdge],'meridianlabel','on','parallellabel','on','plabellocation',5,'mlabellocation',10,...
     'MLabelParallel','south');
set(gcf,'MenuBar','none');
cmapland=colormap('jet');
geoshow(RasterLats,RasterLons,BCM','DisplayType','texturemap');
demcmap(BCM',256,[],cmapland);
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
plotm(JamaicaLat,JamaicaLon,'y')
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
txt2=text(tx2,ty2,'Cloud Mask','FontWeight','bold','FontSize',12);
tx3=.13;
ty3=.24;
txtstr3=strcat('pct clear=',num2str(pctclearpix,6),'-pct cloudy=',num2str(pctclearpix,6));
txt3=text(tx3,ty3,txtstr3,'FontWeight','bold','FontSize',12);
tx4=.13;
ty4=.20;
txtstr4='Clear Pix Sky Mask=0,Cloudy Pix Sky Mask=1';
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
    headingstr1=strcat('Clear Sky Mask For-',GOESShortFileName);
    chapter = Chapter("Title",headingstr1);
    add(chapter,Section('Clear Sky Mask'));
    imdata = imread(figstr);
    [nhigh,nwid,ndepth]=size(imdata);
    image = mlreportgen.report.FormalImage();
    image.Image = which(figstr);
    pdftxtstr=strcat('Clear Sky Mask For File-',GOESShortFileName);
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
    parastr1=strcat('The Data for this chart was taken from file-',GOESShortFileName,'.');
    parastr2=strcat('This ABI Clear Sky Mask is not the result of a single direct measurment but is the result of a complex algorithm that uses data from up to',...
        '-9 bands of data from the ABI imager to develop a binary mask based on whether a given pixel is cloudy or not.');
    parastr3='This is an example of a 2 level mask.';
    parastr4='The same algorithm can also produce a four level mask that has 4 states-clear,probably clear/probably cloudy and cloudy.';
    parastr5='In the chart above a 2 state mask is plotted with the red color assigned to probablycloudy/cloudy pixels and blue assigned to probably clear/clear pixels.';
    parastr6=strcat(parastr1,parastr2,parastr3,parastr4,parastr5);
    p1 = Paragraph(parastr6);
    p1.Style = {OuterMargin("0pt", "0pt","0pt","10pt")};
    add(chapter,p1);
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
    dqfflag3=100*DQFS.percent_degraded_due_to_LZA_threshold_exceeded_qf;
    dqfflagstr3=num2str(dqfflag3,6);
    DQFTable{3,2}=dqfflagstr3;
    DQFTable{4,1}='Missing Band 14 Bright Temp';
    dqfflag4=100*DQFS.pct_inval_due_to_bad_or_missing_input_band_14_bright_temp_qf;
    dqfflagstr4=num2str(dqfflag4,6);
    DQFTable{4,2}=dqfflagstr4;
    DQFTable{5,1}='Degraded Due To Band Input Band 7';
    dqfflag5=100*DQFS.percent_degraded_due_to_bad_input_band_7_pixel_qf;
    dqfflagstr5=num2str(dqfflag5,6);
    DQFTable{5,2}=dqfflagstr5;
    DQFTable{6,1}='Degraded Due To Failed Band 2 Tests';
    dqfflag6=100*DQFS.percent_degraded_due_to_failed_band_2_tests_qf;
    dqfflagstr6=num2str(dqfflag6,6);
    DQFTable{6,2}=dqfflagstr6;
    DQFTable{7,1}='Degraded Due To Other Bad Bands';
    dqfflag7=100*DQFS.percent_degraded_due_to_other_bad_bands_qf;
    dqfflagstr7=num2str(dqfflag7,6);
    DQFTable{7,2}=dqfflagstr7;
    parastr20='There are a total of 7 data quality factors (DQF) that directly relate to the cloud top pressure data and these are shown in the table below.';
    parastr21=strcat('The first DQF is just the number of pixels returning good data-',num2str(dqfflag1,4),'-per cent,if this is well below 100% there are gaps in the picture.');
    parastr22=strcat('Another DQF,is the failure to assign a good geolocation for the data,this value is seen to be-',num2str(dqfflag2,4),'-per cent.');
    parastr23=strcat('A third factor relates to local zenith angle (LZA) of the reporting pixel,if it is too great the values could be unreliable,in this case this value is-',...
        num2str(dqfflag3,4),'-per cent.');
    parastr24=strcat('The algorithm needs the brightness temperature for each pixel in Band 14,if this is missing or unreliable no valid sky mask can be made.',...
        'This value is-',num2str(dqfflag4,4),'-per cent.');
    parastr25=strcat('The 5th DQF is based on whether Band 7 returns good data.',...
        'Band 7 data was found to be not good in-',num2str(dqfflag5,4),'-per cent of pixels.');
    parastr26=strcat('Band 2 data is also needed for good results.',...
        'The 6th DQF provides a measure of the failure rate in to this cause which was-',num2str(dqfflag6,4),'-per cent.');
    parastr27=strcat('The 7th and final DQF notes if bands other 2,7 or 14 were bad-the result was-',num2str(dqfflag7,4),'-per cent.');
    parastr29=strcat(parastr20,parastr21,parastr22,parastr23,parastr24,parastr25,parastr26,parastr27);
    p4 = Paragraph(parastr29);
    p4.Style = {OuterMargin("0pt", "0pt","0pt","10pt")};
    add(chapter,p4);
    parastr30='A list of key values related to the Clear Sky Mask follows-the last 4 items relate to the 4 state mask.';
    p5 = Paragraph(parastr30);
    p5.Style = {OuterMargin("0pt", "0pt","0pt","10pt")};
    add(chapter,p5);
    LZAval1=RLZABS.value(1,1);
    LZAval2=RLZABS.value(2,1);
    SZAval1=RSZABS.value(1,1);
    SZAval2=RSZABS.value(2,1);
    CloudMaskPixels=CloudMaskPtsS.values;
    NumberClearPixels=NumClearPixelsS.values;
    NumberProbClearPixels=NumProbClearPixelsS.values;
    NumberProbCloudyPixels=NumProbCloudyPixelsS.values;
    NumberCloudyPixels=NumCloudyPixelsS.values;
%    NumOutlierPixes=OutlierPixelsS.values;
    liststr1=strcat('Local Zenith Angle Viewing Limits-',num2str(LZAval1,4),'-to-',num2str(LZAval2,4),'-Deg');
    liststr2=strcat('Solar Zenith Angle Viewing Limits-',num2str(SZAval1,4),'-to-',num2str(SZAval2,4),'-Deg');
    liststr3=strcat('Number Of Cloud Mask Pixels-',num2str(CloudMaskPixels));
    liststr4=strcat('Number Of Clear Pixels-',num2str(NumberClearPixels));
    liststr5=strcat('Number Of Prob Clear Pixels-',num2str(NumberProbClearPixels));
    liststr6=strcat('Number Of Prob Cloudy Pixels-',num2str(NumberProbCloudyPixels));
    liststr7=strcat('Number Of Cloudy Pixels-',num2str(NumberCloudyPixels));
    Lists=cell(7,1);
    Lists{1,1}=liststr1;
    Lists{2,1}=liststr2;
    Lists{3,1}=liststr3;
    Lists{4,1}=liststr4;
    Lists{5,1}=liststr5;
    Lists{6,1}=liststr6;
    Lists{7,1}=liststr7;
    ul = UnorderedList(Lists);
    add(chapter,ul);
    br = PageBreak();
    add(chapter,br);
    T4=[DQFHdr;DQFTable];
    tbl4=Table(T4);
    tbl4.Style = [tbl4.Style {Border('solid','black','3px')}];
    tbl4.HAlign='center';
    tbl4.ColSep = 'single';
    tbl4.RowSep = 'single';
%    tb14.TableEntriesHAlign='middle';
    r = row(tbl4,1);
    r.Style = [r.Style {Color('red'),Bold(true)}];
    bt4 = BaseTable(tbl4);
    tabletitle = Text('DQF Table for Clear Sky Mask');
    tabletitle.Bold = false;
    bt4.Title = tabletitle;
    bt4.TableWidth="7in";
    add(chapter,bt4);
    add(rpt,chapter);
end
close('all');
fprintf(fid,'%s\n','-----Exit plot routine DisplayClearSkyMask-----');
fprintf(fid,'\n');
end


