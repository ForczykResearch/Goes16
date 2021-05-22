function [ValidKI]=PlotKIStabilityIndexHistogram(KI1DSF,sgoodfrac,titlestr)
% This routine will plot a histogram of the KI Stability Index
% no distinction is made between land and sea based values
% Written By: Stephen Forczyk
% Created: Feb 21,2021
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
fprintf(fid,'%s\n','-----Create KI Stability Index Histogram Plot-----');
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
numpts=length(KI1DSF);
[istable]=find(KI1DSF<=30);
numstable=length(istable);
[iunstable]=find(KI1DSF>30);
numunstable=length(iunstable);
fracunstable=numunstable/(numstable+numunstable);
[ivalid]=find(KI1DSF>=0 & KI1DSF<=40);
numvalid=length(ivalid);
ValidKI=zeros(numvalid,1);
index=0;
for kk=1:numpts
    if((KI1DSF(kk,1)>=0) && (KI1DSF(kk,1)<=40))
        index=index+1;
        ValidKI(index,1)=KI1DSF(kk,1);
    end
end
num25=round(.25*numvalid);
num50=round(.50*numvalid);
num75=round(.75*numvalid);
num100=numvalid;
minValidKI=min(ValidKI);
maxValidKI=max(ValidKI);
val25=ValidKI(num25,1);
val50=ValidKI(num50,1);
val75=ValidKI(num75,1);
val100=ValidKI(num100,1);
% edgemax=val100-mod(val100,10)+10;
% numedges=(edgemax/10)+1;
statstr1=strcat('25th ptile KI=',num2str(val25,6),'-50 ptile KI=',num2str(val50,6));
statstr2=strcat('75th ptile KI=',num2str(val75,6),'-100 ptile KI=',num2str(val100,6),'-all in Deg-C.');
fprintf(fid,'%s\n',statstr1);
fprintf(fid,'%s\n',statstr2);
% Now plot the histogram of the KI Distribution
movie_figure1=figure('position',[hor1 vert1 widd lend]);
set(gcf,'MenuBar','none');
set(gca,'Position',[.16 .18  .70 .70]);
edges=linspace(0,40,41);
h=histogram(ValidKI,edges,'Normalization','probability','FaceColor','b');
xlabel('KI Stability Index-Deg-C','FontWeight','bold');
ylabel('% Of Pixels','FontWeight','bold');
set(gca,'FontWeight','bold');
xmin=0;
xmax=40;
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
txtstr2=strcat('Min KI Index=',num2str(minValidKI,4),'-Max ValidKI=',num2str(maxValidKI,4));
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
    pdftxtstr=strcat('KI Stability Index For File-',GOESShortFileName);
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
    parastr161=strcat('The data for this chart was taken from file-',GOESShortFileName,'.');
    parastr162='This chart shows this distribution of KI Stability metric as a histogram.';
    if(fracunstable<.05)
        parastr163=strcat('The fraction of unstable pixels-',num2str(fracunstable,5),'-is very low so the scene is quite stable.');
    elseif(fracunstable>=.05)
        parastr163=strcat('The fraction of unstable pixels-',num2str(fracunstable,5),'-is over 5% so there are significant regions of instability.');         
    end
    parastr169=strcat(parastr161,parastr162,parastr163);
    p16 = Paragraph(parastr169);
    p16.Style = {OuterMargin("0pt", "0pt","10pt","10pt")};
    add(chapter,p16);
%    add(rpt,chapter);
    close('all');
    dispstr=strcat('Saved file-',figstr);
    disp(dispstr);
    fprintf(fid,'%s\n','-----Finished KI Stability Index Histogram Plot-----');
    fprintf(fid,'\n');
end

