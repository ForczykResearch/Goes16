function [ValidLVM]=PlotLVMHistogram(LVM1DSF,sgoodfrac,ilevel,titlestr)
% This routine will plot a histogram of LVM values for one
% pressure level
% Written By: Stephen Forczyk
% Created: March 10,2021
% Revised: March 12,2021 clean up code
% Classification: Unclassified
global MetaDataS;
global LVMS PressureS PressureImgS PressureImgBS;
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
global PhPA rho zPress;


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
fprintf(fid,'%s\n','-----Create LVM Histogram Plot-----');
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
numpts=length(LVM1DSF);
[ihigh]=find(LVM1DSF>1);
numhigh=length(ihigh);
[ilow]=find(LVM1DSF<0);
numlow=length(ilow);
frachigh=numhigh/numpts;
fraclow=numlow/numpts;
[ivalid]=find(LVM1DSF>0 & LVM1DSF<=1);
numvalid=length(ivalid);
ValidLVM=zeros(numvalid,1);
index=0;
invalid=0;
numvalid=0;
for kk=1:numpts
    if((LVM1DSF(kk,1)>0) && (LVM1DSF(kk,1)<=1))
        index=index+1;
        ValidLVM(index,1)=LVM1DSF(kk,1);
        numvalid=numvalid+1;
    else
        invalid=invalid+1;
    end
end
num25=round(.25*numvalid);
num50=round(.50*numvalid);
num75=round(.75*numvalid);
num100=numvalid;
minValidLVM=min(ValidLVM);
maxValidLVM=max(ValidLVM);
val25=ValidLVM(num25,1);
val50=ValidLVM(num50,1);
val75=ValidLVM(num75,1);
val100=ValidLVM(num100,1);
statstr1=strcat('25th ptile LVM=',num2str(val25,6),'-50 ptile LVM=',num2str(val50,6));
statstr2=strcat('75th ptile LVM=',num2str(val75,6),'-100 ptile LVM=',num2str(val100,6));
fprintf(fid,'%s\n',statstr1);
fprintf(fid,'%s\n',statstr2);
statstr3=strcat('Fraction LVM Values<0=',num2str(fraclow,6),'-fraction higher than 1=',num2str(frachigh,6));
fprintf(fid,'%s\n',statstr3);
statstr4=strcat('Number of invalid values=',num2str(invalid),'-Number of valid values=',num2str(numvalid));
fprintf(fid,'%s\n',statstr4);
levelstr1=strcat('Histogram corresponds to level-',num2str(ilevel),'-the model atmosphere has 101 levels');
fprintf(fid,'%s\n',levelstr1);
% Now plot the histogram of the LVM Distribution
movie_figure1=figure('position',[hor1 vert1 widd lend]);
set(gcf,'MenuBar','none');
set(gca,'Position',[.16 .18  .70 .70]);
edges=linspace(0,1,101);
h=histogram(ValidLVM,edges,'Normalization','probability','FaceColor','b');
xlabel('LVM-Relative Humidity','FontWeight','bold');
ylabel('% Of Pixels','FontWeight','bold');
set(gca,'FontWeight','bold');
set(gca,'XLim',[0  1]);
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
txtstr2=strcat('Min LVM=',num2str(minValidLVM,5),'-Max ValidLVM=',num2str(maxValidLVM,5));
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
    sectionstr=strcat('LVM-Histogram-Level-',num2str(ilevel));
    add(chapter,Section(sectionstr));
    imdata = imread(figstr);
    [nhigh,nwid,ndepth]=size(imdata);
    image = mlreportgen.report.FormalImage();
    image.Image = which(figstr);
    pdftxtstr=strcat('LVM Histogram For File-',GOESShortFileName);
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
    parastr82='This chart shows this distribution of LVM metric as a histogram for a single pressure level.';
    parastr83=strcat('The median value of the LVM measurement is=',num2str(val50,6),'.');
    parastr89=strcat(parastr81,parastr82,parastr83);
    p9 = Paragraph(parastr89);
    p9.Style = {OuterMargin("0pt", "0pt","10pt","10pt")};
    add(chapter,p9);
    close('all');
    dispstr=strcat('Saved file-',figstr);
    disp(dispstr);
    fprintf(fid,'%s\n','-----Finished LVM Histogram  Plot-----');
    fprintf(fid,'\n');
end

