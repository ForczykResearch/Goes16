% This routine will process one GOES-16/17 satellite images

global BandDataS MetaDataS;
global CMIS DQFS tS yS xS tBS goesImagerS yImgS yImgBS;
global xImgS xImgBS SatDataS GeoSpatialS;
global ReflectanceS AlgoS ErrorS EarthSunS VersionContainerS;
global GoesWaveBand ESunS kappa0S PlanckS FocalPlaneS;
global GOESFileName;

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

GOES16path='D:\Goes16\Imagery\July25_2020\Band01\';
matpath=GOES16path;
% Establish selected run parameters
imachine=2;
if(imachine==1)
    widd=720;
    lend=580;
    widd2=1000;
    lend2=700;
elseif(imachine==2)
    widd=1080;
    lend=812;
    widd2=1000;
    lend2=700;
elseif(imachine==3)
    widd=1296;
    lend=974;
    widd2=1200;
    lend2=840;
end
% Set a specific color order
set(0,'DefaultAxesColorOrder',[1 0 0;
    1 1 0;0 1 0;0 0 1;0.75 0.50 0.25;
    0.5 0.75 0.25; 0.25 1 0.25;0 .50 .75]);
% Set up some defaults for a PowerPoint presentationwhos
scaling='true';
stretching='false';
padding=[75 75 75 75];
igrid=1;
% Set up paramters for graphs that will center them on the screen
[hor1,vert1,Fz1,Fz2,machine]=SetScreenCoordinates(widd,lend);
[hor2,vert2,Fz1,Fz2,machine]=SetScreenCoordinates(widd2,lend2);
chart_time=5;
idirector=1;
initialtimestr=datestr(now);
% Go to the expected path
eval(['cd ' GOES16path(1:length(GOES16path)-1)]);
ReadNetCDFFile();
CMI=CMIS.values;
minval=min(min(CMI));
maxval=max(max(CMI));
imagesc(CMI,[minval maxval]);
colormap(jet)
colorbar

% Now write a Matlab file containing the decoded data
% use the original file name with a .mat extension
[iper]=strfind(GOESFileName,'.');
is=1;
ie=iper(1)-1;
MatFileName=strcat(GOESFileName(is:ie),'.mat');
eval(['cd ' matpath(1:length(matpath)-1)]);
actionstr='save';
varstr1='BandDataS MetaDataS CMIS DQFS tS yS xS tBS goesImagerS';
varstr2=' yImgS yImgBS xImgS xImgBS SatDataS GeoSpatialS';
varstr3=' ReflectanceS AlgoS ErrorS EarthSunS VersionContainerS';
varstr4=' GoesWaveBand ESunS kappa0S PlanckS FocalPlaneS GOESFileName';
varstr=strcat(varstr1,varstr2,varstr3,varstr4);
[cmdString]=MyStrcat(actionstr,MatFileName,varstr);
eval(cmdString)
dispstr=strcat('Wrote Matlab File-',MatFileName);
disp(dispstr);
ab=1;
