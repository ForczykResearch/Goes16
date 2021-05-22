function PlotLightningFlashAreaHistogram(titlestr)
% This routine will plot a histogram of the Lightning Flash Area values
% in units of sq km
% Written By: Stephen Forczyk
% Created: Mar 20,2021
% Revised: ------------
% Classification: Unclassified

global BandDataS MetaDataS;
global SatDataS GoesLatLonProjS;
global AlgoS GoesWaveBand; 
global GOESFileName;
global NumFlashes NumGroups NumEvents;
global Algo2S AlgoProductTS Error1S ;
global EventIDS EventTimeS EventLocS EventEnergyS;
global GroupIDS GQFS FlashDataS FlashData2S FlashQFS;
global FlashFrTimeOffsetFES FlashFrTimeOffsetLES;
global FlashStartTimes FlashEndTimes;
global FlashMinEnergy FlashMaxEnergy FlashMinDuration FlashMaxDuration;
global GroupFrameTimeOffsetS GroupLatS GroupLonS;
global GroupAreaS GroupEnergyS GroupParentFlashIDS;
global EventCountS GroupCountS FlashCountS;
global GroupArea GroupEnergy FlashArea GroupPixels FlashPixels;
global ProductTimeS LightningWaveS NavL1bS YawFlipFlagS LonFOVS LatFOVS;
global ProcessParamVersionContainerS;
global westEdge eastEdge northEdge southEdge;
global isavefiles;
global FlashEnergy FlashDuration FlashLats FlashLons;
global idebug ;
global MonthDayStr MonthDayYearStr;
global DayMonthNonLeapYear DayMonthLeapYear CalendarFileName;
global RptGenPresent iCreatePDFReport pdffilename rpt chapter;


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
fprintf(fid,'%s\n','-----Create Lightning Flash Area Histogram Plot-----');
% Get the scan start date and time data based on the file name
[YearS,DayS,HourS,MinuteS,SecondS] = GetGOESDateTimeString(GOESFileName,1);
result = is_leap_year(YearS);
if(result==0)
    MonthDayStr=char(DayMonthNonLeapYear{DayS,1});
else
    MonthDayStr=char(DayMonthLeapYear{DayS,1});
end
MonthDayYearStr=strcat(MonthDayStr,'-',num2str(YearS));
[nrows,ncols]=size(FlashArea);
totalpix=nrows*ncols;
FlashAreaSort=sort(FlashArea)/1E6;% conver to sq km
numvals=totalpix;
maxFlashArea=max(FlashAreaSort);
minFlashArea=min(FlashAreaSort);
minPixels=ceil(minFlashArea/1E2);
maxPixels=ceil(maxFlashArea/1E2);
val01=FlashAreaSort(round(.01*numvals),1);
val50=FlashAreaSort(round(.50*numvals),1);
val99=FlashAreaSort(round(.99*numvals),1);
flashstr1=strcat('The 1 ptile flash area was=',num2str(val01,5),'-sqKm');
fprintf(fid,'%s\n',flashstr1);
flashstr2=strcat('The 50 ptile flash area was=',num2str(val50,5),'-sqKm');
fprintf(fid,'%s\n',flashstr2);
flashstr3=strcat('The 99 ptile flash area was=',num2str(val99,5),'-sqKm');
fprintf(fid,'%s\n',flashstr3);
% Now plot the histogram of the Flash Energies
movie_figure1=figure('position',[hor1 vert1 widd lend]);
set(gcf,'MenuBar','none');
set(gca,'Position',[.16 .18  .70 .70]);
h=histogram(FlashAreaSort,20);
h.FaceColor = [1 0 0];
h.EdgeColor = 'r';
%set(h,'FaceColor','g');
xlabel('Area-sqKm','FontWeight','bold');
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
txt1=text(tx1,ty1,txtstr1,'FontWeight','bold','FontSize',12);
tx2=.18;
ty2=.06;
txtstr2=strcat('Total Pixels=',num2str(totalpix),'-number of Energy estimates=',num2str(numvals));
txt2=text(tx2,ty2,txtstr2,'FontWeight','bold','FontSize',12);
set(newaxesh,'Visible','Off');
pause(chart_time);
% Save this chart
figstr=strcat('LightningAreaHistogram-','Y',num2str(YearS),'D',...
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
    add(chapter,Section('Lightning Flash Area Histogram'));
    imdata = imread(figstr);
    [nhigh,nwid,ndepth]=size(imdata);
    image = mlreportgen.report.FormalImage();
    image.Image = which(figstr);
    pdftxtstr=strcat('Lightning Flash Area Data Found On File-',GOESShortFileName);
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
    parastr101=strcat('The Data for this chart was from file-',GOESFileName,'-and shows the histogram of the lightning flash area values.');
    parastr102='Note that this area is in sq km-the pixel subtense on the area is approximately 100 sqKm.';
    parastr103=strcat('Using this approximate pixel area the smallest flash covered-',num2str(minPixels),'pixels.',...
        'The largest flash extended over-',num2str(maxPixels),'pixels.');
    parastr109=strcat(parastr101,parastr102,parastr103);
    p10 = Paragraph(parastr109);
    p10.Style = {OuterMargin("0pt", "0pt","0pt","10pt")};
    add(chapter,p10);
    add(rpt,chapter);
end
close('all');
dispstr=strcat('Saved file-',figstr);
disp(dispstr);
savestr1=strcat('Saved Plot to File-',figstr);
fprintf(fid,'%s\n',savestr1);
fprintf(fid,'%s\n','-----Finished Lightning Flash Area Histogram Plot-----');
fprintf(fid,'\n');
end

