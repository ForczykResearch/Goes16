% Test download from HTTP
% This script is a first attempt to download an entire folder of matlab
% code files from a website
% Written By: Stephen Forczyk
% Created: May 8,2020
% Revised: ----
% Classification: Unclassified
downloadpath='D:\Matlab_Codes\Burkardt_Repository\Matlab\Lagrange_Interp_1D\r8_lib\';
urlstub = 'https://people.sc.fsu.edu/~jburkardt/m_src/r8lib/';
filex = 'https://people.sc.fsu.edu/~jburkardt/m_src/r8lib/';
fullList = webread(filex);
fileext='.m';
[DownLoadFileList] = ParsefullList(fullList,fileext);
%filename = 'c8_sqrt_r8.m';
numfiles=length(DownLoadFileList);
dispstr=strcat('Will need to download-',num2str(numfiles),'-files');
disp(dispstr);
f = waitbar(0,'Please wait while download starts');
pause(2);
for n=1:numfiles
    eval(['cd ' downloadpath(1:length(downloadpath)-1)]);
    filename=char(DownLoadFileList{n,1});
    url=strcat(urlstub,filename);
    outfilename = websave(filename,url);
    dispstr=strcat('Downloaded file=',outfilename);
    disp(dispstr)
    nval=n/numfiles;
    waitbar(nval,f,'Loading your data');
    pause(.5);
end
close(f)