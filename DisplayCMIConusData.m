function DisplayCMIConusData(CMI,GeoRef,titlestr)
% Display the CMI Moisture Data from the GOES16/17 data
% on a texture map for the USA
% Written By: Stephen Forczyk
% Created: August 5,2020
% Revised: August 9,2020 added additional countries to map
%          changed figure naming convention and added
% more captions to bottom of figure
% Classification: Unclassified
global BandDataS MetaDataS;
global CMIS DQFS tS yS xS tBS goesImagerS yImgS yImgBS;
global xImgS xImgBS SatDataS GeoSpatialS;
global ReflectanceS AlgoS ErrorS EarthSunS VersionContainerS;
global GoesWaveBand ESunS kappa0S PlanckS FocalPlaneS;
global HTS DQF1S OutlierPS CloudTopS Algo1S ProcessParamS;
global LZAS LZABS SZAS SZABS Error1S CloudPixelsS;
global GOESFileName;
global westEdge eastEdge northEdge southEdge;
global MonthDayStr MonthDayYearStr;
global DayMonthNonLeapYear DayMonthLeapYear CalendarFileName;

global widd2 lend2;
global initialtimestr igrid ijpeg ilog imovie;
global vert1 hor1 widd lend;
global vert2 hor2 machine;
global chart_time;
global Fz1 Fz2;
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
global figpath screencapturepath;
global shapepath2 countrypath countryshapepath usstateboundariespath;
global GOES16Band1path GOES16Band2path GOES16Band3path GOES16Band4path;
global GOES16Band5path GOES16Band6path GOES16Band7path GOES16Band8path
global GOES16Band9path GOES16Band10path GOES16Band11path GOES16Band12path;
global GOES16Band13path GOES16Band14path GOES16Band15path GOES16Band16path;
global GOES16CloudTopHeightpath;

% Now plot the CMI as a texture map
% worldmap(CMI,GeoRef);
% geoshow(CMI,GeoRef,'DisplayType','texturemap')
% demcmap(CMI)
% hold on
% eval(['cd ' jpegpath(1:length(jpegpath)-1)]);
% load('USAHiResBoundaries.mat');
% plotm(USALat,USALon,'r');
% set(gcf,'Position',[hor1 vert1 widd lend])
% axesm ('ortho', 'Frame', 'on', 'Grid', 'on');
% Get the Band Used From the file name
[idash]=strfind(GOESFileName,'-');
numdash=length(idash);
[iunder]=strfind(GOESFileName,'_');
numunder=length(iunder);
is=idash(3)+4;
ie=is+1;
bandstr=GOESFileName(is:ie);
iband=str2num(bandstr);
ab=1;
% GoesWaveBand{1,1}='Band Num';
% GoesWaveBand{1,2}='Resolution-km';
% GoesWaveBand{1,3}='Wavelength-microns';
% GoesWaveBand{1,4}='Spectrum';
% GoesWaveBand{1,5}='Band Desc';
BandNum=GoesWaveBand{iband+1,1};
Resolution=GoesWaveBand{iband+1,2};
WaveLen=(GoesWaveBand{iband+1,3});
SpectrumStr=char(GoesWaveBand{iband+1,4});
BandDescStr=char(GoesWaveBand{iband+1,5});
BandNumStr=num2str(BandNum);
ResolutionStr=num2str(Resolution);
WaveLenStr=num2str(WaveLen);
[nrows,ncols]=size(CMI);
CMI1D=reshape(CMI,nrows*ncols,1);
CMISort=sort(CMI1D);
[ix]=find(CMISort>0);
is=ix(1);
ie=nrows*ncols;
idiff=ie-is+1;
CMIGZSort=zeros(idiff,1);
ind=0;
for n=is:ie
    ind=ind+1;
    CMIGZSort(ind,1)=CMISort(n,1);
end

ab=2;
numvals=length(CMIGZSort);
val01=CMIGZSort(round(.01*numvals),1);
val50=CMIGZSort(round(.50*numvals),1);
val99=CMIGZSort(round(.99*numvals),1);
ab=2;
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
axesm ('eqaconic','Frame','on','Grid','on','MapLatLimit',[southEdge northEdge],...
    'MapLonLimit',[westEdge eastEdge],'meridianlabel','on','parallellabel','on','plabellocation',5,'mlabellocation',20);
