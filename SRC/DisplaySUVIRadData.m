function DisplaySUVIRadData(titlestr,iband)
% Display the SUVI (RAD) values
% for the SUN this will not be mapped onto the earth !
 
% Written By: Stephen Forczyk
% Created: May 06,2021
% Revised: May 11,2021 made changes to add more data to plot and text and
% PDF files
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
global GoesWaveBand MapFormFactor GOESFileName Algo2S;
global DQFHdr DQFTable MiscHdr MiscTable RqmtsHdr RqmtsTable;
global SolarFeatHdr SolarFeatTable SenHdr SenTable;
global CameraHdr CameraSettingsTable;
global RptGenPresent iCreatePDFReport pdffilename rpt chapter;
global JpegCounter JpegFileList;
global MonthDayStr MonthDayYearStr;
global DayMonthNonLeapYear DayMonthLeapYear CalendarFileName;
global westEdge eastEdge northEdge southEdge;


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
global trajpath militarypath gridpath;
global figpath screencapturepath;
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
fprintf(fid,'%s\n','------- Plot Solar SUVI Rad Data For The Solar Disk ------');

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
% Get some stats on the RAD Metric
[nrows,ncols]=size(RAD);
RAD1D=reshape(RAD,nrows*ncols,1);
RAD1DS=sort(RAD1D);
a1=isnan(RAD1D);
numnan=sum(a1);
maxRAD=max(RAD1D);
minRAD=min(RAD1D);
nvals=nrows*ncols-numnan;
num01=round(.01*nvals);
num25=round(.25*nvals);
num50=round(.50*nvals);
num75=round(.75*nvals);
num99=round(.99*nvals);
RAD01=RAD1DS(num01,1);
RAD25=RAD1DS(num25,1);
RAD50=RAD1DS(num50,1);
RAD75=RAD1DS(num75,1);
RAD99=RAD1DS(num99,1);
stats1str=strcat('The  minimum RAD value is-',num2str(minRAD,6),'-W/m^2');
stats2str=strcat('The  1 ptile RAD value is-',num2str(RAD01,6),'-W/m^2');
stats3str=strcat('The 25 ptile RAD value is-',num2str(RAD25,6),'-W/m^2');
stats4str=strcat('The 50 ptile RAD value is-',num2str(RAD50,6),'-W/m^2');
stats5str=strcat('The 75 ptile RAD value is-',num2str(RAD75,6),'-W/m^2');
stats6str=strcat('The 99 ptile RAD value is-',num2str(RAD99,6),'-W/m^2');
stats7str=strcat('The  maximum RAD value is-',num2str(maxRAD,6),'-W/m^2');
fprintf(fid,'%s\n','***** RAD Stats Follow *****');
fprintf(fid,'%s\n',stats1str);
fprintf(fid,'%s\n',stats2str);
fprintf(fid,'%s\n',stats3str);
fprintf(fid,'%s\n',stats4str);
fprintf(fid,'%s\n',stats5str);
fprintf(fid,'%s\n',stats6str);
fprintf(fid,'%s\n',stats7str);
[ilow]=find(RAD1DS<0);
a1=isempty(ilow);
if(a1==1)
    numlow=0;
else
    numlow=length(ilow);
end
pctlow=100*numlow/nvals;
stats8str=strcat('Number of values<0=',num2str(numlow),'-Pct <0=',num2str(pctlow,5));
fprintf(fid,'%s\n',stats8str);
fprintf(fid,'%s\n','***** RAD Stats End*****');
% Get the scan start date and time data based on the file name
[YearS,DayS,HourS,MinuteS,SecondS] = GetGOESDateTimeString(GOESFileName,1);
% Get the scan end date and time data based on the file name
[YearE,DayE,HourE,MinuteE,SecondE] = GetGOESDateTimeString(GOESFileName,2);
result = is_leap_year(YearS);
if(result==0)
    MonthDayStr=char(DayMonthNonLeapYear{DayS,1});
else
    MonthDayStr=char(DayMonthLeapYear{DayS,1});
end
MonthDayYearStr=strcat(MonthDayStr,'-',num2str(YearS));
datestr10='***** Scan Time Definition Follows *****';
datestr14='***** Scan Time Definition End *****';
fprintf(fid,'%s\n',datestr10);
datestr11=strcat('Year=',num2str(YearS,4),'-Day=',num2str(DayS,3),'-Hour=',num2str(HourS,2),...
    '-Minute=',num2str(MinuteS,2),'-Second=',num2str(SecondS,5));
