function  [KI1DSF,sgoodfrac]=DisplayConusKIStabilityIndex(titlestr)
% Display the K Index (KI) Stability Data on a CONUS Grid
% Project this data on a equiconic section map
% This uses the CONUS projection
% Note this routine is basically the same as DisplayCloudTopHeightsRev2.,
% Written By: Stephen Forczyk
% Created: Feb 21,2021
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
fprintf(fid,'%s\n','-----Start plot routine Display CONUS KI Stability Index-----');
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
KI=KIS.values;
KI1D=reshape(KI,nrows*ncols,1);
KI1DS=sort(KI1D);
[istable]=find(KI1DS<30);
a1=isempty(istable);
if(a1==0)
    numstable=length(istable);
else
    numstable=0;
end
[iunstable]=find(KI1DS>=30);
a2=isempty(iunstable);
if(a2==0)
    numunstable=length(iunstable);
else
    numunstable=0;
end
nmeas=numunstable+numstable;
if(nmeas>0)
    fracunstable=numunstable/nmeas;
else
    fracunstable=0;
end
a1=isnan(KI1DS);
numnan=sum(a1);
numvals2=(nrows*ncols)-(numnan+1);
KI1DSF=zeros(numvals2,1);
for k=1:numvals2
    KI1DSF(k,1)=KI1DS(k,1);
end
sgoodfrac=numvals2/(nrows*ncols);
KImin=KI1DSF(1,1);
KImax=KI1DSF(numvals2,1);
statstr1=strcat('Minimum Value KI=',num2str(KImin,6),'-Max Value KI=',num2str(KImax,6),'-in Deg-C');
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
geoshow(RasterLats,RasterLons,KI,'DisplayType','texturemap');
zlimits = [KImin KImax];
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
tx2=.84;
ty2=.75;
txtstr2='KI-Deg-C';
txt2=text(tx2,ty2,txtstr2,'FontWeight','bold','FontSize',12);
tx3=.13;
ty3=.21;
txtstr3=strcat('Number of pixels with (unstable) KI values=',num2str(numunstable),...
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
plotstr1=strcat('Saved KI Stability Plots as-',figstr);
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
    add(chapter,Section('KI Index Map'));
    imdata = imread(figstr);
    [nhigh,nwid,ndepth]=size(imdata);
    image = mlreportgen.report.FormalImage();
    image.Image = which(figstr);
    pdftxtstr=strcat('KI Stability Index For File-',GOESShortFileName);
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
% Now add some text -start by decribing the KI Index Metric
    parastr151=strcat('The Data for this chart was taken from file-',GOESShortFileName,'.');
    parastr152='K Index (KI) is a calculated metric obtained from ABI sensor measurements along with a model atmosphere which provides insight to the level of atmospheric instability.';
    parastr153='Fundamentally,the K Index uses data from discrete pressure levels.It is based on 3 factors,vertical temperature changes,moisture levels and vertical extent of the moisture levels.';
    parastr154='If the KI value in Deg C is less than 30 the atmosphere is deemed stable.Severe weather can be anticipated if the KI exceeds 30.';
    parastr155='This metric can be calculated day or night in cloud free areas.';
    parastr156=strcat('Referring to the current map of the KI it can be seen that-',num2str(fracunstable,5),'-estimates are unstable based on values greater than 30 for this metric.');
    parastr159=strcat(parastr151,parastr152,parastr153,parastr154,parastr155,parastr156);
    p15 = Paragraph(parastr159);
    p15.Style = {OuterMargin("0pt", "0pt","10pt","10pt")};
    add(chapter,p15);
    close('all');
%    add(rpt,chapter);
end
fprintf(fid,'%s\n','-----Exit DisplayConusKI Stability Index Data-----');
fprintf(fid,'\n');
end


