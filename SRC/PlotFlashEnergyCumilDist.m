function PlotFlashEnergyCumilDist(titlestr)
% This routine will plot the cumilative distribution of the GLM2 Flash
% Energy Output
% Written By: Stephen Forczyk
% Created: March 20,2021
% Revised: -----
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
fprintf(fid,'%s\n','-----Create Flash Energy`Cumilative Distribution Plot-----');
% Get the scan start date and time data based on the file name
[YearS,DayS,HourS,MinuteS,SecondS] = GetGOESDateTimeString(GOESFileName,1);
result = is_leap_year(YearS);
if(result==0)
    MonthDayStr=char(DayMonthNonLeapYear{DayS,1});
else
    MonthDayStr=char(DayMonthLeapYear{DayS,1});
end
MonthDayYearStr=strcat(MonthDayStr,'-',num2str(YearS));
numvals=length(FlashEnergySort);
val01=FlashEnergySort(round(.01*numvals),1);
val50=FlashEnergySort(round(.50*numvals),1);
val99=FlashEnergySort(round(.99*numvals),1);
val01=FlashEnergySort(round(.01*numvals),1);
val50=FlashEnergySort(round(.50*numvals),1);
val99=FlashEnergySort(round(.99*numvals),1);
FlashEnergyCumil=FlashEnergySort;
% Now get the data for the event and group energy-convert to picoJoules and
% sort
EventEnergySort=sort(EventEnergy)/1E-12;
GroupEnergySort=sort(GroupEnergy)/1E-12;
EventEnergyCumil=EventEnergySort;
numvals2=length(GroupEnergySort);
numvals3=length(EventEnergySort);
GroupEnergyCumil=GroupEnergySort;
val201=GroupEnergySort(round(.01*numvals2),1);
val250=GroupEnergySort(round(.50*numvals2),1);
val299=GroupEnergySort(round(.99*numvals2),1);
val301=EventEnergySort(round(.01*numvals3),1);
val350=EventEnergySort(round(.50*numvals3),1);
val399=EventEnergySort(round(.99*numvals3),1);
% Now create an x array that runs from 0 to 100 p tile
xp=0:1:100;
xp=xp';
ypi=zeros(101,1);
ypi(1)=val01-mod(val01,10);
ypi(101)=FlashEnergyCumil(numvals,1);
ypj=zeros(101,1);
ypk=zeros(101,1);
for n=2:100
    ptile=(n-1)/100;
    ptileind=round(ptile*numvals);
    ypi(n,1)=FlashEnergyCumil(ptileind,1);
end
for n=2:100
    ptile2=(n-1)/100;
    ptile2ind=round(ptile2*numvals2);
    ypj(n,1)=GroupEnergyCumil(ptile2ind,1);
end
for n=2:100
    ptile3=(n-1)/100;
    ptile3ind=round(ptile3*numvals3);
    ypk(n,1)=EventEnergyCumil(ptile3ind,1);
