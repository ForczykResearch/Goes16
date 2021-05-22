function  DisplayConusAerosolOpticalDepthDQF(titlestr)
% Display the Aerosol Optical Depth DQF data on a CONUS Grid
% Project this data on a equiconic section map
% This uses the CONUS projection
% Note this routine is basically the same as DisplayCloudTopHeightsRev2.,
% Written By: Stephen Forczyk
% Created: Feb 14,2021
% Revised: ----
% Classification: Unclassified

global MetaDataS;
global AODS AODWaveS LandSenBandWS SeaSenBandWS;
global LandSenBandIDS SeaSenBandIDS;
global LatitudeBandS LatitudeBandBoundS;
global SnowFreeLandIceFreeSeaS;
global AOD550_RET_ATT_LandS AOD550_RET_ATT_SeaS;
global AOD550_Good_LZA_RET_ATTS AOD550_OutlierPixelS;
global AOD550_LandStatS AOD550_SeaStatS;
global LatBand_AOD550_LandStatS LatBand_AOD550_SeaStatS;
global LatBand_AOD550_RET_ATT_LandS LatBand_AOD550_RET_ATT_SeaS;
global LatBand_AOD550_LZA_RET_ATT_LandS LatBand_AOD550_LZA_GRET_ATT_LandS;
global LatBand_AOD550_LZA_HQRET_ATT_LandS;
global LatBand_AOD550_LZA_MQRET_ATT_LandS LatBand_AOD550_LZA_LQRET_ATT_LandS;
global LatBand_AOD550_LZA_NRET_ATT_LandS;
global LatBand_AOD550_LZA_GRET_ATT_SeaS LatBand_AOD550_LZA_HQRET_ATT_SeaS;
global LatBand_AOD550_LZA_MQRET_ATT_SeaS;
global LatBand_AOD550_LZA_LQRET_ATT_SeaS LatBand_AOD550_LZA_NRET_ATT_SeaS;
global DQFS tS yS xS tBS goesImagerS yImgS yImgBS;
global xImgS xImgBS SatDataS GeoSpatialS ;
global AlgoS GoesWaveBand;
global AlgoProdVersionContainerS ProcessParamS;
global QLZAS  QLZABS;
global SunGlintS SunGlintBS;
global RLZAS RLZABS RSZAS QSZAS RSZABS QSZABS;
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
global AODHdr AODTable;


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
fprintf(fid,'%s\n','-----Start plot routine Display CONUS Aerosol Optical Depth DQF-----');
eval(['cd ' gridpath(1:length(gridpath)-1)]);
[nrows,ncols]=size(AODS.values);
if((nrows==1500) && (ncols==2500))
   GridMatFileName='ConusAerosolMaskLatLonGrid.mat';
else
   disp('This does not work'); 
end
ntotpixels=nrows*ncols;
gridstr1=strcat('Loaded Map Grid From File=',GridMatFileName);
fprintf(fid,'%s\n',gridstr1);
load(GridMatFileName,'RasterLats','RasterLons');
dispstr=strcat('Loaded Grid Raster File-',GridMatFileName);
disp(dispstr)
DQF=DQFS.values;
FillValue=DQFS.FillValue;
[DQFV,numhit4] = ReplaceFillValues(DQF,FillValue);
ntotpixels=nrows*ncols;
numvals2=ntotpixels-numhit4;
DQFV1D=reshape(DQFV,ntotpixels,1);
DQFV1DS=sort(DQFV1D);
DQFV1DSF=zeros(numvals2,1);
for kk=1:numvals2
    DQFV1DSF(kk,1)=DQFV1DS(kk,1);