fprintf(fid,'%s\n',datestr11);
datestr12=strcat('Calender Month and Day=',MonthDayStr);
fprintf(fid,'%s\n',datestr12);
fprintf(fid,'%s\n',datestr14);
% Set up the image
movie_figure1=figure('position',[hor1 vert1 widd lend]);
set(gcf,'MenuBar','none');
set(gca,'Position',[.16 .18  .70 .70]);
hI=imagesc(RAD,[RAD01 RAD99]);
hc=colorbar;
title(titlestr);
% Build a table to hold Miscellaneous data this can be written to the log
% file and the PDF file if requested
CRPIX1= CRPIX1S.values;
CRPIX2= CRPIX2S.values;
CDELT1=CDELT1S.values;
CDELT2=CDELT2S.values;
DIAMS=DSUNS.values;
Orientation=ORIENTS.values;
RotOffset=CROTAS.values;
RotOffsetstr=num2str(RotOffset,6);
SunEquatOffsetstr=num2str(SOLAR_B0S.values,6);
WCSName=WCS_NAMES.values;
SunCenterLon=CRVAL1S.values;
SunCenterLat=CRVAL2S.values;
Celes_Pole_Lonstr=num2str(LONPOLES.values,5);
Actual_Exp_Time=EXPTIMES.values;
Actual_ExpTimestr=num2str(EXPTIMES.values,6);
SunDist=DSUN_OBSS.values/1000;
SunDiststr=num2str(SunDist,10);
ScienceObj=SCI_OBJS.values;
FwdFilter=FILTER1S.values;
SubSatLat=num2str(HGLT_OBSS.values,6);
SubSatLon=num2str(HGLN_OBSS.values,6);
YAWFlipVal=YAW_FLIPS.values;
YawPos='undefined';
if(YAWFlipVal==0)
  YawPos='upright';
elseif(YAWFlipVal==1)
  YawPos='neither';
elseif(YAWFlipVal==2)
  YawPos='inverted';
end
CCDConfigValue=CCD_READS.values;
CCD_CONFIG='undefined';
if(CCDConfigValue==0)
  CCD_CONFIG='not confiured';
elseif(CCDConfigValue==1)
  CCD_CONFIG='left readout amp';
elseif(CCDConfigValue==3)
  CCD_CONFIG='right readout amp';
end
ECLIPSE_Flag=ECLIPSES.values;
EclipseState='undefined';
if(ECLIPSE_Flag==0)
  EclipseState='no eclipse';
elseif(ECLIPSE_Flag==1)
  EclipseState='penumbra prior to full eclipse';
elseif(ECLIPSE_Flag==2)
  EclipseState='umbra_full_eclipse';
elseif(ECLIPSE_Flag==3)
  EclipseState='penumbra after full eclipse';
end
GOODPix=GOOD_PIXS.values;
FIXPix=FIX_PIXS.values;
SatPix=SAT_PIXS.values;
MissPix=MISS_PIXS.values;
TotPix=GOODPix+FIXPix+SatPix+MissPix;
GoodPixFrac=GOODPix/TotPix;
FixPixFrac=FIXPix/TotPix;
SatPixFrac=SatPix/TotPix;
MissPixFrac=MissPix/TotPix;
ApertureSelecSet=APSELPOSS.values;
if(ApertureSelecSet==0)
    ApertureSetting='93.9-angstrom';
elseif(ApertureSelecSet==1)
    ApertureSetting='131.2-angstrom'; 
elseif(ApertureSelecSet==2)
    ApertureSetting='171.1-angstrom'; 
elseif(ApertureSelecSet==3)
    ApertureSetting='195.1-angstrom'; 
elseif(ApertureSelecSet==4)
    ApertureSetting='283.8-angstrom'; 
elseif(ApertureSelecSet==5)
    ApertureSetting='303.8-angstrom'; 
