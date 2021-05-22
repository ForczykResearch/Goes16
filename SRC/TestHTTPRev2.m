% Test download from HTTP-Rev2 is designed to use a select case
% Loop to allow the user to pick specific download parameters for each case
% Rev1 version stopped worked tried some suggested mathworks changes
% This sort of works but does dispaly unwanted output to screen-files
% appear to be useable
% Written By: Stephen Forczyk
% Created: May 31,2020
% Revised: ----
% Classification: Unclassified
clc
global downloadpath urlstub filex fileext
icase=37;
options=weboptions;

options.Timeout=50;
options.CertificateFilename=("");
%'options.RequestMethod=("POST");
if(icase==1)
    downloadpath='D:\Matlab_Codes\Burkardt_Repository\Matlab\Lagrange_Interp_1D\r8_lib\';
    urlstub = 'https://people.sc.fsu.edu/~jburkardt/m_src/r8lib/';
    filex = 'https://people.sc.fsu.edu/~jburkardt/m_src/r8lib/';
    fileext='.m';
elseif(icase==2)
    downloadpath='D:\Matlab_Codes\Burkardt_Repository\Matlab\Polpak\';
    urlstub='https://people.sc.fsu.edu/~jburkardt/m_src/polpak/';
    filex='https://people.sc.fsu.edu/~jburkardt/m_src/polpak/';
    fileext='.m';
elseif(icase==3)
    downloadpath='D:\Matlab_Codes\Burkardt_Repository\Matlab\Polpak\';
    urlstub='https://people.sc.fsu.edu/~jburkardt/m_src/polpak_test/';
    filex='https://people.sc.fsu.edu/~jburkardt/m_src/polpak_test/';
    fileext='.m';
elseif(icase==4)
    downloadpath='D:\Matlab_Codes\Burkardt_Repository\Python\Polpak\';
    urlstub='https://people.sc.fsu.edu/~jburkardt/py_src/polpak/';
    filex='https://people.sc.fsu.edu/~jburkardt/py_src/polpak/';
    fileext='.py';
elseif(icase==5)
    downloadpath='D:\Matlab_Codes\Burkardt_Repository\Matlab\Polygon_Properties\';
    urlstub='https://people.sc.fsu.edu/~jburkardt/m_src/polygon_properties/';
    filex='https://people.sc.fsu.edu/~jburkardt/m_src/polygon_properties//';
    fileext='.m';
elseif(icase==6)
    downloadpath='D:\Matlab_Codes\Burkardt_Repository\Matlab\Polygon_Properties\';
    urlstub='https://people.sc.fsu.edu/~jburkardt/m_src/polygon_properties_test//';
    filex='https://people.sc.fsu.edu/~jburkardt/m_src/polygon_properties_test/';
    fileext='.m';
elseif(icase==7)
    downloadpath='D:\Matlab_Codes\Burkardt_Repository\Python\Polygon_Properties\';
    urlstub='https://people.sc.fsu.edu/~jburkardt/py_src/polygon_properties//';
    filex='https://people.sc.fsu.edu/~jburkardt/py_src/polygon_properties/';
    fileext='.py';
elseif(icase==8)
    downloadpath='D:\Matlab_Codes\Burkardt_Repository\Python\py_test\';
    urlstub='https://people.sc.fsu.edu/~jburkardt/py_src/py_test/';
    filex='https://people.sc.fsu.edu/~jburkardt/py_src/py_test/';
    fileext='.py';
elseif(icase==9)
    downloadpath='D:\Matlab_Codes\Burkardt_Repository\Matlab\py_test\';
    urlstub='https://people.sc.fsu.edu/~jburkardt/m_src/matlab/';
    filex='https://people.sc.fsu.edu/~jburkardt/m_src/matlab/';
    fileext='.m';
elseif(icase==10)
    downloadpath='D:\Matlab_Codes\Burkardt_Repository\Fortran\py_test\';
    urlstub='https://people.sc.fsu.edu/~jburkardt/f_src/f90/';
    filex='https://people.sc.fsu.edu/~jburkardt/f_src/f90/';
    fileext='.f90';
elseif(icase==11)
    downloadpath='D:\Matlab_Codes\Burkardt_Repository\Matlab\Quadrule\';
    urlstub='https://people.sc.fsu.edu/~jburkardt/m_src/quadrule/';
    filex='https://people.sc.fsu.edu/~jburkardt/m_src/quadrule/';
    fileext='.m';
