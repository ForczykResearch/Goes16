function  [bigreasonval]=CreateDQF_LVT_PieChart(ilevel,titlestr)
% This function will show selected DQF_Overall values for the LVT Metric
% for a single level
% Written By: Stephen Forczyk
% Created: Mar 13,2021
% Revised: ---------
% highest cause have a red color
% Classification: Unclassified
global MetaDataS;
global LVTS PressureS PressureImgS PressureImgBS;
global DQF_OverallS DQF_RetrievalS DQF_SkinTempS;
global tS yS xS tBS goesImagerS yImgS yImgBS;
global xImgS xImgBS SatDataS GeoSpatialS;
global AlgoS GoesWaveBand;
global TPWRS TRVS TotPixRS RROutPixCountS RainRateS;
global AlgoProdVersionContainerS ProcessParamS;
global QLZAS  QLZABS;
global SZAS SZABS;
global RLZAS  RLZABS;
global OutlierPixelCountS PrecipWaterS;
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
global DQFHdr DQFTable MiscHdr MiscTable;
global DQFCauses DQFNormed DQFLabels DQFSortNormed DQFSortLabels;
global RasterLats RasterLons;
global PhPA rho zPress;

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
fprintf(fid,'%s\n','-----Start plot routine CreateDQF_LVT_PieChart-----');
movie_figure1=figure('position',[hor1 vert1 widd lend]);
set(gcf,'MenuBar','none');
set(gca,'Position',[.16 .18  .70 .70]);
numvals=length(DQFNormed);
DQFSortLabels=cell(1,numvals);
[DQFSortNormed,iX]=sort(DQFNormed,'ascend');
nowhold=0;
for jj=1:numvals
    ind=iX(jj,1);
    nowval=DQFSortNormed(jj,1);
    nowstr=char(DQFLabels{1,ind}); 
    if(nowval>nowhold)
        nowhold=nowval;
        bigreason=nowstr;
        bigreasonval=nowval;
    end
    DQFSortLabels{1,jj}=strcat(nowstr,'-',num2str(nowval,4),'%');
end
ph=pie(DQFSortNormed);
[idash]=strfind(titlestr,'-');
is=idash(1);
is1=1;
ie1=idash(1)-1;
prefix=titlestr(is1:ie1);
ie=length(titlestr);
suffix=titlestr(is:ie);
titlestr2=strcat('DQF-LVT-Invalid-Pixels',prefix,suffix);
ht=title(titlestr2);
numvals=length(ph);
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
end
hl=legend(DQFSortLabels,'Location','eastoutside');
pause(chart_time);
% Save this chart
figstr=strcat(titlestr2,'.jpg');
eval(['cd ' jpegpath(1:length(jpegpath)-1)]);
actionstr='print';
typestr='-djpeg';
[cmdString]=MyStrcat2(actionstr,typestr,figstr);
eval(cmdString);
plotstr1=strcat('Saved LVT DQF Plot as-',figstr);
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
    pdftxtstr=strcat('DQF Factors-',prefix,'-',GOESShortFileName);
    pdftext = Text(pdftxtstr);
    pdftext.Color = 'red';
    image.Caption = pdftext;
    nhighs=floor(nhigh/2.2);
    nwids=floor(nwid/2.2);
    heightstr=strcat(num2str(nhighs),'px');
    widthstr=strcat(num2str(nwids),'px');
    image.Height = heightstr;
    image.Width = widthstr;
    image.ScaleToFit=0;
    br = PageBreak();
    add(chapter,br);
    add(chapter,image);
end
close('all');
fprintf(fid,'%s\n','-----Finish plot routine CreateDQF_LVT_PieChart-----');
fprintf(fid,'\n');
end