set(gcf,'MenuBar','none');
%tightmap;
geoshow(CMI,GeoRef,'DisplayType','texturemap')
demcmap(CMI)
hold on
rivers = shaperead('worldrivers.shp', 'UseGeoCoords', true);
numrows=length(rivers);
for n=1:numrows % Plot the rivers
   NowLon=rivers(n).Lon;
   NowLat=rivers(n).Lat;
   plotm(NowLat,NowLon,'b');
end
eval(['cd ' jpegpath(1:length(jpegpath)-1)]);
load('USAHiResBoundaries.mat');
plotm(USALat,USALon,'r');
load('CanadaBoundaries.mat');
plotm(CanadaLat,CanadaLon,'w');
load('MexicoBoundaries.mat');
plotm(MexicoLat,MexicoLon,'w');
load('CubaBoundaries.mat');
plotm(CubaLat,CubaLon,'w');
load('DominicanRepublicBoundaries.mat');
plotm(DRLat,DRLon,'w');
load('HaitiBoundaries.mat');
plotm(HaitiLat,HaitiLon,'w');
load('BelizeBoundaries.mat');
plotm(BelizeLat,BelizeLon,'w');
load('GautemalaBoundaries.mat');
plotm(GautemalaLat,GautemalaLon,'w')
load('JamaicaBoundaries.mat');
plotm(JamaicaLat,JamaicaLon,'w')
load('BahamasBoundaries.mat');
plotm(BahamasLat,BahamasLon,'w');
load('BarbadosBoundaries.mat');
plotm(BarbadosLat,BarbadosLon,'w');
load('BritishVirginIslandsBoundaries.mat');
plotm(BVALat,BVALon,'w');
set(gcf,'Position',[hor1 vert1 widd lend])
title(titlestr)
hold off
colorbar;
newaxesh=axes('Position',[0 0 1 1]);
set(newaxesh,'XLim',[0 1],'YLim',[0 1]);
tx1=.12;
ty1=.24;
txtstr1=strcat('Start Scan-Y',num2str(YearS),'-D-',num2str(DayS),'-H-',...
    num2str(HourS),'-M-',num2str(MinuteS),'-S-',num2str(SecondS));
txt1=text(tx1,ty1,txtstr1,'FontWeight','bold','FontSize',8);
tx2=.32;
ty2=.24;
txtstr2=strcat('End Scan-Y',num2str(YearE),'-D-',num2str(DayE),'-H-',...
    num2str(HourE),'-M-',num2str(MinuteE),'-S-',num2str(SecondE));
txt2=text(tx2,ty2,txtstr2,'FontWeight','bold','FontSize',8);
tx3=.12;
ty3=.20;
txtstr3=strcat('BandNum-',BandNumStr,'-Resolution-km-',ResolutionStr,...
    '-BandCenter-microns-',WaveLenStr,'-Spectral Region-',SpectrumStr,'-WaveBand Desc-',...
    BandDescStr);
txt3=text(tx3,ty3,txtstr3,'FontWeight','bold','FontSize',8);
tx4=.12;
ty4=.16;
txtstr4=strcat('Reflectance 1%-',num2str(val01,3),'-Reflectance 50%-',...
    num2str(val50,3),'-Reflectance 99%-',num2str(val99,3));
txt4=text(tx4,ty4,txtstr4,'FontWeight','bold','FontSize',8);
set(newaxesh,'Visible','Off');
% Save this chart
%figstr2=strcat(titlestr,'.jpg');
figstr=strcat('CloudReflectance-OR-ABI-L2-CMIPC-','Y',num2str(YearS),'D',...
    num2str(DayS),'H',num2str(HourS),'M',num2str(MinuteS),'S',num2str(SecondS),...
    '.jpg');
eval(['cd ' jpegpath(1:length(jpegpath)-1)]);
actionstr='print';
typestr='-djpeg';
[cmdString]=MyStrcat2(actionstr,typestr,figstr);
eval(cmdString);
dispstr=strcat('Saved Image To File-',figstr);
disp(dispstr)
pause(chart_time);
close('all');
end