end
[ihit0]=find(DQFV1DS==0);
numhit0=length(ihit0);
[ihit1]=find(DQFV1DS==1);
numhit1=length(ihit1);
[ihit2]=find(DQFV1DS==2);
numhit2=length(ihit2);
[ihit3]=find(DQFV1DS==3);
numhit3=length(ihit3);
frac0=numhit0/ntotpixels;
frac1=numhit1/ntotpixels;
frac2=numhit2/ntotpixels;
frac3=numhit3/ntotpixels;
frac4=numhit4/ntotpixels;
sumfrac=frac0+frac1+frac2+frac3+frac4;
% Get the land and sea retrievals attempted
land_ret=AOD550_RET_ATT_LandS.values;
sea_ret=AOD550_RET_ATT_SeaS.values;
land_min=AOD550_LandStatS.values1;
land_max=AOD550_LandStatS.values2;
land_mean=AOD550_LandStatS.values3;
land_std=AOD550_LandStatS.values4;
sea_min=AOD550_SeaStatS.values1;
sea_max=AOD550_SeaStatS.values2;
sea_mean=AOD550_SeaStatS.values3;
sea_std=AOD550_SeaStatS.values4;
statstr1=strcat('Attempted Land Retrievals=',num2str(land_ret),'-Sea Retrievals=',num2str(sea_ret));
fprintf(fid,'%s\n',statstr1);
statstr2=strcat('Land mean AOD=',num2str(land_mean,6),'-stdev=',num2str(land_std,6));
fprintf(fid,'%s\n',statstr2);
statstr3=strcat('Sea mean AOD=',num2str(sea_mean,6),'-stdev=',num2str(sea_std,6));
fprintf(fid,'%s\n',statstr3);
statstr4=strcat('Frac of total pixels with high data quality=',num2str(frac0,6));
statstr5=strcat('Frac of total pixels with medium data quality=',num2str(frac1,6));
statstr6=strcat('Frac of total pixels with low data quality=',num2str(frac2,6));
statstr7=strcat('Frac of total pixels with no retrievals=',num2str(frac3,6));
statstr8=strcat('Frac of total pixels with NaN values=',num2str(frac4,6));
statstr9=strcat('Sum of all pixel fractions-',num2str(sumfrac,6));
fprintf(fid,'%s\n',statstr4);
fprintf(fid,'%s\n',statstr5);
fprintf(fid,'%s\n',statstr6);
fprintf(fid,'%s\n',statstr7);
fprintf(fid,'%s\n',statstr8);
fprintf(fid,'%s\n',statstr9);
AODHdr=cell(1,2);
AODTable=cell(10,2);
AODHdr{1,1}='AOD Item';
AODHdr{1,2}='Value';
AODTable{1,1}='Attempted Land Retrievals';
AODTable{1,2}=num2str(land_ret);
AODTable{2,1}='Attempted Sea Retrievals';
AODTable{2,2}=num2str(sea_ret);
AODTable{3,1}='min val AOD land';
AODTable{3,2}=num2str(land_min,5);
AODTable{4,1}='max val AOD land';
AODTable{4,2}=num2str(land_max,5);
AODTable{5,1}='mean val AOD land';
AODTable{5,2}=num2str(land_mean,5);
AODTable{6,1}='stdev val AOD land';
AODTable{6,2}=num2str(land_std,5);
AODTable{7,1}='min val AOD sea';
AODTable{7,2}=num2str(sea_min,5);
AODTable{8,1}='max val AOD sea';
AODTable{8,2}=num2str(sea_max,5);
AODTable{9,1}='mean val AOD sea';
AODTable{9,2}=num2str(sea_mean,5);
AODTable{10,1}='stdev val AOD sea';
AODTable{10,2}=num2str(sea_std,5);
ab=1;
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
geoshow(RasterLats,RasterLons,DQFV,'DisplayType','texturemap');
demcmap(DQFV,256,[],cmapland);
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
ty1=.24;
txtstr1=strcat('Start Scan-Y',num2str(YearS),'-D-',num2str(DayS),'-H-',...
    num2str(HourS),'-M-',num2str(MinuteS),'-S-',num2str(SecondS),'-----',MonthDayYearStr);
txt1=text(tx1,ty1,txtstr1,'FontWeight','bold','FontSize',12);
tx2=.85;
ty2=.75;
txtstr2='AOD-DQF';
txt2=text(tx2,ty2,txtstr2,'FontWeight','bold','FontSize',12);
tx3=.13;
ty3=.21;
txtstr3=strcat('Frac Pixel DQF=0 for high quality return-',num2str(frac0,5),'-Frac Pixel DQF=1 for medium quality return-',...
    num2str(frac1,5));
txt3=text(tx3,ty3,txtstr3,'FontWeight','bold','FontSize',12);
tx4=.13;
ty4=.18;
txtstr4=strcat('Frac Pixel DQF=2 for low quality return-',num2str(frac2,5),'-Frac Pixel DQF=3 for no return return-',...
    num2str(frac1,5));
txt4=text(tx4,ty4,txtstr4,'FontWeight','bold','FontSize',12);
tx5=.13;
ty5=.15;
txtstr5=strcat('Frac Pixel With NaN Values-',num2str(frac4,5),'-Sum Of Values 0 thru 3=',...
    num2str(sumfrac,5));
txt5=text(tx5,ty5,txtstr5,'FontWeight','bold','FontSize',12);
set(newaxesh,'Visible','Off');
% Save this chart
figstr=strcat(titlestr,'.jpg');
eval(['cd ' jpegpath(1:length(jpegpath)-1)]);
actionstr='print';
typestr='-djpeg';
[cmdString]=MyStrcat2(actionstr,typestr,figstr);
eval(cmdString);
plotstr1=strcat('Saved AOD DQF Plots as-',figstr);
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
    imdata = imread(figstr);
    [nhigh,nwid,ndepth]=size(imdata);
    image = mlreportgen.report.FormalImage();
    image.Image = which(figstr);
    pdftxtstr=strcat('Aerosol Optical Depth Map For File-',GOESShortFileName);
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
    br = PageBreak();
    add(chapter,br);
