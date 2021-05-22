function  [LST1DSF,goodfrac]=DisplayLandSurfaceTemps(titlestr)
% Display the Land Surface Temps from the GOES16/17 data
% Project this data on a equiconic section map
% This uses the CONUS projection
% Note this routine is basically the same as DisplayCloudTopHeightsRev2.,
% Written By: Stephen Forczyk
% Created: Dec 27,2020
% Revised: Dec 28,2020 added some finishing touches to the routine with the
% two output values to be used in the histogram routine
% Revised: Jan 24,2021 added logic to include output into PDF file
% Classification: Unclassified
global BandDataS MetaDataS;
global LSTS LSTStatS DQFS tS yS xS tBS goesImagerS yImgS yImgBS;
global xImgS xImgBS SatDataS GeoSpatialS;
global ReflectanceS AlgoS ErrorS EarthSunS VersionContainerS;
global GoesWaveBand ESunS kappa0S PlanckS FocalPlaneS;
global HTS DQF1S OutlierPS CloudTopS Algo1S ProcessParamS;
global LZAS LZABS SZAS SZABS Error1S CloudPixelsS;
global GOESFileName;
global MonthDayStr MonthDayYearStr;
global DayMonthNonLeapYear DayMonthLeapYear CalendarFileName;
global RptGenPresent iCreatePDFReport pdffilename rpt chapter;
global JpegCounter JpegFileList;
global DQFHdr DQFTable MiscHdr MiscTable;
global RasterLats RasterLons;
global LSTSMinValidValue LSTSMaxValidValue;
global westEdge eastEdge northEdge southEdge;
global pctclearpix pctprobclearpix pctprobcloudypix pctcloudypix;

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
fprintf(fid,'%s\n','-----Start plot routine DisplayLandSurfaceTemps-----');
eval(['cd ' gridpath(1:length(gridpath)-1)]);
[nrows,ncols]=size(LSTS.values);
if((nrows==1500) && (ncols==2500))
   GridMatFileName='ConusLSTLatLonGrid.mat';
else
   disp('This does not work'); 
end
gridstr1=strcat('Loaded Map Grid From File=',GridMatFileName);
fprintf(fid,'%s\n',gridstr1);
load(GridMatFileName,'RasterLats','RasterLons');
dispstr=strcat('Loaded Grid Raster File-',GridMatFileName);
disp(dispstr)
gridstr2=strcat('Grid had-',num2str(nrows),'-Rows And-',num2str(ncols),'-Columns');
fprintf(fid,'%s\n',gridstr2);
LST=LSTS.values;
LST1D=reshape(LST,nrows*ncols,1);
LST1DS=sort(LST1D);
a1=isnan(LST1DS);
numnan=sum(a1);
numvals2=(nrows*ncols)-(numnan+1);
LST1DSF=zeros(numvals2,1);
for k=1:numvals2
    LST1DSF(k,1)=LST1DS(k,1);
end
goodfrac=numvals2/(nrows*ncols);
num25=floor(.25*numvals2);
num50=floor(.50*numvals2);
num75=floor(.75*numvals2);
num100=numvals2;
val25=LST1DS(num25,1);
val50=LST1DS(num50,1);
val75=LST1DS(num75,1);
val100=LST1DS(num100,1);
tempstr1=strcat('Temp 25 ptile=',num2str(val25,6),'-Temp 50 ptile=',num2str(val50,6),...
    '-Temp 75 ptile=',num2str(val75,6),'-Temp 100 ptile=',num2str(val100,6),'-Deg K');
fprintf(fid,'%s\n',tempstr1);
tempstr2=strcat('Fraction of Land Pixels with calculated Temp=',num2str(goodfrac,6));
fprintf(fid,'%s\n',tempstr2);
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
geoshow(RasterLats,RasterLons,LST,'DisplayType','texturemap');
demcmap(LST,256,[],cmapland);
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
tx2=.82;
ty2=.76;
txt2=text(tx2,ty2,'Land Temp-Deg-k','FontWeight','bold','FontSize',12);
tx3=tx1;
ty3=ty1-.04;
txtstr3=strcat('Temp 25 ptile=',num2str(val25,6),'-Temp 50 ptile=',num2str(val50,6),...
    '-Temp 75 ptile=',num2str(val75,6),'-Temp 100 ptile=',num2str(val100,6),'-Deg K');
