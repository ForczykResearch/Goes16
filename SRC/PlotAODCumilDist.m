function PlotAODCumilDist(ValidAOD,sgoodfrac,titlestr)
% This routine will plot the cumilative distribution of the AOD
% or Aerosol Optical Depth estimates
% Written By: Stephen Forczyk
% Created: Feb 15,2021
% Revised: ------
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
fprintf(fid,'%s\n','-----Create AOD Cumilative Distribution Plot-----');
% Get the scan start date and time data based on the file name
[YearS,DayS,HourS,MinuteS,SecondS] = GetGOESDateTimeString(GOESFileName,1);
result = is_leap_year(YearS);
if(result==0)
    MonthDayStr=char(DayMonthNonLeapYear{DayS,1});
else
    MonthDayStr=char(DayMonthLeapYear{DayS,1});
end
MonthDayYearStr=strcat(MonthDayStr,'-',num2str(YearS));

numvals=length(ValidAOD);
val01=ValidAOD(round(.01*numvals),1);
val50=ValidAOD(round(.50*numvals),1);
val99=ValidAOD(round(.99*numvals),1);

AODCumil=ValidAOD;
% Now create an x array that runs from 0 to 100 p tile
xp=0:1:100;
xp=xp';
ypi=zeros(101,1);
ypi(1)=val01-mod(val01,10);
ypi(101)=AODCumil(numvals,1);
for n=2:100
    ptile=(n-1)/100;
    ptileind=round(ptile*numvals);
    ypi(n,1)=AODCumil(ptileind,1);
end
ptile25ht=ypi(26,1);
ptile50ht=ypi(51,1);
ptile75ht=ypi(76,1);
ptile100ht=ypi(101,1);
htstr1=strcat('AOD 25 Ptile=',num2str(ptile25ht,6));
htstr2=strcat('AOD 50 Ptile=',num2str(ptile50ht,6));
htstr3=strcat('AOD 75 Ptile=',num2str(ptile75ht,6));
htstr4=strcat('AOD 100 Ptile=',num2str(ptile100ht,6));
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
ylabelstr='AOD-';
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
txtstr2=strcat('AOD 25ptile=',num2str(ptile25ht,6),'-AOD 50ptile=',num2str(ptile50ht,6),...
    '-AOD 75ptile=',num2str(ptile75ht,6),'-AOD 100 ptile=',num2str(ptile100ht,6),'-all in mm');
txt2=text(tx2,ty2,txtstr2,'FontWeight','bold','FontSize',8);
set(newaxesh,'Visible','Off');
pause(chart_time);
% Save this chart
figstr=strcat('AODCumilDist-','Y',num2str(YearS),'D',...
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
if((iCreatePDFReport==1) && (RptGenPresent==1))
    [ibreak]=strfind(GOESFileName,'_e');
    is=1;
    ie=ibreak(1)-1;
    GOESShortFileName=GOESFileName(is:ie);
    br = PageBreak();
    add(chapter,br);
    add(chapter,Section('AOD Cumil Distribution'));
    imdata = imread(figstr);
    [nhigh,nwid,ndepth]=size(imdata);
    image = mlreportgen.report.FormalImage();
    image.Image = which(figstr);
    pdftxtstr=strcat('AOD Data For File-',GOESShortFileName);
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
% Now add some text 
    parastr81=strcat('The Data for this chart was taken from file-',GOESShortFileName,'.');
    parastr82='This chart shows the cumilative distribution of all valid AOD estimates.';
    parastr83=strcat('The median value for the AOD is-',num2str(ptile50ht,6),'-this includes land and sea based pixels values lumped together.');
    parastr89=strcat(parastr81,parastr82,parastr83);
    p8 = Paragraph(parastr89);
    p8.Style = {OuterMargin("0pt", "0pt","0pt","10pt")};
    add(chapter,p8);
    add(rpt,chapter);
    close('all');
    dispstr=strcat('Saved file-',figstr);
    disp(dispstr);
    savestr1=strcat('Saved Plot to File-',figstr);
    fprintf(fid,'%s\n',savestr1);
    fprintf(fid,'%s\n','-----Finished AOD Cumilative Distribution Plot-----');
    fprintf(fid,'\n');
end

