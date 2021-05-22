function DisplayLightningConusData(titlestr)
% Display the CMI Moisture Data from the GOES16/17 data
% on a texture map for the USA
% Written By: Stephen Forczyk
% Created: August 5,2020
% Revised: August 9,2020 numerous changes made to better plots
% islands,changed file naming convention and discarded landarea
% file read to reduce plot time
% Classification: Unclassified

global BandDataS MetaDataS;
global CMIS DQF2S tS yS xS tBS goesImagerS yImgS yImgBS;
global xImgS xImgBS SatDataS GeoSpatialS;
global ReflectanceS AlgoS ErrorS EarthSunS VersionContainerS;
global GoesWaveBand ESunS kappa0S PlanckS FocalPlaneS;
global GOESFileName OutlierPS CloudTopTS LZAS LZABS SZAS SZABS;
global TempS Algo2S ProcessParamTS AlgoProductTS Error1S CloudPixelsS;
global EventIDS EventTimeS EventLocS EventEnergyS;
global GroupIDS GQFS FlashDataS FlashData2S FlashQFS;
global ProductTimeS LightningWaveS NavL1bS YawFlipFlagS LonFOVS LatFOVS;
global ProcessParamVersionContainerS;
global westEdge eastEdge northEdge southEdge;
global MonthDayStr MonthDayYearStr;
global DayMonthNonLeapYear DayMonthLeapYear CalendarFileName;
global FlashEnergy FlashDuration FlashLats FlashLons;
global FlashMinEnergy FlashMaxEnergy FlashMinDuration FlashMaxDuration;
global FlashStartTimes FlashEndTimes;
global RptGenPresent iCreatePDFReport pdffilename rpt chapter;
global JpegCounter JpegFileList;
global DQFHdr DQFTable MiscHdr MiscTable RqmtsHdr RqmtsTable;
global DQFCauses DQFNormed DQFLabels;
global PhPA rho zPress;

global widd2 lend2;
global initialtimestr igrid ijpeg ilog imovie;
global vert1 hor1 widd lend;
global vert2 hor2 machine;
global chart_time;
global Fz1 Fz2;
global idirector mov izoom iwindow;
global matpath GOES16path;
global jpegpath ;
global smhrpath excelpath ascpath;
global ipowerpoint PowerPointFile scaling stretching padding;
global ichartnum;
% additional paths needed for mapping
global matpath1 mappath;
global canadapath stateshapepath topopath;
global trajpath militarypath;
global figpath screencapturepath;
global shapepath2 countrypath countryshapepath usstateboundariespath;
global GOES16Band1path GOES16Band2path GOES16Band3path GOES16Band4path;
global GOES16Band5path GOES16Band6path GOES16Band7path GOES16Band8path
global GOES16Band9path GOES16Band10path GOES16Band11path GOES16Band12path;
global GOES16Band13path GOES16Band14path GOES16Band15path GOES16Band16path;
global GOES16CloudTopHeightpath shapefilepath;
global fid;
global widd2 lend2;
global initialtimestr igrid ijpeg ilog imovie;
global vert1 hor1 widd lend;
if((iCreatePDFReport==1) && (RptGenPresent==1))
    import mlreportgen.dom.*;
    import mlreportgen.report.*;
end
fprintf(fid,'\n');
fprintf(fid,'%s\n','-----Start plot routine Display CONUS Lightning Data-----');
FlashStartTimes=FlashDataS.values2;
FlashEndTimes=FlashDataS.values3;
FlashEnergy=FlashData2S.values4;
FlashDuration=FlashEndTimes-FlashStartTimes;
FlashMinDuration=min(FlashDuration);
FlashMaxDuration=max(FlashDuration);
FlashMinEnergy=min(FlashEnergy);
FlashMaxEnergy=max(FlashEnergy);
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
ax=axesm('mercator','Frame','on','Grid','on','MapLatLimit',[southEdge northEdge],...
    'MapLonLimit',[westEdge eastEdge],'meridianlabel','on','parallellabel','on','plabellocation',10,'mlabellocation',10,...
    'MLabelParallel','south');
set(gcf,'Position',[hor1 vert1 widd lend])
set(gcf,'MenuBar','none');
rivers = shaperead('worldrivers.shp', 'UseGeoCoords', true);
numrows=length(rivers);
for n=1:numrows % Plot the rivers
   NowLon=rivers(n).Lon;
   NowLat=rivers(n).Lat;
   plotm(NowLat,NowLon,'b');
