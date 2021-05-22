function PlotSIStabilityCumilDist(ValidSI,sgoodfrac,titlestr)
% This routine will plot the cumilative distribution of the Showalter Stability Index
% estimates
% Written By: Stephen Forczyk
% Created: Feb 20,2021
% Revised: Feb 21,2021 added stability array computation and polygon
% to final plot to show unstable area
% Classification: Unclassified

global MetaDataS;
global LIS CAPES TTS SIS KIS;
global FAPS;
global DQF_OverallS DQF_RetrievalS DQF_SkinTempS;
global TotAttRetS;
global CAPEOutlierPixelS LIOutlierPixelS KIOutlierPixelS;
global ShowOutlierPixelS TTIOutlierPixelS;
global CAPEStatS LIStatS TTStatS ShowStatS KIStatS;
global tS yS xS tBS goesImagerS yImgS yImgBS;
global xImgS xImgBS SatDataS GeoSpatialS;
global AlgoS GoesWaveBand;
global TPWRS TRVS TotPixRS RROutPixCountS RainRateS;
global AlgoProdVersionContainerS ProcessParamS;
global QLZAS  QLZABS;
global SZAS SZABS;
global RLZAS  RLZABS;
global LatitudeS LatitudeBoundsS;
global SoundingWaveS SoundingWaveIDS;
global TotAttempRetS;
global MeanDiffSoundingBandS StdevDiffSoundingBandS;
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
global LIStability CAPEStability TTStability SIStability KIStability;
global fracUnstableLI fracUnstableCAPE fracUnstableTT fracUnstableSI fracUnstableKI;

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
fprintf(fid,'%s\n','-----Create Showalter Stability Index Cumilative Distribution Plot-----');
% Get the scan start date and time data based on the file name
[YearS,DayS,HourS,MinuteS,SecondS] = GetGOESDateTimeString(GOESFileName,1);
result = is_leap_year(YearS);
if(result==0)
    MonthDayStr=char(DayMonthNonLeapYear{DayS,1});
else
    MonthDayStr=char(DayMonthLeapYear{DayS,1});
end
MonthDayYearStr=strcat(MonthDayStr,'-',num2str(YearS));
numvals=length(ValidSI);
val01=ValidSI(round(.01*numvals),1);
val50=ValidSI(round(.50*numvals),1);
val99=ValidSI(round(.99*numvals),1);
SICumil=ValidSI;
% Create a stability array
SI=SIS.values;
SI=SI';
[nrows,ncols]=size(SI);
SIStability=zeros(nrows,ncols);
numnan=0;
for ii=1:nrows
    for jj=1:ncols
        val=SI(ii,jj);
        a1=isnan(val);
        if(a1==1)
            val=0;
            numnan=numnan+1;
        end
        if((val<=-10) && (val>=4))
            val=0;
        elseif((val>-10) && (val<=-3))
            val=1;
        else
            val=0;
        end
        SIStability(ii,jj)=val;
    end
end
[iunstable]=find((ValidSI>-10) & (ValidSI<-3));
a1=isempty(iunstable);
if(a1~=1)
    numunstable=length(iunstable);
    nvalid=length(ValidSI);
    fracunstable=numunstable/nvalid;
else
    fracunstable=0;
end
fracUnstableSI=fracunstable;
% Now create an x array that runs from 0 to 100 p tile
xp=0:1:100;
xp=xp';
ypi=zeros(101,1);
ypi(1)=val01-mod(val01,10);
ypi(101)=SICumil(numvals,1);
for n=2:100
    ptile=(n-1)/100;
    ptileind=round(ptile*numvals);
    ypi(n,1)=SICumil(ptileind,1);
