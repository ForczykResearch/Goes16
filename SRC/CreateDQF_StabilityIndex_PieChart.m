function  CreateDQF_StabilityIndex_PieChart(titlestr)
% This function will show the causes of invalid pixels in
% calculating the Stability Index data
% Written By: Stephen Forczyk
% Created: Feb 18,2021
% Revised: -----
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
global GOESFileName;
global RptGenPresent iCreatePDFReport pdffilename rpt chapter;
global JpegCounter JpegFileList;
global DayMonthNonLeapYear DayMonthLeapYear CalendarFileName;
global DQFHdr DQFTable MiscHdr MiscTable;
global DQFCauses DQFNormed DQFLabels;
global RasterLats RasterLons;

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
fprintf(fid,'%s\n','-----Start plot routine CreateDQF_Stability Index_PieChart-----');
movie_figure1=figure('position',[hor1 vert1 widd lend]);
set(gcf,'MenuBar','none');
set(gca,'Position',[.16 .18  .70 .70]);
ph=pie(DQFNormed);
[idash]=strfind(titlestr,'-');
is=idash(1);
is1=1;
ie1=idash(1)-1;
prefix=titlestr(is1:ie1);
ie=length(titlestr);
suffix=titlestr(is:ie);
titlestr2=strcat('DQF-Stability-Index-Invalid-Pixels',prefix,suffix);
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
hl=legend(DQFLabels,'Location','eastoutside');
pause(chart_time);
% Save this chart
figstr=strcat(titlestr2,'.jpg');
eval(['cd ' jpegpath(1:length(jpegpath)-1)]);
actionstr='print';
typestr='-djpeg';
[cmdString]=MyStrcat2(actionstr,typestr,figstr);
eval(cmdString);
plotstr1=strcat('Saved DQF Stability Plot as-',figstr);
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
    nhighs=floor(nhigh/2.4);
    nwids=floor(nwid/2.4);
    heightstr=strcat(num2str(nhighs),'px');
    widthstr=strcat(num2str(nwids),'px');
    image.Height = heightstr;
    image.Width = widthstr;
    image.ScaleToFit=0;
    br = PageBreak();
    add(chapter,br);
    add(chapter,image);
    % Add text for this chart
    br = PageBreak();
    add(chapter,br);
    parastr61=strcat('The DQF table that was shown above is plotted as a pie chart to highlight the reasons why POOR values were returned for the stability indices.',...
        'Note these reasons apply to all 5 stability indices.');
    parastr62='Numerically these values differ from the numbers quoted in the DQF table which included good pixels-the values here were normalized to 1 for failed retrievals.';
    parastr63='The last 6 items in the DQF table refer to numerical calculation of the stability indices and typically are not a big contributor.';
    parastr64='In nearly all cases the biggest source of invalid values with be LHA angles over 67 degrees for CONUS and Full Disk views.';
    parastr65='Another much smaller cause is the lack of clear pixels in the 5x5 grid of pixels used calculate each value. At least 10 of 25 must be clear.';
    parastr69=strcat(parastr61,parastr62,parastr63,parastr64,parastr65);
    p6 = Paragraph(parastr69);
    p6.Style = {OuterMargin("0pt", "0pt","10pt","10pt")};
    add(chapter,p6);
end
close('all');
fprintf(fid,'%s\n','-----Finish plot routine CreateDQF_Stability Index_PieChart-----');
fprintf(fid,'\n');
end