end
dispstr=strcat('finished plotting-',num2str(numrows),'-rivers');
disp(dispstr)
hold on
eval(['cd ' mappath(1:length(mappath)-1)]);
load('USAHiResBoundaries.mat','USALat','USALon');
plotm(USALat,USALon,'r');
load('CanadaBoundaries.mat','CanadaLat','CanadaLon');
plotm(CanadaLat,CanadaLon,'k');
load('MexicoBoundaries.mat','MexicoLat','MexicoLon');
plotm(MexicoLat,MexicoLon,'k');
load('CubaBoundaries.mat','CubaLat','CubaLon');
plotm(CubaLat,CubaLon,'g');
% load('USAHiResBoundaries.mat');
% plotm(USALat,USALon,'r');
% load('CanadaBoundaries.mat');
% plotm(CanadaLat,CanadaLon,'k');
% load('MexicoBoundaries.mat');
% plotm(MexicoLat,MexicoLon,'k');
load('BelizeBoundaries.mat');
plotm(BelizeLat,BelizeLon,'g');
load('DominicanRepublicBoundaries.mat');
plotm(DRLat,DRLon,'g');
load('HaitiBoundaries.mat');
plotm(HaitiLat,HaitiLon,'r');
load('JamaicaBoundaries.mat');
plotm(JamaicaLat,JamaicaLon,'r');
load('DominicaBoundaries.mat');
plotm(DominicaLat,DominicaLon,'k');
load('HondurasBoundaries.mat');
plotm(HondurasLat,HondurasLon,'k');
load('ElSalvadorBoundaries.mat');
plotm(ElSalvadorLat,ElSalvadorLon,'r');
load('GautemalaBoundaries.mat');
plotm(GautemalaLat,GautemalaLon,'k');
load('ColumbiaBoundaries.mat');
plotm(ColumbiaLat,ColumbiaLon,'r');
load('VenezuelaBoundaries.mat');
plotm(VenezuelaLat,VenezuelaLon,'k');
load('GuyanaBoundaries.mat');
plotm(GuyanaLat,GuyanaLon,'r');
load('SurinameBoundaries.mat');
plotm(SurinameLat,SurinameLon,'r');
load('BrazilBoundaries.mat');
plotm(BrazilLat,BrazilLon,'k');
load('ParaguayBoundaries.mat');
plotm(ParaguayLat,ParaguayLon,'k');
load('EcuadorBoundaries.mat');
plotm(EcuadorLat,EcuadorLon,'k');
load('PeruBoundaries.mat');
plotm(PeruLat,PeruLon,'c');
load('BoliviaBoundaries.mat');
plotm(BoliviaLat,BoliviaLon,'r--');
load('ChileBoundaries.mat');
plotm(ChileLat,ChileLon,'g');
load('ArgentinaBoundaries.mat');
plotm(ArgentinaLat,ArgentinaLon,'r');
load('UruguayBoundaries.mat');
plotm(UruguayLat,UruguayLon,'g');
load('NicaraguaBoundaries.mat');
plotm(NicaraguaLat,NicaraguaLon,'r');
load('CostaRicaBoundaries.mat');
plotm(CostaRicaLat,CostaRicaLon,'g');
load('PanamaBoundaries.mat');
plotm(PanamaLat,PanamaLon,'r');
load('GreenlandBoundaries.mat');
plotm(GreenlandLat,GreenlandLon,'g-.');
load('GrenadaBoundaries.mat');
plotm(GrenadaLat,GrenadaLon,'r');
load('FrenchGuianaBoundaries.mat');
plotm(FrenchGuianaLat,FrenchGuianaLon,'r');
load('BelizeBoundaries.mat');
plotm(BelizeLat,BelizeLon,'g-.');
load('BahamasBoundaries.mat');
plotm(BahamasLat,BahamasLon,'g-.');
load('BarbadosBoundaries.mat');
plotm(BarbadosLat,BarbadosLon,'g-.');
load('BritishVirginIslandsBoundaries.mat');
plotm(BVALat,BVALon,'k');
plotm(FlashLats,FlashLons,'gd','MarkerSize',6,'MarkerEdgeColor','g',...
    'MarkerFaceColor','y')
numflashes=length(FlashLats);
title(titlestr)
hold off
newaxesh=axes('Position',[0 0 1 1]);
set(newaxesh,'XLim',[0 1],'YLim',[0 1]);
tx1=.78;
ty1=.86;
txtstr1=strcat('Start Scan-Y',num2str(YearS),'-D-',num2str(DayS),'-H-',...
    num2str(HourS),'-M-',num2str(MinuteS),'-S-',num2str(SecondS));
txt1=text(tx1,ty1,txtstr1,'FontWeight','bold','FontSize',8);
tx2=.78;
ty2=.83;
txtstr2=strcat('End Scan-Y',num2str(YearE),'-D-',num2str(DayE),'-H-',...
    num2str(HourE),'-M-',num2str(MinuteE),'-S-',num2str(SecondE));
