function [output1,output2] = SetImageFolders()
% The purpose of this routine is to set up the image paths for the
% newly selected date. These will overide the hardcoded default paths
% 
% Written By: Stephen Forczyk
% Created: April 10,2021
% Revised: April 14,2021 changed ;abel for path 49
global baseimagepath selectedImageFolder;
global GOES16BandPaths GOES16BandSuffixes;
global pdfpath jpegpath;

global fid;
GOES16BandPaths=cell(70,1);
GOES16BandSuffixes=cell(70,1);
output1 = 0;
output2 = 0;

GOES16BandSuffixes{1,1}='ABI_L2_Cloud_Moisture\Conus\Band01\';
GOES16BandSuffixes{2,1}='ABI_L2_Cloud_Moisture\Conus\Band02\';
GOES16BandSuffixes{3,1}='ABI_L2_Cloud_Moisture\Conus\Band03\';
GOES16BandSuffixes{4,1}='ABI_L2_Cloud_Moisture\Conus\Band04\';
GOES16BandSuffixes{5,1}='ABI_L2_Cloud_Moisture\Conus\Band05\';
GOES16BandSuffixes{6,1}='ABI_L2_Cloud_Moisture\Conus\Band06\';
GOES16BandSuffixes{7,1}='ABI_L2_Cloud_Moisture\Conus\Band07\';
GOES16BandSuffixes{8,1}='ABI_L2_Cloud_Moisture\Conus\Band08\';
GOES16BandSuffixes{9,1}='ABI_L2_Cloud_Moisture\Conus\Band09\';
GOES16BandSuffixes{10,1}='ABI_L2_Cloud_Moisture\Conus\Band10\';
GOES16BandSuffixes{11,1}='ABI_L2_Cloud_Moisture\Conus\Band11\';
GOES16BandSuffixes{12,1}='ABI_L2_Cloud_Moisture\Conus\Band12\';
GOES16BandSuffixes{13,1}='ABI_L2_Cloud_Moisture\Conus\Band13\';
GOES16BandSuffixes{14,1}='ABI_L2_Cloud_Moisture\Conus\Band14\';
GOES16BandSuffixes{15,1}='ABI_L2_Cloud_Moisture\Conus\Band15\';
GOES16BandSuffixes{16,1}='ABI_L2_Cloud_Moisture\Conus\Band16\';
GOES16BandSuffixes{17,1}='ABI_L2_Cloud_Top_Height\Conus\';
GOES16BandSuffixes{18,1}='ABI_L2_Cloud_Top_Temp\Full_Disk\';
GOES16BandSuffixes{19,1}='GLM_L2_Flash\Conus\';
GOES16BandSuffixes{20,1}='ABI_L1b_Radiance\Conus\Band01\';
GOES16BandSuffixes{21,1}='ABI_L1b_Radiance\Conus\Band02\';
GOES16BandSuffixes{22,1}='ABI_L1b_Radiance\Conus\Band03\';
GOES16BandSuffixes{23,1}='ABI_L1b_Radiance\Conus\Band04\';
GOES16BandSuffixes{24,1}='ABI_L1b_Radiance\Conus\Band05\';
GOES16BandSuffixes{25,1}='ABI_L1b_Radiance\Conus\Band06\';
GOES16BandSuffixes{26,1}='ABI_L1b_Radiance\Conus\Band07\';
GOES16BandSuffixes{27,1}='ABI_L1b_Radiance\Conus\Band08\';
GOES16BandSuffixes{28,1}='ABI_L1b_Radiance\Conus\Band09\';
GOES16BandSuffixes{29,1}='ABI_L1b_Radiance\Conus\Band10\';
GOES16BandSuffixes{30,1}='ABI_L1b_Radiance\Conus\Band11\';
GOES16BandSuffixes{31,1}='ABI_L1b_Radiance\Conus\Band12\';
GOES16BandSuffixes{32,1}='ABI_L1b_Radiance\Conus\Band13\';
GOES16BandSuffixes{33,1}='ABI_L1b_Radiance\Conus\Band14\';
GOES16BandSuffixes{34,1}='ABI_L1b_Radiance\Conus\Band15\';
GOES16BandSuffixes{35,1}='ABI_L1b_Radiance\Conus\Band16\';
GOES16BandSuffixes{36,1}='ABI_L2_MultiBand_Radiance\Conus\';
GOES16BandSuffixes{37,1}='ABI_L1b_Radiance\Meso1\Band01\';
GOES16BandSuffixes{38,1}='ABI_L1b_Radiance\Meso1\Band02\';
GOES16BandSuffixes{39,1}='ABI_L1b_Radiance\Meso1\Band03\';
GOES16BandSuffixes{40,1}='ABI_L1b_Radiance\Meso1\Band04\';
GOES16BandSuffixes{41,1}='ABI_L1b_Radiance\Meso1\Band05\';
GOES16BandSuffixes{42,1}='ABI_L1b_Radiance\Meso1\Band06\';
GOES16BandSuffixes{43,1}='ABI_L1b_Radiance\Meso1\Band07\';
GOES16BandSuffixes{44,1}='ABI_L1b_Radiance\Meso1\Band08\';
GOES16BandSuffixes{45,1}='ABI_L1b_Radiance\Meso1\Band09\';
GOES16BandSuffixes{46,1}='ABI_L1b_Radiance\Meso1\Band10\';
GOES16BandSuffixes{47,1}='ABI_L1b_Radiance\Meso1\Band11\';
GOES16BandSuffixes{48,1}='ABI_L2_MultiBand_Radiance\Conus\';
GOES16BandSuffixes{49,1}='ABI_L2_MultiBand_Radiance\Meso1\';
GOES16BandSuffixes{50,1}='ABI_L2_MultiBand_Radiance\Full_Disk\';
GOES16BandSuffixes{51,1}='ABI_L2_Cloud_Top_Height\Conus\';
GOES16BandSuffixes{52,1}='ABI_L2_Cloud_Top_Height\Full_Disk\';
GOES16BandSuffixes{53,1}='ABI_L2_Fire\Conus\';
GOES16BandSuffixes{54,1}='ABI_L2_Derived_Motion_Winds\Conus\';
GOES16BandSuffixes{55,1}='ABI_L2_Cloud_Top_Pressure\Conus\';
GOES16BandSuffixes{56,1}='ABI_L2_Cloud_Top_Temp\Full_Disk\';
GOES16BandSuffixes{57,1}='ABI_L2_Clear_Sky_Mask\Conus\';
GOES16BandSuffixes{58,1}='ABI_L2_Sea_Surface_Temp\Full_Disk\';
GOES16BandSuffixes{59,1}='ABI_L2_Land_Surface_Temp\Conus\';
GOES16BandSuffixes{60,1}='ABI_L2_Cloud_Optical_Depth\Conus\';
GOES16BandSuffixes{61,1}='ABI_L2_Cloud_Particle_Size\Conus\';
GOES16BandSuffixes{62,1}='ABI_L2_Aerosol_Detection\Conus \';
GOES16BandSuffixes{63,1}='ABI_L2_Aerosol_Optical_Depth\Conus\';
GOES16BandSuffixes{64,1}='ABI_L2_Derived_Stability\Conus\';
GOES16BandSuffixes{65,1}='ABI_L2_Downward_ShortWave_Radiation\Conus\';
GOES16BandSuffixes{66,1}='ABI_L2_Legacy_Vertical_Moisture_Profile\Conus\';
GOES16BandSuffixes{67,1}='ABI_L2_Legacy_Vertical_Temperature_Profile\Conus\';
GOES16BandSuffixes{68,1}='ABI_L2_Rainfall_Rate\FullDisk\';
GOES16BandSuffixes{69,1}='ABI_L2_Total_Precip_Water\Conus\';
GOES16BandSuffixes{70,1}='ABI_L2_Volcanic_Ash\FullDisk\';
% now set up the new paths by adding the image base path and the
% selectedImageFolder variable with these Suffixes to form the new paths
% if the path does not exist on disk create it
nfolders=length(GOES16BandSuffixes);
for n=1:nfolders
    nowSuffix=char(GOES16BandSuffixes{n,1});
    finalFolder=strcat(baseimagepath,selectedImageFolder,'\',nowSuffix);
    GOES16BandPaths{n,1}=finalFolder;
    a1=exist(finalFolder,'dir');
    if(a1==7)
        output1=output1+1;
    else
        [status, msg, msgID] = mkdir(finalFolder);
        if(status==1)
            output2=output2+1;
            dispstr=strcat('Created new empty folder-',finalFolder);
            disp(dispstr)
        else
            dispstr=strcat('Failed To create new empty folder-',finalFolder);
            disp(dispstr)
        end
    end
end
% Create the pdf and jpeg folders
pdfpath=strcat(baseimagepath,selectedImageFolder,'\','PDF_Files\');
jpegpath=strcat(baseimagepath,selectedImageFolder,'\','Jpeg_Files\');
a1=exist(pdfpath,'dir');
if(a1==7)
    output1=output1+1;
else
    [status, msg, msgID] = mkdir(pdfpath);
    if(status==1)
        output2=output2+1;
        dispstr=strcat('Created new empty folder-',pdfpath);
        disp(dispstr)
    else
        dispstr=strcat('Failed To create new empty folder-',pdfpath);
        disp(dispstr)
    end
end
a1=exist(jpegpath,'dir');
if(a1==7)
    output1=output1+1;
else
    [status, msg, msgID] = mkdir(jpegpath);
    if(status==1)
        output2=output2+1;
        dispstr=strcat('Created new empty folder-',jpegpath);
        disp(dispstr)
    else
        dispstr=strcat('Failed To create new empty folder-',jpegpath);
        disp(dispstr)
    end
end
% Recap the new active file paths
fprintf(fid,'%s\n','******* Current Imagery Band Paths *******');
for n=1:nfolders
    pathstr=strcat('Path #=',num2str(n),'-Folder-',char(GOES16BandPaths{n,1}));
    fprintf(fid,'%s\n',pathstr);
end
% Also print out the PDFPath and the Jpeg Path
pathstr=strcat('PDF Path-',pdfpath);
fprintf(fid,'%s\n',pathstr);
pathstr=strcat('Jpeg Path-',jpegpath);
fprintf(fid,'%s\n',pathstr);

fprintf(fid,'%s\n','******* End Of Imagery Band Paths  *******');
end

