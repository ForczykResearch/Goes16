% This script will read a shapefile and extract data from it
% This script is targeted a shapefiles containing POI data
% Written By: Stephen Forczyk
% Created: Oct4,2020
% Revised: --- 
% Classification: Unclassified/Public Domain
global Category NAMES;
global UniqueCategoryCount;

global widd2 lend2;
global initialtimestr igrid ijpeg ilog imovie;
global vert1 hor1 widd lend;
global vert2 hor2 machine;
global chart_time;
global Fz1 Fz2;
global idirector mov izoom iwindow;
global matpath GOES16path;
global jpegpath ;
global shapefilepath excelpath ascpath;
global ipowerpoint PowerPointFile scaling stretching padding;
global ichartnum;
Category=cell(1,1);
NAME=cell(1,1);

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
suffix='.shp';
outputFlag=0;
eval(['cd ' shapefilepath(1:length(shapefilepath)-1)]);
[FileList] = getfilelist(pwd, suffix, outputFlag );
numfiles=length(FileList);
ShortFileList=cell(numfiles,1);
for n=1:numfiles
    nowFile=FileList{n,1};
    [filepath,name,ext] = fileparts(nowFile);
    ShortFileList{n,1}=strcat(name,ext);
    ab=1;
end
[indx,tf] = listdlg('PromptString',{'Select type of data to read'},...
    'SelectionMode','single','ListString',ShortFileList,'ListSize',[360,300]);
a1=isempty(indx);
if(a1~=1)
    shapefilename=ShortFileList{indx,1};
    dispstr=strcat('Will open shapefile-',shapefilename,'-for reading');
    disp(dispstr)
    % Now open this shapefile
    S1=shaperead(shapefilename,'UseGeoCoords',true);
    [numrows,numcols]=size(S1);
    names=fieldnames(S1);
    numfields=length(names);
    dispstr=strcat('File had-',num2str(numrows),'-and-',num2str(numfields),'-fields of data');
    disp(dispstr)
% Now List the available fields
    for n=1:numfields
        nowField=char(names{n,1});
        dispstr=strcat('Field-',num2str(n),'-named-',nowField);
        disp(dispstr)       
    end
    for j=1:numrows
        nowCategory=char(S1(j,1).CATEGORY);
        Category{j,1}=nowCategory;
        ab=2;
    end
    uniqueCategoryTypes=unique(Category);
    numuniqueCategories=length(uniqueCategoryTypes);
    UniqueCategoryCount=cell(numuniqueCategories,4);
    ab=1;
% Now find out how items in each Category Exist
    for i=1:numuniqueCategories % Cycle over the unique Cataegory types
        tgtRowType=char(uniqueCategoryTypes{i,1});
        icounter=0;
        ipts=0;
        inamed=0;
        for j=1:numrows % cycle over each row
            nowCategoryType=char(Category{j,1});
            a1=strcmp(tgtRowType,nowCategoryType);
            if(a1==1)
               icounter=icounter+1; 
               nowpts=length(S1(j,1).Lon);
               nowCategory=S1(j,1).CATEGORY;
               a2=isempty(nowCategory);
               if(a2==1)
                   namelen=0;
               else
                   namelen=length(nowCategory);
                   inamed=inamed+1;
               end
               ipts=ipts+nowpts;
            end
        end
        UniqueCategoryCount{i,1}=tgtRowType;
        UniqueCategoryCount{i,2}=icounter;
        UniqueCategoryCount{i,3}=ipts/icounter;
        UniqueCategoryCount{i,4}=inamed;
        dispstr=strcat('CategoryType-',tgtRowType,'-had-',num2str(icounter),'-cases');
        disp(dispstr)
    end
% Now find out how many unqiue names there are
  for j=1:numrows
      NAMES{j,1}=char(S1(j).NAME);
  end
  uniqueNames=unique(NAMES);
  numuniqueNames=length(uniqueNames);
  ab=2;
  for k=1:icounter
      FinalIndexList(k,1)=IndexList(k,1);
  end
  clear S1
% Now try reading a file that is using a road selector
    roadselector = {@roadfilter, 'primary'};
    S2=shaperead(shapefilename,'RecordNumbers',FinalIndexList,'UseGeoCoords',true);
end
newshapefilename=strcat('main_',shapefilename);
shapewrite(S2,newshapefilename);
ab=1;