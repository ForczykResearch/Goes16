function PlotLightningFlashEnergyHistogram(titlestr)
% This routine will plot a histogram of the Lightning Flash Energy values
% in units of picoJoules
% Written By: Stephen Forczyk
% Created: Mar 19,2021
% Revised: Mar 20,2021 code cleanup
% Classification: Unclassified

global BandDataS MetaDataS;
global DQF2S tS yS xS tBS goesImagerS yImgS yImgBS;
global xImgS xImgBS SatDataS GeoSpatialS GoesLatLonProjS;
global ReflectanceS AlgoS ErrorS EarthSunS VersionContainerS;
global GoesWaveBand ESunS kappa0S PlanckS FocalPlaneS;
global GOESFileName OutlierPS CloudTopTS LZAS LZABS SZAS SZABS;
global TempS Algo2S ProcessParamTS AlgoProductTS Error1S CloudPixelsS;
global EventIDS EventTimeS EventLocS EventEnergyS;
global GroupIDS GQFS FlashDataS FlashData2S FlashQFS;
global FlashFrTimeOffsetFES FlashFrTimeOffsetLES;
global GroupFrameTimeOffsetS GroupLatS GroupLonS;
global GroupAreaS GroupEnergyS GroupParentFlashIDS ;
global GroupEnergy GroupMinEnergy GroupMaxEnergy;
global EventCountS GroupCountS FlashCountS;
global EventEnergy EventMinEnergy EventMaxEnergy;
global NumFlashes NumGroups NumEvents;
global ProductTimeS LightningWaveS NavL1bS YawFlipFlagS LonFOVS LatFOVS;
global ProcessParamVersionContainerS;
global westEdge eastEdge northEdge southEdge;
global MonthDayStr MonthDayYearStr;
global DayMonthNonLeapYear DayMonthLeapYear CalendarFileName;
global FlashEnergy FlashDuration FlashLats FlashLons;
global FlashEnergySort;
global FlashMinEnergy FlashMaxEnergy FlashMinDuration FlashMaxDuration;
global FlashStartTimes FlashEndTimes;
global RptGenPresent iCreatePDFReport pdffilename rpt chapter;
global JpegCounter JpegFileList;
global DQFHdr DQFTable MiscHdr MiscTable RqmtsHdr RqmtsTable;
global LightningTable LightningHdr LightningTableS LightningHdrS;
global DQFCauses DQFNormed DQFLabels;
global PhPA rho zPress;



global widd2 lend2;
global initialtimestr igrid ijpeg ilog imovie;
global vert1 hor1 widd lend;
global vert2 hor2 machine;
global chart_time;
global Fz1 Fz2 fid;
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
global figpath screencapturepath gridpath;
global shapepath2 countrypath countryshapepath usstateboundariespath;
global GOES16Band1path GOES16Band2path GOES16Band3path GOES16Band4path;
global GOES16Band5path GOES16Band6path GOES16Band7path GOES16Band8path
global GOES16Band9path GOES16Band10path GOES16Band11path GOES16Band12path;
global GOES16Band13path GOES16Band14path GOES16Band15path GOES16Band16path;
global GOES16CloudTopHeightpath;
if((iCreatePDFReport==1) && (RptGenPresent==1))
    import mlreportgen.dom.*;
    import mlreportgen.report.*;
end
fprintf(fid,'\n');
fprintf(fid,'%s\n','-----Create Lightning Flash Energy Histogram Plot-----');
% Get the scan start date and time data based on the file name
[YearS,DayS,HourS,MinuteS,SecondS] = GetGOESDateTimeString(GOESFileName,1);
result = is_leap_year(YearS);
if(result==0)
    MonthDayStr=char(DayMonthNonLeapYear{DayS,1});
else
    MonthDayStr=char(DayMonthLeapYear{DayS,1});
