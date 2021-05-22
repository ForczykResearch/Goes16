function  [TPW1DSF,sgoodfrac]=DisplayCONUS_TPW(titlestr)
% Display the Total Precipitable Water (TPW) data on a CONUS Grid
% Project this data on a equiconic section map
% This uses the CONUS projection
% Note this routine is basically the same as DisplayCloudTopHeightsRev2.,
% Written By: Stephen Forczyk
% Created: Feb 5,2021
% Revised: Feb 7,2021 cleanup code
% Classification: Unclassified

global MetaDataS;
global TPWS;
global DQF_OverallS DQF_RetrievalS DQF_SkinTempS;
global tS yS xS tBS goesImagerS yImgS yImgBS;
global xImgS xImgBS SatDataS GeoSpatialS;
global AlgoS GoesWaveBand;
global TPWRS TRVS TotPixRS RROutPixCountS RainRateS;
global AlgoProdVersionContainerS ProcessParamS;
global QLZAS  QLZABS;
global SZAS SZABS;
global RLZAS  RLZABS;
global OutlierPixelCountS PrecipWaterS;
global LatitudeS LatitudeBoundsS;
global SoundingWaveS SoundingWaveIDS;
global TotAttempRetS;
global MeanDiffSoundingBandS StdevDiffSoundingBandS;
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
fprintf(fid,'%s\n','-----Start plot routine Display CONUS TPW-----');
eval(['cd ' gridpath(1:length(gridpath)-1)]);
[nrows,ncols]=size(TPWS.values);
if((nrows==300) && (ncols==500))
   GridMatFileName='ConusTPWBoundaries.mat';
else
   disp('This does not work'); 
end
ntotpixels=nrows*ncols;
gridstr1=strcat('Loaded Map Grid From File=',GridMatFileName);
fprintf(fid,'%s\n',gridstr1);
load(GridMatFileName,'RasterLats','RasterLons');
dispstr=strcat('Loaded Grid Raster File-',GridMatFileName);
disp(dispstr)
TPW=TPWS.values;
TPW1D=reshape(TPW,nrows*ncols,1);
TPW1DS=sort(TPW1D);
a1=isnan(TPW1DS);
numnan=sum(a1);
numvals2=(nrows*ncols)-(numnan+1);
TPW1DSF=zeros(numvals2,1);
for k=1:numvals2
    TPW1DSF(k,1)=TPW1DS(k,1);
end
sgoodfrac=numvals2/(nrows*ncols);
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
geoshow(RasterLats,RasterLons,TPW,'DisplayType','texturemap');
demcmap(TPW,256,[],cmapland);
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
ty1=.26;
txtstr1=strcat('Start Scan-Y',num2str(YearS),'-D-',num2str(DayS),'-H-',...
    num2str(HourS),'-M-',num2str(MinuteS),'-S-',num2str(SecondS),'-----',MonthDayYearStr);
