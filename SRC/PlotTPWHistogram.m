function [ValidTPW]=PlotTPWHistogram(TPW1DSF,sgoodfrac,titlestr)
% This routine will plot a histogram of the TPW metric
% Written By: Stephen Forczyk
% Created: Feb 6,2021
% Revised: Feb 7,2021 cleanup unused code
% changes
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
global RptGenPresent iCreatePDFReport pdffilename rpt chapter;
global JpegCounter JpegFileList;
global DayMonthNonLeapYear DayMonthLeapYear CalendarFileName;
global DQFHdr DQFTable MiscHdr MiscTable RqmtsHdr RqmtsTable;
global DQFCauses DQFNormed DQFLabels;
global RasterLats RasterLons;
global idebug isavefiles;


global vert1 hor1 widd lend;
global vert2 hor2 lend2 machine;
global chart_time fid;
global Fz1 Fz2 chart_time;
global idirector igrid;
global matpath moviepath;
global jpegpath powerpath;
global ipowerpoint PowerPointFile scaling stretching padding;
if((iCreatePDFReport==1) && (RptGenPresent==1))
    import mlreportgen.dom.*;
    import mlreportgen.report.*;
end
fprintf(fid,'\n');
fprintf(fid,'%s\n','-----Create TPW Histogram Plot-----');
% Get the scan start date and time data based on the file name
[YearS,DayS,HourS,MinuteS,SecondS] = GetGOESDateTimeString(GOESFileName,1);
result = is_leap_year(YearS);
if(result==0)
    MonthDayStr=char(DayMonthNonLeapYear{DayS,1});
else
    MonthDayStr=char(DayMonthLeapYear{DayS,1});
end
MonthDayYearStr=strcat(MonthDayStr,'-',num2str(YearS));
% Calculate a few basic statistics regarding the TPW
% 
[ibig]=find(TPW1DSF>1);
numbig=length(ibig);
numpts=length(TPW1DSF);
ValidTPW=zeros(numbig,1);
first=ibig(1);
index=0;
for kk=first:numpts
    index=index+1;
    ValidTPW(index,1)=TPW1DSF(kk,1);
end

num25=round(.25*numbig);
num50=round(.50*numbig);
num75=round(.75*numbig);
num100=numbig;
val25=ValidTPW(num25,1);
val50=ValidTPW(num50,1);
val75=ValidTPW(num75,1);
val100=ValidTPW(num100,1);
statstr1=strcat('25th ptile TPW=',num2str(val25,6),'-50 ptile TPW=',num2str(val50,6),'-all in mm');
statstr2=strcat('75th ptile TPW=',num2str(val75,6),'-100 ptile TPW=',num2str(val100,6),'-all in mm');
fprintf(fid,'%s\n',statstr1);
fprintf(fid,'%s\n',statstr2);
% Now plot the histogram of the TPWDistribution
movie_figure1=figure('position',[hor1 vert1 widd lend]);
set(gcf,'MenuBar','none');
set(gca,'Position',[.16 .18  .70 .70]);
edges=linspace(0,110,111);
h=histogram(ValidTPW,edges,'Normalization','probability','FaceColor','b');
xlabel('TPW-mm','FontWeight','bold');
ylabel('% Of Pixels','FontWeight','bold');
set(gca,'FontWeight','bold');
xmin=0;
xmax=110;
set(gca,'XLim',[xmin xmax]);
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
    num2str(HourS),'-M-',num2str(MinuteS),'-S-',num2str(SecondS),'-Date-',MonthDayYearStr);
txt1=text(tx1,ty1,txtstr1,'FontWeight','bold','FontSize',8);
tx2=.18;
ty2=.06;
txtstr2=strcat('Fraction of Pixels that had good Rainfall-Estimate=',num2str(sgoodfrac,6));
txt2=text(tx2,ty2,txtstr2,'FontWeight','bold','FontSize',8);
set(newaxesh,'Visible','Off');
pause(chart_time);
figstr=strcat(titlestr,'.jpg');
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
    br = PageBreak();
    add(chapter,br);
    add(chapter,Section('TPW Histogram'));
    imdata = imread(figstr);
    [nhigh,nwid,ndepth]=size(imdata);
    image = mlreportgen.report.FormalImage();
    image.Image = which(figstr);
    pdftxtstr=strcat('TPW For File-',GOESShortFileName);
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
    parastr61=strcat('The data for this chart was taken from file-',GOESShortFileName,'.');
    parastr62='This chart shows this distribution of TPW as a histogram.';
    parastr63=strcat('The fraction of pixels that had good rainfall rate-estimate=',num2str(sgoodfrac,6),'.');
    parastr64=strcat('Basic TPW data as follows.','The first quartile limit is-',num2str(val25,6),'-and the median value is-',...
         num2str(val50,6),'.');
    parastr65=strcat('The third quartile limit is-',num2str(val75,6),'-while the max value is-',num2str(val100,6),'-all TPW estimates are in mm.');
    parastr66='Note that the largest valid TPW estimate is 100mm.';
    parastr67='The computed statistics were only based on those pixels that actually had valid TPW estimates.';
    parastr69=strcat(parastr61,parastr62,parastr63,parastr64,parastr65,parastr66,parastr67);
    p6 = Paragraph(parastr69);
    p6.Style = {OuterMargin("0pt", "0pt","10pt","10pt")};
    add(chapter,p6);
    close('all');
    dispstr=strcat('Saved file-',figstr);
    disp(dispstr);
    fprintf(fid,'%s\n','-----Finished TPW Histogram Plot-----');
    fprintf(fid,'\n');
end

