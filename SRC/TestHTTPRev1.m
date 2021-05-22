% Test download from HTTP-Rev1 is designed to use a select case
% Loop to allow the user to pick specific download parameters for each case
% Tried Matlab suggested fixes-still does not work
% Written By: Stephen Forczyk
% Created: May 16,2020
% Revised: ----
% Classification: Unclassified
clc
global downloadpath urlstub filex fileext
icase=25;
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
end

fullList = webread(urlstub,options);
[DownLoadFileList] = ParsefullList(fullList,fileext);
numfiles=length(DownLoadFileList);
dispstr=strcat('Will need to download-',num2str(numfiles),'-files');
disp(dispstr);
f = waitbar(0,'Please wait while download starts');
pause(2);
for n=1:numfiles
    eval(['cd ' downloadpath(1:length(downloadpath)-1)]);
    filename=char(DownLoadFileList{n,1});
    url=strcat(urlstub,filename);
%    outfilename = websave(filename,url);
    outfilename = webread(url,options);
    dispstr=strcat('Downloaded file=',outfilename);
    disp(dispstr)
    nval=n/numfiles;
    waitbar(nval,f,'Loading your data');
    pause(.5);
end
close(f)