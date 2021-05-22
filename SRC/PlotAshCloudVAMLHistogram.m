function [ValidVAML]=PlotAshCloudVAMLHistogram(VAM1DSF,sgoodfrac,titlestr)
% This routine will plot a histogram of volcanic ash cloud mass loading
% (VAML)
% Written By: Stephen Forczyk
% Created: March 4,2021
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
fprintf(fid,'%s\n','-----Create Volcanic Ash Cloud Mass Loading Histogram Plot-----');
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
VAML=VAMLS.values;
[nrows,ncols]=size(VAML);
ntotpix=nrows*ncols;
numpts=length(VAM1DSF);
[ihigh]=find(VAM1DSF>.2);
numhigh=length(ihigh);
[ilow]=find(VAM1DSF<=.2);
numlow=length(ilow);
frachigh=numhigh/numpts;
fraclow=numlow/numpts;
[ivalid]=find(VAM1DSF>.2 & VAM1DSF<=50);
numvalid=length(ivalid);
ValidVAML=zeros(numvalid,1);
index=0;
invalid=0;
numvalid=0;
for kk=1:numpts
    if((VAM1DSF(kk,1)>.2) && (VAM1DSF(kk,1)<=50))
        index=index+1;
        ValidVAML(index,1)=VAM1DSF(kk,1);
        numvalid=numvalid+1;
    else
        invalid=invalid+1;
    end
end
validfrac=(numvalid/ntotpix);
num25=round(.25*numvalid);
num50=round(.50*numvalid);
num75=round(.75*numvalid);
num100=numvalid;
minValidVAML=min(ValidVAML);
maxValidVAML=max(ValidVAML);
val25=ValidVAML(num25,1);
val50=ValidVAML(num50,1);
val75=ValidVAML(num75,1);
val100=ValidVAML(num100,1);
statstr1=strcat('25th ptile VAML=',num2str(val25,6),'-50 ptile VAML=',num2str(val50,6));
statstr2=strcat('75th ptile VAML=',num2str(val75,6),'-100 ptile VAML=',num2str(val100,6),'-tons/m^2');
statstr3=strcat('The fraction of all pixels that produced valid values was=',num2str(validfrac,6));
fprintf(fid,'%s\n',statstr1);
fprintf(fid,'%s\n',statstr2);
fprintf(fid,'%s\n',statstr3);
% Now plot the histogram of the VAH Distribution
movie_figure1=figure('position',[hor1 vert1 widd lend]);
set(gcf,'MenuBar','none');
set(gca,'Position',[.16 .18  .70 .70]);
edges=linspace(0,50,101);
h=histogram(ValidVAML,edges,'Normalization','probability','FaceColor','b');
xlabel('VAML-tons/m^2','FontWeight','bold');
ylabel('% Of Pixels','FontWeight','bold');
set(gca,'FontWeight','bold');
xmin=0;
set(gca,'XLim',[0 50]);
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
txtstr2=strcat('Min VAML=',num2str(minValidVAML,5),'-Max ValidVAML=',num2str(maxValidVAML,5));
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
    add(chapter,Section('VAML Histogram'));
    imdata = imread(figstr);
    [nhigh,nwid,ndepth]=size(imdata);
    image = mlreportgen.report.FormalImage();
    image.Image = which(figstr);
    pdftxtstr=strcat('VAML Histogram For File-',GOESShortFileName);
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
    parastr141=strcat('The data for this chart was taken from file-',GOESShortFileName,'.');
    parastr142='This chart shows this distribution of VAML or ash mass loading metric as a histogram.';
    parastr143=strcat('The median value of the VAML measurement is=',num2str(val50,6),'-tons/m^2.',...
        'Note that this statistic was computed for only those pixels that had valid values.');
    parastr144=strcat('The fraction of pixels that returned valid values was=',num2str(validfrac,6),'.');
    parastr149=strcat(parastr141,parastr142,parastr143,parastr144);
    p15 = Paragraph(parastr149);
    p15.Style = {OuterMargin("0pt", "0pt","10pt","10pt")};
    add(chapter,p15);
    close('all');
%    add(rpt,chapter);
    dispstr=strcat('Saved file-',figstr);
    disp(dispstr);
    fprintf(fid,'%s\n','-----Finished Volcanic Ash Cloud Mass Loading Histogram Plot-----');
    fprintf(fid,'\n');
end

