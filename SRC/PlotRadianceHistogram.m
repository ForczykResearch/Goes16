function PlotRadianceHistogram(titlestr,itype,bandnum)
% This routine will plot a histogram of the Randiance
% values
% Written By: Stephen Forczyk
% Created: Dec 23,2020
% Revised: Mar 22,2021 add pdf report capability
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

fprintf(fid,'%s\n','-----Create Radiance Histogram Plot-----');
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
% Now plot the histogram of the Radiance data
Radiance=RadS.values;
measunits=RadS.units;
[nrows,ncols]=size(Radiance);
Radiance1D=reshape(Radiance,nrows*ncols,1);
movie_figure1=figure('position',[hor1 vert1 widd lend]);
set(gcf,'MenuBar','none');
set(gca,'Position',[.16 .18  .70 .70]);
rmin=floor(min(Radiance1D,[],'omitnan'));
rmax=ceil(max(Radiance1D));
edges=linspace(rmin,rmax,201);
h=histogram(Radiance1D,edges,'Normalization','probability','FaceColor','b');
xlabel('Radiance','FontWeight','bold');
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
txtstr2=strcat('BandNum-',BandNumStr,'-Resolution-km-',ResolutionStr,...
    '-BandCenter-microns-',WaveLenStr,'-Spectral Region-',SpectrumStr,'-WaveBand Desc-',...
    BandDescStr);
txt2=text(tx2,ty2,txtstr2,'FontWeight','bold','FontSize',8);
set(newaxesh,'Visible','Off');
pause(chart_time);
% Save this chart
figstr=strcat('Radiance-','Y',num2str(YearS),'D',...
    num2str(DayS),'H',num2str(HourS),'M',num2str(MinuteS),'S',num2str(round(SecondS)),...
    '.jpg');
eval(['cd ' jpegpath(1:length(jpegpath)-1)]);
actionstr='print';
typestr='-djpeg';
[cmdString]=MyStrcat2(actionstr,typestr,figstr);
eval(cmdString);
JpegCounter=JpegCounter+1;
JpegFileList{JpegCounter+1,1}=figstr;
JpegFileList{JpegCounter+1,2}=jpegpath;
close('all');
dispstr=strcat('Saved Radiance Histogram Plot To file-',figstr);
disp(dispstr);
if((iCreatePDFReport==1) && (RptGenPresent==1))
    [ibreak]=strfind(GOESFileName,'_e');
    is=1;
    ie=ibreak(1)-1;
    GOESShortFileName=GOESFileName(is:ie);
    sectionstr=strcat('ABI-Radiance-',MapFormFactor,'-Histogram-Band-',BandNumStr);
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
    parastr31='The histogram chart shown above details how the radiance values are distributed.';
    parastr32=strcat('Radiance values ranged from-',num2str(rmin,5),'-to-',num2str(rmax,5),'-',measunits,'.');
    parastr39=strcat(parastr31,parastr32);
    p3 = Paragraph(parastr39);
    p3.Style = {OuterMargin("0pt", "0pt","10pt","10pt")};
    add(chapter,p3);
end
fprintf(fid,'%s\n','-----Finished Radiance Histogram Plot-----');
fprintf(fid,'%s\n',dispstr);
end

