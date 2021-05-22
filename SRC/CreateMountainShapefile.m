% Create a New shapeFile for just mounts
% Thsi routine will read a shapefile create a new smaller shapefile with
% just peaks on it along with their heights
% Written By: Stephen Forczyk
% Created: Oct 11,2020
% Revised: Oct13,2020 added cases for all 50 states
% Classification: Unclassified
clc
global statefipsfile;

global widd2 lend2;
global initialtimestr igrid ijpeg ilog imovie;
global vert1 hor1 widd lend;
global vert2 hor2 machine;
global chart_time;
global Fz1 Fz2;
global idirector mov izoom iwindow;
global matpath GOES16path;
global jpegpath statefipspath shapefilepath;
global shapefilepath excelpath ascpath;
global ipowerpoint PowerPointFile scaling stretching padding;
global ichartnum;

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
shapefilepath='D:\Forczyk\Map_Data\USStateShapeFiles\';
statefipspath='D:\Forczyk\Map_Data\MAT_Files_Geographic\';
inputshapefile='cb_2018_us_ua10_500k.shp';
outputshapefile='cb_2018_us_ua10M_500k.shp';
statefipsfile='StateFipCodeData.mat';
tic;
icase=13;
if(icase==1)%ok
    inputshapefile='alabama_poi.shp';
    outputshapefile='alabama_mountains.shp';
elseif(icase==2)% Failed different structure
    inputshapefile='alaska_poi.shp';
    outputshapefile='alaska_mountains.shp';
elseif(icase==4)%ok
    inputshapefile='arizona_poi.shp';
    outputshapefile='arizona_mountains.shp';
elseif(icase==5)% ok
    inputshapefile='arkansas_poi.shp';
    outputshapefile='arkansas_mountains.shp';
elseif(icase==6)%ok
    inputshapefile='california_poi.shp';
    outputshapefile='california_mountains.shp';
elseif(icase==8)%ok
    inputshapefile='colorado_poi.shp';
    outputshapefile='colorado_mountains.shp';
elseif(icase==9)% Ok
    inputshapefile='connecticut_poi.shp';
    outputshapefile='connecticut_mountains.shp';
elseif(icase==10)% Almost no mountains !
    inputshapefile='delaware_poi.shp';
    outputshapefile='delaware_mountains.shp';
elseif(icase==12)% Ok
    inputshapefile='florida_poi.shp';
    outputshapefile='florida_mountains.shp';
elseif(icase==13)% Ok
    inputshapefile='georgia_poi.shp';
    outputshapefile='georgia_mountains.shp';
elseif(icase==15)%ok
    inputshapefile='hawaii_poi.shp';
    outputshapefile='hawaii_mountains.shp';
elseif(icase==16)%ok
    inputshapefile='idaho_poi.shp';
    outputshapefile='idaho_mountains.shp';
elseif(icase==17)% ok
    inputshapefile='illinois_poi.shp';
    outputshapefile='illinois_mountains.shp';
elseif(icase==18)% %ok
    inputshapefile='indiana_poi.shp';
    outputshapefile='indiana_mountains.shp';
elseif(icase==19)% ok
    inputshapefile='iowa_poi.shp';
    outputshapefile='iowa_mountains.shp';
elseif(icase==20)% Ok
    inputshapefile='kansas_poi.shp';
    outputshapefile='kansas_mountains.shp';
elseif(icase==21)% Ok
    inputshapefile='kentucky_poi.shp';
    outputshapefile='kentucky_mountains.shp';
elseif(icase==22)%ok
    inputshapefile='louisiana_poi.shp';
    outputshapefile='louisina_mountains.shp';
elseif(icase==23)%ok
    inputshapefile='maine_poi.shp';
    outputshapefile='maine_mountains.shp';
elseif(icase==24)%ok
    inputshapefile='maryland_poi.shp';
    outputshapefile='maryland_mountains.shp';