txt3=text(tx3,ty3,txtstr3,'FontWeight','bold','FontSize',12);
tx4=tx1;
ty4=ty3-.04;
txtstr4=strcat('Fraction of Land Pixels with calculated Temp=',num2str(goodfrac,6));
txt4=text(tx4,ty4,txtstr4,'FontWeight','bold','FontSize',12);
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
    headingstr1=strcat('Land Surface Temperatures For-',GOESShortFileName);
    chapter = Chapter("Title",headingstr1);
    add(chapter,Section('Land Surface Temp Map'));
    imdata = imread(figstr);
    [nhigh,nwid,ndepth]=size(imdata);
    image = mlreportgen.report.FormalImage();
    image.Image = which(figstr);
    pdftxtstr=strcat('Land Surface Temp Data For File-',GOESShortFileName);
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
% Now add some text 
%     templowlimit=SSTS.add_offset;
%     scalefactor=SSTS.scale_factor;
%     temphighlimit=floor(templowlimit+scalefactor*2^16);
    parastr1=strcat('The Data for this chart was taken from file-',GOESShortFileName,'.');
    parastr2='This dataset provides a temperature estimate of land pixels.';
%     parastr3='The algorithm computation algorithm uses Bands 7/14 and 15 so it can return values day or night.';
%     parastr4=strcat('Using these three wavebands, the ABI sensor can return valid results in the range of-',num2str(templowlimit,3),'-to-',...
%         num2str(temphighlimit,3),'-deg-K.');
    parastr6=strcat(parastr1,parastr2);
    p1 = Paragraph(parastr6);
    p1.Style = {OuterMargin("0pt", "0pt","0pt","10pt")};
    add(chapter,p1);
    br = PageBreak();
    add(chapter,br);
    DQFHdr = {'Item' '% Of Pixels'};
    DQFTable=cell(11,2);
    DQFTable{1,1}='Pct Good Retrieval';
    dqfflag1=100*DQFS.pct_good_retrieval_qf;
    dqfflagstr1=num2str(dqfflag1,6);
    DQFTable{1,2}=dqfflagstr1;
    DQFTable{2,1}='Pct Valid Input Data';
    dqfflag2=100*DQFS.pct_valid_input_data_qf;
    dqfflagstr2=num2str(dqfflag2,6);
    DQFTable{2,2}=dqfflagstr2;
    DQFTable{3,1}='Pct Invalid Due To Missing Data';
    dqfflag3=100*DQFS.pct_invalid_due_to_bad_or_missing_input_data_qf;
    dqfflagstr3=num2str(dqfflag3,6);
    DQFTable{3,2}=dqfflagstr3;
    DQFTable{4,1}='Pct_valid_clear_conditions';
    dqfflag4=100*DQFS.pct_valid_clear_conditions_qf;
    dqfflagstr4=num2str(dqfflag4,6);
    DQFTable{4,2}=dqfflagstr4;
    DQFTable{5,1}='Pct_invalid_cloudy_conditions';
    dqfflag5=100*DQFS.pct_invalid_due_to_cloudy_conditions_qf;
    dqfflagstr5=num2str(dqfflag5,6);
    DQFTable{5,2}=dqfflagstr5;
    DQFTable{6,1}='Pct_valid_LZA';
    dqfflag6=100*DQFS.pct_valid_LZA_qf;
    dqfflagstr6=num2str(dqfflag6,6);
    DQFTable{6,2}=dqfflagstr6;
    DQFTable{7,1}='Pct_degraded_LZA_threshold_exceeded';
    dqfflag7=100*DQFS.pct_degraded_due_to_LZA_threshold_exceeded_qf;
    dqfflagstr7=num2str(dqfflag7,6);
    DQFTable{7,2}=dqfflagstr7;
    DQFTable{8,1}='Pct_valid_land_inland_surf_water';
    dqfflag8=100*DQFS.pct_invalid_due_to_water_surface_type_qf;
    dqfflagstr8=num2str(dqfflag8,6);
    DQFTable{8,2}=dqfflagstr8;
    DQFTable{9,1}='Pct_invalid_due_to_water_surface_type_qf';
    dqfflag9=100*DQFS.pct_invalid_due_to_water_surface_type_qf;
    dqfflagstr9=num2str(dqfflag9,6);
    DQFTable{9,2}=dqfflagstr9;
    DQFTable{10,1}='Pct_valid_land_surface_temperature_qf';
    dqfflag10=100*DQFS.pct_valid_land_surface_temperature_qf;
    dqfflagstr10=num2str(dqfflag10,6);
    DQFTable{10,2}=dqfflagstr10;
    DQFTable{11,1}='Pct_invalid_due_to_out_of_range_land_surf_temp_qf';
    dqfflag11=100*DQFS.pct_invalid_due_to_out_of_range_land_surf_temp_qf;
    dqfflagstr11=num2str(dqfflag11,6);
    DQFTable{11,2}=dqfflagstr11;
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
    tabletitle = Text('DQF Table For Land Surface Temperatures');
    tabletitle.Bold = false;
    bt4.Title = tabletitle;
    bt4.TableWidth="7in";
    add(chapter,bt4);
end
close('all');
fprintf(fid,'%s\n','-----Exit plot routine DisplaySeaSurfaceTemps-----');
fprintf(fid,'\n');
end


