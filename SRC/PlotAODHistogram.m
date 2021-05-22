function [ValidAOD]=PlotAODHistogram(AOD1DSF,sgoodfrac,titlestr)
% This routine will plot a histogram of the AOD metric
% no distinction is made between land and sea based values
% Written By: Stephen Forczyk
% Created: Feb 15,2021
% Revised: --------
% Classification: Unclassified
global MetaDataS;
global AODS AODWaveS LandSenBandWS SeaSenBandWS;
global LandSenBandIDS SeaSenBandIDS;
global LatitudeBandS LatitudeBandBoundS;
global SnowFreeLandIceFreeSeaS;
global AOD550_RET_ATT_LandS AOD550_RET_ATT_SeaS;
global AOD550_Good_LZA_RET_ATTS AOD550_OutlierPixelS;
global AOD550_LandStatS AOD550_SeaStatS;
global LatBand_AOD550_LandStatS LatBand_AOD550_SeaStatS;
global LatBand_AOD550_RET_ATT_LandS LatBand_AOD550_RET_ATT_SeaS;
global LatBand_AOD550_LZA_RET_ATT_LandS LatBand_AOD550_LZA_GRET_ATT_LandS;
global LatBand_AOD550_LZA_HQRET_ATT_LandS;
global LatBand_AOD550_LZA_MQRET_ATT_LandS LatBand_AOD550_LZA_LQRET_ATT_LandS;
global LatBand_AOD550_LZA_NRET_ATT_LandS;
global LatBand_AOD550_LZA_GRET_ATT_SeaS LatBand_AOD550_LZA_HQRET_ATT_SeaS;
global LatBand_AOD550_LZA_MQRET_ATT_SeaS;
global LatBand_AOD550_LZA_LQRET_ATT_SeaS LatBand_AOD550_LZA_NRET_ATT_SeaS;
global DQFS tS yS xS tBS goesImagerS yImgS yImgBS;
global xImgS xImgBS SatDataS GeoSpatialS ;
global AlgoS GoesWaveBand;
global AlgoProdVersionContainerS ProcessParamS;
global QLZAS  QLZABS;
global SunGlintS SunGlintBS;
global RLZAS RLZABS RSZAS QSZAS RSZABS QSZABS;
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
fprintf(fid,'%s\n','-----Create AOD Histogram Plot-----');
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
[ibig]=find(AOD1DSF>0);
numbig=length(ibig);
numpts=length(AOD1DSF);
ValidAOD=zeros(numbig,1);
first=ibig(1);
index=0;
for kk=first:numpts
    index=index+1;
    ValidAOD(index,1)=AOD1DSF(kk,1);
end

num25=round(.25*numbig);
num50=round(.50*numbig);
num75=round(.75*numbig);
num100=numbig;
val25=ValidAOD(num25,1);
val50=ValidAOD(num50,1);
val75=ValidAOD(num75,1);
val100=ValidAOD(num100,1);
statstr1=strcat('25th ptile AOD=',num2str(val25,6),'-50 ptile AOD=',num2str(val50,6));
statstr2=strcat('75th ptile AOD=',num2str(val75,6),'-100 ptile AOD=',num2str(val100,6));
fprintf(fid,'%s\n',statstr1);
fprintf(fid,'%s\n',statstr2);
% Now plot the histogram of the AOD Distribution
movie_figure1=figure('position',[hor1 vert1 widd lend]);
set(gcf,'MenuBar','none');
set(gca,'Position',[.16 .18  .70 .70]);
edges=linspace(0,5,101);
h=histogram(ValidAOD,edges,'Normalization','probability','FaceColor','b');
xlabel('AOD','FontWeight','bold');
ylabel('% Of Pixels','FontWeight','bold');
set(gca,'FontWeight','bold');
xmin=0;
xmax=5;
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
txtstr2=strcat('Fraction of Pixels that had good AOD-Estimate=',num2str(sgoodfrac,6));
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
    add(chapter,Section('AOD Histogram'));
    imdata = imread(figstr);
    [nhigh,nwid,ndepth]=size(imdata);
    image = mlreportgen.report.FormalImage();
    image.Image = which(figstr);
    pdftxtstr=strcat('AOD For File-',GOESShortFileName);
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
    parastr62='This chart shows this distribution of Aerosol Optical Depth metric as a histogram.';
    parastr63=strcat('Typical values range from 0 to about 1 even though the algorithm computes data out to a value of 5.',...
        'For this data frame,the median value is-',num2str(val50,6),'.');
    parastr64='This histogram does not make the distinction between values coming from land or sea based pixels.';
    parastr65='Values of AOD larger than 1 typically arise from low quality retrievals from the edges of the scene because of LZA issues.';
%     parastr64=strcat('Basic TPW data as follows.','The first quartile limit is-',num2str(val25,6),'-and the median value is-',...
%          num2str(val50,6),'.');
%     parastr65=strcat('The third quartile limit is-',num2str(val75,6),'-while the max value is-',num2str(val100,6),'-all TPW estimates are in mm.');
%     parastr66='Note that the largest valid TPW estimate is 100mm.';
%     parastr67='The computed statistics were only based on those pixels that actually had valid TPW estimates.';
    parastr69=strcat(parastr61,parastr62,parastr63,parastr64,parastr65);
    p6 = Paragraph(parastr69);
    p6.Style = {OuterMargin("0pt", "0pt","10pt","10pt")};
    add(chapter,p6);
%    add(rpt,chapter);
    close('all');
    dispstr=strcat('Saved file-',figstr);
    disp(dispstr);
    fprintf(fid,'%s\n','-----Finished AOD Histogram Plot-----');
    fprintf(fid,'\n');
end

