% This script will read a text file to create a full set of Lat/Lon Raster
% coodinates for GOES-16
% Created: August 31,2020
% Written By: Stephen Forczyk
% Revised: -----
% Classification: Unclassified

% Note at present this hardwired for full disk arrays
% which have dimension of 5424 x 5424
global RasterLats RasterLons;
global westEdge eastEdge northEdge southEdge;

global widd2 lend2;
global initialtimestr igrid ijpeg ilog imovie;
global vert1 hor1 widd lend;
global vert2 hor2 machine;
global chart_time;
global Fz1 Fz2;
global idirector mov izoom iwindow;
global matpath GOES16path;
global jpegpath ;
global smhrpath excelpath ascpath datapath;
global ipowerpoint PowerPointFile scaling stretching padding;
global ichartnum;
datapath='D:\Goes16\Grids\';
matpath='D:\Goes16\Forczyk_Python\';
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
icase=2;
if(icase==1)
    RasterLats=ones(300,500);
    RasterLons=ones(300,500);
    GridFileTxtName='CONUSCloudTopHeightBoundaries.txt';
    GridMatFileName='CONUSCloudTopHeightBoundaries.mat';
    FillValue=1;
elseif(icase==2)
    RasterLats=ones(1086,1086);
    RasterLons=ones(1086,1086);
    GridFileTxtName='FullDiskCloudTopHeightBoundaries.txt';
    GridMatFileName='FullDiskCloudTopHeightBoundaries.mat';
    FillValue=1;
end
% RasterLats=ones(5424,5424);
% RasterLons=ones(5424,5424);
eval(['cd ' datapath(1:length(datapath)-1)]);
% [textfilename,path]=uigetfile('*txt','Select One GOES Raster File');%
[fid,errmsg] = fopen(GridFileTxtName);
%tline = fgetl(fid);
ictr=0;
ibadlat=0;
ibadlon=0;
tline='dud';
numbadcomma=0;
while ischar(tline)
%    disp(tline);
    tline = fgetl(fid);
    ictr=ictr+1;
    [icomma]=strfind(tline,',');
    numcomma=length(icomma);
    if(numcomma==4)
        tlen=length(tline);
        is=1;
        ie=icomma(1)-1;
        istr=tline(is:ie);
        i=str2num(istr)+1;
        is=ie+2;
        ie=icomma(2)-1;
        jstr=tline(is:ie);
        j=str2num(jstr)+1;
        is=ie+2;
        ie=icomma(3)-1;
        latstr=tline(is:ie);
        lat=str2num(latstr);
        if(abs(lat)>90)
            lat=NaN;
            ibadlat=ibadlat+1;
        else
            ab=3;
        end
        is=ie+2;
        ie=icomma(4)-1;
        lonstr=tline(is:ie);
        lon=str2num(lonstr);
        if(abs(lon)>500)
            lon=NaN;
            ibadlon=ibadlon+1;
        else
            ab=4;
        end
        ab=1;
        RasterLats(i,j)=lat;
        RasterLons(i,j)=lon;
    else
        numbadcomma=numbadcomma+1;
    end
% There are 2 indices on this line and then a lat and a single lon value
    if(mod(ictr,1000)==0)
        dispstr=strcat('just read line-',num2str(ictr));
        disp(dispstr)
    ab=1;
    end
end
fclose(fid);
dispstr=strcat('File-',GridFileTxtName,'-had-',num2str(ictr),'-lines of data');
disp(dispstr)
% Now calculate the edges
RasterLons2=RasterLons;
RasterLats2=RasterLats;
[nrows,ncols]=size(RasterLats);
for i=1:nrows
    for j=1:ncols
        nowLat=RasterLats(i,j);
        nowLon=RasterLons(i,j);
        if(nowLat==FillValue)
            RasterLats2(i,j)=NaN;
        end
        if(nowLon==FillValue)
            RasterLons2(i,j)=NaN;
        end
    end
end
% These two new arrays exist to remove Fill Values
westEdge1=min(RasterLons2,[],'omitnan');
westEdge=min(westEdge1,[],'omitnan');
eastEdge1=max(RasterLons2,[],'omitnan');
eastEdge=max(eastEdge1,[],'omitnan');
northEdge1=max(RasterLats2,[],'omitnan');
northEdge=max(northEdge1,[],'omitnan');
southEdge1=min(RasterLats2,[],'omitnan');
southEdge=min(southEdge1,[],'omitnan');
%MaFileName='GOES16-FullDisk-Lat-Lon-Boundaries.mat';
eval(['cd ' datapath(1:length(datapath)-1)]);
actionstr='save';
varstr1='RasterLats RasterLons ibadlat ibadlon';
varstr2=' westEdge eastEdge northEdge southEdge';
varstr=strcat(varstr1,varstr2);
qualstr='-v7.3';
[cmdString]=MyStrcatV73(actionstr,GridMatFileName,varstr,qualstr);
eval(cmdString)
dispstr=strcat('Wrote Matlab File-',GridMatFileName);
disp(dispstr);

ab=1;