end
CameraHdr ={'Item' 'Value'};
CameraSettingsTable=cell(1,1);
CameraSettingsTable{1,1}='Center Sun Pixel-X dir';
CameraSettingsTable{1,2}=num2str(CRPIX1,5);
CameraSettingsTable{2,1}='Center Sun Pixel-Y dir';
CameraSettingsTable{2,2}=num2str(CRPIX2,5);
CameraSettingsTable{3,1}='Plate Scale at Ref Pix X-dir-arcsec';
CameraSettingsTable{3,2}=num2str(CDELT1,5);
CameraSettingsTable{4,1}='Plate Scale at Ref Pix Y-dir-arcsec';
CameraSettingsTable{4,2}=num2str(CDELT2,5);
CameraSettingsTable{5,1}='Sun Diam Pixels';
CameraSettingsTable{5,2}=num2str(DIAMS,5);
CameraSettingsTable{6,1}='Orientation of Sun Image';
CameraSettingsTable{6,2}=Orientation;
CameraSettingsTable{7,1}='Angular Offset Of Sun North Pole-deg';
CameraSettingsTable{7,2}=RotOffsetstr;
CameraSettingsTable{8,1}='Solar equator angular offset-deg';
CameraSettingsTable{8,2}=SunEquatOffsetstr;
CameraSettingsTable{9,1}='Solar coordinate system type';
CameraSettingsTable{9,2}=WCSName;
CameraSettingsTable{10,1}='Sun Center Longitude-deg';
CameraSettingsTable{10,2}=SunCenterLon;
CameraSettingsTable{11,1}='Sun Center Latitude-deg';
CameraSettingsTable{11,2}=SunCenterLat;
CameraSettingsTable{12,1}='Celestial Pole Lon-deg';
CameraSettingsTable{12,2}=Celes_Pole_Lonstr;
CameraSettingsTable{13,1}='Actual Camera Exp Time-sec';
CameraSettingsTable{13,2}=Actual_ExpTimestr;
CameraSettingsTable{14,1}='Dist To Center Of Sun-km';
CameraSettingsTable{14,2}=SunDiststr;
CameraSettingsTable{15,1}='Science Objective';
CameraSettingsTable{15,2}=ScienceObj;
CameraSettingsTable{16,1}='Forward Filter';
CameraSettingsTable{16,2}=FwdFilter;
CameraSettingsTable{17,1}='Heliographic Lat On Sun-deg';
CameraSettingsTable{17,2}=SubSatLat;
CameraSettingsTable{18,1}='Heliographic Lon On Sun-deg';
CameraSettingsTable{18,2}=SubSatLon;
CameraSettingsTable{19,1}='Yaw Flip Config';
CameraSettingsTable{19,2}=YawPos;
CameraSettingsTable{20,1}='CCD Readout Configuration';
CameraSettingsTable{20,2}=CCD_CONFIG;
CameraSettingsTable{21,1}='Sun Eclise State';
CameraSettingsTable{21,2}=EclipseState;
% Get the Data on Camera Calibration
dtime1=DATE_OBSS.DString;
dtime2=DATE_ENDS.DString;
dtime3=DATE_BKES.DString;
dtime4=DATE_DFMS.DString;
ndframes=NDFRAMESS.values;
dtime5=DATE_DF0S.DString;
dtime6=DATE_DF1S.DString;
dtime7=DATE_DF2S.DString;
dtime8=DATE_DF3S.DString;
dtime9=DATE_DF4S.DString;
dtime10=DATE_DF5S.DString;
dtime11=DATE_DF6S.DString;
dtime12=DATE_DF7S.DString;
dtime13=DATE_DF8S.DString;
dtime14=DATE_DF9S.DString;
ccdsnr=DER_SNRS.values;
ccdsat=SAT_THRS.values;
ccdtemp1=CCD_TMP1S.values;
ccdtemp2=CCD_TMP2S.values;
xlabel('Pixel Column Numbers');
ylabel('Pixel Row Numbers');
newaxesh=axes('Position',[0 0 1 1]);
set(newaxesh,'XLim',[0 1],'YLim',[0 1]);
Pos=get(hc,'Position');
PosyL=.78*Pos(1,2);
PosyU=1.03*(Pos(1,2)+Pos(1,4));
tx1=.13;
ty1=PosyL;
tx2=tx1;
ty2=0.80*PosyL;
txtstr2=strcat('Rad-1-Ptile =',num2str(RAD01,5),'-Median RAD=',num2str(RAD50,5),'-RAD-99-Ptile =',...
    num2str(RAD99,5),'-all in W/m^2/sr','-values<0=',num2str(numlow),'-pctlow=',num2str(pctlow,5));
txt2=text(tx2,ty2,txtstr2,'FontWeight','bold','FontSize',10);
tx3=Pos(1,1)-.02;
ty3=1.01*PosyU;
txtstr3='RAD-W/m^2/sr';
txt3=text(tx3,ty3,txtstr3,'FontWeight','bold','FontSize',10);
tx4=tx1;
ty4=ty2-.04;
txtstr4=strcat('Actual Exposure Time-',Actual_ExpTimestr,'-sec-Eclipse Status=',...
    EclipseState,'-waveband=',num2str(waveband,5),'-Angstroms');
