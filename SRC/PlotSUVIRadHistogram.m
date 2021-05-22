function [RAD1DSF]=PlotSUVIRadHistogram(titlestr,iband)
% This routine will plot a histogram of the RAD values for one of
% the 6 available UV bands
% Written By: Stephen Forczyk
% Created: May 11,2021
% Revised: -----
% Revised: 
% 
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
fprintf(fid,'%s\n','-----Create SUVI Rad Histogram Plot-----');
% Get the scan start date and time data based on the file name
[YearS,DayS,HourS,MinuteS,SecondS] = GetGOESDateTimeString(GOESFileName,1);
result = is_leap_year(YearS);
if(result==0)
    MonthDayStr=char(DayMonthNonLeapYear{DayS,1});
else
    MonthDayStr=char(DayMonthLeapYear{DayS,1});
end
MonthDayYearStr=strcat(MonthDayStr,'-',num2str(YearS));
% Now plot the histogram of the SUVI RAD data
RAD=RADS.values;
measunits=RADS.units;
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
[nrows,ncols]=size(RAD);
RAD1D=reshape(RAD,nrows*ncols,1);
RAD1DS=sort(RAD1D);
a1=isnan(RAD1DS);
numnan=sum(a1);
numall=nrows*ncols;
numgood=numall-numnan;
goodfrac=numgood/numall;
goodpct=100*goodfrac;
RAD1DSF=zeros(numgood,1);
for k=1:numgood
    RAD1DSF(k,1)=RAD1DS(k,1);
end
num01=round(.01*numgood);
num99=round(.99*numgood);
val01=RAD1DSF(num01,1);
val99=RAD1DSF(num99,1);
minval2=RAD1DSF(1,1);
maxval2=RAD1DSF(numgood,1);
minval=floor(minval2);
maxval=ceil(minval2);
movie_figure1=figure('position',[hor1 vert1 widd lend]);
set(gcf,'MenuBar','none');
set(gca,'Position',[.16 .18  .70 .70]);
nbins=200;
edges=[ -1.0 -.5:.005:.5 1]; 
h=histogram(RAD1DSF,edges,'FaceColor','b');
%h=histogram(RAD1DSF,nbins,'FaceColor','b');
xlabel('SUVI-RAD W/m^2/sr','FontWeight','bold');
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
tx2=tx1;
ty2=ty1-.04;
txtstr2=strcat('SUVI-RAD-',num2str(waveband,5),'-1 ptile value=',num2str(val01,5),'-99 ptile value=',num2str(val99,5),...
    '-waveband-',num2str(waveband,5),'-Angstroms');
txt2=text(tx2,ty2,txtstr2,'FontWeight','bold','FontSize',8);
set(newaxesh,'Visible','Off');
pause(chart_time);
% Save this chart
figstr=strcat('SUVI-Rad-Dist-OR-ABI-L2-CMIPC-','Y',num2str(YearS),'D',...
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
    add(chapter,Section('Histogram of SUVI Rad'));
    imdata = imread(figstr);
    [nhigh,nwid,ndepth]=size(imdata);
    image = mlreportgen.report.FormalImage();
    image.Image = which(figstr);
    pdftxtstr=strcat('SUVI Rad For File-',GOESShortFileName);
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
    parastr1='This chart provides a Histogram plot of the SUVI Rad values.';
    parastr2=' The first line below the plot provides details of when the scan was taken.';
    parastr3=strcat('This data is for-',bandstr,'-which is at-',num2str(waveband,5),'-Angstroms.');
    parastr4=strcat('A histogram of the data shows that the data ranges from a 1 ptile value=',num2str(val01,5),...
        '-to a 99 ptile value of-',num2str(val99,5),'-W/m^2/sr.');
    parastr=strcat(parastr1,parastr2,parastr3,parastr4);
    p1 = Paragraph(parastr);
    p1.Style = {OuterMargin("0pt", "0pt","10pt","10pt")};
    add(chapter,p1);
%    add(rpt,chapter);
end
JpegCounter=JpegCounter+1;
JpegFileList{JpegCounter+1,1}=figstr;
JpegFileList{JpegCounter+1,2}=jpegpath;
close('all');
dispstr=strcat('Saved file-',figstr);
disp(dispstr);
fprintf(fid,'%s\n','-----Finished SUVI Rad Histogram Plot-----');
end

