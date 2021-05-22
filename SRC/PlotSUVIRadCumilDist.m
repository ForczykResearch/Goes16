function PlotSUVIRadCumilDist(RAD1DSF,titlestr,iband)
% This routine will plot the cumilative SUVI Rad Metric
% Written By: Stephen Forczyk
% Created: May 11,2021
% Revised: -----------
% Classification: Unclassified

global BandDataS MetaDataS;
global RADS DQFS;
global IMSENUMBS CRPIX1S CRPIX2S CDELT1S CDELT2S;
global CUNIT1S CUNIT2S DSUNS ORIENTS CROTAS;
global SOLAR_B0S PC1_1S PC1_2S PC2_1S PC2_2S;
global CSYER1S CSYER2S WCS_NAMES CTYPE1S CTYPE2S;
global CRVAL1S CRVAL2S LONPOLES TIMESYSS;
global DATE_OBSS DATE_ENDS CMD_EXPS EXPTIMES;
global OBSGEO_XS OBSGEO_YS OBSGEO_ZS DSUN_OBSS;
global OBJECTS SCI_OBJS WAVEUNITS WAVELNTHS;
global IMG_MINS IMG_MAXS FILTER1S FILTER2S;
global GOOD_PIXS FIX_PIXS SAT_PIXS MISS_PIXS;
global IMGTIIS IMG_SDEVS EFF_AREAS APSELPOSS INSTRESPS;
global PHOT_ENGS RSUNS HGLT_OBSS HGLN_OBSS;
global HEEX_OBSS HEEY_OBSS HEEZ_OBSS;
global FILTPOS1S FILTPOS2S YAW_FLIPS CCD_READS ECLIPSES;
global CONTAMINS CONT_FLGS DATE_BKES DER_SNRS SAT_THRS;
global CCD_BIASS CCD_TMP1S CCD_TMP2S;
global DATE_DFMS NDFRAMESS DATE_DF0S DATE_DF1S DATE_DF2S;
global DATE_DF3S DATE_DF4S DATE_DF5S DATE_DF6S;
global DATE_DF7S DATE_DF8S DATE_DF9S;
global SOLCURR1S SOLCURR2S SOLCURR3S SOLCURR4S PCTL0ERRS;
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
fprintf(fid,'%s\n','-----Create SUVI Rad Cumilative Distribution Plot-----');
% Get the scan start date and time data based on the file name
[YearS,DayS,HourS,MinuteS,SecondS] = GetGOESDateTimeString(GOESFileName,1);
result = is_leap_year(YearS);
if(result==0)
    MonthDayStr=char(DayMonthNonLeapYear{DayS,1});
else
    MonthDayStr=char(DayMonthLeapYear{DayS,1});
end
MonthDayYearStr=strcat(MonthDayStr,'-',num2str(YearS));
if(iband==1)
    bandstr='Fe093';
    KeyFeature='Filament';
    waveband=93.9;
elseif(iband==2)
    bandstr='Fe131';
    KeyFeature='Flare Location';
    waveband=131.2;
elseif(iband==3)
    bandstr='Fe171';
    KeyFeature='Coronal Mass Ejection';
    waveband=171.1;
elseif(iband==4)
    bandstr='Fe195';
    KeyFeature='Coronal Mass Ejection';
    waveband=195.1;
elseif(iband==5)
    bandstr='Fe284';
    KeyFeature='Coronal Hole';
    waveband=284.2;
elseif(iband==6)
    bandstr='He303';
    KeyFeature='Filament';
    waveband=303.8;
end
numvals=length(RAD1DSF);
maxRad=max(RAD1DSF);
RadCumil=zeros(numvals,1);
for n=1:numvals
   RadCumil(n,1)=RAD1DSF(n,1); 
end
% Now create an x array that runs from 0 to 100 p tile
xp=0:1:100;
xp=xp';
ypi=zeros(101,1);
ypi(1)=0;
ypi(101)=RadCumil(numvals,1);
for n=2:100
    ptile=(n-1)/100;
    ptileind=round(ptile*numvals);
    ypi(n,1)=RadCumil(ptileind,1);