txt4=text(tx4,ty4,txtstr4,'FontWeight','bold','FontSize',10);
set(newaxesh,'Visible','Off');
% Save this chart
figstr=strcat(titlestr,'.jpg');
eval(['cd ' jpegpath(1:length(jpegpath)-1)]);
actionstr='print';
typestr='-djpeg';
[cmdString]=MyStrcat2(actionstr,typestr,figstr);
eval(cmdString);
pause(chart_time);
JpegCounter=JpegCounter+1;
JpegFileList{JpegCounter+1,1}=figstr;
JpegFileList{JpegCounter+1,2}=jpegpath;
close('all');
savestr=strcat('Saved Solar RAD data plot to file-',figstr);
fprintf(fid,'%s\n',savestr);
if((iCreatePDFReport==1) && (RptGenPresent==1))
    [ibreak]=strfind(GOESFileName,'_e');
    is=1;
    ie=ibreak(1)-1;
    GOESShortFileName=GOESFileName(is:ie);
    headingstr1=strcat('SUVI-',bandstr,'-',GOESShortFileName);
    chapter = Chapter("Title",headingstr1);
    sectionstr=strcat('SolarRAD-','Whole Disk');
    add(chapter,Section(sectionstr));
    imdata = imread(figstr);
    [nhigh,nwid,ndepth]=size(imdata);
    image = mlreportgen.report.FormalImage();
    image.Image = which(figstr);% 
    pdftxtstr=strcat('SolarRad-For File-',GOESShortFileName);
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
    parastr11=strcat('The Data for this chart was taken from file-',GOESShortFileName,'.');
    parastr12=strcat('Plotted on this chart is the solar ultraviolet radiation as seen by the Solar Ultraviolet Imager (SUVI) in band-',bandstr,'.');
    parastr13='Unlike the ABI sensor plots, this data was plotted as an image and not projected onto the surface of the sun.';
    parastr14='Basic statistics of the Solar UV radiation are shown below the chart.';
    parastr15='There are 6 available UV bands-the utility of each band is shown in the table that follows next.';
    parastr16=strcat('The SUVI Radiation data values range from-',num2str(RAD01,5),'-at 1 Ptile to-',num2str(RAD99,5),'-for 99 Ptile.');
    if(Actual_Exp_Time>.25)
        parastr17=strcat('This is a normal frame of data with an exposure time of-',num2str(Actual_Exp_Time,6),'-sec.');
    else
        parastr17=strcat('This is a not a normal frame of data with an exposure time of-',num2str(Actual_Exp_Time,6),'-sec.');
    end
    parastr18='The existance of negative values in the image is probably the result of calibration issues.';
    parastr19=strcat(parastr11,parastr12,parastr13,parastr14,parastr15,parastr16,parastr17,parastr18);
    p1 = Paragraph(parastr19);
    p1.Style = {OuterMargin("0pt", "0pt","10pt","10pt")};
    add(chapter,p1);
% Now build a Solar Features Table
      SolarFeatHdr={'Feature' 'Fe93.9' 'Fe131.2'  'Fe171.1' 'Fe195.1' 'Fe284.2' 'He303.8'};
      SolarFeatTable=cell(6,7);
      SolarFeatTable{1,1}='Filament';
      SolarFeatTable{1,2}=' ';
      SolarFeatTable{1,3}=' ';
      SolarFeatTable{1,4}=' ';
      SolarFeatTable{1,5}=' ';
      SolarFeatTable{1,6}=' ';
      SolarFeatTable{1,7}='X';
      SolarFeatTable{2,1}='Coronal Hole';
      SolarFeatTable{2,2}=' ';
      SolarFeatTable{2,3}=' ';
      SolarFeatTable{2,4}=' ';
      SolarFeatTable{2,5}=' ';
      SolarFeatTable{2,6}='X';
      SolarFeatTable{2,7}=' ';
      SolarFeatTable{3,1}='Active Region Complexity';
      SolarFeatTable{3,2}=' ';
      SolarFeatTable{3,3}=' ';
      SolarFeatTable{3,4}='X';
      SolarFeatTable{3,5}='X';
      SolarFeatTable{3,6}=' ';
      SolarFeatTable{3,7}=' ';
      SolarFeatTable{4,1}='Coronal Mass Ejection';
      SolarFeatTable{4,2}=' ';
      SolarFeatTable{4,3}=' ';
      SolarFeatTable{4,4}='X';
      SolarFeatTable{4,5}='X';
      SolarFeatTable{4,6}=' ';
      SolarFeatTable{4,7}=' ';
      SolarFeatTable{5,1}='Flare Location and Morphology';
      SolarFeatTable{5,2}='X';
      SolarFeatTable{5,3}='X';
      SolarFeatTable{5,4}=' ';
      SolarFeatTable{5,5}=' ';
      SolarFeatTable{5,6}=' ';
      SolarFeatTable{5,7}=' ';
      SolarFeatTable{6,1}='Quiet Region';
      SolarFeatTable{6,2}=' ';
      SolarFeatTable{6,3}=' ';
      SolarFeatTable{6,4}='X';
      SolarFeatTable{6,5}='X';
      SolarFeatTable{6,6}=' ';
      SolarFeatTable{6,7}='X';
      T2=[SolarFeatHdr;SolarFeatTable];
      tb21=Table(T2);
      tb21.Style = [tb21.Style {Border('solid','black','3px')}];
      tb21.HAlign='center';
      tb21.TableEntriesHAlign = 'center';
      tb21.ColSep = 'single';
      tb21.RowSep = 'single';
      r = row(tb21,1);
      r.Style = [r.Style {Color('red'),Bold(true)}];
      bt2 = BaseTable(tb21);
      tabletitle = Text('SUVI Sensor Usage');
      tabletitle.Bold = false;
      bt2.Title = tabletitle;
      bt2.TableWidth="7in";
      add(chapter,bt2);