txt1=text(tx1,ty1,txtstr1,'FontWeight','bold','FontSize',12);
tx2=.83;
ty2=.75;
txtstr2='TPW-mm';
txt2=text(tx2,ty2,txtstr2,'FontWeight','bold','FontSize',12);
set(newaxesh,'Visible','Off');
% Save this chart
figstr=strcat(titlestr,'.jpg');
eval(['cd ' jpegpath(1:length(jpegpath)-1)]);
actionstr='print';
typestr='-djpeg';
[cmdString]=MyStrcat2(actionstr,typestr,figstr);
eval(cmdString);
plotstr1=strcat('Saved TPW Plots as-',figstr);
disp(plotstr1);
fprintf(fid,'%s\n',plotstr1);
pause(chart_time);
if((iCreatePDFReport==1) && (RptGenPresent==1))
    [ibreak]=strfind(GOESFileName,'_e');
    is=1;
    ie=ibreak(1)-1;
    GOESShortFileName=GOESFileName(is:ie);
    headingstr1=strcat('Total Precipitable Water For-',GOESShortFileName);
    chapter = Chapter("Title",headingstr1);
    add(chapter,Section('TPW Map'));
    imdata = imread(figstr);
    [nhigh,nwid,ndepth]=size(imdata);
    image = mlreportgen.report.FormalImage();
    image.Image = which(figstr);
    pdftxtstr=strcat('Total Precipitable Water Map For File-',GOESShortFileName);
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
% Now add some text -start by decribing the TPW Metric
    parastr1=strcat('The Data for this chart was taken from file-',GOESShortFileName,'.');
    parastr2='Plotted on the chart is the Total Precipitable Water (TPW) in mm.';
    parastr3='The TPW metric is a Goes Legacy product derived from the combination of ABI sensor measurments the Legacy Atmospheric Product.';
    parastr4='A good way to think about what the TPW means is to consider that it represent the sum of water in a single column covered by the pixel.';
    parastr5='Most moisture in contained in the lower atmosphere-for this reason the sum of the water in different layers goes from the ground up to the 300 hPA level.';
    parastr6='There is another significant limit on the TPW algorithm-in performing the claculation 20% of the pixels in a 5x5 pixel box must be clear. This is significant limit.';
    parastr7=strcat('Each TPW estimate requires a 5 x 5 grid of pixels to produce one estimate-for this reason the number of possible estimates is only-',num2str(ntotpixels),'.');
    parastr8='Inspection of the chart indicates many fewer estimates than that are actually calculated and retrieved as many conditions must be met to complete the calculation of TPW.';
    parastr9=strcat(parastr1,parastr2,parastr3,parastr4,parastr5,parastr6,parastr7,parastr8);
    p1 = Paragraph(parastr9);
    p1.Style = {OuterMargin("0pt", "0pt","10pt","10pt")};
    add(chapter,p1);