elseif(icase==25)% Ok
    inputshapefile='massachusetts_poi.shp';
    outputshapefile='massachusetts_mountains.shp';
elseif(icase==26)% ok
    inputshapefile='michigan_poi.shp';
    outputshapefile='michigan_mountains.shp';
elseif(icase==27)% ok
    inputshapefile='minnesota_poi.shp';
    outputshapefile='minnesota_mountains.shp';
elseif(icase==28)% ok
    inputshapefile='mississippi_poi.shp';
    outputshapefile='mississipi_mountains.shp';
elseif(icase==29)% ok
    inputshapefile='missouri_poi.shp';
    outputshapefile='missouri_mountains.shp';
elseif(icase==30)% 
    inputshapefile='montana_poi.shp';
    outputshapefile='montana_mountains.shp';
elseif(icase==31)% Ok
    inputshapefile='nebraska_poi.shp';
    outputshapefile='nebraska_mountains.shp';
elseif(icase==32)% ok
    inputshapefile='nevada_poi.shp';
    outputshapefile='nevada_mountains.shp';
elseif(icase==33)% Ok
    inputshapefile='new_hampshire_poi.shp';
    outputshapefile='new_hampshire_mountains.shp';
elseif(icase==34)% Ok
    inputshapefile='new_jersey_poi.shp';
    outputshapefile='new_jersey_mountains.shp';
elseif(icase==35)% Ok
    inputshapefile='new_mexico_poi.shp';
    outputshapefile='new_mexico_mountains.shp';
elseif(icase==36)% Ok
    inputshapefile='new_york_poi.shp';
    outputshapefile='new_york_mountains.shp';
elseif(icase==37)% Ok
    inputshapefile='north_carolina_poi.shp';
    outputshapefile='north_carolina_mountains.shp';
elseif(icase==38)% Ok
    inputshapefile='north_dakota_poi.shp';
    outputshapefile='north_dakota_mountains.shp';
elseif(icase==39)% Ok
    inputshapefile='ohio_poi.shp';
    outputshapefile='ohio_mountains.shp';
elseif(icase==40)% Ok
    inputshapefile='oklahoma_poi.shp';
    outputshapefile='oklahoma_mountains.shp';
elseif(icase==41)% Ok
    inputshapefile='oregon_poi.shp';
    outputshapefile='oregon_mountains.shp';
elseif(icase==42)% Ok
    inputshapefile='pennsylvania_poi.shp';
    outputshapefile='pennsylvania_mountains.shp';
elseif(icase==44)% Ok
    inputshapefile='rhode_island_poi.shp';
    outputshapefile='rhode_island_mountains.shp';
elseif(icase==45)% Ok
    inputshapefile='south_carolina_poi.shp';
    outputshapefile='south_carolina_mountains.shp';
elseif(icase==46)% Ok
    inputshapefile='south_dakota_poi.shp';
    outputshapefile='south_dakota_mountains.shp';
elseif(icase==47)% Ok
    inputshapefile='tennessee_poi.shp';
    outputshapefile='tennessee_mountains.shp';
elseif(icase==48)% Ok
    inputshapefile='texas_poi.shp';
    outputshapefile='texas_mountains.shp';
elseif(icase==49)% Ok
    inputshapefile='utah_poi.shp';
    outputshapefile='utah_mountains.shp';
elseif(icase==50)% Ok
    inputshapefile='vermont_poi.shp';
    outputshapefile='vermont_mountains.shp';
elseif(icase==51)% Ok
    inputshapefile='virginia_poi.shp';
    outputshapefile='virginia_mountains.shp';
elseif(icase==53)% Ok
    inputshapefile='washington_poi.shp';
    outputshapefile='washington_mountains.shp';
elseif(icase==54)% Ok
    inputshapefile='west_virginia_poi.shp';
    outputshapefile='west_virginia_mountains.shp';
