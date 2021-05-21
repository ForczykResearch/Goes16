% This script will read a Landsat Image file reproject it and plot it
% Written By: Stephen Forczyk
% Created: Oct 6,2020
% Revised: -----
% Classification: Unclassified
global geotiffilename;

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
global ColorList RGBVals ColorList2 xkcdVals LandColors;
global orange bubblegum;
% additional paths needed for mapping
global matpath1 mappath matlabpath;
global jpegpath geotiffpath;
global mappath gridpath countyshapepath nationalshapepath summarypath;

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
geotiffpath='D:\Earth_Explorer\Landsat\Huntsville\';
geotiffilename='LC08_L1TP_020036_20200817_20200822_01_T1_B8.TIF';
% Navigate to where the geotiff file is stored
eval(['cd ' geotiffpath(1:length(geotiffpath)-1)]);
[Z,R] = readgeoraster(geotiffilename,'OutputType','double');
proj = geotiffinfo(geotiffilename);
x = proj.CornerCoords.X;
y = proj.CornerCoords.Y;
[latProj, lonProj] = projinv(proj, x, y);
mstruct = geotiff2mstruct(proj);
[latMstruct, lonMstruct] = minvtran(mstruct, x, y);
abs(latProj - latMstruct) <= 1e-7
ab=1;



