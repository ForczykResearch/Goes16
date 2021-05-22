function  [CAPE1DSF,sgoodfrac]=DisplayConusCAPEStabilityIndex(titlestr)
% Display the CAPE Index Stability Data on a CONUS Grid
% Project this data on a equiconic section map
% This uses the CONUS projection
% Note this routine is basically the same as DisplayCloudTopHeightsRev2.,
% Written By: Stephen Forczyk
% Created: Feb 18,2021
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
fprintf(fid,'%s\n','-----Start plot routine Display CONUS CAPE Stability Index-----');
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
CAPE=CAPES.values;
CAPE1D=reshape(CAPE,nrows*ncols,1);
CAPE1DS=sort(CAPE1D);
[ilow]=find(CAPE1DS<1000);
a1=isempty(ilow);
if(a1==0)
    numlow=length(ilow);
else
    numlow=0;
end
[imedium]=find((CAPE1DS>=1000) & (CAPE1DS<=3000));
a2=isempty(imedium);
if(a2==0)
    nummedium=length(imedium);
else
    nummedium=0;
end
[ihigh]=find((CAPE1DS>=3000) & (CAPE1DS<=5000));
a2=isempty(ihigh);
if(a2==0)
    numhigh=length(ihigh);
else
    numhigh=0;
end
nmeas=numlow+nummedium+numhigh;
a1=isnan(CAPE1DS);
numnan=sum(a1);
numvals2=(nrows*ncols)-(numnan+1);
CAPE1DSF=zeros(numvals2,1);
for k=1:numvals2
    CAPE1DSF(k,1)=CAPE1DS(k,1);
end
sgoodfrac=numvals2/(nrows*ncols);
CAPEmin=CAPE1DSF(1,1);
CAPEmax=CAPE1DSF(numvals2,1);
num99=round(.99*numvals2);
val99=CAPE1DSF(num99,1);
zlow=0;
if(CAPEmax<1000)
    zhigh=1000;
elseif((CAPEmax>1000) && (CAPEmax<=3000))
    zhigh=3000;
elseif(CAPEmax>3000)
    zhigh=5000;
end
statstr1=strcat('Minimum Value CAPE=',num2str(CAPEmin,6),'-Max Value CAPE=',num2str(CAPEmax,6));
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
geoshow(RasterLats,RasterLons,CAPE,'DisplayType','texturemap');
zlimits = [zlow zhigh];
demcmap(zlimits);
%demcmap(CAPE,256,[],cmapland);
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
txtstr2='CAPE-Index-J/Kg';
txt2=text(tx2,ty2,txtstr2,'FontWeight','bold','FontSize',12);
tx3=.13;
ty3=.21;
txtstr3=strcat('The 99 ptile value of the CAPE index=',num2str(val99,5));
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
    br = PageBreak();
    add(chapter,br);
    add(chapter,Section('CAPE Index Map'));
    imdata = imread(figstr);
    [nhigh,nwid,ndepth]=size(imdata);
    image = mlreportgen.report.FormalImage();
    image.Image = which(figstr);
    pdftxtstr=strcat('CAPE Stability Index For File-',GOESShortFileName);
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
% Now add some text -start by decribing the CAPE Stability Index Metric
    parastr1=strcat('The Data for this chart was taken from file-',GOESShortFileName,'.');
    parastr2=' Convective Available Potential Energy (CAPE) is a calculated metric obtained from ABI sensor measurements along with a model atmosphere which provides insight to the level of atmospheric instability.';
    parastr3='Fundamentally, the CAPE provides a measure of the buoyancy of the atmosphere and is in units of joules per kilogram.';
    parastr4='Typically values below 3000 for this index indicate relatively stable air while values above 3000 point to stormy air masses.';
    parastr5='This metric can be calculated day or night in cloud free areas.';
    if(zhigh<=1000)
        parastr6=strcat('The maximum value of the CAPE index is-',num2str(CAPEmax,5),'-this can be interpreted to mean the atmosphere is pretty stable.');
    elseif((zhigh>=3000) && (zhigh<=4000))
        parastr6=strcat('The maximum value of the CAPE index is-',num2str(CAPEmax,5),'-this indicates fairly stable.');
    elseif(zhigh>=4000)
        parastr6=strcat('The maximum value of the CAPE index is-',num2str(CAPEmax,5),'-shows that at least in some areas the atmosphere is stormy.');
    end
    parastr7='Note that the maximum CAPE plot scale can be either 1000,3000 or 5000 to accentuate the values for each run.';
    parastr9=strcat(parastr1,parastr2,parastr3,parastr4,parastr5,parastr6,parastr7);
    p1 = Paragraph(parastr9);
    p1.Style = {OuterMargin("0pt", "0pt","10pt","10pt")};
    add(chapter,p1);
    close('all');
%    add(rpt,chapter);
end
fprintf(fid,'%s\n','-----Exit DisplayConus CAPE Stability Index Data-----');
fprintf(fid,'\n');
end