elseif(icase==55)% Ok
    inputshapefile='wisconsin_poi.shp';
    outputshapefile='wisconsin_mountains.shp';
elseif(icase==56)% Ok
    inputshapefile='wyoming_poi.shp';
    outputshapefile='wyoming_mountains.shp';
end
% Load the state fips code data
eval(['cd ' statefipspath(1:length(statefipspath)-1)]);
load(statefipsfile);
% Load in the original shapefile
eval(['cd ' shapefilepath(1:length(shapefilepath)-1)]);
S1=shaperead(inputshapefile,'UseGeoCoords',true);
numrecords=length(S1);
dispstr=strcat('numrecords in this file-',num2str(numrecords));
disp(dispstr)
S2=struct('Geometry',[],'Lon',[],'Lat',[],'CATEGORY',[],'NAME',[],'StateFIPS',[],'ShortName',[],'Height',[]);
S3=struct('Geometry',[],'Lon',[],'Lat',[],'CATEGORY',[],'NAME',[],'StateFIPS',[],'ShortName',[],'Height',[]);
% Get the state FIPS code
fipslen=length(StateFIPSCodes);
[iunder]=strfind(inputshapefile,'_');
numunder=length(iunder);
if(numunder==1)
    stateName=inputshapefile(1:iunder-1);    
end
imatchstate=0;
for n=1:fipslen
    listState=lower(char(StateFIPSCodes{n,1}));
    a1=strcmpi(listState,stateName);
    if(n>35)
        ab=1;
    end
    if(a1==1)
        imatchstate=n;
        stateFIPS=StateFIPSCodes{n,3};
    end
