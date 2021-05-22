function  DisplayDuskMask(titlestr)
% Display the dusk mask from the GOES16/17 data
% Project this data on a equiconic section map
% This uses the CONUS projection
% Note this routine is basically the same as DisplayCloudTopHeightsRev2.,
% Written By: Stephen Forczyk
% Created: Feb 9,2021
% Revised: 
% Classification: Unclassified

global MetaDataS;
global AerosolS SmokeS DustS;
global DQFS tS yS xS tBS goesImagerS yImgS yImgBS;
global xImgS xImgBS SatDataS GeoSpatialS ;
global AlgoS GoesWaveBand;
global TPWRS TRVS TotPixRS RROutPixCountS RainRateS;
global AlgoProdVersionContainerS ProcessParamS;
global QLZAS  QLZABS;
global SZAS SZABS;
global RLZAS RLZABS RSZAS QSZAS RSZABS QSZABS;
global NumGoodSZAPixelS NumGoodLZAPixelS NumRetrievalS;
global GRBErrorsS L0ErrorsS;
global westEdge eastEdge northEdge southEdge;
global GOESFileName;
global RasterLats RasterLons;
global idebug isavefiles;
global DQFHdr DQFTable;
global MonthDayStr MonthDayYearStr;
global DayMonthNonLeapYear DayMonthLeapYear CalendarFileName;
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
fprintf(fid,'%s\n','-----Start plot routine DisplaySmokeMask-----');
eval(['cd ' gridpath(1:length(gridpath)-1)]);
ab=1;
% Get the Smoke Mask Data
Smoke=SmokeS.values;
[ismoke]=find(Smoke>0);
numsmoke=length(ismoke);
[nrows,ncols]=size(Smoke);
ntotpixels=nrows*ncols;
smokefrac=numsmoke/ntotpixels;
if((nrows==1500) && (ncols==2500))
   GridMatFileName='ConusAerosolMaskLatLonGrid.mat';
else
   disp('This does not work'); 