end
ptile05ht=ypi(6,1);
ptile25ht=ypi(26,1);
ptile50ht=ypi(51,1);
ptile75ht=ypi(76,1);
ptile95ht=ypi(96,1);
ptile100ht=ypi(101,1);
medianFlash=median(FlashEnergySort);
medianGroup=median(GroupEnergySort);
medianEvent=median(EventEnergySort);
htstr1=strcat('FlashEnergy 25 Ptile=',num2str(ptile25ht,6),'-picoJ');
htstr2=strcat('FlashEnergy 50 Ptile=',num2str(ptile50ht,6),'-picoJ');
htstr3=strcat('FlashEnergy 75 Ptile=',num2str(ptile75ht,6),'-picoJ');
htstr4=strcat('FlashEnergy 100 Ptile=',num2str(ptile100ht,6),'-picoJ');
fprintf(fid,'%s\n',htstr1);
fprintf(fid,'%s\n',htstr2);
fprintf(fid,'%s\n',htstr3);
fprintf(fid,'%s\n',htstr4);
ymin=0;
ymax=ceil(ptile95ht);
% Now create a line plot of the cumilative distribution
movie_figure1=figure('position',[hor1 vert1 widd lend]);
set(gcf,'MenuBar','none');
set(gca,'Position',[.16 .18  .70 .70]);
h=plot(xp,ypi,'r',xp,ypj,'g',xp,ypk,'b');
xlabel('Percentile','FontWeight','bold');
ylabelstr='FlashEnergy-pJoule';
ylabel(ylabelstr,'FontWeight','bold');
set(gca,'FontWeight','bold');
set(gca,'XGrid','On','YGrid','On');
set(gca,'YLim',[ymin ymax]);
hl=legend('Flash','Group','Event','Location','NorthWest');
ht=title(titlestr);
set(ht,'FontWeight','bold');
% Set up the axis for writing at the bottom of the chart
newaxesh=axes('Position',[0 0 1 1]);
set(newaxesh,'XLim',[0 1],'YLim',[0 1]);
tx1=.18;
ty1=.10;
txtstr1=strcat('Start Scan-Y',num2str(YearS),'-D-',num2str(DayS),'-H-',...
    num2str(HourS),'-M-',num2str(MinuteS),'-S-',num2str(SecondS),'-Date=',MonthDayYearStr);
txt1=text(tx1,ty1,txtstr1,'FontWeight','bold','FontSize',10);
tx2=.18;
ty2=.06;
txtstr2=strcat('Flash Energy 25ptile=',num2str(ptile25ht,6),'-FlashEnergy 50ptile=',num2str(ptile50ht,6),...
    '-FlashEnergy 75ptile=',num2str(ptile75ht,6),'-FlashEnergy 100 ptile=',num2str(ptile100ht,6),'-Deg-k');
txt2=text(tx2,ty2,txtstr2,'FontWeight','bold','FontSize',10);
set(newaxesh,'Visible','Off');
pause(chart_time);
% Save this chart
figstr=strcat('FlashEnergyCumilDist-','Y',num2str(YearS),'D',...
    num2str(DayS),'H',num2str(HourS),'M',num2str(MinuteS),'S',num2str(round(SecondS)),...
    '.jpg');
eval(['cd ' jpegpath(1:length(jpegpath)-1)]);
actionstr='print';
typestr='-djpeg';
[cmdString]=MyStrcat2(actionstr,typestr,figstr);
eval(cmdString);
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
    sectionstr=strcat('FlashEnergy-CumilDist');
    add(chapter,Section(sectionstr));
    imdata = imread(figstr);
    [nhigh,nwid,ndepth]=size(imdata);
    image = mlreportgen.report.FormalImage();
    image.Image = which(figstr);
    pdftxtstr=strcat('Flash Energy Data For File-',GOESShortFileName);
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
    br = PageBreak();
    add(chapter,br);
    parastr151=strcat('The Flash Energy Data for this chart was taken from file-',GOESShortFileName,'.');
    parastr152='This chart shows the cumilative distribution of all valid Lightning Energy estimates at the Flash/Group and Event Levels.';
    parastr153='In order to show greater detail the maximum value of the plot was cutoff at roughly the 95% level for flash events.';
    parastr154=strcat('The median Flash Energy was=',num2str(medianFlash,5),'.','At the Group level the median value was=',...
        num2str(medianGroup,5),'-finally at the event level the median was=',num2str(medianEvent,5),'-all values in pJoules.');
    parastr159=strcat(parastr151,parastr152,parastr153,parastr154);
    p16 = Paragraph(parastr159);
    p16.Style = {OuterMargin("0pt", "0pt","10pt","10pt")};
    add(chapter,p16);
%    add(rpt,chapter);
    close('all');
    dispstr=strcat('Saved file-',figstr);
    disp(dispstr);
    savestr1=strcat('Saved Plot to File-',figstr);
    fprintf(fid,'%s\n',savestr1);
    fprintf(fid,'%s\n','-----Finished Flash Cumilative Distribution Plot-----');
    fprintf(fid,'\n');
end

