function  CreateAshParticleSizePieChart(AshFractions,DQFLabels,sumvalidfrac,titlestr)
% This function will show the calculated ash particle sizes
% Written By: Stephen Forczyk
% Created: March 3,2021
% Revised:------
% Classification: Unclassified
global MetaDataS;
global VAHS VAMLS ;
global AshMassLoadTotMassS CountAttAshRetS;
global AshHtOutlierPixCountS AshMassOutlierPixCountS;
global AshCloudHtStatS AshMassStatS AshExistConfAngS;
global DET_DQFS RET_DQFS;
global tS yS xS tBS goesImagerS;
global SatDataS GeoSpatialS;
global AlgoS GoesWaveBand;
global AlgoProdVersionContainerS ProcessParamS;
global QLZAS  QLZABS;
global RLZAS RLZABS;
global SZAS SZABS;
global GRBErrorsS L0ErrorsS;
global GOESFileName;
global RasterLats RasterLons;
global westEdge eastEdge northEdge southEdge;
global MonthDayStr MonthDayYearStr;
global DayMonthNonLeapYear DayMonthLeapYear CalendarFileName;
global NumProcFiles ProcFileList;
global RptGenPresent iCreatePDFReport pdffilename rpt chapter;
global JpegCounter JpegFileList;
global DQFHdr DQFTable MiscHdr MiscTable RqmtsHdr RqmtsTable;
global DQFCauses DQFNormed DQFLabels;
global DQFHdr2 DQFTable2 AshHdr AshSizeTable;
global widd2 lend2;
global initialtimestr igrid ijpeg ilog imovie;
global vert1 hor1 widd lend;
global vert2 hor2 machine;
global chart_time;
global Fz1 Fz2;
global idirector mov izoom iwindow;
global matpath GOES16path;
global jpegpath fid;
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
global GOES16CloudTopHeightpath GOES16BandPaths;
if((iCreatePDFReport==1) && (RptGenPresent==1))
    import mlreportgen.dom.*;
    import mlreportgen.report.*;
end
fprintf(fid,'\n');
fprintf(fid,'%s\n','-----Start plot routine CreateAshParticleSizePieChart-----');
% Get the scan start date and time data based on the file name
[YearS,DayS,HourS,MinuteS,SecondS] = GetGOESDateTimeString(GOESFileName,1);
result = is_leap_year(YearS);
if(result==0)
    MonthDayStr=char(DayMonthNonLeapYear{DayS,1});
else
    MonthDayStr=char(DayMonthLeapYear{DayS,1});
end
MonthDayYearStr=strcat(MonthDayStr,'-',num2str(YearS));
movie_figure1=figure('position',[hor1 vert1 widd lend]);
set(gcf,'MenuBar','none');
set(gca,'Position',[.16 .18  .70 .70]);
ph=pie(AshFractions);
[idash]=strfind(titlestr,'-');
is=idash(1);
ie=length(titlestr);
suffix=titlestr(is:ie);
titlestr2=RemoveUnderScores(strcat('Volcanic-',suffix));
ht=title(titlestr2);
numvals=length(ph);
numvals2=numvals/2;
cb=jet;
inc=floor(228/numvals);
for kk=1:2:numvals
    sector=ph(kk);
    nn=1+kk*inc;
    if(nn>228)
        nn=228;
    end
    cbn=[cb(nn,1) cb(nn,2) cb(nn,3)];
    sector.FaceColor=cbn;
    ab=2;
end
hl=legend(DQFLabels,'Location','eastoutside');
size11=RET_DQFS.percent_ash_particle_size_invalid_qf;
sizestr11=num2str(size11,6);
% Set up the axis for writing at the bottom of the chart
newaxesh=axes('Position',[0 0 1 1]);
set(newaxesh,'XLim',[0 1],'YLim',[0 1]);
tx1=.18;
ty1=.10;
txtstr1=strcat('Start Scan-Y',num2str(YearS),'-D-',num2str(DayS),'-H-',...
    num2str(HourS),'-M-',num2str(MinuteS),'-S-',num2str(SecondS),'-Date-',MonthDayYearStr);
txt1=text(tx1,ty1,txtstr1,'FontWeight','bold','FontSize',10);
tx2=.18;
ty2=.06;
txtstr2=strcat('Note that this particle distribution was for valid particles sizes only which were-',num2str(sumvalidfrac,6),...
    '-of all returned values');
txt2=text(tx2,ty2,txtstr2,'FontWeight','bold','FontSize',10);
set(newaxesh,'Visible','Off');
pause(chart_time);
% Save this chart
figstr=strcat(titlestr2,'.jpg');
eval(['cd ' jpegpath(1:length(jpegpath)-1)]);
actionstr='print';
typestr='-djpeg';
[cmdString]=MyStrcat2(actionstr,typestr,figstr);
eval(cmdString);
plotstr1=strcat('Saved Ash Cloud Sizes as-',figstr);
disp(plotstr1);
fprintf(fid,'%s\n',plotstr1);
pause(chart_time);
if((iCreatePDFReport==1) && (RptGenPresent==1))
    [ibreak]=strfind(GOESFileName,'_e');
    is=1;
    ie=ibreak(1)-1;
    GOESShortFileName=GOESFileName(is:ie);
    imdata = imread(figstr);
    [nhigh,nwid,ndepth]=size(imdata);
    image = mlreportgen.report.FormalImage();
    image.Image = which(figstr);
    pdftxtstr=strcat('Ash Cloud Particle Sizes-',GOESShortFileName);
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
    br = PageBreak();
    close('all');
    add(chapter,br);
    add(chapter,image);
% Add some descriptive text
    add(chapter,br);
    size11=RET_DQFS.percent_ash_particle_size_invalid_qf;
    sizestr11=num2str(size11,6);
    parastr51='The Pie chart above shows the distribution of ash particles by valid size.';
    parastr52=strcat('Note that the sum of the 10 valid particle sizes was-',num2str(sumvalidfrac,6),'-while the invalid sizes were-',num2str(size11,6),'.');
    if(sumvalidfrac>=.50)
        parastr53='Note that most of the ash cloud particle sizes were in the valid range.';
    else
        parastr53='Most of the particles sizes calculated were not in the valid range.';
    end
    parastr54='The values shown in the pie chart will not agree with the previous table because the valid size particle fractions were normed to 1 for plot purposes.';
    parastr59=strcat(parastr51,parastr52,parastr53,parastr54);
    p6 = Paragraph(parastr59);
    p6.Style = {OuterMargin("0pt", "0pt","10pt","10pt")};
    add(chapter,p6);

end
close('all');

fprintf(fid,'%s\n','-----Finish plot routine CreateCreateAshParticleSizePieChart-----');
fprintf(fid,'\n');
end