txt2=text(tx2,ty2,txtstr2,'FontWeight','bold','FontSize',8);
tx3a=.78;
ty3a=.80;
txtstr3a=strcat('Calendar Date-',MonthDayYearStr);
txt3a=text(tx3a,ty3a,txtstr3a,'FontWeight','bold','FontSize',8);
tx3b=.78;
ty3b=.76;
txtstr3b='--------------------------';
txt3b=text(tx3b,ty3b,txtstr3b,'FontWeight','bold','FontSize',8);
tx3c=.78;
ty3c=.73;
txtstr3c=strcat('Number of Lighting Flashes=',num2str(numflashes));
txt3c=text(tx3c,ty3c,txtstr3c,'FontWeight','bold','FontSize',8);

tx4=.78;
ty4=.70;
txtstr4=strcat('Min Flash Duration-Sec=',num2str(FlashMinDuration));
txt4=text(tx4,ty4,txtstr4,'FontWeight','bold','FontSize',8);
tx5=.78;
ty5=.67;
txtstr5=strcat('Max Flash Duration-Sec=',num2str(FlashMaxDuration));
txt5=text(tx5,ty5,txtstr5,'FontWeight','bold','FontSize',8);
tx6=.78;
ty6=.64;
txtstr6=strcat('Max Flash Energy-J=',num2str(FlashMaxEnergy));
txt6=text(tx6,ty6,txtstr6,'FontWeight','bold','FontSize',8);
tx7=.78;
ty7=.61;
txtstr7=strcat('Min Flash Energy-J=',num2str(FlashMinEnergy));
txt7=text(tx7,ty7,txtstr7,'FontWeight','bold','FontSize',8);
set(newaxesh,'Visible','Off');
% Save this chart
figstr2=strcat(titlestr,'.jpg');
figstr=strcat('LightningFlashes-GLM-L2-LCFA-','Y',num2str(YearS),'D',...
    num2str(DayS),'H',num2str(HourS),'M',num2str(MinuteS),'S',num2str(SecondS),...
    '.jpg');
eval(['cd ' jpegpath(1:length(jpegpath)-1)]);
actionstr='print';
typestr='-djpeg';
[cmdString]=MyStrcat2(actionstr,typestr,figstr);
eval(cmdString);
dispstr=strcat('Saved Image To File-',figstr);
disp(dispstr)
pause(chart_time);
JpegCounter=JpegCounter+1;
JpegFileList{JpegCounter+1,1}=figstr;
JpegFileList{JpegCounter+1,2}=jpegpath;
close('all');
if((iCreatePDFReport==1) && (RptGenPresent==1))
    [ibreak]=strfind(GOESFileName,'_e');
    is=1;
    ie=ibreak(1)-1;
    GOESShortFileName=GOESFileName(is:ie);
    headingstr1=strcat('GLM Lighting Data For-',GOESShortFileName);
    chapter = Chapter("Title",headingstr1);
    sectionstr=strcat('CONUS-GLM-Lightning');
    add(chapter,Section(sectionstr));
    imdata = imread(figstr);
    [nhigh,nwid,ndepth]=size(imdata);
    image = mlreportgen.report.FormalImage();
    image.Image = which(figstr);
    pdftxtstr=strcat('GLM Lightning Data-For File-',GOESShortFileName);
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
% Now add some text -start by decribing the GLM2 Lightning
    parastr11=strcat('The Data for this chart was taken from file-',GOESShortFileName,'.');
    parastr12='Plotted on the chart is the a number of lighting events as detected by the GLM sensor';
    parastr13='The GLM sensor is inherently different from the data produced by the ABI sensor which is a true imager';
%     parastr4='A good way to think about what the LVM means is to consider that it represents the relative humidity level at a specific pressure level.';
%     parastr5=strcat('The selected level of-',num2str(ilevel),'-has a pressure of-',num2str(nowPressureLevel,6),'-hPA.',...
%         'In turn,this has an altitude of about-',num2str(zLevelkm,5),'-km.');
%     parastr6='As written to the file,the LVM data is a 3 D array of size (nlevels)X(nrows)X(ncols).';
%     parastr7=strcat('The chart above is for a single level and has dimensions of nrowsXncols.',...
%         'Each file has data for 101 different pressure levels-these presssure levels can be related to a height using the standard US model Atmosphere.');
%     parastr8=strcat('Care should be taken in comparing a pressure level to a physical altitude.',...
%         'This value can change with atmospheric temperature-the model used here only employed a nominal temperature for the air mass.');
    parastr19=strcat(parastr11,parastr12,parastr13);
    p1 = Paragraph(parastr19);
    p1.Style = {OuterMargin("0pt", "0pt","10pt","10pt")};
    add(chapter,p1);
end
fprintf(fid,'%s\n','-----End plot routine Display CONUS Lightning Data-----');
fprintf(fid,'\n');
add(rpt,chapter);
end


