function [ValidDSR]=PlotDSRHistogram(DSR1DSF,sgoodfrac,titlestr)
% This routine will plot a histogram of the Downward Shortwave Radiation
% no distinction is made between land and sea based values
% Written By: Stephen Forczyk
% Created: Feb 26,2021
% Revised: --------
% Classification: Unclassified
global MetaDataS;
global DSRS DSRWaveS DSRWaveBS ImageCloudFracS;
global DQFS;
global RetPixelCountS LZAPixelCountS OutlierPixelCountS;
global LatS LonS;
global tS yS xS tBS goesImagerS LatImgS LatImgBS;
global LonImgS LonImgBS SatDataS GeoSpatialS;
global AlgoS GoesWaveBand;
global AlgoProdVersionContainerS ProcessParamS;
global QLZAS  QLZABS;
global RSZAS QSZAS RSZABS QSZABS;
global RLZAS RLZABS;
global SZAStatS DSRStatS;
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
fprintf(fid,'%s\n','-----Create DSR Histogram Plot-----');
% Get the scan start date and time data based on the file name
[YearS,DayS,HourS,MinuteS,SecondS] = GetGOESDateTimeString(GOESFileName,1);
result = is_leap_year(YearS);
if(result==0)
    MonthDayStr=char(DayMonthNonLeapYear{DayS,1});
else
    MonthDayStr=char(DayMonthLeapYear{DayS,1});
end
MonthDayYearStr=strcat(MonthDayStr,'-',num2str(YearS));
% Calculate a few basic statistics regarding the Showalter Stability Index
numpts=length(DSR1DSF);
[ihigh]=find(DSR1DSF>=1200);
numhigh=length(ihigh);
[ilow]=find(DSR1DSF<100);
numlow=length(ilow);
frachigh=numhigh/numpts;
fraclow=numlow/numpts;
[ivalid]=find(DSR1DSF>=-0 & DSR1DSF<=1500);
numvalid=length(ivalid);
ValidDSR=zeros(numvalid,1);
index=0;
for kk=1:numpts
    if((DSR1DSF(kk,1)>=0) && (DSR1DSF(kk,1)<=1500))
        index=index+1;
        ValidDSR(index,1)=DSR1DSF(kk,1);
    end
end
num25=round(.25*numvalid);
num50=round(.50*numvalid);
num75=round(.75*numvalid);
num100=numvalid;
minValidDSR=min(ValidDSR);
maxValidDSR=max(ValidDSR);
val25=ValidDSR(num25,1);
val50=ValidDSR(num50,1);
val75=ValidDSR(num75,1);
val100=ValidDSR(num100,1);
statstr1=strcat('25th ptile DSR=',num2str(val25,6),'-50 ptile DSR=',num2str(val50,6));
statstr2=strcat('75th ptile DSR=',num2str(val75,6),'-100 ptile DSR=',num2str(val100,6),'-all in w/m^2');
fprintf(fid,'%s\n',statstr1);
fprintf(fid,'%s\n',statstr2);
% Now plot the histogram of the DSR Distribution
movie_figure1=figure('position',[hor1 vert1 widd lend]);
set(gcf,'MenuBar','none');
set(gca,'Position',[.16 .18  .70 .70]);
edges=linspace(0,1500,101);
h=histogram(ValidDSR,edges,'Normalization','probability','FaceColor','b');
xlabel('DSR- w/m^2','FontWeight','bold');
ylabel('% Of Pixels','FontWeight','bold');
set(gca,'FontWeight','bold');
xmin=0;
xmax=1500;
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
txtstr2=strcat('Min DSR=',num2str(minValidDSR,4),'-Max ValidDSR=',num2str(maxValidDSR,4));
txt2=text(tx2,ty2,txtstr2,'FontWeight','bold','FontSize',8);
set(newaxesh,'Visible','Off');
pause(chart_time);

figstr=strcat(titlestr,'.jpg');
JpegCounter=JpegCounter+1;
JpegFileList{JpegCounter+1,1}=figstr;
JpegFileList{JpegCounter+1,2}=jpegpath;
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
    add(chapter,Section('DSR Histogram'));
    imdata = imread(figstr);
    [nhigh,nwid,ndepth]=size(imdata);
    image = mlreportgen.report.FormalImage();
    image.Image = which(figstr);
    pdftxtstr=strcat('DSR Histogram For File-',GOESShortFileName);
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
    parastr121=strcat('The data for this chart was taken from file-',GOESShortFileName,'.');
    parastr122='This chart shows this distribution of DSR metric as a histogram.';
    parastr123=strcat('The fraction of pixels with very low DSR=',num2str(fraclow,5),'-while-',num2str(frachigh,5),'-pixels has a DSR >1200 w/m^2.');
    parastr129=strcat(parastr121,parastr122,parastr123);
    p12 = Paragraph(parastr129);
    p12.Style = {OuterMargin("0pt", "0pt","10pt","10pt")};
    add(chapter,p12);
    close('all');
    dispstr=strcat('Saved file-',figstr);
    disp(dispstr);
    fprintf(fid,'%s\n','-----Finished DSR Histogram Plot-----');
    fprintf(fid,'\n');
end

