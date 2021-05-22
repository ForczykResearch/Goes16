function PlotCloudTopPressureCumilDist(Pressure,titlestr)
% This routine will plot the cumilative distribution of cloud top pressure
% in units of Km
% Written By: Stephen Forczyk
% Created: Nov 26,2020
% Revised: Jan 20,2021 add logic to include this plot in the PDF report
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
fprintf(fid,'\n');
fprintf(fid,'%s\n','-----Create Cloud Cumilative Pressure Distribution Plot-----');
% Get the scan start date and time data based on the file name
[YearS,DayS,HourS,MinuteS,SecondS] = GetGOESDateTimeString(GOESFileName,1);
[idash]=strfind(GOESFileName,'-');
numdash=length(idash);
[iunder]=strfind(GOESFileName,'_');
numunder=length(iunder);
is=idash(3)+4;
ie=is+1;
[nrows,ncols]=size(Pressure);
totalpix=nrows*ncols;
Pressure1D=reshape(Pressure,nrows*ncols,1);
PressureSort=sort(Pressure1D);
[ibad]=isnan(PressureSort);
numnan=sum(ibad);
numvals=length(PressureSort)-numnan;
val01=PressureSort(round(.01*numvals),1);
val50=PressureSort(round(.50*numvals),1);
val99=PressureSort(round(.99*numvals),1);
maxPressure=max(PressureSort);
PressureCumil=zeros(numvals,1);
for n=1:numvals
   PressureCumil(n,1)=PressureSort(n,1); 
end
% Now create an x array that runs from 0 to 100 p tile
xp=0:1:100;
xp=xp';
xpi=zeros(101,1);
% xpi(1)=1;
% xpi(100)=numvals;
ypi=zeros(101,1);
ypi(1)=0;
ypi(101)=PressureCumil(numvals,1);
for n=2:100
    ptile=(n-1)/100;
    ptileind=round(ptile*numvals);
    ypi(n,1)=PressureCumil(ptileind,1);
end
ptile25ht=ypi(26,1);
ptile50ht=ypi(51,1);
ptile75ht=ypi(76,1);
ptile100ht=ypi(101,1);
htstr1=strcat('Cloud Pres 25 Ptile=',num2str(ptile25ht,6),'-hPa');
htstr2=strcat('Cloud Pres 50 Ptile=',num2str(ptile50ht,6),'-hPa');
htstr3=strcat('Cloud Pres 75 Ptile=',num2str(ptile75ht,6),'-hPa');
htstr4=strcat('Cloud Pres 100 Ptile=',num2str(ptile100ht,6),'-hPa');
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
ylabel('Cloud Top Pressure-hPa','FontWeight','bold');
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
txtstr2=strcat('Cloud Press 25ptile=',num2str(ptile25ht,6),'-Pres 50 ptile=',num2str(ptile50ht,6),...
    '-Pres 75 ptile=',num2str(ptile75ht,6),'-Pres 100 ptile=',num2str(ptile100ht,6),'-all Pres in hPa');
txt2=text(tx2,ty2,txtstr2,'FontWeight','bold','FontSize',8);
set(newaxesh,'Visible','Off');
pause(chart_time);
% Save this chart
figstr=strcat('CloudTopCumPresDist-','Y',num2str(YearS),'D',...
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
    add(chapter,Section('Cloud Top Pressure Cumilative Distribution'));
    imdata = imread(figstr);
    [nhigh,nwid,ndepth]=size(imdata);
    image = mlreportgen.report.FormalImage();
    image.Image = which(figstr);
    pdftxtstr=strcat('Cloud Top Pressure Data Found On File-',GOESShortFileName);
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
    parastr1='The Data for this chart was from file-';
    parastr2=strcat(parastr1,GOESFileName,'-and shows the cumilative distribuition of cloud top pressure values.');
    parastr3=strcat('The user needs to be aware that low pressure values correspond to high level clouds,',...
        'while high pressure values are associated with low altitude clouds.');
    parastr4=strcat('The median value of the cloud top pressure is-',htstr2);
    parastr5=strcat(parastr1,parastr2,parastr3,parastr4);
    p1 = Paragraph(parastr5);
    p1.Style = {OuterMargin("0pt", "0pt","0pt","10pt")};
    add(chapter,p1);
    add(rpt,chapter);
end
close('all');

dispstr=strcat('Saved file-',figstr);
disp(dispstr);
savestr1=strcat('Saved Plot to File-',figstr);
fprintf(fid,'%s\n',savestr1);
fprintf(fid,'%s\n','-----Finished Cloud Cumilative Pressure Distirubution Plot-----');
fprintf(fid,'\n');
end

