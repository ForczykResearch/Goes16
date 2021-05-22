function PlotCMICumilDist(titlestr,itype,bandnum)
% This routine will plot the cumilative distribution of the cloud
% relectance
% 
% Written By: Stephen Forczyk
% Created: Dec 24,2020
% Revised: Jan 01,2021 added capability to add figures to PDF report
%          using report generator
% Revised: Jan 06,2021 changed image scale for pdf report to allow for
% caption
% Revised: Jan 16,2021 made change to allow TOC entry for PDF report
% Revised: Mar 27,2021 added MapFormFactor variable into section name
% Classification: Unclassified

global BandDataS MetaDataS;
global CMIS DQFS tS yS xS tBS goesImagerS yImgS yImgBS;
global xImgS xImgBS SatDataS GeoSpatialS;
global ReflectanceS AlgoS ErrorS EarthSunS VersionContainerS;
global GoesWaveBand ESunS kappa0S PlanckS FocalPlaneS;
global HTS DQF1S OutlierPS CloudTopS Algo1S ProcessParamS;
global LZAS LZABS SZAS SZABS Error1S CloudPixelsS;
global GOESFileName;
global MonthDayStr MonthDayYearStr;
global DayMonthNonLeapYear DayMonthLeapYear CalendarFileName;
global westEdge eastEdge northEdge southEdge;
global JpegCounter JpegFileList;
global NumProcFiles ProcFileList;
global RptGenPresent iCreatePDFReport pdffilename rpt chapter;
global JpegCounter JpegFileList;
global MapFormFactor;

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
fprintf(fid,'%s\n','-----Create Cloud Relectance Cumilative Distribution Plot-----');
% Get the scan start date and time data based on the file name
[YearS,DayS,HourS,MinuteS,SecondS] = GetGOESDateTimeString(GOESFileName,1);
result = is_leap_year(YearS);
if(result==0)
    MonthDayStr=char(DayMonthNonLeapYear{DayS,1});
else
    MonthDayStr=char(DayMonthLeapYear{DayS,1});
end
MonthDayYearStr=strcat(MonthDayStr,'-',num2str(YearS));
% [idash]=strfind(GOESFileName,'-');
% numdash=length(idash);
% [iunder]=strfind(GOESFileName,'_');
% numunder=length(iunder);
% is=idash(3)+4;
% ie=is+1;
[idash]=strfind(GOESFileName,'-');
numdash=length(idash);
[iunder]=strfind(GOESFileName,'_');
numunder=length(iunder);
is=idash(3)+4;
ie=is+1;
bandstr=GOESFileName(is:ie);
iband=str2num(bandstr);
BandNum=GoesWaveBand{iband+1,1};
Resolution=GoesWaveBand{iband+1,2};
WaveLen=(GoesWaveBand{iband+1,3});
SpectrumStr=char(GoesWaveBand{iband+1,4});
BandDescStr=char(GoesWaveBand{iband+1,5});
BandNumStr=num2str(BandNum);
ResolutionStr=num2str(Resolution);
WaveLenStr=num2str(WaveLen);
CMI=CMIS.values;
[nrows,ncols]=size(CMI);
totalpix=nrows*ncols;
CMI1D=reshape(CMI,totalpix,1);
CMISort=sort(CMI1D);
[ibad]=isnan(CMISort);
numnan=sum(ibad);
numvals=length(CMISort)-numnan;
val01=CMISort(round(.01*numvals),1);
val50=CMISort(round(.50*numvals),1);
val99=CMISort(round(.99*numvals),1);
maxCMI=max(CMISort);
CMICumil=zeros(numvals,1);
for n=1:numvals
   CMICumil(n,1)=CMISort(n,1); 
end
% Now create an x array that runs from 0 to 100 p tile
xp=0:1:100;
xp=xp';
ypi=zeros(101,1);
ypi(1)=0;
ypi(101)=CMICumil(numvals,1);
for n=2:100
    ptile=(n-1)/100;
    ptileind=round(ptile*numvals);
    ypi(n,1)=CMICumil(ptileind,1);
end
ptile25ht=ypi(26,1);
ptile50ht=ypi(51,1);
ptile75ht=ypi(76,1);
ptile100ht=ypi(101,1);
htstr1=strcat('Cloud Reflectance 25 Ptile=',num2str(ptile25ht,6));
htstr2=strcat('Cloud Reflectance 50 Ptile=',num2str(ptile50ht,6));
htstr3=strcat('Cloud Reflectance 75 Ptile=',num2str(ptile75ht,6));
htstr4=strcat('Cloud Reflectance 100 Ptile=',num2str(ptile100ht,6));
fprintf(fid,'%s\n',htstr1);
fprintf(fid,'%s\n',htstr2);
fprintf(fid,'%s\n',htstr3);
fprintf(fid,'%s\n',htstr4);
% Now create a line plot of the cumilative distribution
movie_figure1=figure('position',[hor1 vert1 widd lend]);
set(gcf,'MenuBar','none');
set(gca,'Position',[.16 .18  .70 .70]);
h=plot(xp,ypi,'g');
xlabel('Percentile','FontWeight','bold');
ylabelstr='Cloud Reflectance-';
ylabel(ylabelstr,'FontWeight','bold');
set(gca,'FontWeight','bold');
set(gca,'XGrid','On','YGrid','On');
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
txtstr2=strcat('Cloud Refl 25ptile=',num2str(ptile25ht,6),'-Refl 50 ptile=',num2str(ptile50ht,6),...
    '-Refl 75 ptile=',num2str(ptile75ht,6),'-Refl 100 ptile=',num2str(ptile100ht,6));
txt2=text(tx2,ty2,txtstr2,'FontWeight','bold','FontSize',8);
set(newaxesh,'Visible','Off');
pause(chart_time);
% Save this chart
figstr=strcat('CloudRlectanceCumilDist-','Y',num2str(YearS),'D',...
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
    sectionstr=strcat('ABI-CMI-',MapFormFactor,'-CumilDist-Band-',bandstr);
    add(chapter,Section(sectionstr));
    imdata = imread(figstr);
    [nhigh,nwid,ndepth]=size(imdata);
    image = mlreportgen.report.FormalImage();
    image.Image = which(figstr);
    pdftxtstr=strcat('Cloud CMI Cumil Dist For File-',GOESShortFileName);
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
    parastr1='This chart provides a Cumiliative distribution plot of the CMI reflectance values.';
    parastr2=' The first line below the plot provides details of when the scan was taken.';
    parastr3=' The last line provides additional details on the distribution at selected points.';
    parastr4=strcat('The median Reflectance value is-',num2str(val50,4),'-for those pixels that had clouds=the higher the reflectance the more dense the cloud');
    parastr=strcat(parastr1,parastr2,parastr3,parastr4);
    p1 = Paragraph(parastr);
    p1.Style = {OuterMargin("0pt", "0pt","50pt","10pt")};
    add(chapter,p1);
    add(rpt,chapter);
end
JpegCounter=JpegCounter+1;
JpegFileList{JpegCounter+1,1}=figstr;
JpegFileList{JpegCounter+1,2}=jpegpath;
%close('all');
dispstr=strcat('Saved file-',figstr);
disp(dispstr);
savestr1=strcat('Saved Plot to File-',figstr);
fprintf(fid,'%s\n',savestr1);
fprintf(fid,'%s\n','-----Finished Cloud Cumiliative Reflectance Distribution Plot-----');
close('all');
end

