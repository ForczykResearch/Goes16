function PlotRGBHistogram(CMI1DS,titlestr)
% This routine will plot a histogram of the multiband true color
% reflectance values
% Written By: Stephen Forczyk
% Created: Jan 6,2021
% Revised: Jan 7,2021 added quick statistic to calculate fraction of night
% pixels
% Classification: Unclassified
global BandDataS MetaDataS;
global CMIS DQFS tS yS xS tBS goesImagerS yImgS yImgBS;
global xImgS xImgBS SatDataS GeoSpatialS;
global ReflectanceS AlgoS ErrorS EarthSunS VersionContainerS;
global GoesWaveBand ESunS kappa0S PlanckS FocalPlaneS;
global HTS DQF1S OutlierPS CloudTopS Algo1S ProcessParamS;
global LZAS LZABS SZAS SZABS Error1S CloudPixelsS;
global CMI_C01S DQF_C01S;
global CMI_C02S DQF_C02S;
global CMI_C03S DQF_C03S;
global CMI_C04S DQF_C04S;
global CMI_C05S DQF_C05S;
global CMI_C06S DQF_C06S;
global CMI_C07S DQF_C07S;
global CMI_C08S DQF_C08S;
global CMI_C09S DQF_C09S;
global CMI_C10S DQF_C10S;
global CMI_C11S DQF_C11S;
global CMI_C12S DQF_C12S;
global CMI_C13S DQF_C13S;
global CMI_C14S DQF_C14S;
global CMI_C15S DQF_C15S;
global CMI_C16S DQF_C16S;
global MBandDataS MBandiDS;
global goodfrac nightfrac;
global GOESFileName MapFormFactor;
global westEdge eastEdge northEdge southEdge;
global MonthDayStr MonthDayYearStr;
global DayMonthNonLeapYear DayMonthLeapYear CalendarFileName;
global NumProcFiles ProcFileList;
global RptGenPresent iCreatePDFReport pdffilename rpt chapter;
global JpegCounter JpegFileList;

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
fprintf(fid,'%s\n','-----Create Earth Scene True Color Histogram Plot-----');
% Get the scan start date and time data based on the file name
[YearS,DayS,HourS,MinuteS,SecondS] = GetGOESDateTimeString(GOESFileName,1);
result = is_leap_year(YearS);
if(result==0)
    MonthDayStr=char(DayMonthNonLeapYear{DayS,1});
else
    MonthDayStr=char(DayMonthLeapYear{DayS,1});
end
MonthDayYearStr=strcat(MonthDayStr,'-',num2str(YearS));
[idash]=strfind(GOESFileName,'-');
numdash=length(idash);
[iunder]=strfind(GOESFileName,'_');
numunder=length(iunder);
is=idash(3)+4;
ie=is+1;
% Now plot the histogram of the RGB data
a1=isnan(CMI1DS);
numnan=sum(a1);
numtotpix=length(CMI1DS);
numgoodpix=numtotpix-numnan;
goodfrac=numgoodpix/numtotpix;
% Establish night pixels as having an RGB value less than 0.1;
[ilow]=find(CMI1DS<0.1);
numlow=length(ilow);
nightfrac=numlow/numgoodpix;
pixelstr1=strcat('Fraction of Pixels with good values=',num2str(goodfrac,6),...
    '-Fraction of Pixels Viewing Night side=',num2str(nightfrac,6));
fprintf(fid,'%s\n',pixelstr1);
movie_figure1=figure('position',[hor1 vert1 widd lend]);
set(gcf,'MenuBar','none');
set(gca,'Position',[.16 .18  .70 .70]);
edges=linspace(0,3,101);
h=histogram(CMI1DS,edges,'Normalization','probability','FaceColor','b');
xlabel('True RGB Reflectance','FontWeight','bold');
ylabel('% Of Pixels','FontWeight','bold');
set(gca,'FontWeight','bold');
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
txtstr2=strcat('Fraction Of pixels with good results=',num2str(goodfrac,6),...
    '-fraction viewing night side=',num2str(nightfrac,6));
txt2=text(tx2,ty2,txtstr2,'FontWeight','bold','FontSize',8);
set(newaxesh,'Visible','Off');
pause(chart_time);
% Save this chart
figstr=strcat('TrueRGB-OR-ABI-L2-CMIPC-','Y',num2str(YearS),'D',...
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
    add(chapter,Section('Histogram of True Color RGB Values'));
    imdata = imread(figstr);
    [nhigh,nwid,ndepth]=size(imdata);
    image = mlreportgen.report.FormalImage();
    image.Image = which(figstr);
    pdftxtstr=strcat('True RGB Histogram For File-',GOESShortFileName);
    pdftext = Text(pdftxtstr);
    pdftext.Color = 'red';
    image.Caption = pdftext;
    nhighs=floor(nhigh/2.5);
    nwids=floor(nwid/2.5);
    heightstr=strcat(num2str(nhighs),'px');
    widthstr=strcat(num2str(nwids),'px');
    image.Height = heightstr;
    image.Width = widthstr;
    image.ScaleToFit=0;
    add(chapter,image);
    parastr1='This chart provides a Histogram plot of the True RGB reflectance values.';
    parastr2=' The first line below the plot provides details of when the scan was taken.';
    parastr3=strcat('The fraction of goodpixels was=',num2str(goodfrac),'.');
    parastr4='Since the RGB image is made up of 2 Vis and 1 SWIR band,earth regions not in daylight';
    parastr5=' will have an RGB very close to 0-using a limit of 0.1 for the RGB value for night';
    parastr6=strcat(' it can be seen that the fraction of pixels looking at dark areas=',num2str(nightfrac,6));
    parastr=strcat(parastr1,parastr2,parastr3,parastr4,parastr5,parastr6);
    p1 = Paragraph(parastr);
    p1.Style = {OuterMargin("0pt", "0pt","50pt","10pt")};
    add(chapter,p1);    
end
JpegCounter=JpegCounter+1;
JpegFileList{JpegCounter+1,1}=figstr;
JpegFileList{JpegCounter+1,2}=jpegpath;
close('all');
dispstr=strcat('Saved file-',figstr);
disp(dispstr);
fprintf(fid,'%s\n','-----Finished Making Earth Scene True Color Histogram Plot-----');
end