% % Add text for this table
      parastr21=strcat('The SUVI channel used for this data is-',bandstr,'-which is designed to study the following Key Feature-',KeyFeature,'.');
      parastr22='All solar images are taken at a 1280 x 1280 image format.';
      parastr23='At the present time,the SUVI data as shown as an image not as a scene mapped on the sun.';
      parastr24='In order to do this a helioprojective carterisan system must be used. This has not yet been coded up hence the use of an unprojected image.';
      parastr29=strcat(parastr21,parastr22,parastr23,parastr24);
      p2 = Paragraph(parastr29);
      p2.Style = {OuterMargin("0pt", "0pt","10pt","10pt")};
      add(chapter,p2);
      br = PageBreak();
      add(chapter,br);
      T3=[CameraHdr;CameraSettingsTable];
      tbl3=Table(T3);
      tbl3.Style = [tbl3.Style {Border('solid','black','3px')}];
      tbl3.HAlign='center';
      tbl3.TableEntriesHAlign = 'center';
      tbl3.ColSep = 'single';
      tbl3.RowSep = 'single';
      r = row(tbl3,1);
      r.Style = [r.Style {Color('red'),Bold(true)}];
      bt3 = BaseTable(tbl3);
      tabletitle = Text('SUVI Camera Settings Data');
      tabletitle.Bold = false;
      bt3.Title = tabletitle;
      bt3.TableWidth="7in";
      add(chapter,bt3);
