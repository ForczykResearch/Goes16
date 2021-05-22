function [ValidTT]=PlotTTStabilityIndexHistogram(TT1DSF,sgoodfrac,titlestr)
% This routine will plot a histogram of the TT Stability Index
% no distinction is made between land and sea based values
% Written By: Stephen Forczyk
% Created: Feb 20,2021
% Revised: --------
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
fprintf(fid,'%s\n','-----Create TT Stability Index Histogram Plot-----');
% Get the scan start date and time data based on the file name
[YearS,DayS,HourS,MinuteS,SecondS] = GetGOESDateTimeString(GOESFileName,1);
result = is_leap_year(YearS);
if(result==0)
    MonthDayStr=char(DayMonthNonLeapYear{DayS,1});
else
    MonthDayStr=char(DayMonthLeapYear{DayS,1});
end
MonthDayYearStr=strcat(MonthDayStr,'-',num2str(YearS));
% Calculate a few basic statistics regarding the AOD
% 
numpts=length(TT1DSF);
[istable]=find(TT1DSF<45);
numstable=length(istable);
[iunstable]=find(TT1DSF>=45);
numunstable=length(iunstable);
[ivalid]=find(TT1DSF>-43 & TT1DSF<56);
numvalid=length(ivalid);
ValidTT=zeros(numvalid,1);
index=0;
for kk=1:numpts
    if((TT1DSF(kk,1)>=-43) && (TT1DSF(kk,1)<=56))
        index=index+1;
        ValidTT(index,1)=TT1DSF(kk,1);
    end
end
num25=round(.25*numvalid);
num50=round(.50*numvalid);
num75=round(.75*numvalid);
num100=numvalid;
val25=ValidTT(num25,1);
val50=ValidTT(num50,1);
val75=ValidTT(num75,1);
val100=ValidTT(num100,1);
statstr1=strcat('25th ptile TT=',num2str(val25,6),'-50 ptile TT=',num2str(val50,6));
statstr2=strcat('75th ptile TT=',num2str(val75,6),'-100 ptile TT=',num2str(val100,6));
fprintf(fid,'%s\n',statstr1);
fprintf(fid,'%s\n',statstr2);
% Now plot the histogram of the TT Distribution
movie_figure1=figure('position',[hor1 vert1 widd lend]);
set(gcf,'MenuBar','none');
set(gca,'Position',[.16 .18  .70 .70]);
edges=linspace(-43,56,100);
h=histogram(ValidTT,edges,'Normalization','probability','FaceColor','b');
xlabel('TT Stability Index-Deg-C','FontWeight','bold');
ylabel('% Of Pixels','FontWeight','bold');
set(gca,'FontWeight','bold');
xmin=-50;
xmax=60;
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
txtstr2=strcat('Fraction of Pixels that had good TT-Estimate=',num2str(sgoodfrac,6));
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
    imdata = imread(figstr);
    [nhigh,nwid,ndepth]=size(imdata);
    image = mlreportgen.report.FormalImage();
    image.Image = which(figstr);
    pdftxtstr=strcat('TT Stability Index For File-',GOESShortFileName);
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
    parastr91=strcat('The data for this chart was taken from file-',GOESShortFileName,'.');
    parastr92='This chart shows this distribution of TT Stability metric as a histogram.';
    parastr93='A few basic statistics follow.';
    parastr94=strcat('The unstable pixels-those with TT values>45 totaled-',num2str(numunstable),'-while-',num2str(numstable),...
        '-pixels had TT values <45 and thus are deemed stable.');
    parastr95=strcat('The 25th ptile of TT=',num2str(val25,5),'-the 50th ptile was-',num2str(val50,5),'-while the 75th ptile-',...
        num2str(val75,5),'-and the max valid value was-',num2str(val100,5),'-in units of Deg C.');
    parastr99=strcat(parastr91,parastr92,parastr93,parastr94,parastr95);
    p9 = Paragraph(parastr99);
    p9.Style = {OuterMargin("0pt", "0pt","10pt","10pt")};
    add(chapter,p9);
%    add(rpt,chapter);
    close('all');
    dispstr=strcat('Saved file-',figstr);
    disp(dispstr);
    fprintf(fid,'%s\n','-----Finished TT Stability Index Histogram Plot-----');
    fprintf(fid,'\n');
end

