% This script will read a large text file to import it
% This text file has the lat lon data for a large grid of CMI values coming
% from GOES16

% Created: Dec 12,2020
% Written By: Stephen Forczyk
% Revised: Dec 16,2020 adding capaibility to generate grids for all 16
% wavebands of the CMI data
% Classification: Unclassified/Public Domain
global TextFileName MatFileName;
global RasterLats RasterLons;

global fid;
global widd2 lend2;
global initialtimestr igrid ijpeg ilog imovie;
global vert1 hor1 widd lend;
global vert2 hor2 machine;
global chart_time;
global Fz1 Fz2;
global idirector mov izoom iwindow;
global matpath GOES16path;
global jpegpath tiffpath;
global smhrpath excelpath ascpath;
global ipowerpoint PowerPointFile scaling stretching padding;
global ichartnum;
global ColorList RGBVals ColorList2 xkcdVals LandColors;
global orange bubblegum brown brightblue;
% additional paths needed for mapping
global matpath1 mappath matlabpath;
global gridpath;
icase=17;
gridpath='D:\Goes16\Grids\';

if(icase==1)
    TextFileName='ConusBand1CMILatLonsRev2.txt';
    MatFileName='ConusBand1CMILatLonGridRev2.mat';
    RasterLats=zeros(5000,3000);
    RasterLons=zeros(5000,3000);
    maxcount=5000*3000;
elseif(icase==2)
    TextFileName='ConusBand2CMILatLons.txt';
    MatFileName='ConusBand2CMILatLonGrid.mat';
    RasterLats=zeros(6000,10000);
    RasterLons=zeros(6000,10000);
    maxcount=6000*10000;
elseif(icase==3)
    TextFileName='ConusBand3CMILatLons.txt';
    MatFileName='ConusBand3CMILatLonGrid.mat';
    RasterLats=zeros(3000,5000);
    RasterLons=zeros(3000,5000);
    maxcount=3000*5000;
elseif(icase==4)
    TextFileName='ConusBand4CMILatLons.txt';
    MatFileName='ConusBand4CMILatLonGrid.mat';
    RasterLats=zeros(1500,2500);
    RasterLons=zeros(1500,2500);
    maxcount=1500*2500;
elseif(icase==5)
    TextFileName='ConusBand5CMILatLons.txt';
    MatFileName='ConusBand5CMILatLonGrid.mat';
    RasterLats=zeros(3000,5000);
    RasterLons=zeros(3000,5000);
    maxcount=3000*5000;
elseif(icase==6)
    TextFileName='ConusBand6CMILatLons.txt';
    MatFileName='ConusBand6CMILatLonGrid.mat';
    RasterLats=zeros(1500,2500);
    RasterLons=zeros(1500,2500);
    maxcount=1500*2500;
elseif(icase==7)
    TextFileName='ConusBand7CMILatLons.txt';
    MatFileName='ConusBand7CMILatLonGrid.mat';
    RasterLats=zeros(1500,2500);
    RasterLons=zeros(1500,2500);
    maxcount=1500*2500;
elseif(icase==8)
    TextFileName='ConusBand8CMILatLons.txt';
    MatFileName='ConusBand8CMILatLonGrid.mat';
    RasterLats=zeros(1500,2500);
    RasterLons=zeros(1500,2500);
    maxcount=1500*2500;
elseif(icase==9)
    TextFileName='ConusBand9CMILatLons.txt';
    MatFileName='ConusBand9CMILatLonGrid.mat';
    RasterLats=zeros(1500,2500);
    RasterLons=zeros(1500,2500);
    maxcount=1500*2500;
elseif(icase==10)
    TextFileName='ConusBand10CMILatLons.txt';
    MatFileName='ConusBand10CMILatLonGrid.mat';
    RasterLats=zeros(1500,2500);
    RasterLons=zeros(1500,2500);
    maxcount=1500*2500;
elseif(icase==11)
    TextFileName='ConusBand11CMILatLons.txt';
    MatFileName='ConusBand11CMILatLonGrid.mat';
    RasterLats=zeros(1500,2500);
    RasterLons=zeros(1500,2500);
    maxcount=1500*2500;
elseif(icase==12)
    TextFileName='ConusBand12CMILatLons.txt';
    MatFileName='ConusBand12CMILatLonGrid.mat';
    RasterLats=zeros(1500,2500);
    RasterLons=zeros(1500,2500);
    maxcount=1500*2500;
elseif(icase==13)
    TextFileName='ConusBand13CMILatLons.txt';
    MatFileName='ConusBand13CMILatLonGrid.mat';
    RasterLats=zeros(1500,2500);
    RasterLons=zeros(1500,2500);
    maxcount=1500*2500;
elseif(icase==14)
    TextFileName='ConusBand14CMILatLons.txt';
    MatFileName='ConusBand14CMILatLonGrid.mat';
    RasterLats=zeros(1500,2500);
    RasterLons=zeros(1500,2500);
    maxcount=1500*2500;
elseif(icase==15)
    TextFileName='ConusBand15CMILatLons.txt';
    MatFileName='ConusBand15CMILatLonGrid.mat';
    RasterLats=zeros(1500,2500);
    RasterLons=zeros(1500,2500);
    maxcount=1500*2500;
elseif(icase==16)
    TextFileName='ConusBand16CMILatLons.txt';
    MatFileName='ConusBand16CMILatLonGrid.mat';
    RasterLats=zeros(1500,2500);
    RasterLons=zeros(1500,2500);
    maxcount=1500*2500;
elseif(icase==17)
    TextFileName='ConusBand01RadLatLons.txt';
    MatFileName='ConusBand1RadLatLonGrid.mat';
    RasterLats=zeros(5000,3000);
    RasterLons=zeros(5000,3000);
    maxcount=5000*3000;
end
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
eval(['cd ' gridpath(1:length(gridpath)-1)]);
%form="%i %s %i %s %10.4f %s %10.4f %s\n"
% RasterLats=zeros(10848,10848);
% RasterLons=zeros(10848,10848);
% maxcount=10848*10848;
nonnan=0;
fid=fopen(TextFileName,'r');
count=0;
while  ~feof(fid)
    tline=fgetl(fid);
    [icomma]=strfind(tline,',');
    numcomma=length(icomma);
    if(numcomma==4)
        is=1;
        ie=icomma(1)-1;
        ival=str2double(tline(is:ie))+1;
        is=ie+2;
        ie=icomma(2)-1;
        jval=str2double(tline(is:ie))+1;
        is=ie+2;
        ie=icomma(3)-1;
        latval=str2double(tline(is:ie));
        is=ie+2;
        ie=icomma(4)-1;
        lonval=str2double(tline(is:ie));
        ab=1;
        if(abs(latval>180))
            latval=NaN;
        else
            nonnan=nonnan+1;
        end
        if(abs(lonval>180))
            lonval=NaN;
        end
        RasterLats(ival,jval)=latval;
        RasterLons(ival,jval)=lonval;
        count=count+1;
        if(mod(count,1000)==0)
            pctread=100*(count/maxcount);
            dispstr=strcat('count=',num2str(count),'-pct read=',num2str(pctread,8));
            disp(dispstr)
            ab=1;
        end
    end
end

fclose(fid);
% Save as a matfile
actionstr='save';
varstr='RasterLats RasterLons';
qualstr='-v7.3';
[cmdString]=MyStrcatV73(actionstr,MatFileName,varstr,qualstr);
eval(cmdString)
dispstr=strcat('Wrote Matlab File-',MatFileName);
disp(dispstr);