% Build a Rqmts Table
    RqmtsHdr=cell(1,2);
    RqmtsHdr{1,1}='Description';
    RqmtsHdr{1,2}='Rqmts Value';
    RqmtsTable=cell(1,1);
    RqmtsTable{1,1}='Geographic Coverage';
    RqmtsTable{1,2}='FullDisk/Conus/Meso';
    RqmtsTable{2,1}='Vertical Resolution';
    RqmtsTable{2,2}='N/A';
    RqmtsTable{3,1}='Horizontal Resolution';
    RqmtsTable{3,2}='10 km';
    RqmtsTable{4,1}='Product Mapping Accuracy';
    RqmtsTable{4,2}='2 km';
    RqmtsTable{5,1}='Product Measurement Range';
    RqmtsTable{5,2}='0-100 mm';
    RqmtsTable{6,1}='Product Measurement Accuracy';
    RqmtsTable{6,2}='1 mm';
    RqmtsTable{7,1}='Product Refresh Rate-Full Disk';
    RqmtsTable{7,2}='60 minutes';
    RqmtsTable{8,1}='Product Refresh Rate-Conus';
    RqmtsTable{8,2}='30 minutes';
    RqmtsTable{9,1}='Product Refresh Rate-Meso';
    RqmtsTable{9,2}='5 minutes';
    RqmtsTable{10,1}='Data Latency';
    RqmtsTable{10,2}='806 FD/266 Conus/Meso-sec';
    RqmtsTable{11,1}='Product Extent Qualifier';
    RqmtsTable{11,2}='LZA < 67 deg';
    RqmtsTable{12,1}='Coverage Qualifier Qualifier';
    RqmtsTable{12,2}='Day/Night';
    br = PageBreak();
    add(chapter,br);
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
% Description of the Requirements table
    parastr41=strcat('The table above shows some of the requirements that were levied on the Goes satellite with respect to the TPW metric.');
    parastr42=strcat('Basic requirements are definited in 12 separate rows.');
    parastr43='This table shows that the metric can be returned at Full Disk/Conus or Meso levels-there is no vertical resolution requirement but there is a 10 km horizonal limit.';
    parastr44='Mapping accuracy is set to 2 km which is about the typical footprint at the nadir view point.';
    parastr45='The TPW metric itself should be accurate to 1 mm.';
    parastr46='Refresh rate for this metric ranges from a little as 5 minutes for meso scale up to 60 for the full disk.';
    parastr47='Data can be taken in day or night,with a latency that ranges from 266 sec to 806 sec for Full Disk mode.';
    parastr48='Finally the local zenith angle must be less than 67 degrees in order to have acceptable data.'; 
    parastr49=strcat(parastr41,parastr42,parastr43,parastr44,parastr45,parastr46,parastr47,parastr48);
    p4 = Paragraph(parastr49);
    p4.Style = {OuterMargin("0pt", "0pt","10pt","10pt")};
    add(chapter,p4);
    dqfflag1=100*DQF_OverallS.pct_good_quality_qf;
    dqfflagstr1=num2str(dqfflag1,6);
    dqfflag2=100*DQF_OverallS.pct_inval_due_to_not_geolocated_or_retrieval_LZA_qf;
    dqfflagstr2=num2str(dqfflag2,6);
    dqfflag3=100*DQF_OverallS.pct_degraded_due_to_latitude_threshold_exceeded_qf;
    dqfflagstr3=num2str(dqfflag3,6);
    dqfflag4=100*DQF_OverallS.pct_degraded_due_to_quantitative_LZA_threshold_exceeded_qf;
    dqfflagstr4=num2str(dqfflag4,6);
    dqfflag5=100*DQF_OverallS.pct_inval_due_to_insuff_clear_pixels_in_field_of_regard_qf;
    dqfflagstr5=num2str(dqfflag5,6);
    dqfflag6=100*DQF_OverallS.pct_inval_due_to_missing_NWP_data_qf;
    dqfflagstr6=num2str(dqfflag6,6);
    dqfflag7=100*DQF_OverallS.pct_inval_due_to_missing_L1b_data_or_fatal_processing_error_qf;
    dqfflagstr7=num2str(dqfflag7,6);
    dqfflag8=100*DQF_OverallS.pct_inval_due_to_bad_NWP_surface_pressure_index_qf;
    dqfflagstr8=num2str(dqfflag8,6);
    dqfflag9=100*DQF_OverallS.pct_inval_due_to_indeterminate_land_surface_emissivity_qf;
    dqfflagstr9=num2str(dqfflag9,6);
    dqfflag10=100*DQF_OverallS.pct_inval_due_to_bad_TPW_sigma_pressure_level_index_qf;
    dqfflagstr10=num2str(dqfflag10,6);
    dqfflag11=100*DQF_OverallS.pct_inval_due_to_occurrence_of_not_a_number_qf;
    dqfflagstr11=num2str(dqfflag11,6);
    DQFCauses=zeros(10,1);
    DQFCauses(1,1)=dqfflag2;
    DQFCauses(2,1)=dqfflag3;
    DQFCauses(3,1)=dqfflag4;
    DQFCauses(4,1)=dqfflag5;
    DQFCauses(5,1)=dqfflag6;
    DQFCauses(6,1)=dqfflag7;
    DQFCauses(7,1)=dqfflag8;
    DQFCauses(8,1)=dqfflag9;
    DQFCauses(9,1)=dqfflag10;
    DQFCauses(10,1)=dqfflag11;
    sumcauses=sum(DQFCauses);
    DQFLabels=cell(1,10);
    DQFLabels{1,1}='Invalid Geo Location or LZA problem';
    DQFLabels{1,2}='Degraded to Latitude Threshold Exceeded';
    DQFLabels{1,3}='Invalid due exceedance of LZA quant threshold';
    DQFLabels{1,4}='Invalid insufficient clear pixels in FOV';
    DQFLabels{1,5}='Invalid due to missing NWP data';
    DQFLabels{1,6}='Invalid due misssing L1b data';
    DQFLabels{1,7}='Invalid due bad NWP surf pressure index';
    DQFLabels{1,8}='Invalid due to indeterminate land surface emissivity';
    DQFLabels{1,9}='Invalid due bad TWP sigma pressure index';
    DQFLabels{1,10}='Invalid due occurance of NaN';
    if(sumcauses>0)
        DQFNormed=DQFCauses*100/sumcauses;
    else
        DQFNormed=DQFCauses;
    end    
