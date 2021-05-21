function  [RainFallRate1DSF,sgoodfrac]=DisplayRainFallRate(titlestr)
% Display the RainFall Rate on a Full Disk Grid
% Project this data on a equiconic section map
% This uses the Full Disk projection
% Note this routine is basically the same as DisplayCloudTopHeightsRev2.,
% Written By: Stephen Forczyk
% Created: Feb 2,2021
% Revised: ---
% Classification: Unclassified

global MetaDataS;
global RRQPES;
global DQFS tS yS xS tBS goesImagerS yImgS yImgBS;
global xImgS xImgBS SatDataS GeoSpatialS;
global AlgoS GoesWaveBand;
global TPWRS TRVS TotPixRS RROutPixCountS RainRateS;
global AlgoProdVersionContainerS ProcessParamS;
global QLZAS  QLZABS;
global SZAS SZABS;
global RLZAS  RLZABS;
global LatitudeS LatitudeBoundsS;
global AcctRainRateS AcctRainRateBoundsS;
global GRBErrorsS L0ErrorsS;
global SensorList;
global westEdge eastEdge northEdge southEdge;
global GOESFileName;
global RptGenPresent iCreatePDFReport pdffilename rpt chapter;
global JpegCounter JpegFileList;
global DayMonthNonLeapYear DayMonthLeapYear CalendarFileName;
global DQFHdr DQFTable MiscHdr MiscTable RqmtsHdr RqmtsTable;
global DQFCauses DQFNormed DQFLabels;
global RasterLats RasterLons;
global idebug isavefiles;

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
fprintf(fid,'%s\n','-----Start plot routine Display RainFall Rate-----');
eval(['cd ' gridpath(1:length(gridpath)-1)]);
[nrows,ncols]=size(RRQPES.values);
if((nrows==5424) && (ncols==5424))
   GridMatFileName='GOES16-FullDisk-RainFallRateBoundaries.mat ';
else
   disp('This does not work'); 
end
ntotpixels=nrows*ncols;
gridstr1=strcat('Loaded Map Grid From File=',GridMatFileName);
fprintf(fid,'%s\n',gridstr1);
load(GridMatFileName,'RasterLats','RasterLons');
dispstr=strcat('Loaded Grid Raster File-',GridMatFileName);
disp(dispstr)
RainFallRate=RRQPES.values;
RainFallRate1D=reshape(RainFallRate,nrows*ncols,1);
RainFallRate1DS=sort(RainFallRate1D);
a1=isnan(RainFallRate1DS);
numnan=sum(a1);
numvals2=(nrows*ncols)-(numnan+1);
RainFallRate1DSF=zeros(numvals2,1);
for k=1:numvals2
    RainFallRate1DSF(k,1)=RainFallRate1DS(k,1);
end
sgoodfrac=numvals2/(nrows*ncols);
% Get some data relating to the data collection
NumRainPixels=TPWRS.values;
fracRainPixels=NumRainPixels/ntotpixels;
fracRainPixelstr=num2str(fracRainPixels,6);
NumGoodRainFall=TotPixRS.values;
fracGoodRainFall=NumGoodRainFall/ntotpixels;
fracGoodRainFallstr=num2str(fracGoodRainFall,6);
NumOutsideRange=RROutPixCountS.values;
fracOutsideRange=NumOutsideRange/ntotpixels;
fracOutsideRangestr=num2str(fracOutsideRange,6);
minRainFallRate=RainRateS.values1;
minRainFallRatestr=num2str(minRainFallRate,5);
maxRainFallRate=RainRateS.values2;
maxRainFallRatestr=num2str(maxRainFallRate,5);
meanRainFallRate=RainRateS.values3;
meanRainFallRatestr=num2str(meanRainFallRate,5);
sumRainFallRate=TRVS.values;
sumRainFallRatestr=num2str(sumRainFallRate,7);
RainFallRateLimits=AcctRainRateBoundsS.values;
rainLLstr=num2str(RainFallRateLimits(1,1),3);
rainULstr=num2str(RainFallRateLimits(2,1),3);
rainstr1=strcat('Number of pixels recording rain=',num2str(NumRainPixels));
fprintf(fid,'%s\n',rainstr1);
rainstr2=strcat('Fraction of pixels recording rain=',num2str(fracRainPixels,6));
fprintf(fid,'%s\n',rainstr2);
rainstr3=strcat('Fraction of pixels with good rainfall data=',num2str(fracGoodRainFall,6));
fprintf(fid,'%s\n',rainstr3);
rainstr4=strcat('Fraction of pixels outside valid rainfall rate data=',num2str(fracOutsideRange,6));
fprintf(fid,'%s\n',rainstr4);
rainstr5=strcat('Minimum recorded rainfall rate data=',num2str(minRainFallRate,6),'-mm/hr');
fprintf(fid,'%s\n',rainstr5);
rainstr6=strcat('Maximum recorded rainfall rate data=',num2str(maxRainFallRate,6),'-mm/hr');
fprintf(fid,'%s\n',rainstr6);
rainstr7=strcat('Mean recorded rainfall rate data=',num2str(meanRainFallRate,6),'-mm/hr');
fprintf(fid,'%s\n',rainstr7);
rainstr8=strcat('Sum recorded rainfall rate data over all pixels=',num2str(sumRainFallRate,6),'-mm/hr');
fprintf(fid,'%s\n',rainstr8);
rainstr9=strcat('Valid rainfall rates range from-',num2str(RainFallRateLimits(1,1),3),'-to-',...
    num2str(RainFallRateLimits(2,1),3),'-mm/hr');