% Add text for the Camera Settings Table
      br = PageBreak();
      add(chapter,br);
      parastr21='The Table above shows the values for 21 values of camera and data collection related setings.';
      parastr22='Rows 1 and 2 detail the sun center location in pixels units.';
      parastr23='The scale of the pixels is provided in rows 3 and 4 and is fixed at 2.5 arcsec-the diameters of the sun in pixels is in row 5.';
      parastr24='The next several rows provide of few values that are used in the solar coordinate projection system.';
      parastr25='The remaining of items in the table are a mix of items of interest-this list is not a complete listing of all settings.';
      parastr29=strcat(parastr21,parastr22,parastr23,parastr24,parastr25);
      p2 = Paragraph(parastr29);
      p2.Style = {OuterMargin("0pt", "0pt","10pt","10pt")};
      add(chapter,p2);
      DQFValues=DQFS.values;
      [nrows,ncols]=size(DQFValues);
      DQFVal1D=reshape(DQFValues,nrows*ncols,1);
      FillValue=DQFS.FillValue;
      [ifill,jfill]=find(DQFValues==FillValue);
      a1=isempty(ifill);
      if(a1==0)
          numbad=length(ifill);
      else
          numbad=0;
      end
      numgood=nrows*ncols-numbad;
      DQFVal1DG=zeros(numgood,1);
      ihit=0;
      for kk=1:numgood
          nowVal=DQFVal1D(kk,1);
          if(nowVal~=FillValue)
             ihit=ihit+1;
             DQFVal1DG(ihit,1)=nowVal;
          end
      end
      [ival0]=find(DQFVal1DG==0);
      [ival1]=find(DQFVal1DG==1);
      [ival2]=find(DQFVal1DG==2);
      [ival3]=find(DQFVal1DG==3);
      [ival4]=find(DQFVal1DG==4);
      a0=isempty(ival0);
      if(a0==1)
          num0=0;
      else
          num0=length(ival0);
      end
      a1=isempty(ival1);
      if(a1==1)
          num1=0;
      else
          num1=length(ival1);
      end
      a2=isempty(ival2);
      if(a2==1)
          num2=0;
      else
          num2=length(ival2);
      end
      a3=isempty(ival3);
      if(a3==1)
          num3=0;
      else
          num3=length(ival3);
      end
      a4=isempty(ival4);
      if(a4==1)
          num4=0;
      else
          num4=length(ival4);
      end
      frac0=num0/(nrows*ncols);
      frac1=num1/(nrows*ncols);
      frac2=num2/(nrows*ncols);
      frac3=num3/(nrows*ncols);
      frac4=num4/(nrows*ncols);
      
 % Create Data Quality Table
    DQFHdr={'Item' 'Value'};
    DQFTable=cell(5,2);
    dqfstr0=num2str(frac0,5);
    dqfstr1=num2str(frac1,5);
    dqfstr2=num2str(frac2,5);
    dqfstr3=num2str(frac3,5);
    dqfstr4=num2str(frac4,5);
    DQFTable{1,1}='frac qood quality pixels';
    DQFTable{1,2}=dqfstr0;
    DQFTable{2,1}='frac degraded due to bad pixel correction';
    DQFTable{2,2}=dqfstr1;
    DQFTable{3,1}='frac degraded due to bad column correction';
    DQFTable{3,2}=dqfstr2;
    DQFTable{4,1}='frac invalid due to missing L0 data';
    DQFTable{4,2}=dqfstr3;
    DQFTable{5,1}='frac potentially degraded due to pixel spike';
    DQFTable{5,2}=dqfstr4;
    br = PageBreak();
    add(chapter,br);
    T4=[DQFHdr;DQFTable];
    tbl4=Table(T4);
    tbl4.Style = [tbl4.Style {Border('solid','black','3px')}];
    tbl4.HAlign='center';
    tbl4.TableEntriesHAlign = 'center';
    tbl4.ColSep = 'single';
    tbl4.RowSep = 'single';
    r = row(tbl4,1);
    r.Style = [r.Style {Color('red'),Bold(true)}];
    bt4 = BaseTable(tbl4);
    tabletitle = Text('SUVI Data DQF');
    tabletitle.Bold = false;
    bt4.Title = tabletitle;
    bt4.TableWidth="7in";
    add(chapter,bt4);
    parastr31='The DQF Table for the SUVI data contains only 5 items.';
    parastr32=strcat('Item 1 lists the good quality pixels-in this case-',dqfstr0,'-are listed as good.');
    parastr33='The next 4 items lists this reasons why pixels are degraded or invalid-typically nearly all the pixels are good.';
    parastr39=strcat(parastr31,parastr32,parastr33);
    p4 = Paragraph(parastr39);
    p4.Style = {OuterMargin("0pt", "0pt","10pt","10pt")};
    add(chapter,p4);
