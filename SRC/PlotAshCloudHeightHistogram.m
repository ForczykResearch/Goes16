function [ValidVAH]=PlotAshCloudHeightHistogram(VAHS1DSF,sgoodfrac,titlestr)
% This routine will plot a histogram of volcanic ash cloud heights
% (VAH)
% Written By: Stephen Forczyk
% Created: March 3,2021
% Revised: --------
% Classification: Unclassified
global MetaDataS;
global VAHS VAMLS ;
global AshMassLoadTotMassS CountAttAshRetS;
global AshHtOutlierPixCountS AshMassOutlierPixCountS;
global AshCloudHtStatS AshMassStatS AshExistConfAngS;
global DET_DQFS RET_DQFS;
global tS yS xS tBS goesImagerS;
global SatDataS GeoSpatialS;
global AlgoS GoesWaveBand;
global AlgoProdVersionContainerS ProcessParamS;
global QLZAS  QLZABS;
global RLZAS RLZABS;
global SZAS SZABS;
global GRBErrorsS L0ErrorsS;
global GOESFileName;
global RasterLats RasterLons;
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
fprintf(fid,'%s\n','-----Create Volcanic Ash Cloud Height Histogram Plot-----');
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
numpts=length(VAHS1DSF);
[ihigh]=find(VAHS1DSF>100);
numhigh=length(ihigh);
[ilow]=find(VAHS1DSF<100);
numlow=length(ilow);
frachigh=numhigh/numpts;
fraclow=numlow/numpts;
[ivalid]=find(VAHS1DSF>100 & VAHS1DSF<=20000);
numvalid=length(ivalid);
ValidVAH=zeros(numvalid,1);
index=0;
invalid=0;
numvalid=0;
for kk=1:numpts
    if((VAHS1DSF(kk,1)>100) && (VAHS1DSF(kk,1)<=20000))
        index=index+1;
        ValidVAH(index,1)=VAHS1DSF(kk,1);
        numvalid=numvalid+1;
    else
        invalid=invalid+1;
    end
end
num25=round(.25*numvalid);
num50=round(.50*numvalid);
num75=round(.75*numvalid);
num100=numvalid;
minValidVAH=min(ValidVAH);
maxValidVAH=max(ValidVAH);
val25=ValidVAH(num25,1);
val50=ValidVAH(num50,1);
val75=ValidVAH(num75,1);
val100=ValidVAH(num100,1);
statstr1=strcat('25th ptile VAH=',num2str(val25,6),'-50 ptile VAH=',num2str(val50,6));
statstr2=strcat('75th ptile VAH=',num2str(val75,6),'-100 ptile VAH=',num2str(val100,6),'-m');
fprintf(fid,'%s\n',statstr1);
fprintf(fid,'%s\n',statstr2);
% Now plot the histogram of the VAH Distribution
movie_figure1=figure('position',[hor1 vert1 widd lend]);
set(gcf,'MenuBar','none');
set(gca,'Position',[.16 .18  .70 .70]);
xmax=val100-mod(val100,100)+100;
numbins=floor(xmax/200);
edges=linspace(100,xmax,numbins);
h=histogram(ValidVAH,edges,'Normalization','probability','FaceColor','b');
xlabel('VAH-m','FontWeight','bold');
ylabel('% Of Pixels','FontWeight','bold');
set(gca,'FontWeight','bold');
xmin=0;
set(gca,'XLim',[xmin xmax+100]);
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
txt1=text(tx1,ty1,txtstr1,'FontWeight','bold','FontSize',10);
tx2=.18;
ty2=.06;
txtstr2=strcat('Min VAH=',num2str(minValidVAH,5),'-Max ValidVAH=',num2str(maxValidVAH,5));
txt2=text(tx2,ty2,txtstr2,'FontWeight','bold','FontSize',10);
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
    add(chapter,Section('VAH Histogram'));
    imdata = imread(figstr);
    [nhigh,nwid,ndepth]=size(imdata);
    image = mlreportgen.report.FormalImage();
    image.Image = which(figstr);
    pdftxtstr=strcat('VAH Histogram For File-',GOESShortFileName);
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
    parastr81=strcat('The data for this chart was taken from file-',GOESShortFileName,'.');
    parastr82='This chart shows this distribution of VAH metric as a histogram.';
    parastr83=strcat('The median value of the VAH measurement is=',num2str(val50,6),'-meters.');
    parastr89=strcat(parastr81,parastr82,parastr83);
    p9 = Paragraph(parastr89);
    p9.Style = {OuterMargin("0pt", "0pt","10pt","10pt")};
    add(chapter,p9);
%    add(rpt,chapter);
    close('all');
    dispstr=strcat('Saved file-',figstr);
    disp(dispstr);
    fprintf(fid,'%s\n','-----Finished Volcanic Ash Cloud Height Histogram Plot-----');
    fprintf(fid,'\n');
end