end
ab=1;
ind=0;
olddtedfile='Dummy';
waitstr=strcat('Reading Mountain Peaks-',RemoveUnderScores(inputshapefile));
h=waitbar(0,waitstr);
for n=1:numrecords
   Category=char(S1(n).CATEGORY);
   namelen=length(Category);
   a1=strcmp(Category,'Tourism');
   if(a1==1)
       Name=char(S1(n).NAME);
       a2=strfind(Name,'Peak:');
       namelen=length(Name);
       a3=isempty(a2);
       if(a3==0)
           ind=ind+1;
           S2(ind).Geometry=S1(n).Geometry;
           S2(ind).Lon=S1(n).Lon;
           S2(ind).Lat=S1(n).Lat;
           LatC=S1(n).Lat;
           LonC=S1(n).Lon;
           S2(ind).CATEGORY=S1(n).CATEGORY;
           S2(ind).NAME=S1(n).NAME;
           S2(ind).StateFIPS=stateFIPS;
           is=a2(1)+5;
           ie=namelen;
           ShortName=Name(is:ie);
           shortlen=length(ShortName);
           a4=strfind(ShortName,'Mountain');
           a5=isempty(a4);
           if(a5==0)
              is=1;
              ie=a4(1)-1;
              prefix=ShortName(is:ie);
              centerstr='-Mt';
              is=a4(1)+8;
              ie=shortlen;
              suffix=ShortName(is:ie);
              newstr=strcat(prefix,centerstr,suffix);
              ab=2;
              ShortName=newstr;
              ab=3;
           end
           shortlen=length(ShortName);
           a4=strfind(ShortName,'Mount');
           a5=isempty(a4);
           if(a5==0)
              is=1;
              ie=a4(1)-1;
              prefix=ShortName(is:ie);
              centerstr='Mt-';
              is=a4(1)+5;
              ie=shortlen;
              suffix=ShortName(is:ie);
              newstr=strcat(prefix,centerstr,suffix);
              ab=2;
              ShortName=newstr;
              ab=3;
           end
           shortlen=length(ShortName);
           a4=strfind(ShortName,'Peak');
           a5=isempty(a4);
           if(a5==0)
              is=1;
              ie=a4(1)-1;
              prefix=ShortName(is:ie);
              centerstr='-Pk';
              is=a4(1)+5;
              ie=shortlen;
              suffix=ShortName(is:ie);
              newstr=strcat(prefix,centerstr,suffix);
              ab=2;
              ShortName=newstr;
              ab=3;
           end
           shortlen=length(ShortName);
           if(shortlen>12)
               ShortName=ShortName(1:12);
           end
           S2(ind).ShortName=ShortName;
           latlim=[floor(LatC)+.01 ceil(LatC)-.01];
           lonlim=[floor(LonC)+.01 ceil(LonC)-.01];
           dtedfiles=dteds(latlim,lonlim,1);
           % assign correct full file paths to each of these files
           numdted=length(dtedfiles);
           FullDTEDFilePaths=cell(numdted,1);
           prefix='F:\DTED\';
           for jj=1:numdted
                nowpath=char(dtedfiles{jj,1});
                nowlen=length(nowpath);
                [islash]=strfind(nowpath,'\');
                numslash=length(islash);
                longstr=nowpath(islash(1)+1:islash(2)-1);
                longstr2=upper(longstr);
                filestr=nowpath(islash(2)+1:nowlen);
                finalpath=strcat(prefix,longstr2,'\',filestr);
                FullDTEDFilePaths{jj,1}=finalpath;
           end
           dtedfile=char(FullDTEDFilePaths{1,1});
           a4=strcmp(olddtedfile,dtedfile);
           if(a4==0)
               [Z,R] = readgeoraster(dtedfile,'OutputType','double');
               [latRef,lonRef] = meshgrat(Z,R);
               [PeakHeight,indLat,indLon] = GetFireHeightFromDEM(LatC,LonC,latRef,lonRef,Z);
               olddtedfile=dtedfile;
           else
               [PeakHeight,indLat,indLon] = GetFireHeightFromDEM(LatC,LonC,latRef,lonRef,Z);
           end
           if(PeakHeight<0)
               PeakHeight=0;
           end
           S2(ind).Height=PeakHeight;
       end
   end

   ab=1;
   waitbar(n/numrecords);
end % Loop over all records
close(h);

numpeaks=ind;
% Collect some data on the mountains
MountainHeights=zeros(numpeaks,1);
for n=1:numpeaks
    nowHeight=S2(n).Height;
    MountainHeights(n,1)=nowHeight;
end
% Now reorder the peaks in descending height
[SortedMountainHeights,inds]=sort(MountainHeights,'descend');
igo=1;
n=0;
while igo>0
    n=n+1;
    ind=inds(n);
    S3(n).Geometry=S2(ind).Geometry;
    S3(n).Lon=S2(ind).Lon;
    S3(n).Lat=S2(ind).Lat;
    S3(n).CATEGORY=S2(ind).CATEGORY;
    S3(n).NAME=S2(ind).NAME;
    nowName=char(S2(ind).NAME);
    nowHeight=S2(ind).Height;
    S3(n).StateFIPS=S2(ind).StateFIPS;
    S3(n).ShortName=S2(ind).ShortName;
    S3(n).Height=S2(ind).Height;
%     dispstr=strcat('n=',num2str(n),'-ind=',num2str(ind),'-nowName=',nowName,...
%         '-nowHeight=',num2str(nowHeight));
%     disp(dispstr);
    if(nowHeight<100)
        igo=0;
    end
    if(n>=numpeaks)
        igo=0;
    end
    ab=2;
end
ab=1;
figure
hist(SortedMountainHeights,20);
% titlestr=RemoveUnderScores(outputshapefile);
% title(titlestr)
pause(5);
close()
% Now write this new file
eval(['cd ' shapefilepath(1:length(shapefilepath)-1)]);
shapewrite(S3,outputshapefile);
dispstr=strcat('Wrote new shapefile-',outputshapefile);
disp(dispstr)
elapsed_time=toc;
dispstr=strcat('Run Took=',num2str(elapsed_time),'-sec');
disp(dispstr);
ab=2;