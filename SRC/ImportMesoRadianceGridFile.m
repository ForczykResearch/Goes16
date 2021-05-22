% This script will import a Meso grid File
% Created: Mar 23,2021
% Revised: March 24,2021 added additional grids for all bands
% Classification: Unclassified
global gridrawfile gridmatfile gridrows gridcols;
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

% additional paths needed for mapping
global gridpath mappath matlabpath USshapefilepath;
icase=26;
if(icase==1)
    gridrawfile='Meso1Band01RadLatLons.txt';
    gridmatfile='Meso1Band01RadLatLons.mat';
    gridrows=1000;
    gridcols=1000;
elseif(icase==2)
    gridrawfile='Meso1Band02RadLatLons.txt';
    gridmatfile='Meso1Band02RadLatLonsGrid.mat';
    gridrows=2000;
    gridcols=2000;
elseif(icase==3)
    gridrawfile='Meso1Band03RadLatLons.txt';
    gridmatfile='Meso1Band03RadLatLonsGrid.mat';
    gridrows=1000;
    gridcols=1000;
elseif(icase==4)
    gridrawfile='Meso1Band04RadLatLons.txt';
    gridmatfile='Meso1Band04RadLatLonsGrid.mat';
    gridrows=500;
    gridcols=500;
elseif(icase==5)
    gridrawfile='Meso1Band05RadLatLons.txt';
    gridmatfile='Meso1Band05RadLatLonsGrid.mat';
    gridrows=1000;
    gridcols=1000;
elseif(icase==6)
    gridrawfile='Meso1Band06RadLatLons.txt';
    gridmatfile='Meso1Band06RadLatLonsGrid.mat';
    gridrows=500;
    gridcols=500;
elseif(icase==7)
    gridrawfile='Meso1Band07RadLatLons.txt';
    gridmatfile='Meso1Band07RadLatLonsGrid.mat';
    gridrows=500;
    gridcols=500;
elseif(icase==8)
    gridrawfile='Meso1Band08RadLatLons.txt';
    gridmatfile='Meso1Band08RadLatLonsGrid.mat';
    gridrows=500;
    gridcols=500;
elseif(icase==9)
    gridrawfile='Meso1Band09RadLatLons.txt';
    gridmatfile='Meso1Band09RadLatLonsGrid.mat';
    gridrows=500;
    gridcols=500;
elseif(icase==10)
    gridrawfile='Meso1Band10RadLatLons.txt';
    gridmatfile='Meso1Band10RadLatLonsGrid.mat';
    gridrows=500;
    gridcols=500;
elseif(icase==11)
    gridrawfile='Meso1Band11RadLatLons.txt';
    gridmatfile='Meso1Band11RadLatLonsGrid.mat';
    gridrows=500;
    gridcols=500;
elseif(icase==12)
    gridrawfile='Meso1Band12RadLatLons.txt';
    gridmatfile='Meso1Band12RadLatLonsGrid.mat';
    gridrows=500;
    gridcols=500;
elseif(icase==13)
    gridrawfile='Meso1Band13RadLatLons.txt';
    gridmatfile='Meso1Band13RadLatLonsGrid.mat';
    gridrows=500;
    gridcols=500;
elseif(icase==14)
    gridrawfile='Meso1Band14RadLatLons.txt';
    gridmatfile='Meso1Band14RadLatLonsGrid.mat';
    gridrows=500;
    gridcols=500;
elseif(icase==15)
    gridrawfile='Meso1Band15RadLatLons.txt';
    gridmatfile='Meso1Band15RadLatLonsGrid.mat';
    gridrows=500;
    gridcols=500;
elseif(icase==16)
    gridrawfile='Meso1Band16RadLatLons.txt';
    gridmatfile='Meso1Band16RadLatLonsGrid.mat';
    gridrows=500;
    gridcols=500;
elseif(icase==17)
    gridrawfile='Meso2Band01RadLatLons.txt';
    gridmatfile='Meso2Band01RadLatLons.mat';
    gridrows=1000;
    gridcols=1000;
elseif(icase==18)
    gridrawfile='Meso2Band02RadLatLons.txt';
    gridmatfile='Meso2Band02RadLatLonsGrid.mat';
    gridrows=2000;
    gridcols=2000;
elseif(icase==19)
    gridrawfile='Meso2Band03RadLatLons.txt';
    gridmatfile='Meso2Band03RadLatLonsGrid.mat';
    gridrows=1000;
    gridcols=1000;
elseif(icase==20)
    gridrawfile='Meso2Band04RadLatLons.txt';
    gridmatfile='Meso2Band04RadLatLonsGrid.mat';
    gridrows=500;
    gridcols=500;
elseif(icase==21)
    gridrawfile='Meso2Band05RadLatLons.txt';
    gridmatfile='Meso2Band05RadLatLonsGrid.mat';
    gridrows=1000;
    gridcols=1000;
elseif(icase==22)
    gridrawfile='Meso2Band06RadLatLons.txt';
    gridmatfile='Meso2Band06RadLatLonsGrid.mat';
    gridrows=500;
    gridcols=500;
elseif(icase==23)
    gridrawfile='Meso2Band07RadLatLons.txt';
    gridmatfile='Meso2Band07RadLatLonsGrid.mat';
    gridrows=500;
    gridcols=500;
elseif(icase==24)
    gridrawfile='Meso2Band08RadLatLons.txt';
    gridmatfile='Meso2Band08RadLatLonsGrid.mat';
    gridrows=500;
    gridcols=500;
elseif(icase==25)
    gridrawfile='Meso2Band09RadLatLons.txt';
    gridmatfile='Meso2Band09RadLatLonsGrid.mat';
    gridrows=500;
    gridcols=500;
elseif(icase==26)
    gridrawfile='CMIMeso1RasterBand4.txt';
    gridmatfile='CMIMeso1RasterBand4.mat';
    gridrows=500;
    gridcols=500;
end
RasterLats=zeros(gridrows,gridcols);
RasterLons=zeros(gridrows,gridcols);
gridpath='D:\Goes16\Grids\';
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
% Now open the selected raw grid file for reading
fid=fopen(gridrawfile,'r');
if(fid>0)
    dispstr=strcat('File-',gridrawfile,'-opened for reading');
    disp(dispstr);
else
    dispstr=strcat('File-',gridrawfile,'-Could not be opened for reading');
    disp(dispstr);
end
if(fid>0)
    icounter=0;
    while 1
        tline = fgetl(fid);
        if ~ischar(tline), break, end
        icounter=icounter+1;
        tlen=length(tline);
        [icomma]=strfind(tline,',');
        numcomma=length(icomma);
        is=1;
        ie=icomma(1)-1;
        nr=str2num(tline(is:ie))+1;
        is=ie+2;
        ie=icomma(2)-1;
        nc=str2num(tline(is:ie))+1;
        is=ie+2;
        ie=icomma(3)-1;
        lat=str2num(tline(is:ie));
        is=ie+2;
        ie=icomma(4)-1;
        lon=str2num(tline(is:ie));
        RasterLats(nr,nc)=lat;
        RasterLons(nr,nc)=lon;
        if(mod(icounter,1000)==0)
            dispstr=strcat('Reading record=',num2str(icounter));
            disp(dispstr)
        end
        ab=1;
        
    end
    fclose(fid);
% Now save the data
actionstr='save';
varstr='RasterLats RasterLons';
qualstr='-v7.3';
[cmdString]=MyStrcat(actionstr,gridmatfile,varstr);
eval(cmdString)
dispstr=strcat('Saved Matlab File-',gridmatfile);
disp(dispstr);
ab=1;
end