% Now add some text -start by decribing the AOD Metric
    parastr1=strcat('The Data for this chart was taken from file-',GOESShortFileName,'.');
    parastr2=strcat('There 4 valid Data Quality Factors (DQF) for the AOD metric.','Shown above is a plot of these DQF values on a CONUS map.');
    parastr3='If the DQF has a value of 0 for a pixel that pixel is said to return a high quality result which means the LZA is <60,and the pixel was in sunlight and clear.';
    parastr4='Values of DQF of 1 or 2 depict pixels with medium to low quality while a value of 3 means that no result can be returned.';
    parastr5=strcat('Some pixels have fill values-these are interpreted as NaN values and not plotted.','In the next line the DQF values and the NaN value pixels are both considered.');
    parastr6=strcat('The Hi Quality Fraction Pixels=',num2str(frac0,5),'-Med Quality=',num2str(frac1,5),'-Low Quality=',num2str(frac2,5),'.');
    parastr7=strcat('Finally,the fraction of pixels returning no values=',num2str(frac3,5),'-additionally-',num2str(frac4,5),'-have NaN values.');
%     parastr5='AOD is a dimensionless parameter that describes the extinction properties of light in the visible band.';
%     parastr6='A very clear atmosphere will have a value of .01,typical values are in the range of .10 and a very hazy atmosphere would be above 0.4.';
%     parastr7=strcat('For the image above the AOD value range was=',num2str(AODmin,6),'-to-',num2str(AODmax,6),'.','The list below shows key requirements for this product.');
    parastr9=strcat(parastr1,parastr2,parastr3,parastr4,parastr5,parastr6,parastr7);
    p1 = Paragraph(parastr9);
    p1.Style = {OuterMargin("0pt", "0pt","10pt","10pt")};
    add(chapter,p1);
% Get the data for land and sea based retrievals
    parastr11='The table on the next page details some basic statistics regarding AOD calculated from land vs sea pixels.';
    parastr12='It can be seen that this table has 10 rows and 2 columns of data. The first column identifies the data and the second the numerical value.';
    parastr13='Rows 1 and 2 quantify how many AOD data retrievals were attempted from land and sea pixels respectively.';
    parastr14='The next 4 rows provide basic statistics on the Aerosol Optical Depth for pixels reporting from land.';
    parastr15='Negative minimum values are an artifact of how the data was reported-values below zero have no real meaning.';
    parastr16='The final 4 rows provide the same data for sea based pixels.';
    if(land_mean>sea_mean)
        parastr17=strcat('The land mean AOD of-',num2str(land_mean,6),'-is greater than the corresponding sea based value of-',num2str(sea_mean,6),...
            '-which is not particularly surprising.');
    else
        parastr17=strcat('The sea mean AOD of-',num2str(sea_mean,6),'-is greater than the corresponding land based value of-',num2str(land_mean,6),...
            '-which is not typically the case.');
    end
    parastr19=strcat(parastr11,parastr12,parastr13,parastr14,parastr15,parastr16,parastr17);
    p2 = Paragraph(parastr19);
    p2.Style = {OuterMargin("0pt", "0pt","10pt","10pt")};
    add(chapter,p2);
    br = PageBreak();
    add(chapter,br);
    T1=[AODHdr;AODTable];
    tbl1=Table(T1);
    tbl1.Style = [tbl1.Style {Border('solid','black','3px')}];
    tbl1.HAlign='center';
    tbl1.TableEntriesHAlign = 'center';
    tbl1.ColSep = 'single';
    tbl1.RowSep = 'single';
    r = row(tbl1,1);
    r.Style = [r.Style {Color('red'),Bold(true)}];
    bt1 = BaseTable(tbl1);
    tabletitle = Text('AOD Stats Land Vs Sea');
    tabletitle.Bold = false;
    bt1.Title = tabletitle;
    bt1.TableWidth="7in";
    add(chapter,bt1);
