function  [LI1DSF,sgoodfrac]=DisplayConusLIStabilityIndex(titlestr)
% Display the Lift Index (LI) Stability Data on a CONUS Grid
% Project this data on a equiconic section map
% This uses the CONUS projection
% Note this routine is basically the same as DisplayCloudTopHeightsRev2.,
% Written By: Stephen Forczyk
% Created: Feb 17,2021
% Revised: ----
% Classification: Unclassified

global MetaDataS;
global LIS CAPES TTS SIS KIS;
global FAPS;
global DQF_OverallS DQF_RetrievalS DQF_SkinTempS;
global TotAttRetS;
global CAPEOutlierPixelS LIOutlierPixelS KIOutlierPixelS;
global ShowOutlierPixelS TTIOutlierPixelS;
global CAPEStatS LIStatS TTStatS ShowStatS KIStatS;
global tS yS xS tBS goesImagerS yImgS yImgBS;
global xImgS xImgBS SatDataS GeoSpatialS;
global AlgoS GoesWaveBand;
global TPWRS TRVS TotPixRS RROutPixCountS RainRateS;
global AlgoProdVersionContainerS ProcessParamS;
global QLZAS  QLZABS;
global SZAS SZABS;
global RLZAS  RLZABS;
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
fprintf(fid,'%s\n','-----Start plot routine Display CONUS LI Stability Index-----');
eval(['cd ' gridpath(1:length(gridpath)-1)]);
ab=1;
[nrows,ncols]=size(LIS.values);
if((nrows==300) && (ncols==500))
   GridMatFileName='ConusStabilityIndexBoundaries.mat';
else
   disp('This does not work'); 
end
ntotpixels=nrows*ncols;
gridstr1=strcat('Loaded Map Grid From File=',GridMatFileName);
fprintf(fid,'%s\n',gridstr1);
load(GridMatFileName,'RasterLats','RasterLons');
dispstr=strcat('Loaded Grid Raster File-',GridMatFileName);
disp(dispstr)
LI=LIS.values;
LI1D=reshape(LI,nrows*ncols,1);
LI1DS=sort(LI1D);
[ilow]=find(LI1DS<0);
a1=isempty(ilow);
if(a1==0)
    numunstable=length(ilow);
else
    numunstable=0;
end
[ihigh]=find(LI1DS>0);
a2=isempty(ihigh);
if(a2==0)
    numstable=length(ihigh);
else
    numstable=0;
end
nmeas=numunstable+numstable;
if(nmeas>0)
    fracunstable=numunstable/nmeas;
else
    fracunstable=0;
end
a1=isnan(LI1DS);
numnan=sum(a1);
numvals2=(nrows*ncols)-(numnan+1);
LI1DSF=zeros(numvals2,1);
for k=1:numvals2
    LI1DSF(k,1)=LI1DS(k,1);
end
sgoodfrac=numvals2/(nrows*ncols);
LImin=LI1DSF(1,1);
LImax=LI1DSF(numvals2,1);
%LI=LI-LImin;
statstr1=strcat('Minimum Value LI=',num2str(LImin,6),'-Max Value LI=',num2str(LImax,6));
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
geoshow(RasterLats,RasterLons,LI,'DisplayType','texturemap');
zlimits = [min(LI(:)) max(LI(:))];
demcmap(zlimits);
%demcmap(LI,256,[],cmapland);
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
tx2=.80;
ty2=.75;
txtstr2='Lift-Index-Deg-K';
txt2=text(tx2,ty2,txtstr2,'FontWeight','bold','FontSize',12);
tx3=.13;
ty3=.21;
txtstr3=strcat('Number of pixels with negative (unstable) LI values=',num2str(numunstable),...
    '-fraction of pixels that are unstable=',num2str(fracunstable,5));
txt3=text(tx3,ty3,txtstr3,'FontWeight','bold','FontSize',12);
set(newaxesh,'Visible','Off');
% Save this chart
figstr=strcat(titlestr,'.jpg');
eval(['cd ' jpegpath(1:length(jpegpath)-1)]);
actionstr='print';
typestr='-djpeg';
[cmdString]=MyStrcat2(actionstr,typestr,figstr);
eval(cmdString);
plotstr1=strcat('Saved LI Stability Plots as-',figstr);
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
    headingstr1=strcat('Atmospheric Stability Index-',GOESShortFileName);
    chapter = Chapter("Title",headingstr1);
    add(chapter,Section('Lift Index Map'));
    imdata = imread(figstr);
    [nhigh,nwid,ndepth]=size(imdata);
    image = mlreportgen.report.FormalImage();
    image.Image = which(figstr);
    pdftxtstr=strcat('Lift Stability Index For File-',GOESShortFileName);
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
% Now add some text -start by decribing the AOD Metric
    parastr1=strcat('The Data for this chart was taken from file-',GOESShortFileName,'.');
    parastr2='Lift Index (LI) is a calculated metric obtained from ABI sensor measurements along with a model atmosphere which provides insight to the level of atmospheric instability.';
    parastr3='Fundamentally, the Lift Index provides a measure of the stability of the atmosphere and is in units of temperature.';
    parastr4='If the LI is negative, it means that the parcel of air is warmer than its surroundings and is not stable.';
    parastr5='This metric can be calculated day or night in cloud free areas.';
    parastr6=strcat('Referring to the current map of the LI iy can be seen that-',num2str(fracunstable,5),'-estimates are unstable based on negative values for this metric.');
    parastr9=strcat(parastr1,parastr2,parastr3,parastr4,parastr5,parastr6);
    p1 = Paragraph(parastr9);
    p1.Style = {OuterMargin("0pt", "0pt","10pt","10pt")};
    add(chapter,p1);