elseif(icase==12)
    downloadpath='D:\Matlab_Codes\Burkardt_Repository\Matlab\Quadrule\';
    urlstub='https://people.sc.fsu.edu/~jburkardt/m_src/quadrule_test/';
    filex='https://people.sc.fsu.edu/~jburkardt/m_src/quadrule_test/';
    fileext='.m';
elseif(icase==13)
    downloadpath='D:\Matlab_Codes\Burkardt_Repository\Python\Quadrule\';
    urlstub='https://people.sc.fsu.edu/~jburkardt/py_src/quadrule/';
    filex='https://people.sc.fsu.edu/~jburkardt/py_src/quadrule/';
    fileext='.py';
elseif(icase==14)
    downloadpath='D:\Matlab_Codes\Burkardt_Repository\Matlab\Random_Data\';
    urlstub='https://people.sc.fsu.edu/~jburkardt/m_src/random_data/';
    filex='https://people.sc.fsu.edu/~jburkardt/m_src/random_data/';
    fileext='.m';
elseif(icase==15)
    downloadpath='D:\Matlab_Codes\Burkardt_Repository\Matlab\Random_Data\';
    urlstub='https://people.sc.fsu.edu/~jburkardt/m_src/random_data_test/';
    filex='https://people.sc.fsu.edu/~jburkardt/m_src/random_data_test/';
    fileext='.m';
elseif(icase==16)
    downloadpath='D:\Matlab_Codes\Burkardt_Repository\Matlab\Quarternion\';
    urlstub='https://people.sc.fsu.edu/~jburkardt/py_src/quaternions/';
    filex='https://people.sc.fsu.edu/~jburkardt/py_src/quaternions/';
    fileext='.m';
elseif(icase==17)
    downloadpath='D:\Matlab_Codes\Burkardt_Repository\Python\Quarternion\';
    urlstub='https://people.sc.fsu.edu/~jburkardt/py_src/quaternions/';
    filex='https://people.sc.fsu.edu/~jburkardt/py_src/quaternions/';
    fileext='.py';
elseif(icase==18)
    downloadpath='D:\Matlab_Codes\Burkardt_Repository\Matlab\Stochastic_Diffusion\';
    urlstub='https://people.sc.fsu.edu/~jburkardt/m_src/stochastic_diffusion_test/';
    filex='https://people.sc.fsu.edu/~jburkardt/m_src/stochastic_diffusion_test/';
    fileext='.m';
elseif(icase==19)
    downloadpath='D:\Matlab_Codes\Burkardt_Repository\Python\Stochastic_Diffusion\';
    urlstub='https://people.sc.fsu.edu/~jburkardt/py_src/stochastic_diffusion/';
    fileext='.py';
elseif(icase==20)
    downloadpath='D:\Matlab_Codes\Burkardt_Repository\Python\Stokes_2D_Exact\';
    urlstub='https://people.sc.fsu.edu/~jburkardt/py_src/stokes_2d_exact/';
    fileext='.py';
elseif(icase==21)
    downloadpath='D:\Matlab_Codes\Burkardt_Repository\Matlab\Table_IO\';
    urlstub='https://people.sc.fsu.edu/~jburkardt/m_src/table_io/';
    fileext='.m';
elseif(icase==22)
    downloadpath='D:\Matlab_Codes\Burkardt_Repository\Matlab\Table_IO\';
    urlstub='https://people.sc.fsu.edu/~jburkardt/m_src/table_io_test/';
    fileext='.m';
elseif(icase==23)
    downloadpath='D:\Matlab_Codes\Burkardt_Repository\Python\Table_IO\';
    urlstub='https://people.sc.fsu.edu/~jburkardt/py_src/table_io/';
    fileext='.py';
elseif(icase==24)
    downloadpath='D:\Matlab_Codes\Burkardt_Repository\Matlab\Test_Interp\';
    urlstub='https://people.sc.fsu.edu/~jburkardt/m_src/test_interp/';
    fileext='.m';
elseif(icase==25)
    downloadpath='D:\Matlab_Codes\Burkardt_Repository\Matlab\ISBN\';
    urlstub='https://people.sc.fsu.edu/~jburkardt/m_src/isbn/';
    fileext='.m';
