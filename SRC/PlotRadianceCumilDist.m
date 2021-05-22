function PlotRadianceCumilDist(titlestr,itype,bandnum)
% This routine will plot the cumilative distribution of the cloud radiance
% 
% Written By: Stephen Forczyk
% Created: Dec 23,2020
% Revised: Mar 22,2021 added code to create PDF report entries
% Classification: Unclassified

global BandDataS MetaDataS;
global RadS DQFS tS yS xS tBS goesImagerS yImgS yImgBS;
global xImgS xImgBS SatDataS GeoSpatialS;
global ReflectanceS AlgoS ErrorS EarthSunS VersionContainerS;
global GoesWaveBand ESunS kappa0S PlanckS FocalPlaneS;
global HTS DQF1S OutlierPS CloudTopS Algo1S ProcessParamS;
global LZAS LZABS SZAS SZABS Error1S CloudPixelsS;
global GOESFileName;
global westEdge eastEdge northEdge southEdge;
global MonthDayStr MonthDayYearStr;
global DayMonthNonLeapYear DayMonthLeapYear CalendarFileName;
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
fprintf(fid,'%s\n','-----Create Radiance Cumilative Distribution Plot-----');
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
Radiance=RadS.values;
measunits=RadS.units;
[nrows,ncols]=size(Radiance);
totalpix=nrows*ncols;
Radiance1D=reshape(Radiance,totalpix,1);
RadianceSort=sort(Radiance1D);
[ibad]=isnan(RadianceSort);
numnan=sum(ibad);
numvals=length(RadianceSort)-numnan;
val01=RadianceSort(round(.01*numvals),1);
val50=RadianceSort(round(.50*numvals),1);
val99=RadianceSort(round(.99*numvals),1);
maxRadiance=max(RadianceSort);
RadianceCumil=zeros(numvals,1);
for n=1:numvals
   RadianceCumil(n,1)=RadianceSort(n,1); 
end
% Now create an x array that runs from 0 to 100 p tile
xp=0:1:100;
xp=xp';
xpi=zeros(101,1);
ypi=zeros(101,1);
ypi(1)=0;
ypi(101)=RadianceCumil(numvals,1);
for n=2:100
    ptile=(n-1)/100;
    ptileind=round(ptile*numvals);
    ypi(n,1)=RadianceCumil(ptileind,1);
end
ptile25ht=ypi(26,1);
ptile50ht=ypi(51,1);
ptile75ht=ypi(76,1);
ptile100ht=ypi(101,1);
htstr1=strcat('ABI Radiance 25 Ptile=',num2str(ptile25ht,6),'-',measunits);
htstr2=strcat('ABI Radiance 50 Ptile=',num2str(ptile50ht,6),'-',measunits);
htstr3=strcat('ABI Radiance 75 Ptile=',num2str(ptile75ht,6),'-',measunits);
htstr4=strcat('ABI Radiance 100 Ptile=',num2str(ptile100ht,6),'-',measunits);
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
ylabelstr=strcat('Cloud Radiance-',measunits);
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
txtstr2=strcat('Rad 25ptile=',num2str(ptile25ht,6),'-Rad 50 ptile=',num2str(ptile50ht,6),...
    '-Rad 75 ptile=',num2str(ptile75ht,6),'-Rad 100 ptile=',num2str(ptile100ht,6),'-all in',measunits);
txt2=text(tx2,ty2,txtstr2,'FontWeight','bold','FontSize',8);
set(newaxesh,'Visible','Off');
pause(chart_time);
% Save this chart
figstr=strcat('RadCumilDist-','Y',num2str(YearS),'D',...
    num2str(DayS),'H',num2str(HourS),'M',num2str(MinuteS),'S',num2str(round(SecondS)),...
    '.jpg');
eval(['cd ' jpegpath(1:length(jpegpath)-1)]);
actionstr='print';
typestr='-djpeg';
[cmdString]=MyStrcat2(actionstr,typestr,figstr);
eval(cmdString);
close('all');
dispstr=strcat('Saved file-',figstr);
disp(dispstr);
savestr1=strcat('Saved Plot to File-',figstr);
fprintf(fid,'%s\n',savestr1);
if((iCreatePDFReport==1) && (RptGenPresent==1))
    [ibreak]=strfind(GOESFileName,'_e');
    is=1;
    ie=ibreak(1)-1;
    GOESShortFileName=GOESFileName(is:ie);
    sectionstr=strcat('ABI-Radiance-',MapFormFactor,'-CumilDist-Band-',BandNumStr);
    add(chapter,Section(sectionstr));
    imdata = imread(figstr);
    [nhigh,nwid,ndepth]=size(imdata);
    image = mlreportgen.report.FormalImage();
    image.Image = which(figstr);% 
    pdftxtstr=strcat('ABI-Radiance-Data-For File-',GOESShortFileName);
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
% Add text for this image
    parastr41='The cumilitative distribution chart shown above details how the radiance values are distributed.';
    parastr42=strcat('The median Radiance value was-',num2str(ptile50ht,5),'-in-',measunits,'.');
    parastr49=strcat(parastr41,parastr42);
    p4 = Paragraph(parastr49);
    p4.Style = {OuterMargin("0pt", "0pt","10pt","10pt")};
    add(chapter,p4);
    add(rpt,chapter);
end
fprintf(fid,'%s\n','-----Finished Radiance Cumiliative Radiance Distribution Plot-----');
end