% Build a KeyRqmts List
    RqmtsHdr={'Item'  'Requirement'};
    RqmtsTable=cell(10,2);
    RqmtsTable{1,1}='Geographic Coverage';
    RqmtsTable{1,2}='Conus/FullDisk/MesoScale';
    RqmtsTable{2,1}='Vertical Resolution';
    RqmtsTable{2,2}='N/A';
    RqmtsTable{3,1}='Horizontal Resolution';
    RqmtsTable{3,2}='10 Km';
    RqmtsTable{4,1}='Mapping Accuracy';
    RqmtsTable{4,2}='2 Km';
    RqmtsTable{5,1}='Measurement Range-LI';
    RqmtsTable{5,2}='-10 to 40 Deg-K';
    RqmtsTable{6,1}='Measurement Range-CAPE';
    RqmtsTable{6,2}='0-5000 J/kg';
    RqmtsTable{7,1}='Measurement Range-Showalter';
    RqmtsTable{7,2}='>4 to -10K';
    RqmtsTable{8,1}='Measurement Range-Total totals';
    RqmtsTable{8,2}='-43 to 56K';
    RqmtsTable{9,1}='Measurement Range-K Index';
    RqmtsTable{9,2}='0 to 40';
    RqmtsTable{10,1}='Measurement Accuracy-LI';
    RqmtsTable{10,2}='2 K';
    RqmtsTable{11,1}='Measurement Accuracy-CAPE';
    RqmtsTable{11,2}='1000 J/kg';
    RqmtsTable{12,1}='Measurement Accuracy-Showalter';
    RqmtsTable{12,2}='2 K';
    RqmtsTable{13,1}='Measurement Accuracy-Total totals';
    RqmtsTable{13,2}='1 K';
    RqmtsTable{14,1}='Measurement Accuracy-K Index';
    RqmtsTable{14,2}='2 K';
    RqmtsTable{15,1}='Refresh Rate-Minutes';
    RqmtsTable{15,2}='Conus-30/FullDisk-60/Meso-5';
    RqmtsTable{16,1}='Data Latency-Sec';
    RqmtsTable{16,2}='Conus-159/FullDisk-159/Meso-266';
    RqmtsTable{17,1}='Temporal Coverage';
    RqmtsTable{17,2}='Day/Night';
    RqmtsTable{18,1}='LHA Extent';
    RqmtsTable{18,2}='67 Deg';
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
    tabletitle = Text('Requirments For Stability Indices');
    tabletitle.Bold = false;
    bt1.Title = tabletitle;
    bt1.TableWidth="7in";
    add(chapter,bt1);
    parastr11='The table above defines keys requirements on the GOES system regard the 5 Stability Incides that are calculated.';
    parastr12=strcat('There are 5 stability indices - Lift Index (LI) - Convective available potential energy (CAPE)-',...
        'Totals total Index (TT)-','Showalter Index (SI) and K Indices (KI)- most of which are in units of Deg-K.');
    parastr13=strcat('A few items may need clarification,','the hoizontal resolution is 10 km because a 5x5 array of pixels is',...
        ' used to compute one estimate and each of these pixels has a nominal 2 km footprint on the earth.');
    parastr14='Vertical resolution is not applicable as the index referes to an air column from the ground to the 100 hPA level.';
    parastr15='The CAPE index is really in units of energy rather than temperature.';
    parastr16='Temporal coverage extends through the day/night cycle as vis and IR bands are used but the air column must be clear.';
    parastr19=strcat(parastr11,parastr12,parastr13,parastr14,parastr15,parastr16);
    p2 = Paragraph(parastr19);
    p2.Style = {OuterMargin("0pt", "0pt","10pt","10pt")};
    add(chapter,p2);