fprintf(fid,'%s\n',rainstr9);
MiscTable=cell(8,3);
MiscTable{1,1}='Number Of Rain Pixels';
MiscTable{1,2}=floor(NumRainPixels);
MiscTable{1,3}='-';
MiscTable{2,1}='Fraction of pixels w/Rain';
MiscTable{2,2}=fracRainPixelstr;
MiscTable{2,3}='-';
MiscTable{3,1}='Fraction of pixels w/Good Data';
MiscTable{3,2}=fracGoodRainFallstr;
MiscTable{3,3}='-';
MiscTable{4,1}='Fraction of pixels Outside Range';
MiscTable{4,2}=fracOutsideRangestr;
MiscTable{4,3}='-';
MiscTable{5,1}='Minimum Rainfall Rate';
MiscTable{5,2}=minRainFallRatestr;
MiscTable{5,3}='mm/hour';
MiscTable{6,1}='Maximum Rainfall Rate';
MiscTable{6,2}=maxRainFallRatestr;
MiscTable{6,3}='mm/hr';
MiscTable{7,1}='Mean Rainfall Rate';
MiscTable{7,2}=meanRainFallRatestr;
MiscTable{7,3}='mm/hour';
MiscTable{8,1}='Summed Rainfall Rate';
MiscTable{8,2}=sumRainFallRatestr;
MiscTable{8,3}='mm/hour';
MiscTable{9,1}='Rainfall Rate Measurement Lower Limit';
MiscTable{9,2}=rainLLstr;
MiscTable{9,3}='mm/hour';
MiscTable{10,1}='Rainfall Rate Measurement Upper Limit';
MiscTable{10,2}=rainULstr;
MiscTable{10,3}='mm/hour';
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
geoshow(RasterLats,RasterLons,RainFallRate,'DisplayType','texturemap');
demcmap(RainFallRate,256,[],cmapland);
%demcmap('inc',[60 0],10);
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
tx2=.77;
ty2=.95;
txt2=text(tx2,ty2,'Rainfall-mm/hr','FontWeight','bold','FontSize',12);
set(newaxesh,'Visible','Off');
% Save this chart
figstr=strcat(titlestr,'.jpg');
eval(['cd ' jpegpath(1:length(jpegpath)-1)]);
actionstr='print';
typestr='-djpeg';
[cmdString]=MyStrcat2(actionstr,typestr,figstr);
eval(cmdString);
plotstr1=strcat('Saved RainFall Rate Plots as-',figstr);
disp(plotstr1);
fprintf(fid,'%s\n',plotstr1);
pause(chart_time);
if((iCreatePDFReport==1) && (RptGenPresent==1))
    [ibreak]=strfind(GOESFileName,'_e');
    is=1;
    ie=ibreak(1)-1;
    GOESShortFileName=GOESFileName(is:ie);
    headingstr1=strcat('RainFall Rate For-',GOESShortFileName);
    chapter = Chapter("Title",headingstr1);
    add(chapter,Section('RainFall Rate Map'));
    imdata = imread(figstr);
    [nhigh,nwid,ndepth]=size(imdata);
    image = mlreportgen.report.FormalImage();
    image.Image = which(figstr);
    pdftxtstr=strcat('RainFallRate For File-',GOESShortFileName);
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
% Now add some text -start by decribing the COD Metric
    parastr1=strcat('The Data for this chart was taken from file-',GOESShortFileName,'.');
    parastr2='Plotted on the chart is the RainFall Rate in mm/hr.';
    parastr3='The RainFall rate is a calculated metric derived from the ABI sensor measurements taken from bands 8/10/11/14/15.';
    parastr4='These are all infrared bands so these measuresments can be carried out day or night-';
    parastr5='this data product is intended to help in forecasting floods.The table below displays some key requirements for this dataset.'; 
    parastr6=strcat(parastr1,parastr2,parastr3,parastr4,parastr5);
    p1 = Paragraph(parastr6);
    p1.Style = {OuterMargin("0pt", "0pt","0pt","10pt")};
    add(chapter,p1);
