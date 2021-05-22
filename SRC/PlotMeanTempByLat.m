function PlotMeanTempByLat(MeanTempByLat,titlestr)
% This routine will plot the mean temperature by Latitude
% Written By: Stephen Forczyk
% Created: Jan 23,2021
% Revised: 
% Classification: Unclassified

global MetaDataS;
global DQFS tS yS xS tBS goesImagerS yImgS yImgBS;
global xImgS xImgBS SatDataS GeoSpatialS ;
global TQPixelsS NumDaySSTPixelsS NumNightSSTPixelsS NumTwilightSSTPixelsS;
global AlgoS GoesWaveBand;
global AlgoProdVersionContainerS ProcessParamS;
global RLZAS QLZAS RLZABS QLZABS;
global RSZAS TSZAS RSZABS TSZABS;
global DSZAS NSZAS TSZAS;
global DSZABS NSZABS ;
global SST_EBS;
global GRBErrorsS L0ErrorsS;
global SSTS SeaSurfOutlierPixelS SeaSurfTempS;
global SST_Night_Only_EBS Reynolds_SSTS;
global westEdge eastEdge northEdge southEdge;
global RptGenPresent iCreatePDFReport pdffilename rpt chapter;
global DayMonthNonLeapYear DayMonthLeapYear CalendarFileName;
global JpegCounter JpegFileList;
global GOESFileName;
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
fprintf(fid,'%s\n','-----Create The Mean Temp By Latitude Plot-----');
% Get the scan start date and time data based on the file name
[YearS,DayS,HourS,MinuteS,SecondS] = GetGOESDateTimeString(GOESFileName,1);
result = is_leap_year(YearS);
if(result==0)
    MonthDayStr=char(DayMonthNonLeapYear{DayS,1});
else
    MonthDayStr=char(DayMonthLeapYear{DayS,1});
end
MonthDayYearStr=strcat(MonthDayStr,'-',num2str(YearS));
xp=MeanTempByLat(:,1);
yp=MeanTempByLat(:,2);
minTemp=min(yp);
meanTemp=mean(yp);
maxTemp=max(yp);
maxTempDiff=maxTemp-minTemp;
% Find the latitudes closest to these temps
lat1ind=-1;
lat2ind=-1;
lat2ind=-1;
temp1miss=500;
temp2miss=500;
temp3miss=500;
numvals=length(xp);
for kk=1:numvals
    ntemp1miss=abs(yp(kk,1)-minTemp);
    ntemp2miss=abs(yp(kk,1)-meanTemp);
    ntemp3miss=abs(yp(kk,1)-maxTemp);
    if(ntemp1miss<temp1miss)
        lat1ind=kk;
        temp1miss=ntemp1miss;
    end
    if(ntemp2miss<temp2miss)
        lat2ind=kk;
        temp2miss=ntemp2miss;
    end
    if(ntemp3miss<temp3miss)
        lat3ind=kk;
        temp3miss=ntemp3miss;
    end    
end

lat1=xp(lat1ind,1);
lat2=xp(lat2ind,1);
lat3=xp(lat3ind,1);
ab=1;

tempstr1=strcat('Min Temp =',num2str(minTemp,6),'-Mean=',num2str(meanTemp,6),...
    '-Max=',num2str(maxTemp,6),'-Max Temp Diff=',num2str(maxTempDiff,6),'-all values in Deg-K');
tempstr2=strcat('The Latitude for Min Temp=',num2str(lat1,2),'-Mean Temp=',num2str(lat2,2),'-Mean Temp=',...
    num2str(lat3,2),'-In Degrees');
fprintf(fid,'%s\n',tempstr1);
fprintf(fid,'%s\n',tempstr1);
% Now create a line plot of the surface temps by latitude
movie_figure1=figure('position',[hor1 vert1 widd lend]);
set(gcf,'MenuBar','none');
set(gca,'Position',[.16 .18  .70 .70]);
plot(xp,yp,'r');
set(gca,'XLim',[-60 60],'YLim',[180 340]);
xlabel('Latitude-Deg','FontWeight','bold');
ylabel('Mean Surface Temp-Deg-K','FontWeight','bold');
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
% tx2=.18;
% ty2=.06;
% txtstr2=strcat('RGB Val 25ptile=',num2str(ptile25ht,6),'-RGB Val 50 ptile=',num2str(ptile50ht,6),...
%      '-RGB Val 75 ptile=',num2str(ptile75ht,6),'-RGB Val100 ptile=',num2str(ptile100ht,6));
% txt2=text(tx2,ty2,txtstr2,'FontWeight','bold','FontSize',8);
set(newaxesh,'Visible','Off');
pause(chart_time);
% Save this chart
% figstr=strcat('EarthSceneRGBCumDist-','Y',num2str(YearS),'D',...
%     num2str(DayS),'H',num2str(HourS),'M',num2str(MinuteS),'S',num2str(round(SecondS)),...
%     '.jpg');
figstr=strcat(titlestr,'.jpg');
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
    add(chapter,Section('Surface Temperatures By Latitude'));
    imdata = imread(figstr);
    [nhigh,nwid,ndepth]=size(imdata);
    image = mlreportgen.report.FormalImage();
    image.Image = which(figstr);
    pdftxtstr=strcat('Earth Surface Temps For File-',GOESShortFileName);
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
    parastr1='This chart provides a map of how the surface temperature varies by latitude.';
    parastr2='It can generally be antipated that the warmest temperatures would be found in equatorial regions.';
%     parastr3=' Unlike the Cloud Data,the True Color Image can see Cloud Tops or land with no cloud cover,';
%     parastr4=' therefore the user can see both clouds where they are present or the earth itself.';
%     parastr5=' The true color image uses 2 visible wavelength and one SWIR band to make up the true color image,';
%     parastr6=' because of this the RGB value will become at or near zero on the night side and this can be noted in the images.';
%     parastr7=strcat('In this image,the fraction of pixels viewing the night side of earth=',num2str(nightfrac,6));
    parastr=strcat(parastr1,parastr2);
    p1 = Paragraph(parastr);
    p1.Style = {OuterMargin("0pt", "0pt","50pt","10pt")};
    add(chapter,p1);
    add(rpt,chapter)
end
close('all');
JpegCounter=JpegCounter+1;
JpegFileList{JpegCounter+1,1}=figstr;
JpegFileList{JpegCounter+1,2}=jpegpath;
dispstr=strcat('Saved file-',figstr);
disp(dispstr);
fprintf(fid,'%s\n','-----Finished The Mean Temp By Latitude Plot-----');
fprintf(fid,'\n');
end