% Add the sensor calibration table
    br = PageBreak();
    add(chapter,br);
    SenHdr={'Item' 'Value'};
    SenTable=cell(1,2);
    SenTable{1,1}='Start Time of Solar Observations';
    SenTable{1,2}=dtime1;
    SenTable{2,1}='End Time of Solar Observations';
    SenTable{2,2}=dtime2;
    SenTable{3,1}='Time Of Last Contamination Bake Out';
    SenTable{3,2}=dtime3;
    SenTable{4,1}='Time Of Median Dark Frame To Calibrate Image';
    SenTable{4,2}=dtime4;
    SenTable{5,1}='Number of Dark Frames used to calibrate Image';
    SenTable{5,2}=num2str(ndframes);
    SenTable{6,1}='Time Stamp Of Dark Frame 1';
    SenTable{6,2}=dtime5;
    SenTable{7,1}='Time Stamp Of Dark Frame 2';
    SenTable{7,2}=dtime6;
    SenTable{8,1}='Time Stamp Of Dark Frame 3';
    SenTable{8,2}=dtime7;
    SenTable{9,1}='Time Stamp Of Dark Frame 4';
    SenTable{9,2}=dtime8;
    SenTable{10,1}='Time Stamp Of Dark Frame 5';
    SenTable{10,2}=dtime9;
    SenTable{11,1}='Time Stamp Of Dark Frame 6';
    SenTable{11,2}=dtime10;
    SenTable{12,1}='Time Stamp Of Dark Frame 7';
    SenTable{12,2}=dtime11;
    SenTable{13,1}='Time Stamp Of Dark Frame 8';
    SenTable{13,2}=dtime12;
    SenTable{14,1}='Time Stamp Of Dark Frame 9';
    SenTable{14,2}=dtime13;
    SenTable{15,1}='Time Stamp Of Dark Frame 10';
    SenTable{15,2}=dtime14;
    SenTable{16,1}='CCD SNR for 10 photons';
    SenTable{16,2}=num2str(ccdsnr,5);
    SenTable{17,1}='CCD Saturation level';
    SenTable{17,2}=strcat(num2str(ccdsat,6),'-W/m^2/sr');
    SenTable{18,1}='CCD Sensor 1 Temp';
    SenTable{18,2}=strcat(num2str(ccdtemp1,5),'-deg C');
    SenTable{19,1}='CCD Sensor 2 Temp';
    SenTable{19,2}=strcat(num2str(ccdtemp2,5),'-deg C');
    T5=[SenHdr;SenTable];
    tbl5=Table(T5);
    tbl5.Style = [tbl4.Style {Border('solid','black','3px')}];
    tbl5.HAlign='center';
    tbl5.TableEntriesHAlign = 'center';
    tbl5.ColSep = 'single';
    tbl5.RowSep = 'single';
    r = row(tbl4,1);
    r.Style = [r.Style {Color('red'),Bold(true)}];
    bt5 = BaseTable(tbl5);
    tabletitle = Text('SUVI Sensor Calibration Data');
    tabletitle.Bold = false;
    bt5.Title = tabletitle;
    bt5.TableWidth="7in";
    add(chapter,bt5);
    br = PageBreak();
    add(chapter,br);
    parastr41='The table above displays data relevant to the SUVI camera calibration in 19 rows.';
    parastr42='Rows 1 and 2 provide the start and end times of this set of solar observations.';
    parastr43='Periodically the sensor is heated to bake out contaminants, if this was not done recently the string No valid date is shown.';
    parastr44=strcat('CCD sensors need to be periodically to be re-calibrated due to dark current variations-Row 4 provides a time stamp and the',...
        '-number of frames used to complete this operation.');
    parastr45='The times of the calibration frames is provided in rows 6 through 15-note that these are not all in the same hour or day.';
    parastr46='The final 4 rows of the table SNR,saturation levels and CCD temps.';
    parastr49=strcat(parastr41,parastr42,parastr43,parastr44,parastr45,parastr46);
    p4 = Paragraph(parastr49);
    p4.Style = {OuterMargin("0pt", "0pt","10pt","10pt")};
    add(chapter,p4);
    br = PageBreak();
    add(chapter,br);