% Build a Rqmts Table
    RqmtsHdr=cell(1,2);
    RqmtsHdr{1,1}='Description';
    RqmtsHdr{1,2}='Rqmts Value';
    RqmtsTable=cell(1,1);
    RqmtsTable{1,1}='Name';
    RqmtsTable{1,2}='Rainfall Rate/QPE';
    RqmtsTable{2,1}='Geographic Coverage';
    RqmtsTable{2,2}='Full Disk';
    RqmtsTable{3,1}='Temporal Coverage';
    RqmtsTable{3,2}='Day/Night';
    RqmtsTable{4,1}='Product Extent Qualifier';
    RqmtsTable{4,2}='Quantitative If LZA<70 deg or Lat<+/-60';
    RqmtsTable{5,1}='Cloud Cover Qualifier';
    RqmtsTable{5,2}='N/A';
    RqmtsTable{6,1}='Vertical Resolution';
    RqmtsTable{6,2}='N/A';
    RqmtsTable{7,1}='Horizontal Resolution';
    RqmtsTable{7,2}='2-km';
    RqmtsTable{8,1}='Mapping Accuracy';
    RqmtsTable{8,2}='2-km';
    RqmtsTable{9,1}='Measurement Range';
    RqmtsTable{9,2}='0-100 mm/hr';
    RqmtsTable{10,1}='Refresh Rate';
    RqmtsTable{10,2}='15 min';
    T2=[RqmtsHdr;RqmtsTable];
    tbl2=Table(T2);
    tbl2.Style = [tbl2.Style {Border('solid','black','3px')}];
    tbl2.HAlign='center';
    tbl2.TableEntriesHAlign = 'center';
    tbl2.ColSep = 'single';
    tbl2.RowSep = 'single';
    r = row(tbl2,1);
    r.Style = [r.Style {Color('red'),Bold(true)}];
    bt2 = BaseTable(tbl2);
    tabletitle = Text('Rainfall Rate Rqmts');
    tabletitle.Bold = false;
    bt2.Title = tabletitle;
    bt2.TableWidth="7in";
    add(chapter,bt2);
% Description of Rainfall Rate Calculation
    parastr41='A brief description is given here to detail how the rainfall rate metric is calculated.';
    parastr42='Step 1 of the computation involves identifying which pixels currently have measureable rainfall.';
    parastr43='The next step is to retrieve rainfall rates for just these pixels using measured and model data.';
    parastr44='Higher accuracy can be achieved if the models can be updated using contemporaneous radar measurments.';
    parastr45='Shown below is a bulleted list of needed sensor measurements.';
    parastr49=strcat(parastr41,parastr42,parastr43,parastr44,parastr45);
    p4 = Paragraph(parastr49);
    p4.Style = {OuterMargin("0pt", "0pt","10pt","10pt")};
    add(chapter,p4);