elseif(icase==26)
    downloadpath='D:\Matlab_Codes\Burkardt_Repository\Matlab\blas_2d\';
    urlstub='https://people.sc.fsu.edu/~jburkardt/m_src/blas2_d/';
    fileext='.m';
elseif(icase==27)
    downloadpath='D:\Matlab_Codes\Burkardt_Repository\Matlab\pdflib\';
    urlstub='https://people.sc.fsu.edu/~jburkardt/m_src/pdflib/';
    fileext='.m';
elseif(icase==28)
    downloadpath='D:\Matlab_Codes\Burkardt_Repository\Matlab\pdflib\';
    urlstub='https://people.sc.fsu.edu/~jburkardt/m_src/rnglib/';
    fileext='.m';
elseif(icase==29)
    downloadpath='D:\Matlab_Codes\Burkardt_Repository\Python\pdflib\';
    urlstub='https://people.sc.fsu.edu/~jburkardt/py_src/pdflib/';
    fileext='.py';
elseif(icase==30)
    downloadpath='D:\Matlab_Codes\Burkardt_Repository\Matlab\Prob\';
    urlstub='https://people.sc.fsu.edu/~jburkardt/m_src/prob/';
    fileext='.m';
elseif(icase==31)
    downloadpath='D:\Matlab_Codes\Burkardt_Repository\Matlab\Prob\';
    urlstub='https://people.sc.fsu.edu/~jburkardt/m_src/prob_test/';
    fileext='.m';
elseif(icase==32)
    downloadpath='D:\Matlab_Codes\Burkardt_Repository\Python\Prob\';
    urlstub='https://people.sc.fsu.edu/~jburkardt/py_src/prob/';
    fileext='.py';
elseif(icase==33)
    downloadpath='D:\Matlab_Codes\Burkardt_Repository\Matlab\SFTPack\';
    urlstub='https://people.sc.fsu.edu/~jburkardt/m_src/sftpack/';
    fileext='.m';
elseif(icase==34)
    downloadpath='D:\Matlab_Codes\Burkardt_Repository\Matlab\SFTPack\';
    urlstub='https://people.sc.fsu.edu/~jburkardt/m_src/sftpack_test/';
    fileext='.m';
elseif(icase==35)
    downloadpath='D:\Matlab_Codes\Burkardt_Repository\Python\SFTPack\';
    urlstub='https://people.sc.fsu.edu/~jburkardt/py_src/sftpack/';
    fileext='.py';
elseif(icase==36)
    downloadpath='D:\Matlab_Codes\Burkardt_Repository\Matlab\Test_Optimization\';
    urlstub='https://people.sc.fsu.edu/~jburkardt/m_src/test_optimization/';
    fileext='.m';
elseif(icase==37)
    downloadpath='F:\Redstone\Goes16\ABI_L2\';
    urlstub='https://geo.nsstc.nasa.gov/satellite/goes16/abi/l1b/conus/';
    fileext='.nc';
end

fullList = webread(urlstub,options);
if(icase<37)
    [DownLoadFileList] = ParsefullList(fullList,fileext);
else
    [DownLoadFileList] = ParseRedstonefullList(fullList,fileext);
end
numfiles=length(DownLoadFileList);
ab=1;
dispstr=strcat('Will need to download-',num2str(numfiles),'-files');
disp(dispstr);
f = waitbar(0,'Please wait while download starts');
pause(2);
if(numfiles>30)
    numfiles=30;
end
for n=1:numfiles % This works for Redstone but the actual number files loaded is 1 half
    eval(['cd ' downloadpath(1:length(downloadpath)-1)]);
    filename=char(DownLoadFileList{n,1});
    url=strcat(urlstub,filename);
    outfilename = websave(filename,url);
%    outfilename = webread(url,options);
%     if(n==1)
%         fid=fopen(filename,'wt');
%     else
%         fprintf(fid, '%s\n',filename);
%     end
%     if(n==numfiles)
%         fclose(fid);
%     end
    dispstr=strcat('Downloaded file=',filename);
    disp(dispstr)
    nval=n/numfiles;
    waitbar(nval,f,'Loading your data');
    pause(.5);
end
close(f)