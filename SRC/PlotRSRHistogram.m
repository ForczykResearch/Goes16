function [ValidRSR]=PlotRSRHistogram(titlestr)
% This routine will plot a histogram of Reflected Solar Radiation 
% Written By: Stephen Forczyk
% Created: April 28,2021
% Revised: --------
% Classification: Unclassified
global BandDataS MetaDataS;
global RSRS DQFS tS tBS ;
global SatDataS GeoSpatialS;
global lat_imageS lat_image_BS;
global lon_imageS lon_image_BS;
global GoesWaveBand MapFormFactor;
global GOESFileName ;
global LatS LonS;
global RLZAS QLZAS RLZABS QLZABS;
global RSZAS QSZAS RSZABS QSZABS;
global RSRProdWaveS RSRProdWaveBS;
global RetPixCountS LZAPixCountS OutlierPixCountS;
global ImageCloudFracS SZAStatS RSRStatS;
global Algo2S ProcessParamTS AlgoProductTS Error1S ;
global GRBErrorsS L0ErrorsS;
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
fprintf(fid,'%s\n','-----Create Reflected Solar Radiation Histogram Plot-----');
% Get the scan start date and time data based on the file name
[YearS,DayS,HourS,MinuteS,SecondS] = GetGOESDateTimeString(GOESFileName,1);
result = is_leap_year(YearS);
if(result==0)
    MonthDayStr=char(DayMonthNonLeapYear{DayS,1});
else
    MonthDayStr=char(DayMonthLeapYear{DayS,1});
end
MonthDayYearStr=strcat(MonthDayStr,'-',num2str(YearS));
% Get Create an array only containing Valid RSR data
RSR=RSRS.values;
[nrows,ncols]=size(RSR);
RSR1D=reshape(RSR,nrows*ncols,1);
RSR1DS=sort(RSR1D);
a1=isnan(RSR1D);
numnan=sum(a1);
ntotpix=nrows*ncols;
nvalid=ntotpix-numnan;
ValidRSR=zeros(nvalid,1);
for n=1:nvalid
    ValidRSR(n,1)=RSR1DS(n,1);
end
validfrac=nvalid/ntotpix;
num25=round(.25*nvalid);
num50=round(.50*nvalid);
num75=round(.75*nvalid);
num100=nvalid;
minRSR=min(ValidRSR);
maxRSR=max(ValidRSR);
val25=ValidRSR(num25,1);
val50=ValidRSR(num50,1);
val75=ValidRSR(num75,1);
val100=ValidRSR(num100,1);
statstr1=strcat('25th ptile RSR=',num2str(val25,6),'-50 ptile RSR=',num2str(val50,6),'-in W/m^2');
statstr2=strcat('75th ptile RSR=',num2str(val75,6),'-100 ptile RSR=',num2str(val100,6),'-in W/m^2');
fprintf(fid,'%s\n',statstr1);
fprintf(fid,'%s\n',statstr2);
statstr3=strcat('RSR data stored in an array of nrows x ncols=',num2str(nrows,4),'-x-',num2str(ncols,4));
fprintf(fid,'%s\n',statstr3);
statstr4=strcat('Total Pixels=',num2str(ntotpix,6),'-Valid Pixels=',num2str(nvalid,6),'-which is-',num2str(validfrac,6),...
    '-of all pixels');
fprintf(fid,'%s\n',statstr4);
% Now plot the histogram of the RSR
movie_figure1=figure('position',[hor1 vert1 widd lend]);
set(gcf,'MenuBar','none');
set(gca,'Position',[.16 .18  .70 .70]);
xmax=val100-mod(val100,100)+100;
xmax=1500;
numbins=floor(xmax/50);
edges=linspace(0,xmax,numbins);
h=histogram(ValidRSR,edges,'Normalization','probability','FaceColor','b');
xlabel('RSR-W/m^2','FontWeight','bold');
ylabel('% Of Pixels','FontWeight','bold');
set(gca,'FontWeight','bold');
xmin=0;
set(gca,'XLim',[xmin xmax+100],'YLim',[0 .35]);
if(igrid==1)
    set(gca,'XGrid','On','YGrid','On');
end
hold on
xp(1,1)=1454;
xp(2,1)=1454;
yp(1,1)=0.0;
yp(2,1)=0.35;
plot(xp,yp,'r--');
tx0=1250;
ty0=.20;
txt0=text(tx0,ty0,'Solar Constant','FontWeight','bold','FontSize',10,'Color',[1 0 0]);
hold off
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
txtstr2=strcat('Min RSR=',num2str(minRSR,5),'-Max ValidRSR=',num2str(maxRSR,5));
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
    add(chapter,Section('RSR Histogram'));
    imdata = imread(figstr);
    [nhigh,nwid,ndepth]=size(imdata);
    image = mlreportgen.report.FormalImage();
    image.Image = which(figstr);
    pdftxtstr=strcat('RSR Histogram For File-',GOESShortFileName);
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
    parastr82='This chart shows this distribution of RSR metric as a histogram.';
    parastr83=strcat('The median value of the RSR measurement is=',num2str(val50,6),'-W/m^2.');
    parastr84='The solar constant is commonly quoted as 1454 w/m^2.';
    parastr85='For comparison purposes this was plotted as a dashed red line on the chart-no RSR value should exceed this.';
    parastr89=strcat(parastr81,parastr82,parastr83,parastr84,parastr85);
    p9 = Paragraph(parastr89);
    p9.Style = {OuterMargin("0pt", "0pt","10pt","10pt")};
    add(chapter,p9);
    %add(rpt,chapter);
    close('all');
    dispstr=strcat('Saved file-',figstr);
    disp(dispstr);
    fprintf(fid,'%s\n','-----Finished RSR Histogram Plot-----');
    fprintf(fid,'\n');
end