% Create an Unordered List Showing Key Sensor Data Needed
    SensorList=cell(7,1);
    Lists{1,1}='Calibrated Bright Temps For Bands 8/10/11/14/15';
    Lists{2,1}='Pixel Lattitude,Longitude and LZA';
    Lists{3,1}='Min bright temps for a 5 x 5 array of band 14 pixels';
    Lists{4,1}='Mean bright temps of 6 neighbor pixels for band 14';
    Lists{5,1}='relevant ABI quality control flags';
    ul = UnorderedList(Lists);
    add(chapter,ul);
    dqfflag1=100*DQFS.pct_good_quality_qf;
    dqfflagstr1=num2str(dqfflag1,6);
    dqfflag2=100*DQFS.pct_bad_quality_qf;
    dqfflagstr2=num2str(dqfflag2,6);
    sumpixqual=dqfflag1+dqfflag2;
    dqfflag3=100*DQFS.pct_degraded_due_to_LZA_or_latitude_threshold_exceeded_qf;
    dqfflagstr3=num2str(dqfflag3,6);
    dqfflag4=100*DQFS.pct_inval_due_to_bad_bright_temp_data_or_1st_rain_pred_fails_qf;
    dqfflagstr4=num2str(dqfflag4,6);
    dqfflag5=100*DQFS.pct_inval_due_to_bad_bright_temp_data_or_2nd_rain_pred_fails_qf;
    dqfflagstr5=num2str(dqfflag5,6);
    dqfflag6=100*DQFS.pct_inval_due_to_bad_bright_temp_or_1st_rain_rate_pred_fails_qf;
    dqfflagstr6=num2str(dqfflag6,6);
    dqfflag7=100*DQFS.pct_inval_due_to_bad_bright_temp_or_2nd_rain_rate_pred_fails_qf;
    dqfflagstr7=num2str(dqfflag7,6);
    dqfflag8=100*DQFS.pct_inval_due_to_missing_retrieval_coefficients_qf;
    dqfflagstr8=num2str(dqfflag8,6);
    DQFCauses=zeros(6,1);
    DQFCauses(1,1)=dqfflag3;
    DQFCauses(2,1)=dqfflag4;
    DQFCauses(3,1)=dqfflag5;
    DQFCauses(4,1)=dqfflag6;
    DQFCauses(5,1)=dqfflag7;
    DQFCauses(6,1)=dqfflag8;
    sumcauses=sum(DQFCauses);
    DQFLabels=cell(1,6);
    DQFLabels{1,1}='Degraded due LZA';
    DQFLabels{1,2}='Inval-bad bright temp 1st rain-pred';
    DQFLabels{1,3}='Inval-bad bright temp 2nd rain-pred';
    DQFLabels{1,4}='Inval-bad bright temp 1st rain-rate-pred';
    DQFLabels{1,5}='Inval-bad bright temp 2nd rain-rate-pred';
    DQFLabels{1,6}='Inval-missing retrieval coeff';
    if(sumcauses>0)
        DQFNormed=DQFCauses*100/sumcauses;
    else
        DQFNormed=DQFCauses;
    end    
% Now build a DQF Table of key values
    DQFHdr = {'Item' '% Of Pixels'};
    DQFTable=cell(8,2);
    DQFTable{1,1}='Pct Good Quality Pixel';
    DQFTable{1,2}=dqfflagstr1;
    DQFTable{2,1}='Pct Bad Quality Pixel';
    DQFTable{2,2}=dqfflagstr2;
    DQFTable{3,1}='Pct Degraded LZA Threshold';
    DQFTable{3,2}=dqfflagstr3;
    DQFTable{4,1}='Pct_Inval due_to_bad_bright_temp_data_or_1st_rain_pred_fails';
    DQFTable{4,2}=dqfflagstr4;
    DQFTable{5,1}='Pct_Inval due_to_bad_bright_temp_data_or_2nd_rain_pred_fails';
    DQFTable{5,2}=dqfflagstr5;
    DQFTable{6,1}='Pct_Inval_due_to_bad_bright_temp_or_1st_rain_rate_pred_fails';
    DQFTable{6,2}=dqfflagstr6;
    DQFTable{7,1}='Pct_Inval_due_to_bad_bright_temp_or_2nd_rain_rate_pred_fails';
    DQFTable{7,2}=dqfflagstr7;
    DQFTable{8,1}='Pct_inval_due_to_missing_retrieval_coefficients_qf';
    DQFTable{8,2}=dqfflagstr8;
    br = PageBreak();
    add(chapter,br);
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
    tabletitle = Text('DQF RainRate Table');
    tabletitle.Bold = false;
    bt4.Title = tabletitle;
    bt4.TableWidth="7in";
    add(chapter,bt4);