end
ptile05ht=ypi(6,1);
ptile25ht=ypi(26,1);
ptile50ht=ypi(51,1);
ptile75ht=ypi(76,1);
ptile100ht=ypi(101,1);
htstr1=strcat('SI 25 Ptile=',num2str(ptile25ht,6),'-Deg-C');
htstr2=strcat('SI 50 Ptile=',num2str(ptile50ht,6),'-Deg-C');
htstr3=strcat('SI 75 Ptile=',num2str(ptile75ht,6),'-Deg-C');
htstr4=strcat('SI 100 Ptile=',num2str(ptile100ht,6),'-Deg-C');
htstr5=strcat('The fraction of unstable SI values is=',num2str(fracunstable,6));
fprintf(fid,'%s\n',htstr1);
fprintf(fid,'%s\n',htstr2);
fprintf(fid,'%s\n',htstr3);
fprintf(fid,'%s\n',htstr4);
fprintf(fid,'%s\n',htstr5);
% Now create a line plot of the cumilative distribution
movie_figure1=figure('position',[hor1 vert1 widd lend]);
set(gcf,'MenuBar','none');
set(gca,'Position',[.16 .18  .70 .70]);
h=plot(xp,ypi,'g');
xlabel('Percentile','FontWeight','bold');
ylabelstr='SI-Deg-C';
ylabel(ylabelstr,'FontWeight','bold');
set(gca,'FontWeight','bold');
set(gca,'XGrid','On','YGrid','On');
ht=title(titlestr);
set(ht,'FontWeight','bold');
hold on
v1 = [1 -10; 99 -10; 99 -3.0; 1 -3.0];
f1 = [1 2 3 4];
patch('Faces',f1,'Vertices',v1,'FaceColor','red','FaceAlpha',.3);
hold off
tx0=40;
ty0=-3.2;
txt0=text(tx0,ty0,'Unstable Region','FontWeight','bold','FontSize',10);
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
txtstr2=strcat('SI 25ptile=',num2str(ptile25ht,6),'-SI 50ptile=',num2str(ptile50ht,6),...
    '-SI 75ptile=',num2str(ptile75ht,6),'-SI 100 ptile=',num2str(ptile100ht,6),'-all in Deg-C',...
    '-fraction of unstable pixels=',num2str(fracunstable,6));
txt2=text(tx2,ty2,txtstr2,'FontWeight','bold','FontSize',8);
set(newaxesh,'Visible','Off');
pause(chart_time);
% Save this chart
figstr=strcat('SICumilDist-','Y',num2str(YearS),'D',...
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
    imdata = imread(figstr);
    [nhigh,nwid,ndepth]=size(imdata);
    image = mlreportgen.report.FormalImage();
    image.Image = which(figstr);
    pdftxtstr=strcat('SI Index Data For File-',GOESShortFileName);
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
    br = PageBreak();
    add(chapter,br);
    parastr141=strcat('The SI Stability Index Data for this chart was taken from file-',GOESShortFileName,'.');
    parastr142='This chart shows the cumilative distribution of all valid SI Stability Index estimates.';
    parastr143=strcat('The median value for the SI is-',num2str(ptile50ht,6),'.');
    parastr144=strcat('The red box shows the unstable region.','The fraction of pixels in the unstable region is=',num2str(fracunstable,6),'.');
    if(ptile05ht>-3)
        parastr145=strcat('Since the 5th percentile value-',num2str(ptile05ht,5),'-exceeds a value of -3 the current scene is quite stable.');
    else
        parastr145=strcat('Since the 5th percentile value-',num2str(ptile05ht,5),'-is less than a value of -3 the current scene shows significant instability.');
    end
    parastr149=strcat(parastr141,parastr142,parastr143,parastr144,parastr145);
    p14 = Paragraph(parastr149);
    p14.Style = {OuterMargin("0pt", "0pt","0pt","10pt")};
    add(chapter,p14);
%    add(rpt,chapter);
    close('all');
    dispstr=strcat('Saved file-',figstr);
    disp(dispstr);
    savestr1=strcat('Saved Plot to File-',figstr);
    fprintf(fid,'%s\n',savestr1);
    fprintf(fid,'%s\n','-----Finished Showalter Stability Index Cumilative Distribution Plot-----');
    fprintf(fid,'\n');
end