end
gridstr1=strcat('Loaded Map Grid From File=',GridMatFileName);
fprintf(fid,'%s\n',gridstr1);
load(GridMatFileName,'RasterLats','RasterLons');
dispstr=strcat('Loaded Grid Raster File-',GridMatFileName);
disp(dispstr)
smokestr1=strcat('Fraction of pixels with smoke detected=',num2str(smokefrac,6));
fprintf(fid,'%s\n',smokestr1);
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
geoshow(RasterLats,RasterLons,Smoke','DisplayType','texturemap');
demcmap(Smoke',256,[],cmapland);
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
txt2=text(tx2,ty2,'Smoke Mask','FontWeight','bold','FontSize',12);
tx3=.13;
ty3=.24;
txtstr3=strcat('fraction smoke pixels=',num2str(smokefrac,6));
txt3=text(tx3,ty3,txtstr3,'FontWeight','bold','FontSize',12);
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
%     headingstr1=strcat('Smoke Mask For-',GOESShortFileName);
%     chapter = Chapter("Title",headingstr1);
    add(chapter,Section('Smoke Mask'));
    imdata = imread(figstr);
    [nhigh,nwid,ndepth]=size(imdata);
    image = mlreportgen.report.FormalImage();
    image.Image = which(figstr);
    pdftxtstr=strcat('Smoke Mask For File-',GOESShortFileName);
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
    parastr1=strcat('The Data for this chart was taken from file-',GOESShortFileName,'.');
    parastr2=strcat('This ABI Smoke Mask is not a directly observed quantity but instead is computed from a number of reflectance measurements made by the ABI sensor.');
    parastr3='This mask is binary so a 0 corresponds to no smoke contamination present in the pixel to a 1 that signifies an smoke detection.';
    parastr4='Detection of Aerosol/Smoke or Dust is not an easy measurement and a fact of  a zero mask value should be interpreted to mean that the detection threshold was not met.';
    parastr5='The compuatational algorithm to detect the Smoke works best when there are heavy concentrations of Smoke over dark pixels and worst for lower concentrations on lighter pixels.';
    parastr6=strcat('In the data sample shown above the fraction of pixels with smoke detected above threshold was-',num2str(smokefrac,6));
    parastr9=strcat(parastr1,parastr2,parastr3,parastr4,parastr5,parastr6);
    p1 = Paragraph(parastr9);
    p1.Style = {OuterMargin("0pt", "0pt","0pt","10pt")};
    add(chapter,p1);
% Now build a DQF Table of key values
      DQFHdr = {'Item' 'Fraction Of Pixels'};
      DQFTable=cell(7,2);
      DQFTable{1,1}='Good Quality-Smoke Detection';
      dqfflag1=100*DQFS.pct_good_smoke_detection_retrieval_qf;
      dqfflagstr1=num2str(dqfflag1,6);
      DQFTable{1,2}=dqfflagstr1;
      DQFTable{2,1}='Invalid Smoke Detection';
      dqfflag2=100*DQFS.pct_inval_smoke_detection_due_to_snow_ice_clouds_qf;
      dqfflagstr2=num2str(dqfflag2,6);
      DQFTable{2,2}=dqfflagstr2;
      DQFTable{3,1}='Good Quality Dust Detection';
      dqfflag3=100*DQFS.pct_good_dust_detection_retrieval_qf;
      dqfflagstr3=num2str(dqfflag3,6);
      DQFTable{3,2}=dqfflagstr3;
      DQFTable{4,1}='Invalid_Dust_Detection';
      dqfflag4=100*DQFS.pct_inval_dust_detection_due_to_snow_ice_clouds_qf;
      dqfflagstr4=num2str(dqfflag4,6);
      DQFTable{4,2}=dqfflagstr4;
      DQFTable{5,1}='Low Confidence Smoke Detection';
      dqfflag5=100*DQFS.pct_low_confidence_smoke_detection_qf;
      dqfflagstr5=num2str(dqfflag5,6);
      DQFTable{5,2}=dqfflagstr5;
      DQFTable{6,1}='Medium Confidence Smoke Detection';
      dqfflag6=100*DQFS.pct_medium_confidence_smoke_detection_qf;
      dqfflagstr6=num2str(dqfflag6,6);
      DQFTable{6,2}=dqfflagstr6;
      DQFTable{7,1}='High Confidence Smoke Detection';
      dqfflag7=100*DQFS.pct_high_confidence_smoke_detection_qf;
      dqfflagstr7=num2str(dqfflag7,6);
      DQFTable{7,2}=dqfflagstr7;
      DQFTable{8,1}='Low Confidence Dust Detection';
      dqfflag8=100*DQFS.pct_low_confidence_dust_detection_qf;
      dqfflagstr8=num2str(dqfflag8,6);
      DQFTable{8,2}=dqfflagstr8;
      DQFTable{9,1}='Medium Confidence Dust Detection';
      dqfflag9=100*DQFS.pct_medium_confidence_dust_detection_qf;
      dqfflagstr9=num2str(dqfflag9,6);
      DQFTable{9,2}=dqfflagstr9;
      DQFTable{10,1}='High Confidence Dust Detection';
      dqfflag10=100*DQFS.pct_high_confidence_dust_detection_qf;
      dqfflagstr10=num2str(dqfflag10,6);
      DQFTable{10,2}=dqfflagstr10;
      DQFTable{11,1}='Pixels Out Of Sun Glint';
      dqfflag11=100*DQFS.pct_out_of_sun_glint_qf;
      dqfflagstr11=num2str(dqfflag11,6);
      DQFTable{11,2}=dqfflagstr11;
      DQFTable{12,1}='Pixels Within Sun Glint';
      dqfflag12=100*DQFS.pct_within_sun_glint_qf;
      dqfflagstr12=num2str(dqfflag12,6);
      DQFTable{12,2}=dqfflagstr12;
      DQFTable{13,1}='Pixels Meeting SZA and LZA Rqmts';
      dqfflag13=100*DQFS.pct_within_solar_and_satellite_zenith_angle_range_qf;
      dqfflagstr13=num2str(dqfflag13,6);
      DQFTable{13,2}=dqfflagstr13;
      DQFTable{14,1}='Pixels Failing SZA and/or LZA Rqmts';
      dqfflag14=100*DQFS.pct_outside_solar_or_satellite_zenith_angle_range_qf;
      dqfflagstr14=num2str(dqfflag14,6);
      DQFTable{14,2}=dqfflagstr14;     
%       parastr20='There are a total of 14 data quality factors (DQF) that directly relate to the aerosol/smoke/dusk data and these are shown in the table below.';
%       parastr21=strcat('The first 4 rows provide data on the fraction of pixels that have good or invalid pixels for smoke and dust detection.',...
%           'For example,in the current frame of data-',dqfflagstr1,'-of pixels have good smoke detection.');
%       parastr22=strcat('Rows 5 thru 7 provide an estimate of the quality of smoke data which can be low,medium or high.',...
%           'Inspection of these rows shows that in some of these cases the sum of low/medium and high confidence can exceed 100% of the pixels-this appears to be the consequence',...
%           'of how the algorithm sets the decision boundary.','The next three rows provide similar data for dust detection.');
%       parastr23=strcat('The final 4 rows provide data on the fraction of pixels that are affected by sunglint,the Solar Zenith Angle and The Local Zenith Angle.');
%       parastr24='These masks have the overall purpose of assessing air quality and are likely to be changed in the future-this is a difficult measurement.';
%       parastr29=strcat(parastr20,parastr21,parastr22,parastr23,parastr24);
%       p4 = Paragraph(parastr29);
%       p4.Style = {OuterMargin("0pt", "0pt","0pt","10pt")};
%       add(chapter,p4);
%     parastr30='A list of key values related to the Clear Sky Mask follows-the last 4 items relate to the 4 state mask.';
%     p5 = Paragraph(parastr30);
%     p5.Style = {OuterMargin("0pt", "0pt","0pt","10pt")};
%     add(chapter,p5);
%     LZAval1=RLZABS.value(1,1);
%     LZAval2=RLZABS.value(2,1);
%     SZAval1=RSZABS.value(1,1);
%     SZAval2=RSZABS.value(2,1);
%     CloudMaskPixels=CloudMaskPtsS.values;
%     NumberClearPixels=NumClearPixelsS.values;
%     NumberProbClearPixels=NumProbClearPixelsS.values;
%     NumberProbCloudyPixels=NumProbCloudyPixelsS.values;
%     NumberCloudyPixels=NumCloudyPixelsS.values;
%    NumOutlierPixes=OutlierPixelsS.values;
%     liststr1=strcat('Local Zenith Angle Viewing Limits-',num2str(LZAval1,4),'-to-',num2str(LZAval2,4),'-Deg');
%     liststr2=strcat('Solar Zenith Angle Viewing Limits-',num2str(SZAval1,4),'-to-',num2str(SZAval2,4),'-Deg');
%     liststr3=strcat('Number Of Cloud Mask Pixels-',num2str(CloudMaskPixels));
%     liststr4=strcat('Number Of Clear Pixels-',num2str(NumberClearPixels));
%     liststr5=strcat('Number Of Prob Clear Pixels-',num2str(NumberProbClearPixels));
%     liststr6=strcat('Number Of Prob Cloudy Pixels-',num2str(NumberProbCloudyPixels));
%     liststr7=strcat('Number Of Cloudy Pixels-',num2str(NumberCloudyPixels));
%     Lists=cell(7,1);
%     Lists{1,1}=liststr1;
%     Lists{2,1}=liststr2;
%     Lists{3,1}=liststr3;
%     Lists{4,1}=liststr4;
%     Lists{5,1}=liststr5;
%     Lists{6,1}=liststr6;
%     Lists{7,1}=liststr7;
%     ul = UnorderedList(Lists);
%     add(chapter,ul);
%     br = PageBreak();
%     add(chapter,br);
%     T4=[DQFHdr;DQFTable];
%     tbl4=Table(T4);
%     tbl4.Style = [tbl4.Style {Border('solid','black','3px')}];
%     tbl4.HAlign='center';
%     tbl4.ColSep = 'single';
%     tbl4.RowSep = 'single';
%     tbl4.TableEntriesHAlign = 'center';
%     r = row(tbl4,1);
%     r.Style = [r.Style {Color('red'),Bold(true)}];
%     bt4 = BaseTable(tbl4);
%     tabletitle = Text('DQF Table for Aerosol/Smoke/Dust Mask');
%     tabletitle.Bold = false;
%     bt4.Title = tabletitle;
%     bt4.TableWidth="7in";
%     add(chapter,bt4);
    add(rpt,chapter);
end
close('all');
fprintf(fid,'%s\n','-----Exit plot routine DisplaySmokeMask-----');
fprintf(fid,'\n');
end