end % 
fprintf(fid,'%s\n','----- Start Camera Setting and Environments Data-----');
str1=strcat('Center Sun Pixel-X dir=',num2str(CRPIX1,5));
str2=strcat('Center Sun Pixel-Y dir=',num2str(CRPIX2,5));
str3=strcat('Plate scale in X Dir-',num2str(CDELT1,5),'-arc sec');
str4=strcat('Plate scale in Y Dir-',num2str(CDELT2,5),'-arc sec');
str5=strcat('Sun Diameter in pixels-',num2str(DIAMS,5));
str6=strcat('Angular Offset Of Sun North Pole=',RotOffsetstr,'-deg');
str7=strcat('Angular Offset of Sun Equator=',SunEquatOffsetstr,'-deg');
str8=strcat('Solar Coordinate system name-',WCSName);
str9=strcat('Sun Center Longitude-deg=',num2str(SunCenterLon,5));
str10=strcat('Sun Center Latitude-deg=',num2str(SunCenterLat,5));
str11=strcat('celestial north pole for sun projection-',Celes_Pole_Lonstr,'-deg');
str12=strcat('Actual camera exposure time-',Actual_ExpTimestr,'-sec');
str13=strcat('Distance to sun center-',SunDiststr,'-km');
str14=strcat('Science Objective Of this frame-',ScienceObj);
str15=strcat('Forwards Filter Setting-',FwdFilter);
str16=strcat('Heliographic Lat On Sun-',SubSatLat,'-deg');
str17=strcat('Heliographic Lon On Sun-',SubSatLon,'-deg');
str18=strcat('Yaw Flip Config-',YawPos);
str19=strcat('CCD Readout Configuration-',CCD_CONFIG);
str20=strcat('Sun Eclipse State-',EclipseState);
str21=strcat('Good Pixel Fraction-',num2str(GoodPixFrac,5));
str22=strcat('Fixed Pixel Fraction-',num2str(FixPixFrac,5));
str23=strcat('Saturated Pixel Fraction-',num2str(SatPixFrac,5));
str24=strcat('Missing Pixel Fraction-',num2str(MissPixFrac,5));
str25=strcat('Camera Aperture Setting-',ApertureSetting);
fprintf(fid,'%s\n',str1);
fprintf(fid,'%s\n',str2);
fprintf(fid,'%s\n',str3);
fprintf(fid,'%s\n',str4);
fprintf(fid,'%s\n',str5);
fprintf(fid,'%s\n',str6);
fprintf(fid,'%s\n',str7);
fprintf(fid,'%s\n',str8);
fprintf(fid,'%s\n',str9);
fprintf(fid,'%s\n',str10);
fprintf(fid,'%s\n',str11);
fprintf(fid,'%s\n',str12);
fprintf(fid,'%s\n',str13);
fprintf(fid,'%s\n',str14);
fprintf(fid,'%s\n',str15);
fprintf(fid,'%s\n',str16);
fprintf(fid,'%s\n',str17);
fprintf(fid,'%s\n',str18);
fprintf(fid,'%s\n',str19);
fprintf(fid,'%s\n',str20);
fprintf(fid,'%s\n',str21);
fprintf(fid,'%s\n',str22);
fprintf(fid,'%s\n',str23);
fprintf(fid,'%s\n',str24);
fprintf(fid,'%s\n',str25);
fprintf(fid,'%s\n','----- End Camera Setting and Environments Data-----');
fprintf(fid,'%s\n','----- Start Camera Calibration Data-----');
calstr1=strcat('Start Time for Solar Observations-',dtime1);
calstr2=strcat('End Time For Solar Observations-',dtime2);
calstr3=strcat('Time Of last contamination bake out-',dtime3);
calstr4=strcat('Time Of Median Dark Frame Use to Calibrate Image-',dtime4);
calstr5=strcat('Number of Dark Frames used to calibrate Image-',num2str(ndframes));
calstr6=strcat('Time Stamp of Dark Frame 1-',dtime5);
calstr7=strcat('Time Stamp of Dark Frame 2-',dtime6);
calstr8=strcat('Time Stamp of Dark Frame 3-',dtime7);
calstr9=strcat('Time Stamp of Dark Frame 4-',dtime8);
calstr10=strcat('Time Stamp of Dark Frame 5-',dtime9);
calstr11=strcat('Time Stamp of Dark Frame 6-',dtime10);
calstr12=strcat('Time Stamp of Dark Frame 7-',dtime11);
calstr13=strcat('Time Stamp of Dark Frame 8-',dtime12);
calstr14=strcat('Time Stamp of Dark Frame 9-',dtime13);
calstr15=strcat('Time Stamp of Dark Frame 10-',dtime14);
calstr16=strcat('CCD SNR for 10 photons-',num2str(ccdsnr,5));
calstr17=strcat('CCD Saturation level-',num2str(ccdsat,6),'-W/m^2/sr');
calstr18=strcat('CCD Sensor 1 Temp-',num2str(ccdtemp1,5),'-deg C');
calstr19=strcat('CCD Sensor 2 Temp-',num2str(ccdtemp2,5),'-deg C');
fprintf(fid,'%s\n',calstr1);
fprintf(fid,'%s\n',calstr2);
fprintf(fid,'%s\n',calstr3);
fprintf(fid,'%s\n',calstr4);
fprintf(fid,'%s\n',calstr5);
fprintf(fid,'%s\n',calstr6);
fprintf(fid,'%s\n',calstr7);
fprintf(fid,'%s\n',calstr8);
fprintf(fid,'%s\n',calstr9);
fprintf(fid,'%s\n',calstr10);
fprintf(fid,'%s\n',calstr11);
fprintf(fid,'%s\n',calstr12);
fprintf(fid,'%s\n',calstr13);
fprintf(fid,'%s\n',calstr14);
fprintf(fid,'%s\n',calstr15);
fprintf(fid,'%s\n',calstr16);
fprintf(fid,'%s\n',calstr17);
fprintf(fid,'%s\n',calstr18);
fprintf(fid,'%s\n',calstr19);
fprintf(fid,'%s\n','----- End Camera Calibration Data Data-----');
fprintf(fid,'%s\n','------- Finished Plotting SUVI Solar Rad Data ------');
end