% Find which factor causes thre most invalid/degraded pixels
    [DQFCausesSort,Index]=sort(DQFCauses,'descend');
    Index3=Index+2;
    biggest_reason_str=DQFTable{Index3(1,1),1};
    is=4;
    ie=length(biggest_reason_str);
    prime_cause_str=biggest_reason_str(is:ie);
    biggest_reason_value=DQFTable{Index3(1,1),2};
    dqfstr1=strcat('The biggest reason for rejected pixels is-',prime_cause_str,'-which results in-',biggest_reason_value,....
        '%-of all reporting pixels reporting invalid values.');
    fprintf(fid,'%s\n',dqfstr1);
% Add text for this table
    parastr11='The DQF table shows the factors that affect the quality of the rainfall rate estimates.';
    parastr12='The first two items illustrate the per centage of good and bad quality pixels.';
    if(sumpixqual>101)
        parastr13=strcat('The sum of good and bad pixels=',num2str(sumpixqual,6),'-note this exceeds 100%.');
    elseif(sumpixqual<99)
        parastr13=strcat('The sum of good and bad pixels=',num2str(sumpixqual,6),'-note this less than 99%.');
    else
        parastr13=strcat('The sum of good and bad pixels=',num2str(sumpixqual,6),'-which is expected.');
    end
    parastr14='Rows 4 through 8 provide a mode detailed breakout for invalid or degraded pixels.';
    parastr15=strcat('Inspection of the data in rows 4 through 8 reveal that the biggest cause for invalid pixels is-',prime_cause_str,'-which caused-',...
          biggest_reason_value,'-% of pixels to return bad values.','On the next page is a pie chart showing those DQF factors relating to invalid pixels.');
    parastr16='Another observation is that the LZA flag is independent of the flags shown in rows 4 through 8 which are highly correlated.';
    parastr19=strcat(parastr11,parastr12,parastr13,parastr14,parastr15,parastr16);
    p2 = Paragraph(parastr19);
    p2.Style = {OuterMargin("0pt", "0pt","10pt","10pt")};
    add(chapter,p2);
end
close('all');
% Create the pie chart
CreateRainfallRateDQFPieChart(titlestr)
% Add the table with miscellaneous data
br = PageBreak();
add(chapter,br);
T5=[MiscHdr;MiscTable];
tbl5=Table(T5);
tbl5.Style = [tbl5.Style {Border('solid','black','3px')}];
tbl5.HAlign='center';
tbl5.TableEntriesHAlign = 'center';
tbl5.ColSep = 'single';
tbl5.RowSep = 'single';
r = row(tbl5,1);
r.Style = [r.Style {Color('red'),Bold(true)}];
bt5 = BaseTable(tbl5);
tabletitle = Text('Miscellaneous Data Relating to Rain Rate Estimation');
tabletitle.Bold = false;
bt5.Title = tabletitle;
bt5.TableWidth="7in";
add(chapter,bt5);
% Add a paragraph to describe this table
parastr51='The table shown above displays some additional facts related to the Rainfall Rate Estimation Process.';
parastr52='This table has 10 rows of data showing a variety of related quantities.';
parastr53='Rows 1 and 2 show the actual number of pixels that had measureable rainfall and what fraction of pixels this was.';
parastr54='Values shown in Rows 3 and 4 correspond to what fraction of the pixels had good data,or data outside the valid range respectively.';
parastr55=strcat('The min,max and mean rainfall rates are provided in rows 5,6 and 7.','Row 8 displays the rainfall rate summed over all the pixels.');
parastr56='The lower and upper limits of the rainfall rate that can be measured by GOES are available in the last 2 rows.';
parastr59=strcat(parastr51,parastr52,parastr53,parastr54,parastr55,parastr56);
p5 = Paragraph(parastr59);
p5.Style = {OuterMargin("0pt", "0pt","10pt","10pt")};
add(chapter,p5);
fprintf(fid,'%s\n','-----Exit plot routine Display RainFall Rate-----');
fprintf(fid,'\n');
%add(rpt,chapter);
end


