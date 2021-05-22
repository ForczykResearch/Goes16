function PlotCloudTopHeightsHistogram(HT,titlestr)
% This routine will plot a histogram of the CloudTop Heights
% in units of Km
% Written By: Stephen Forczyk
% Created: Nov 24,2020
% Revised: Jan 4,2021 added code to create pdf reports
% Revised: Jan 16,2021 added TOC entry to PDF Report
% Classification: Unclassified

global BandDataS MetaDataS;
global CMIS DQFS tS yS xS tBS goesImagerS yImgS yImgBS;
global xImgS xImgBS SatDataS GeoSpatialS;
global ReflectanceS AlgoS ErrorS EarthSunS VersionContainerS;
global GoesWaveBand ESunS kappa0S PlanckS FocalPlaneS;
global HTS DQF1S OutlierPS CloudTopS Algo1S ProcessParamS;
global LZAS LZABS SZAS SZABS Error1S CloudPixelsS;
global GOESFileName MapFormFactor;
global MonthDayStr MonthDayYearStr;
global DayMonthNonLeapYear DayMonthLeapYear CalendarFileName;
global westEdge eastEdge northEdge southEdge;
global RptGenPresent iCreatePDFReport pdffilename rpt chapter;
global JpegCounter JpegFileList;


global widd2 lend2;
global initialtimestr igrid ijpeg ilog imovie;
global vert1 hor1 widd lend;
global vert2 hor2 machine;
global chart_time;
global Fz1 Fz2 fid;
global idirector mov izoom iwindow;
global matpath GOES16path;
global jpegpath ;
global smhrpath excelpath ascpath;
global ipowerpoint PowerPointFile scaling stretching padding;
global ichartnum;
% additional paths needed for mapping
global matpath1 mappath;
global canadapath stateshapepath topopath;
global trajpath militarypath;
global figpath screencapturepath gridpath;
global shapepath2 countrypath countryshapepath usstateboundariespath;
global GOES16Band1path GOES16Band2path GOES16Band3path GOES16Band4path;
global GOES16Band5path GOES16Band6path GOES16Band7path GOES16Band8path
global GOES16Band9path GOES16Band10path GOES16Band11path GOES16Band12path;
global GOES16Band13path GOES16Band14path GOES16Band15path GOES16Band16path;
global GOES16CloudTopHeightpath;
if((iCreatePDFReport==1) && (RptGenPresent==1))
    import mlreportgen.dom.*;
    import mlreportgen.report.*;
end

% Get the scan start date and time data based on the file name
[YearS,DayS,HourS,MinuteS,SecondS] = GetGOESDateTimeString(GOESFileName,1);
[idash]=strfind(GOESFileName,'-');
numdash=length(idash);
[iunder]=strfind(GOESFileName,'_');
numunder=length(iunder);
is=idash(3)+4;
ie=is+1;
[nrows,ncols]=size(HT);
totalpix=nrows*ncols;
HT=HT/1000;
HTS1D=reshape(HT,nrows*ncols,1);
HTSort=sort(HTS1D);
[ibad]=isnan(HTSort);
numnan=sum(ibad);
numvals=length(HTSort)-numnan;
val01=HTSort(round(.01*numvals),1);
val50=HTSort(round(.50*numvals),1);
val99=HTSort(round(.99*numvals),1);
maxHT=max(HTSort);
pixoutofrange=OutlierPS.values;
fracoutofrange=pixoutofrange/totalpix;
nanfrac=numnan/totalpix;
numuse=numvals/totalpix;
% Now plot the histogram of the CloudTop Heights
movie_figure1=figure('position',[hor1 vert1 widd lend]);
set(gcf,'MenuBar','none');
set(gca,'Position',[.16 .18  .70 .70]);
h=histogram(HTS1D,50);
set(h,'FaceColor','b');
xlabel('Altitude -Km','FontWeight','bold');
ylabel('Cases','FontWeight','bold');
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
    num2str(HourS),'-M-',num2str(MinuteS),'-S-',num2str(SecondS),'-Date=',MonthDayYearStr);
txt1=text(tx1,ty1,txtstr1,'FontWeight','bold','FontSize',8);
tx2=.18;
ty2=.06;
txtstr2=strcat('Total Pixels=',num2str(totalpix),'-number of HT estimates=',num2str(numvals),...
    '-number of Nan estimates=',num2str(numnan));
txt2=text(tx2,ty2,txtstr2,'FontWeight','bold','FontSize',8);
set(newaxesh,'Visible','Off');
pause(chart_time);
% Save this chart
figstr=strcat('CloudTopHeights-','Y',num2str(YearS),'D',...
    num2str(DayS),'H',num2str(HourS),'M',num2str(MinuteS),'S',num2str(round(SecondS)),...
    '.jpg');
eval(['cd ' jpegpath(1:length(jpegpath)-1)]);
actionstr='print';
typestr='-djpeg';
[cmdString]=MyStrcat2(actionstr,typestr,figstr);
eval(cmdString);
close('all');
if((iCreatePDFReport==1) && (RptGenPresent==1))
    imgPath = which(figstr);
    img1 = Image(imgPath);
    img1.Style=[img1.Style {ScaleToFit}];
    add(chapter,img1);
    add(chapter,Section('Histogram Of Cloud Top Heights'));
    parastr1='This chart provides a Histogram plot of the Cloud Top Heights in Km.';
    parastr2=' The first line below the plot provides details of when the scan was taken.';
    parastr3=' The last line provides details on how many pixels were involved in creating the histgram.';
    parastr4=strcat('This map had a-',MapFormFactor,'-scope.');
    parastr5=strcat('Useable HT estimates frac=',num2str(numuse,6),'-frac of pixels reporting NaN values=',num2str(nanfrac,6));
    parastr6=strcat(' The fraction of pixels that returned bad height estimates=',num2str(fracoutofrange,6));
    parastr=strcat(parastr1,parastr2,parastr3,parastr4,parastr5,parastr6);
    p1 = Paragraph(parastr);
    p1.Style = {OuterMargin("0pt", "0pt","50pt","10pt")};
    add(chapter,p1);
end
JpegCounter=JpegCounter+1;
JpegFileList{JpegCounter+1,1}=figstr;
JpegFileList{JpegCounter+1,2}=jpegpath;
dispstr=strcat('Saved file-',figstr);
disp(dispstr);

end