% Now build a DQF Table of key values
    DQFHdr = {'Item' '% Of Pixels'};
    DQFTable=cell(11,2);
    DQFTable{1,1}='Pct Good Quality';
    dqfflag1=100*DQF_OverallS.pct_good_quality_qf;
    dqfflagstr1=num2str(dqfflag1,6);
    DQFTable{1,2}=dqfflagstr1;
    DQFTable{2,1}='Pct Invalid Geolocation/LHA Problems';
    dqfflag2=100*DQF_OverallS.pct_inval_due_to_not_geolocated_or_retrieval_LZA_qf;
    dqfflagstr2=num2str(dqfflag2,6);
    DQFTable{2,2}=dqfflagstr2;
    DQFTable{3,1}='Pct Degraded Latitude Threshold Exceeded';
    dqfflag3=100*DQF_OverallS.pct_degraded_due_to_latitude_threshold_exceeded_qf;
    dqfflagstr3=num2str(dqfflag3,6);
    DQFTable{3,2}=dqfflagstr3;
    DQFTable{4,1}='Pct Degraded Quant LHA Threshold Exceeded';
    dqfflag4=100*DQF_OverallS.pct_degraded_due_to_quantitative_LZA_threshold_exceeded_qf;
    dqfflagstr4=num2str(dqfflag4,6);
    DQFTable{4,2}=dqfflagstr4;
    DQFTable{5,1}='Pct Inval Insufficient Clear Pixel in FOR';
    dqfflag5=100*DQF_OverallS.pct_inval_due_to_insuff_clear_pixels_in_field_of_regard_qf;
    dqfflagstr5=num2str(dqfflag5,6);
    DQFTable{5,2}=dqfflagstr5;
    DQFTable{6,1}='Pct Inval Missing NWP Data';
    dqfflag6=100*DQF_OverallS.pct_inval_due_to_missing_NWP_data_qf;
    dqfflagstr6=num2str(dqfflag6,6);
    DQFTable{6,2}=dqfflagstr6;
    DQFTable{7,1}='Pct Inval Missing L1b data';
    dqfflag7=100*DQF_OverallS.pct_inval_due_to_missing_L1b_data_or_fatal_processing_error_qf;
    dqfflagstr7=num2str(dqfflag7,6);
    DQFTable{7,2}=dqfflagstr7;
    DQFTable{8,1}='Pct Inval Bad NWP Surf Pressure';
    dqfflag8=100*DQF_OverallS.pct_inval_due_to_bad_NWP_surface_pressure_index_qf;
    dqfflagstr8=num2str(dqfflag8,6);
    DQFTable{8,2}=dqfflagstr8;
    DQFTable{9,1}='Pct Inval Indeterminate Land Surf';
    dqfflag9=100*DQF_OverallS.pct_inval_due_to_indeterminate_land_surface_emissivity_qf;
    dqfflagstr9=num2str(dqfflag9,6);
    DQFTable{9,2}=dqfflagstr9;
    DQFTable{10,1}='Pct Inval Bad TPW Pressure Level';
    dqfflag10=100*DQF_OverallS.pct_inval_due_to_bad_TPW_sigma_pressure_level_index_qf;
    dqfflagstr10=num2str(dqfflag10,6);
    DQFTable{10,2}=dqfflagstr10;
    DQFTable{11,1}='Pct Inval NaN';
    dqfflag11=100*DQF_OverallS.pct_inval_due_to_occurrence_of_not_a_number_qf;
    dqfflagstr11=num2str(dqfflag11,6);
    DQFTable{11,2}=dqfflagstr11;
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
    parastr31='The DQF table above is intended to inform the user regarding the factors that play into the quality of the data for the Stability Indices .';
    parastr32='Row 1 of the table details the fraction of pixels that returned good values-note this statistic is based only on pixels that did return any values.';
    parastr33=dqfstr1;
    parastr34=strcat('Another factor is the LHA angle which must be less than 67 degrees to return good data.',...
        'Beyond this limit it is possible for the algorithm to return some quantitative but inaccurate results out to a LHA of about 70 deg.');
    parastr39=strcat(parastr31,parastr32,parastr33,parastr34);
    p3 = Paragraph(parastr39);
    p3.Style = {OuterMargin("0pt", "0pt","10pt","10pt")};
    add(chapter,p3);
    br = PageBreak();
    add(chapter,br);
    T2=[DQFHdr;DQFTable];
    tbl2=Table(T2);
    tbl2.Style = [tbl2.Style {Border('solid','black','3px')}];
    tbl2.HAlign='center';
    tbl2.TableEntriesHAlign = 'center';
    tbl2.ColSep = 'single';
    tbl2.RowSep = 'single';
    r = row(tbl2,1);
    r.Style = [r.Style {Color('red'),Bold(true)}];
    bt2 = BaseTable(tbl2);
    tabletitle = Text('DQF Overall Table Stability Indices');
    tabletitle.Bold = false;
    bt2.Title = tabletitle;
    bt2.TableWidth="7in";
    add(chapter,bt2);
    CreateDQF_StabilityIndex_PieChart(titlestr)
    close('all');
end
fprintf(fid,'%s\n','-----Exit DisplayConusLI Stability Index Data-----');
fprintf(fid,'\n');
end