end
MonthDayYearStr=strcat(MonthDayStr,'-',num2str(YearS));
[nrows,ncols]=size(FlashEnergy);
totalpix=nrows*ncols;
FlashEnergySort=sort(FlashEnergy)/1E-12;
numvals=totalpix;
val01=FlashEnergySort(round(.01*numvals),1);
val50=FlashEnergySort(round(.50*numvals),1);
val99=FlashEnergySort(round(.99*numvals),1);
flashstr1=strcat('The 1 ptile flash energy was=',num2str(val01,5),'-picoJoules');
fprintf(fid,'%s\n',flashstr1);
flashstr2=strcat('The 50 ptile flash energy was=',num2str(val50,5),'-picoJoules');
fprintf(fid,'%s\n',flashstr2);
flashstr3=strcat('The 99 ptile flash energy was=',num2str(val99,5),'-picoJoules');
fprintf(fid,'%s\n',flashstr3);
% Now plot the histogram of the Flash Energies
movie_figure1=figure('position',[hor1 vert1 widd lend]);
set(gcf,'MenuBar','none');
set(gca,'Position',[.16 .18  .70 .70]);
h=histogram(FlashEnergySort,20);
set(h,'FaceColor','g');
xlabel('Energy-picoJ','FontWeight','bold');
ylabel('Cases','FontWeight','bold');
set(gca,'FontWeight','bold');
if(igrid==1)
    set(gca,'XGrid','On','YGrid','On');
end
ht=title(titlestr);
set(ht,'FontWeight','bold');
% Set up the axis for writing at the bottom of the chart
newaxesh=axes('Position',[0 0 1 1]);
set(newaxesh,'XLim',[0 1],'YLim',[0 1]);
tx1=.18;
ty1=.10;
txtstr1=strcat('Start Scan-Y',num2str(YearS),'-D-',num2str(DayS),'-H-',...
    num2str(HourS),'-M-',num2str(MinuteS),'-S-',num2str(SecondS),'-Date=',MonthDayYearStr);
txt1=text(tx1,ty1,txtstr1,'FontWeight','bold','FontSize',12);
tx2=.18;
ty2=.06;
txtstr2=strcat('Total Pixels=',num2str(totalpix),'-number of Energy estimates=',num2str(numvals));
txt2=text(tx2,ty2,txtstr2,'FontWeight','bold','FontSize',12);
set(newaxesh,'Visible','Off');
pause(chart_time);
% Save this chart
figstr=strcat('LightningEnergyHistogram-','Y',num2str(YearS),'D',...
    num2str(DayS),'H',num2str(HourS),'M',num2str(MinuteS),'S',num2str(round(SecondS)),...
    '.jpg');
eval(['cd ' jpegpath(1:length(jpegpath)-1)]);
actionstr='print';
typestr='-djpeg';
[cmdString]=MyStrcat2(actionstr,typestr,figstr);
eval(cmdString);
if((iCreatePDFReport==1) && (RptGenPresent==1))
    [ibreak]=strfind(GOESFileName,'_e');
    is=1;
    ie=ibreak(1)-1;
    GOESShortFileName=GOESFileName(is:ie);
    add(chapter,Section('Lightning Flash Energy Histogram'));
    imdata = imread(figstr);
    [nhigh,nwid,ndepth]=size(imdata);
    image = mlreportgen.report.FormalImage();
    image.Image = which(figstr);
    pdftxtstr=strcat('Lightning Flash Energy Data Found On File-',GOESShortFileName);
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
    parastr61=strcat('The Data for this chart was from file-',GOESFileName,'-and shows the histogram of the lightning flash energy values.');
    parastr62='Note that this energy is in picoJoules received at the GOES focal plane and not the energy actually released by the bolt.';
    parastr63='Many lightning bolts can release a billion Joules of energy in a pulse lasting only hundred of micro seconds.';
    parastr69=strcat(parastr61,parastr62,parastr63);
    p6 = Paragraph(parastr69);
    p6.Style = {OuterMargin("0pt", "0pt","0pt","10pt")};
    add(chapter,p6);
end
close('all');
dispstr=strcat('Saved file-',figstr);
disp(dispstr);
savestr1=strcat('Saved Plot to File-',figstr);
fprintf(fid,'%s\n',savestr1);
fprintf(fid,'%s\n','-----Finished Lightning Flash Energy Histogram Plot-----');
fprintf(fid,'\n');
end