end
ptile25ht=ypi(26,1);
ptile50ht=ypi(51,1);
ptile75ht=ypi(76,1);
ptile100ht=ypi(101,1);
htstr1=strcat('SUVI Rad 25 Ptile =',num2str(ptile25ht,6),'-W/m^2/sr');
htstr2=strcat('SUVI Rad 50 Ptile Temp=',num2str(ptile50ht,6),'-W/m^2/sr');
htstr3=strcat('SUVI Rad 75 Ptile Temp=',num2str(ptile75ht,6),'-W/m^2/sr');
htstr4=strcat('SUVI Rad 100 Ptile Height=',num2str(ptile100ht,6),'-W/m^2/sr');
fprintf(fid,'%s\n',htstr1);
fprintf(fid,'%s\n',htstr2);
fprintf(fid,'%s\n',htstr3);
fprintf(fid,'%s\n',htstr4);
% Now create a line plot of the cumilative distrivution
movie_figure1=figure('position',[hor1 vert1 widd lend]);
set(gcf,'MenuBar','none');
set(gca,'Position',[.16 .18  .70 .70]);
h=plot(xp,ypi,'g');
%set(h,'FaceColor','b');
xlabel('Percentile','FontWeight','bold');
ylabel('SUVI Rad-W/m^2/sr','FontWeight','bold');
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
tx2=tx1;
ty2=.07;
txtstr2=strcat('RAD 25 ptile-',num2str(ptile25ht,6),'-RAD-50 ptile-',num2str(ptile25ht,6),...
    '-RAD 75 ptile-',num2str(ptile75ht,6),'-RAD-100 ptile-',num2str(ptile100ht,6),...
    '-waveband-',num2str(waveband,5),'-Angstroms');
txt2=text(tx2,ty2,txtstr2,'FontWeight','bold','FontSize',8);
set(newaxesh,'Visible','Off');
pause(chart_time);
% Save this chart
figstr=strcat('SUVI-RAD-Band-',num2str(iband),'-CumDist-','Y',num2str(YearS),'D',...
    num2str(DayS),'H',num2str(HourS),'M',num2str(MinuteS),'S',num2str(round(SecondS)),...
    '.jpg');
eval(['cd ' jpegpath(1:length(jpegpath)-1)]);
actionstr='print';
typestr='-djpeg';
[cmdString]=MyStrcat2(actionstr,typestr,figstr);
eval(cmdString);
close('all');
if((iCreatePDFReport==1) && (RptGenPresent==1))
    [ibreak]=strfind(GOESFileName,'_e');
    is=1;
    ie=ibreak(1)-1;
    GOESShortFileName=GOESFileName(is:ie);
    add(chapter,Section('Cumil Distribution Of SUVI Rad'));
    imdata = imread(figstr);
    [nhigh,nwid,ndepth]=size(imdata);
    image = mlreportgen.report.FormalImage();
    image.Image = which(figstr);
    pdftxtstr=strcat('SUVI RAD CumilDist For File-',GOESShortFileName);
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
    parastr1='This chart provides a Cumilative plot of the SUVI RADin W/m^2/sr.';
    parastr2=' The first line below the plot provides details of when the scan was taken.';
    parastr3=' The last line a few details on the distribution of the SUVI RAD measurement.';
    parastr4=strcat('Median SUVI RAD is=',num2str(ptile50ht,5),'-W/m^2/sr.');
    parastr=strcat(parastr1,parastr2,parastr3,parastr4);
    p1 = Paragraph(parastr);
    p1.Style = {OuterMargin("0pt", "0pt","10pt","10pt")};
    add(chapter,p1);
    add(rpt,chapter)
end
JpegCounter=JpegCounter+1;
JpegFileList{JpegCounter+1,1}=figstr;
JpegFileList{JpegCounter+1,2}=jpegpath;
dispstr=strcat('Saved file-',figstr);
disp(dispstr);
fprintf(fid,'%s\n','-----Finished SUVI RAD Cumilative Distirubution Plot-----');
end