% Now build a DQF Table of key values
    DQFHdr = {'Item' '% Of Pixels'};
    DQFTable=cell(11,2);
    DQFTable{1,1}='Pct Good Quality Pixel';
    DQFTable{1,2}=dqfflagstr1;
    DQFTable{2,1}='Invalid Geo Location or LZA problem';
    DQFTable{2,2}=dqfflagstr2;
    DQFTable{3,1}='Degraded due to Latitude Threshold Exceeded';
    DQFTable{3,2}=dqfflagstr3;
    DQFTable{4,1}='Invalid due to exceedance of LZA quant threshold';
    DQFTable{4,2}=dqfflagstr4;
    DQFTable{5,1}='Invalid insufficient clear pixels in FOV';
    DQFTable{5,2}=dqfflagstr5;
    DQFTable{6,1}='Invalid due to missing NWP data';
    DQFTable{6,2}=dqfflagstr6;
    DQFTable{7,1}='Invalid due to misssing L1b data';
    DQFTable{7,2}=dqfflagstr7;
    DQFTable{8,1}='Invalid due to bad NWP surf pressure index';
    DQFTable{8,2}=dqfflagstr8;
    DQFTable{9,1}='Invalid_due_to_indeterminate_land_surface_emissivity';
    DQFTable{9,2}=dqfflagstr9;
    DQFTable{10,1}='Invalid due to bad TWP sigma pressure index';
    DQFTable{10,2}=dqfflagstr10;
    DQFTable{11,1}='Invalid due to occurance of NaN';
    DQFTable{11,2}=dqfflagstr11;
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
    tabletitle = Text('DQF Overall Table For TPW');
    tabletitle.Bold = false;
    bt4.Title = tabletitle;
    bt4.TableWidth="7in";
    add(chapter,bt4);
% Find which factor causes the most invalid/degraded pixels
    [DQFCausesSort,Index]=sort(DQFCauses,'descend');
    Index3=Index+1;
    biggest_reason_str=DQFTable{Index3(1,1),1};
    is=1;
    ie=length(biggest_reason_str);
    prime_cause_str=biggest_reason_str(is:ie);
    biggest_reason_value=DQFTable{Index3(1,1),2};
    dqfstr1=strcat('The biggest reason for rejected pixels is-',prime_cause_str,'-which results in-',biggest_reason_value,....
        '%-of all reporting pixels reporting invalid values.');
    fprintf(fid,'%s\n',dqfstr1);
% Add text for this table
    parastr11=strcat('The DQF table above is intended to inform the user regarding the factors that play into the quality of the data.',...
        'The TPW metric actually has 3 different data quality factors-the table above is for the DQF_Overall variable.');
    parastr12=strcat('In the first row of the table is the per centage of all pixels that returned good data-',dqfflagstr1,'%.');
    parastr13=strcat('Inspection of the data in rows 2 through 11 reveals that the biggest cause for invalid pixels is-',prime_cause_str,'-which caused-',...
         biggest_reason_value,'-% of pixels to return invalid values.','On the next page is a pie chart showing those DQF factors relating to invalid pixels.');
    parastr19=strcat(parastr11,parastr12,parastr13);
    p2 = Paragraph(parastr19);
    p2.Style = {OuterMargin("0pt", "0pt","10pt","10pt")};
    add(chapter,p2);
    CreateDQF_TPW_PieChart(titlestr)
% Add text to provide additional commentary for the DQF plot
      parastr31='The pie chart above provides additional details on the DQF_Overall quality factors.';
      parastr32='Note that the distributions in this chart were normed to 1 prior to plotting which only covers the reasons why pixels were REJECTED.';
      parastr39=strcat(parastr31,parastr32);
      p3 = Paragraph(parastr39);
      p3.Style = {OuterMargin("0pt", "0pt","10pt","10pt")};
      add(chapter,p3);
      close('all');
end
fprintf(fid,'%s\n','-----Exit plot TPW Data-----');
fprintf(fid,'\n');
end