% Build a KeyRqmts List
%     liststr1=strcat('AOD Coverage-','-Conus/FullDisk');
%     liststr2=strcat('AOD Vertical Resolution-','Total Air Column');
%     liststr3=strcat('AOD Horizontal Resolution-','2 km');
%     liststr4=strcat('Map Accuracy-','1 km');
%     liststr5=strcat('Measurement Range-','-0.05 to 5');
%     liststr6=strcat('Refresh Rate-','Conus-5 min,FD-15 min');
%     liststr7=strcat('Measurement Latency-','Conus-50 sec/FD-59 sec');
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
%     parastr19='Key qualifiers for AOD metric';
%     p2 = Paragraph(parastr19);
%     p2.Style = {OuterMargin("0pt", "0pt","10pt","10pt")};
%     add(chapter,p2);
%     Lists2=cell(4,1);
%     liststr12='Graphic coverage-Conus=C or Full Disk=FD';
%     liststr22='Temporal coverage-Daytime Only';
%     liststr23='Product Extent-Quantitiative out to 60 Deg LZA';
%     liststr24='Cloud Conditions-Clear Sky pixels';
%     Lists2{1,1}=liststr12;
%     Lists2{2,1}=liststr22;
%     Lists2{3,1}=liststr23;
%     Lists2{4,1}=liststr24;
%     ul2 = UnorderedList(Lists2);
%     add(chapter,ul2);
%     dqfflag1=100*DQFS.pct_high_quality_retrieval_qf;
%     dqfflagstr1=num2str(dqfflag1,6);
%     dqfflag2=100*DQFS.pct_medium_quality_retrieval_qf;
%     dqfflagstr2=num2str(dqfflag2,6);
%     dqfflag3=100*DQFS.pct_low_quality_retrieval_qf;
%     dqfflagstr3=num2str(dqfflag3,6);
%     dqfflag4=100*DQFS.pct_no_retrieval_qf;
%     dqfflagstr4=num2str(dqfflag4,6);  
% % Now build a DQF Table of key values
%     DQFHdr = {'Item' '% Of Pixels'};
%     DQFTable=cell(4,2);
%     DQFTable{1,1}='Pct High Quality Retrieval';
%     DQFTable{1,2}=dqfflagstr1;
%     DQFTable{2,1}='Pct Medium Quality Retrieval';
%     DQFTable{2,2}=dqfflagstr2;
%     DQFTable{3,1}='Pct Low Quality Retrieval';
%     DQFTable{3,2}=dqfflagstr3;
%     DQFTable{4,1}='Pct No Retrieval';
%     DQFTable{4,2}=dqfflagstr4;
%     br = PageBreak();
%     add(chapter,br);
%     T4=[DQFHdr;DQFTable];
%     tbl4=Table(T4);
%     tbl4.Style = [tbl4.Style {Border('solid','black','3px')}];
%     tbl4.HAlign='center';
%     tbl4.TableEntriesHAlign = 'center';
%     tbl4.ColSep = 'single';
%     tbl4.RowSep = 'single';
%     r = row(tbl4,1);
%     r.Style = [r.Style {Color('red'),Bold(true)}];
%     bt4 = BaseTable(tbl4);
%     tabletitle = Text('DQF Overall Table For Aerosol Optical Depth');
%     tabletitle.Bold = false;
%     bt4.Title = tabletitle;
%     bt4.TableWidth="7in";
%     add(chapter,bt4);
% Find which factor causes the most invalid/degraded pixels
%     [DQFCausesSort,Index]=sort(DQFCauses,'descend');
%     Index3=Index+1;
%     biggest_reason_str=DQFTable{Index3(1,1),1};
%     is=1;
%     ie=length(biggest_reason_str);
%     prime_cause_str=biggest_reason_str(is:ie);
%     biggest_reason_value=DQFTable{Index3(1,1),2};
%     dqfstr1=strcat('The biggest reason for rejected pixels is-',prime_cause_str,'-which results in-',biggest_reason_value,....
%         '%-of all reporting pixels reporting invalid values.');
%     fprintf(fid,'%s\n',dqfstr1);
% Add text for this table
%     parastr31='The DQF table above is intended to inform the user regarding the factors that play into the quality of the data for the AOD metric.';
%     parastr32='In calculating this metric two factors are really important-the local zenith angle (LZA) which should be less 60 deg and whether the pixel is in sunlight.';
%     parastr33=strcat('If a significant part of the scene is not sunlit and clear the rejected pixel count will be high,for this scene this is-',....
%           dqfflagstr4,'-per cent'); 
%     parastr39=strcat(parastr31,parastr32,parastr33);
%     p3 = Paragraph(parastr39);
%     p3.Style = {OuterMargin("0pt", "0pt","10pt","10pt")};
%     add(chapter,p3);
%     CreateDQF_TPW_PieChart(titlestr)
% Add text to provide additional commentary for the DQF plot
%       parastr31='The pie chart above provides additional details on the DQF_Overall quality factors.';
%       parastr32='Note that the distributions in this chart were normed to 1 prior to plotting which only covers the reasons why pixels were REJECTED.';
%       parastr39=strcat(parastr31,parastr32);
%       p3 = Paragraph(parastr39);
%       p3.Style = {OuterMargin("0pt", "0pt","10pt","10pt")};
%       add(chapter,p3);
        close('all');
%        add(rpt,chapter);
end
fprintf(fid,'%s\n','-----Exit DisplayConusAerosolOpticalDepthDQF-----');
fprintf(fid,'\n');
end


