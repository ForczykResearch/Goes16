% This routine will get a quick analysis of the program source code
% Written By: Stephen Forczyk
% Created: Dec 24,2020
% Revised: Mar 31,2021 added pList to get toolboxes required
% Classification: Unclassified
clc
global fid;
global widd2 lend2;
global initialtimestr igrid ijpeg ilog imovie;
global vert1 hor1 widd lend;
global vert2 hor2 machine;
global chart_time;
global Fz1 Fz2;
global idirector mov izoom iwindow;
global matpath codepath;
global jpegpath tiffpath;
global smhrpath excelpath ascpath;
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
codepath='D:\Goes16\Code\';

S=which('ReadGOES16Datasets.m');
[pathstr,name,ext]=fileparts(S);
% Get a list of all files in this directory
[FullFileList] = getfilelist(pathstr,'.m',0);
numallfiles=length(FullFileList);
outstr1=strcat('number of all code files in code folder-',num2str(numallfiles));
disp(outstr1);
options.complete=1;
options.recursive=0;
iprint=0;
stats = program_statistics(pathstr,options,iprint);
outstr1='Results of program statistics run follows';
disp(outstr1)
outstr1=strcat('number of files is code folder-',num2str(stats.files),'-code folder path-',pathstr);
disp(outstr1)
outstr1=strcat('lines of code in these files-',num2str(stats.lines));
disp(outstr1);
outstr1=strcat('functions in these files-',num2str(stats.functions));
disp(outstr1);
outstr1='now analyzing code dependencies-this could take a minute or two';
disp(outstr1);
[fList,pList] = matlab.codetools.requiredFilesAndProducts('ReadGOES16Datasets.m');
fList=fList';
numfiles=length(fList);
outstr1=strcat('Found a total of -',num2str(numfiles),'-files needed to run this package');
disp(outstr1)
% Now see how many are in this folder
MissingFiles=cell(1,1);
imissing=0;
for n=1:numfiles
    nowFile=fList{n,1};
   [nowpath,shortname,ext]=fileparts(nowFile);
% compare this to the desired path and if not equal flag this
    a1=strcmp(pathstr,nowpath);
    if(a1<1)
        imissing=imissing+1;
        MissingFiles{imissing,1}=nowFile;
        outstr1=strcat('File-',shortname,'-is not in desired folder and is located at-',nowpath);
        disp(outstr1);
    end
end
outstr1=strcat('Total number of files outside of desired folder is-',num2str(imissing));
disp(outstr1)
% Now get the required toolboxes
numtoolboxes=length(pList');
ab=1;