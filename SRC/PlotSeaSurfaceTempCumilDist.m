function PlotSeaSurfaceTempCumilDist(SST1DSF,sgoodfrac,titlestr)
% This routine will plot the cumilative distribution of the sea surface
% temp
% 
% Written By: Stephen Forczyk
% Created: Dec 28,2020
% Revised: Jan 22,2021 made changes to add content to PDF report
% Classification: Unclassified


global BandDataS MetaDataS;
global LSTS DQFS tS yS xS tBS goesImagerS yImgS yImgBS;
global xImgS xImgBS SatDataS GeoSpatialS;
global ReflectanceS AlgoS ErrorS EarthSunS VersionContainerS;
global GoesWaveBand ESunS kappa0S PlanckS FocalPlaneS;
global HTS DQF1S OutlierPS CloudTopS Algo1S ProcessParamS;
global LZAS LZABS SZAS SZABS Error1S CloudPixelsS;
global GOESFileName;
global westEdge eastEdge northEdge southEdge;
global MonthDayStr MonthDayYearStr;
global DayMonthNonLeapYear DayMonthLeapYear CalendarFileName;
global RptGenPresent iCreatePDFReport pdffilename rpt chapter;
global JpegCounter JpegFileList;

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
fprintf(fid,'%s\n','-----Create Sea Surface Temp Cumilative Distribution Plot-----');
% Get the scan start date and time data based on the file name
[YearS,DayS,HourS,MinuteS,SecondS] = GetGOESDateTimeString(GOESFileName,1);
result = is_leap_year(YearS);
if(result==0)
    MonthDayStr=char(DayMonthNonLeapYear{DayS,1});
else
    MonthDayStr=char(DayMonthLeapYear{DayS,1});
end
MonthDayYearStr=strcat(MonthDayStr,'-',num2str(YearS));

numvals=length(SST1DSF);

val01=SST1DSF(round(.01*numvals),1);
val50=SST1DSF(round(.50*numvals),1);
val99=SST1DSF(round(.99*numvals),1);
maxSeaTemp=max(SST1DSF);
minSeaTemp=min(SST1DSF);
SSTCumil=SST1DSF;

% Now create an x array that runs from 0 to 100 p tile
xp=0:1:100;
xp=xp';
ypi=zeros(101,1);
ypi(1)=val01-mod(val01,10);
ypi(101)=SSTCumil(numvals,1);
for n=2:100
    ptile=(n-1)/100;
    ptileind=round(ptile*numvals);
    ypi(n,1)=SSTCumil(ptileind,1);
end
ptile25ht=ypi(26,1);
ptile50ht=ypi(51,1);
ptile75ht=ypi(76,1);
ptile100ht=ypi(101,1);
htstr1=strcat('SST 25 Ptile=',num2str(ptile25ht,6),'-Deg K');
htstr2=strcat('SST 50 Ptile=',num2str(ptile50ht,6),'-Deg K');
htstr3=strcat('SST 75 Ptile=',num2str(ptile75ht,6),'-Deg K');
htstr4=strcat('SST 100 Ptile=',num2str(ptile100ht,6),'-Deg K');
fprintf(fid,'%s\n',htstr1);
fprintf(fid,'%s\n',htstr2);
fprintf(fid,'%s\n',htstr3);
fprintf(fid,'%s\n',htstr4);
% Now create a line plot of the cumilative distribution
movie_figure1=figure('position',[hor1 vert1 widd lend]);
set(gcf,'MenuBar','none');
set(gca,'Position',[.16 .18  .70 .70]);
h=plot(xp,ypi,'g');
xlabel('Percentile','FontWeight','bold');
ylabelstr=strcat('Sea Surface Temp-','Deg K');
ylabel(ylabelstr,'FontWeight','bold');
set(gca,'FontWeight','bold');
set(gca,'XGrid','On','YGrid','On');
ht=title(titlestr);
set(ht,'FontWeight','bold');
% Set up the axis for writing at the bottom of the chart
newaxesh=axes('Position',[0 0 1 1]);
set(newaxesh,'XLim',[0 1],'YLim',[0 1]);
tx1=.18;
ty1=.10;
txtstr1=strcat('Start Scan-Y',num2str(YearS),'-D-',num2str(DayS),'-H-',...
    num2str(HourS),'-M-',num2str(MinuteS),'-S-',num2str(SecondS),'-Date=',MonthDayYearStr);
txt1=text(tx1,ty1,txtstr1,'FontWeight','bold','FontSize',8);
tx2=.18;
ty2=.06;
txtstr2=strcat('SST 25ptile=',num2str(ptile25ht,6),'-SST 50ptile=',num2str(ptile50ht,6),...
    '-SST 75ptile=',num2str(ptile75ht,6),'-SST 100 ptile=',num2str(ptile100ht,6));
txt2=text(tx2,ty2,txtstr2,'FontWeight','bold','FontSize',8);
set(newaxesh,'Visible','Off');
pause(chart_time);
% Save this chart
figstr=strcat('SSTCumilDist-','Y',num2str(YearS),'D',...
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
    add(chapter,Section('Sea Surface Temp Cumilative Distribution'));
    imdata = imread(figstr);
    [nhigh,nwid,ndepth]=size(imdata);
    image = mlreportgen.report.FormalImage();
    image.Image = which(figstr);
    pdftxtstr=strcat('Sea Surface Temp Cumilative Distribuition Based On File-',GOESShortFileName);
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
    parastr1=strcat('Data for this chart was taken from file-',GOESShortFileName,'.');
    parastr2='The purpose is to allow the user to what fraction of the sea surface exceeds a given temperature.';
    parastr3=strcat(parastr1,parastr2);
    p2 = Paragraph(parastr3);
    p2.Style = {OuterMargin("0pt", "0pt","0pt","10pt")};
    add(chapter,p2);
   
end
close('all');
dispstr=strcat('Saved file-',figstr);
disp(dispstr);
savestr1=strcat('Saved Plot to File-',figstr);
fprintf(fid,'%s\n',savestr1);
fprintf(fid,'%s\n','-----Finished Sea Surface Temp Cumiliative  Distribution Plot-----');
fprintf(fid,'\n');
end

