function  MakeNewImageFolder()
% This routine will create a new labelled folder to hold a GOES 16 set
% of images for 1 day
% Written By: Stephen Forczyk
% Created:April 16,2021
% Revised: ----
% Clasification: Unclassified

global baseimagepath selectedImageFolder;
global matlabpath;
global fid;
eval(['cd ' baseimagepath(1:length(baseimagepath)-1)]);
dirlis=dir(baseimagepath);
numfolders=length(dirlis);
[results]=uisetdate2;
Year=results(1,1);
YearStr=num2str(Year);
MonthNum=results(1,2);
Day=results(1,3);
if(Day<10)
    DayStr=strcat('0',num2str(Day,1));
else
    DayStr=num2str(Day,2);
end

% Now change the MonthNum to a 3 letter string
if(MonthNum==1)
    MonthStr='Jan';
elseif(MonthNum==2)
    MonthStr='Feb';
elseif(MonthNum==3)
    MonthStr='Mar';
elseif(MonthNum==4)
    MonthStr='Apr';
elseif(MonthNum==5)
    MonthStr='May';
elseif(MonthNum==6)
    MonthStr='Jun';
elseif(MonthNum==7)
    MonthStr='Jul';
elseif(MonthNum==8)
    MonthStr='Aug';
elseif(MonthNum==9)
    MonthStr='Sep';
elseif(MonthNum==10)
    MonthStr='Oct';
elseif(MonthNum==11)
    MonthStr='Nov';
elseif(MonthNum==12)
    MonthStr='Dec';
end
dispstr=strcat('Selected Month is-',MonthStr);
disp(dispstr)
ab=1;
selectedImageFolder=strcat(MonthStr,DayStr,'_',YearStr);
dispstr=strcat('Selected Folder To Make=',selectedImageFolder);
disp(dispstr)
iduplicate=0;
% Now see if this folder already exists !
for n=1:numfolders
    nowName=dirlis(n).name;
    TF=startsWith(nowName,selectedImageFolder);
    iduplicate=iduplicate+TF;
end
% If this folder already exists stop now or risk overwriting the data
if(iduplicate>0)
    fig = uifigure;
    message=strcat('Folder-',selectedImageFolder,'-already exists');
    uialert(fig,message,'Conflict');
    uiwait(fig,10);
    close(fig);
else % This folder doesn't yet create it now
    ab=1;
    newdir=strcat(baseimagepath,selectedImageFolder);
    [status,msg,msgID]=mkdir(newdir);
    newfolderstr1=strcat('Will make new folder-',newdir,'-to receive data');
    fprintf(fid,'%s\n',newfolderstr1);
% Start with the ABI_L1b_Radiance folder which has 4 scale and 16 band
% folders for a total of 64 subfolders
    topicdir='\ABI_L1b_Radiance';
    newdir=strcat(baseimagepath,selectedImageFolder,topicdir);
    subfolder1=strcat('-----Completed Creating subdirectory-',baseimagepath,selectedImageFolder,topicdir);
    [status,msg,msgID]=mkdir(newdir);
    scaledir='\Full_Disk';
    newdir=strcat(baseimagepath,selectedImageFolder,topicdir,scaledir);
    [status,msg,msgID]=mkdir(newdir);
    scaledir='\Conus';
    newdir=strcat(baseimagepath,selectedImageFolder,topicdir,scaledir);
    [status,msg,msgID]=mkdir(newdir);
    scaledir='\Meso1';
    newdir=strcat(baseimagepath,selectedImageFolder,topicdir,scaledir);
    [status,msg,msgID]=mkdir(newdir);
    scaledir='\Meso2';
    newdir=strcat(baseimagepath,selectedImageFolder,topicdir,scaledir);
    [status,msg,msgID]=mkdir(newdir);
% Now make the individual Band folders for the \ABI_L1b_Radiance\Full_Disk
% path
    scaledir='\Full_Disk';
    for k=1:16
        if(k<10)
            banddir=strcat('\','Band0',num2str(k));
        else
            banddir=strcat('\','Band',num2str(k));
        end
        newdir=strcat(baseimagepath,selectedImageFolder,topicdir,scaledir,banddir);
        if(k==1)
            holdir=newdir;
        end
        [status,msg,msgID]=mkdir(newdir);
    end
% Now make the individual Band folders for the \ABI_L1b_Radiance\Conus
% path
    scaledir='\Conus';
    for k=1:16
        if(k<10)
            banddir=strcat('\','Band0',num2str(k));
        else
            banddir=strcat('\','Band',num2str(k));
        end
        newdir=strcat(baseimagepath,selectedImageFolder,topicdir,scaledir,banddir);
        newdir2=strcat(baseimagepath,selectedImageFolder,topicdir);
        [status,msg,msgID]=mkdir(newdir);
    end
% Now make the individual Band folders for the \ABI_L1b_Radiance\Meso1
% path
    scaledir='\Meso1';
    for k=1:16
        if(k<10)
            banddir=strcat('\','Band0',num2str(k));
        else
            banddir=strcat('\','Band',num2str(k));
        end
        newdir=strcat(baseimagepath,selectedImageFolder,topicdir,scaledir,banddir);
        [status,msg,msgID]=mkdir(newdir);
    end
% Now make the individual Band folders for the \ABI_L1b_Radiance\Meso2
% path
    scaledir='\Meso2';
    for k=1:16
        if(k<10)
            banddir=strcat('\','Band0',num2str(k));
        else
            banddir=strcat('\','Band',num2str(k));
        end
        newdir=strcat(baseimagepath,selectedImageFolder,topicdir,scaledir,banddir);
        [status,msg,msgID]=mkdir(newdir);
    end
    fprintf(fid,'%s\n',subfolder1);
% Now make the folders for the ABI_L2_Aerosol_Detection
% folder which has 4 scale folders
    topicdir='\ABI_L2_Aerosol_Detection';
    newdir=strcat(baseimagepath,selectedImageFolder,topicdir);
    subfolder2=strcat('-----Completed Creating subdirectory-',baseimagepath,selectedImageFolder,topicdir);
    [status,msg,msgID]=mkdir(newdir);
    scaledir='\Full_Disk';
    newdir=strcat(baseimagepath,selectedImageFolder,topicdir,scaledir);
    [status,msg,msgID]=mkdir(newdir);
    scaledir='\Conus';
    newdir=strcat(baseimagepath,selectedImageFolder,topicdir,scaledir);
    [status,msg,msgID]=mkdir(newdir);
    scaledir='\Meso1';
    newdir=strcat(baseimagepath,selectedImageFolder,topicdir,scaledir);
    [status,msg,msgID]=mkdir(newdir);
    scaledir='\Meso2';
    newdir=strcat(baseimagepath,selectedImageFolder,topicdir,scaledir);
    [status,msg,msgID]=mkdir(newdir);
    fprintf(fid,'%s\n',subfolder2);
% Now make the individual folders for the ABI_L2_Aerosol_Optical_Depth
% folder which has 4 scale folders
    topicdir='\ABI_L2_Aerosol_Optical_Depth';
    newdir=strcat(baseimagepath,selectedImageFolder,topicdir);
    subfolder3=strcat('-----Completed Creating subdirectory-',baseimagepath,selectedImageFolder,topicdir);
    [status,msg,msgID]=mkdir(newdir);
    scaledir='\Full_Disk';
    newdir=strcat(baseimagepath,selectedImageFolder,topicdir,scaledir);
    [status,msg,msgID]=mkdir(newdir);
    scaledir='\Conus';
    newdir=strcat(baseimagepath,selectedImageFolder,topicdir,scaledir);
    [status,msg,msgID]=mkdir(newdir);
    scaledir='\Meso1';
    newdir=strcat(baseimagepath,selectedImageFolder,topicdir,scaledir);
    [status,msg,msgID]=mkdir(newdir);
    scaledir='\Meso2';
    newdir=strcat(baseimagepath,selectedImageFolder,topicdir,scaledir);
    [status,msg,msgID]=mkdir(newdir);
    fprintf(fid,'%s\n',subfolder3);
% Now make the individual folders for the ABI_L2_Clear_Sky_Mask
% folder which has 4 scale folders
    topicdir='\ABI_L2_Clear_Sky_Mask';
    newdir=strcat(baseimagepath,selectedImageFolder,topicdir);
    subfolder4=strcat('-----Completed Creating subdirectory-',baseimagepath,selectedImageFolder,topicdir);
    [status,msg,msgID]=mkdir(newdir);
    scaledir='\Full_Disk';
    newdir=strcat(baseimagepath,selectedImageFolder,topicdir,scaledir);
    [status,msg,msgID]=mkdir(newdir);
    scaledir='\Conus';
    newdir=strcat(baseimagepath,selectedImageFolder,topicdir,scaledir);
    [status,msg,msgID]=mkdir(newdir);
    scaledir='\Meso1';
    newdir=strcat(baseimagepath,selectedImageFolder,topicdir,scaledir);
    [status,msg,msgID]=mkdir(newdir);
    scaledir='\Meso2';
    newdir=strcat(baseimagepath,selectedImageFolder,topicdir,scaledir);
    [status,msg,msgID]=mkdir(newdir);
    fprintf(fid,'%s\n',subfolder4);
% Now make the individual  folders for the ABI_L2_Cloud_Moisture
% folder which has 4 scale folders and 16 band folders
    topicdir='\ABI_L2_Cloud_Moisture';
    newdir=strcat(baseimagepath,selectedImageFolder,topicdir);
    subfolder5=strcat('-----Completed Creating subdirectory-',baseimagepath,selectedImageFolder,topicdir);
    scaledir='\Full_Disk';
    newdir=strcat(baseimagepath,selectedImageFolder,topicdir,scaledir);
    [status,msg,msgID]=mkdir(newdir);
    scaledir='\Conus';
    newdir=strcat(baseimagepath,selectedImageFolder,topicdir,scaledir);
    [status,msg,msgID]=mkdir(newdir);
    scaledir='\Meso1';
    newdir=strcat(baseimagepath,selectedImageFolder,topicdir,scaledir);
    [status,msg,msgID]=mkdir(newdir);
    scaledir='\Meso2';
    newdir=strcat(baseimagepath,selectedImageFolder,topicdir,scaledir);
    [status,msg,msgID]=mkdir(newdir);
    scaledir='\Full_Disk';
% Now make the individual Band folders for the
% \ABI_L2_Cloud_Moisture\Full_Disk    path
    for k=1:16
        if(k<10)
            banddir=strcat('\','Band0',num2str(k));
        else
            banddir=strcat('\','Band',num2str(k));
        end
        newdir=strcat(baseimagepath,selectedImageFolder,topicdir,scaledir,banddir);
        [status,msg,msgID]=mkdir(newdir);
    end
% Now make the individual Band folders for the \ABI_L2_Cloud_Moisture\Conus
% path
    scaledir='\Conus';
    for k=1:16
        if(k<10)
            banddir=strcat('\','Band0',num2str(k));
        else
            banddir=strcat('\','Band',num2str(k));
        end
        newdir=strcat(baseimagepath,selectedImageFolder,topicdir,scaledir,banddir);
        newdir2=strcat(baseimagepath,selectedImageFolder,topicdir);
        [status,msg,msgID]=mkdir(newdir);
    end
% Now make the individual Band folders for the \ABI_L2_Cloud_Moisture\Meso1
% path
    scaledir='\Meso1';
    for k=1:16
        if(k<10)
            banddir=strcat('\','Band0',num2str(k));
        else
            banddir=strcat('\','Band',num2str(k));
        end
        newdir=strcat(baseimagepath,selectedImageFolder,topicdir,scaledir,banddir);
        [status,msg,msgID]=mkdir(newdir);
    end
% Now make the individual Band folders for the \ABI_L2_Cloud_Moisture\Meso2
% path
    scaledir='\Meso2';
    for k=1:16
        if(k<10)
            banddir=strcat('\','Band0',num2str(k));
        else
            banddir=strcat('\','Band',num2str(k));
        end
        newdir=strcat(baseimagepath,selectedImageFolder,topicdir,scaledir,banddir);
        [status,msg,msgID]=mkdir(newdir);
    end    
    fprintf(fid,'%s\n',subfolder5);
% Now make the individual folders for the ABI_L2_Cloud_Optical_Depth
% folder which has 4 scale folders
    topicdir='\ABI_L2_Cloud_Optical_Depth';
    newdir=strcat(baseimagepath,selectedImageFolder,topicdir);
    subfolder6=strcat('-----Completed Creating subdirectory-',baseimagepath,selectedImageFolder,topicdir);
    [status,msg,msgID]=mkdir(newdir);
    scaledir='\Full_Disk';
    newdir=strcat(baseimagepath,selectedImageFolder,topicdir,scaledir);
    [status,msg,msgID]=mkdir(newdir);
    scaledir='\Conus';
    newdir=strcat(baseimagepath,selectedImageFolder,topicdir,scaledir);
    [status,msg,msgID]=mkdir(newdir);
    scaledir='\Meso1';
    newdir=strcat(baseimagepath,selectedImageFolder,topicdir,scaledir);
    [status,msg,msgID]=mkdir(newdir);
    scaledir='\Meso2';
    newdir=strcat(baseimagepath,selectedImageFolder,topicdir,scaledir);
    [status,msg,msgID]=mkdir(newdir);
    fprintf(fid,'%s\n',subfolder6);
% Now make the individual folders for the ABI_L2_Cloud_Particle_Size
% folder which has 4 scale folders
    topicdir='\ABI_L2_Cloud_Particle_Size';
    newdir=strcat(baseimagepath,selectedImageFolder,topicdir);
    subfolder7=strcat('-----Completed Creating subdirectory-',baseimagepath,selectedImageFolder,topicdir);
    [status,msg,msgID]=mkdir(newdir);
    scaledir='\Full_Disk';
    newdir=strcat(baseimagepath,selectedImageFolder,topicdir,scaledir);
    [status,msg,msgID]=mkdir(newdir);
    scaledir='\Conus';
    newdir=strcat(baseimagepath,selectedImageFolder,topicdir,scaledir);
    [status,msg,msgID]=mkdir(newdir);
    scaledir='\Meso1';
    newdir=strcat(baseimagepath,selectedImageFolder,topicdir,scaledir);
    [status,msg,msgID]=mkdir(newdir);
    scaledir='\Meso2';
    newdir=strcat(baseimagepath,selectedImageFolder,topicdir,scaledir);
    [status,msg,msgID]=mkdir(newdir);
    fprintf(fid,'%s\n',subfolder7);
% Now make the individual folders for the ABI_L2_Cloud_Top_Height
% folder which has 4 scale folders
    topicdir='\ABI_L2_Cloud_Top_Height';
    newdir=strcat(baseimagepath,selectedImageFolder,topicdir);
    subfolder8=strcat('-----Completed Creating subdirectory-',baseimagepath,selectedImageFolder,topicdir);
    [status,msg,msgID]=mkdir(newdir);
    scaledir='\Full_Disk';
    newdir=strcat(baseimagepath,selectedImageFolder,topicdir,scaledir);
    [status,msg,msgID]=mkdir(newdir);
    scaledir='\Conus';
    newdir=strcat(baseimagepath,selectedImageFolder,topicdir,scaledir);
    [status,msg,msgID]=mkdir(newdir);
    scaledir='\Meso1';
    newdir=strcat(baseimagepath,selectedImageFolder,topicdir,scaledir);
    [status,msg,msgID]=mkdir(newdir);
    scaledir='\Meso2';
    newdir=strcat(baseimagepath,selectedImageFolder,topicdir,scaledir);
    [status,msg,msgID]=mkdir(newdir);
    fprintf(fid,'%s\n',subfolder8);
% Now make the individual folders for the ABI_L2_Cloud_Top_Presssure
% folder which has 4 scale folders
    topicdir='\ABI_L2_Cloud_Top_Pressure';
    newdir=strcat(baseimagepath,selectedImageFolder,topicdir);
    subfolder9=strcat('-----Completed Creating subdirectory-',baseimagepath,selectedImageFolder,topicdir);
    [status,msg,msgID]=mkdir(newdir);
    scaledir='\Full_Disk';
    newdir=strcat(baseimagepath,selectedImageFolder,topicdir,scaledir);
    [status,msg,msgID]=mkdir(newdir);
    scaledir='\Conus';
    newdir=strcat(baseimagepath,selectedImageFolder,topicdir,scaledir);
    [status,msg,msgID]=mkdir(newdir);
    scaledir='\Meso1';
    newdir=strcat(baseimagepath,selectedImageFolder,topicdir,scaledir);
    [status,msg,msgID]=mkdir(newdir);
    scaledir='\Meso2';
    newdir=strcat(baseimagepath,selectedImageFolder,topicdir,scaledir);
    [status,msg,msgID]=mkdir(newdir);
    fprintf(fid,'%s\n',subfolder9);
% Now make the individual folders for the ABI_L2_Cloud_Top_Temp
% folder which has 4 scale folders
    topicdir='\ABI_L2_Cloud_Top_Temp';
    newdir=strcat(baseimagepath,selectedImageFolder,topicdir);
    subfolder10=strcat('-----Completed Creating subdirectory-',baseimagepath,selectedImageFolder,topicdir);
    [status,msg,msgID]=mkdir(newdir);
    scaledir='\Full_Disk';
    newdir=strcat(baseimagepath,selectedImageFolder,topicdir,scaledir);
    [status,msg,msgID]=mkdir(newdir);
    scaledir='\Conus';
    newdir=strcat(baseimagepath,selectedImageFolder,topicdir,scaledir);
    [status,msg,msgID]=mkdir(newdir);
    scaledir='\Meso1';
    newdir=strcat(baseimagepath,selectedImageFolder,topicdir,scaledir);
    [status,msg,msgID]=mkdir(newdir);
    scaledir='\Meso2';
    newdir=strcat(baseimagepath,selectedImageFolder,topicdir,scaledir);
    [status,msg,msgID]=mkdir(newdir);
    fprintf(fid,'%s\n',subfolder10);
% Now make the individual folders for the ABI_L2_Derived_Motion_Winds
% folder which has 4 scale folders
    topicdir='\ABI_L2_Derived_Motion_Winds';
    newdir=strcat(baseimagepath,selectedImageFolder,topicdir);
    subfolder11=strcat('-----Completed Creating subdirectory-',baseimagepath,selectedImageFolder,topicdir);
    [status,msg,msgID]=mkdir(newdir);
    scaledir='\Full_Disk';
    newdir=strcat(baseimagepath,selectedImageFolder,topicdir,scaledir);
    [status,msg,msgID]=mkdir(newdir);
    scaledir='\Conus';
    newdir=strcat(baseimagepath,selectedImageFolder,topicdir,scaledir);
    [status,msg,msgID]=mkdir(newdir);
    scaledir='\Meso1';
    newdir=strcat(baseimagepath,selectedImageFolder,topicdir,scaledir);
    [status,msg,msgID]=mkdir(newdir);
    scaledir='\Meso2';
    newdir=strcat(baseimagepath,selectedImageFolder,topicdir,scaledir);
    [status,msg,msgID]=mkdir(newdir);
    fprintf(fid,'%s\n',subfolder11);
% Now make the individual folders for the ABI_L2_Derived_Stability
% folder which has 4 scale folders
    topicdir='\ABI_L2_Derived_Stability';
    newdir=strcat(baseimagepath,selectedImageFolder,topicdir);
    subfolder12=strcat('-----Completed Creating subdirectory-',baseimagepath,selectedImageFolder,topicdir);
    [status,msg,msgID]=mkdir(newdir);
    scaledir='\Full_Disk';
    newdir=strcat(baseimagepath,selectedImageFolder,topicdir,scaledir);
    [status,msg,msgID]=mkdir(newdir);
    scaledir='\Conus';
    newdir=strcat(baseimagepath,selectedImageFolder,topicdir,scaledir);
    [status,msg,msgID]=mkdir(newdir);
    scaledir='\Meso1';
    newdir=strcat(baseimagepath,selectedImageFolder,topicdir,scaledir);
    [status,msg,msgID]=mkdir(newdir);
    scaledir='\Meso2';
    newdir=strcat(baseimagepath,selectedImageFolder,topicdir,scaledir);
    [status,msg,msgID]=mkdir(newdir);
    fprintf(fid,'%s\n',subfolder12);
% Now make the individual folders for the
% ABI_L2_Downward_ShortWave_Radiation
% folder which has 4 scale folders
    topicdir='\ABI_L2_Downward_ShortWave_Radiation';
    newdir=strcat(baseimagepath,selectedImageFolder,topicdir);
    subfolder13=strcat('-----Completed Creating subdirectory-',baseimagepath,selectedImageFolder,topicdir);
    [status,msg,msgID]=mkdir(newdir);
    scaledir='\Full_Disk';
    newdir=strcat(baseimagepath,selectedImageFolder,topicdir,scaledir);
    [status,msg,msgID]=mkdir(newdir);
    scaledir='\Conus';
    newdir=strcat(baseimagepath,selectedImageFolder,topicdir,scaledir);
    [status,msg,msgID]=mkdir(newdir);
    scaledir='\Meso1';
    newdir=strcat(baseimagepath,selectedImageFolder,topicdir,scaledir);
    [status,msg,msgID]=mkdir(newdir);
    scaledir='\Meso2';
    newdir=strcat(baseimagepath,selectedImageFolder,topicdir,scaledir);
    [status,msg,msgID]=mkdir(newdir);
    fprintf(fid,'%s\n',subfolder13);
% Now make the individual folders for the ABI_L2_Fire
% folder which has 4 scale folders
    topicdir='\ABI_L2_Fire';
    newdir=strcat(baseimagepath,selectedImageFolder,topicdir);
    subfolder14=strcat('-----Completed Creating subdirectory-',baseimagepath,selectedImageFolder,topicdir);
    [status,msg,msgID]=mkdir(newdir);
    scaledir='\Full_Disk';
    newdir=strcat(baseimagepath,selectedImageFolder,topicdir,scaledir);
    [status,msg,msgID]=mkdir(newdir);
    scaledir='\Conus';
    newdir=strcat(baseimagepath,selectedImageFolder,topicdir,scaledir);
    [status,msg,msgID]=mkdir(newdir);
    scaledir='\Meso1';
    newdir=strcat(baseimagepath,selectedImageFolder,topicdir,scaledir);
    [status,msg,msgID]=mkdir(newdir);
    scaledir='\Meso2';
    newdir=strcat(baseimagepath,selectedImageFolder,topicdir,scaledir);
    [status,msg,msgID]=mkdir(newdir);
    fprintf(fid,'%s\n',subfolder14);
% Now make the individual folders for the ABI_L2_Land_Surface_Temp
% folder which has 4 scale folders
    topicdir='\ABI_L2_Land_Surface_Temp';
    newdir=strcat(baseimagepath,selectedImageFolder,topicdir);
    subfolder15=strcat('-----Completed Creating subdirectory-',baseimagepath,selectedImageFolder,topicdir);
    [status,msg,msgID]=mkdir(newdir);
    scaledir='\Full_Disk';
    newdir=strcat(baseimagepath,selectedImageFolder,topicdir,scaledir);
    [status,msg,msgID]=mkdir(newdir);
    scaledir='\Conus';
    newdir=strcat(baseimagepath,selectedImageFolder,topicdir,scaledir);
    [status,msg,msgID]=mkdir(newdir);
    scaledir='\Meso1';
    newdir=strcat(baseimagepath,selectedImageFolder,topicdir,scaledir);
    [status,msg,msgID]=mkdir(newdir);
    scaledir='\Meso2';
    newdir=strcat(baseimagepath,selectedImageFolder,topicdir,scaledir);
    [status,msg,msgID]=mkdir(newdir);
    fprintf(fid,'%s\n',subfolder15);
% Now make the individual folders for the
% ABI_L2_Legacy_Vertical_Moisture_Profile
% folder which has 4 scale folders
    topicdir='\ABI_L2_Legacy_Vertical_Moisture_Profile';
    newdir=strcat(baseimagepath,selectedImageFolder,topicdir);
    subfolder16=strcat('-----Completed Creating subdirectory-',baseimagepath,selectedImageFolder,topicdir);
    [status,msg,msgID]=mkdir(newdir);
    scaledir='\Full_Disk';
    newdir=strcat(baseimagepath,selectedImageFolder,topicdir,scaledir);
    [status,msg,msgID]=mkdir(newdir);
    scaledir='\Conus';
    newdir=strcat(baseimagepath,selectedImageFolder,topicdir,scaledir);
    [status,msg,msgID]=mkdir(newdir);
    scaledir='\Meso1';
    newdir=strcat(baseimagepath,selectedImageFolder,topicdir,scaledir);
    [status,msg,msgID]=mkdir(newdir);
    scaledir='\Meso2';
    newdir=strcat(baseimagepath,selectedImageFolder,topicdir,scaledir);
    [status,msg,msgID]=mkdir(newdir);
    fprintf(fid,'%s\n',subfolder16);
% Now make the individual folders for the
% ABI_L2_Legacy_Vertical_Temperature_Profile
% folder which has 4 scale folders
    topicdir='\ABI_L2_Legacy_Vertical_Temperature_Profile';
    newdir=strcat(baseimagepath,selectedImageFolder,topicdir);
    subfolder17=strcat('-----Completed Creating subdirectory-',baseimagepath,selectedImageFolder,topicdir);
    [status,msg,msgID]=mkdir(newdir);
    scaledir='\Full_Disk';
    newdir=strcat(baseimagepath,selectedImageFolder,topicdir,scaledir);
    [status,msg,msgID]=mkdir(newdir);
    scaledir='\Conus';
    newdir=strcat(baseimagepath,selectedImageFolder,topicdir,scaledir);
    [status,msg,msgID]=mkdir(newdir);
    scaledir='\Meso1';
    newdir=strcat(baseimagepath,selectedImageFolder,topicdir,scaledir);
    [status,msg,msgID]=mkdir(newdir);
    scaledir='\Meso2';
    newdir=strcat(baseimagepath,selectedImageFolder,topicdir,scaledir);
    [status,msg,msgID]=mkdir(newdir);
    fprintf(fid,'%s\n',subfolder17);
% Now make the individual folders for the ABI_L2_MultiBand_Radiance
% folder which has 4 scale folders
    topicdir='\ABI_L2_MultiBand_Radiance';
    newdir=strcat(baseimagepath,selectedImageFolder,topicdir);
    subfolder18=strcat('-----Completed Creating subdirectory-',baseimagepath,selectedImageFolder,topicdir);
    [status,msg,msgID]=mkdir(newdir);
    scaledir='\Full_Disk';
    newdir=strcat(baseimagepath,selectedImageFolder,topicdir,scaledir);
    [status,msg,msgID]=mkdir(newdir);
    scaledir='\Conus';
    newdir=strcat(baseimagepath,selectedImageFolder,topicdir,scaledir);
    [status,msg,msgID]=mkdir(newdir);
    scaledir='\Meso1';
    newdir=strcat(baseimagepath,selectedImageFolder,topicdir,scaledir);
    [status,msg,msgID]=mkdir(newdir);
    scaledir='\Meso2';
    newdir=strcat(baseimagepath,selectedImageFolder,topicdir,scaledir);
    [status,msg,msgID]=mkdir(newdir);
    fprintf(fid,'%s\n',subfolder18);
% Now make the individual folders for the ABI_L2_Rainfall_Rate
% folder which has 4 scale folders
    topicdir='\ABI_L2_Rainfall_Rate';
    newdir=strcat(baseimagepath,selectedImageFolder,topicdir);
    subfolder19=strcat('-----Completed Creating subdirectory-',baseimagepath,selectedImageFolder,topicdir);
    [status,msg,msgID]=mkdir(newdir);
    scaledir='\Full_Disk';
    newdir=strcat(baseimagepath,selectedImageFolder,topicdir,scaledir);
    [status,msg,msgID]=mkdir(newdir);
    scaledir='\Conus';
    newdir=strcat(baseimagepath,selectedImageFolder,topicdir,scaledir);
    [status,msg,msgID]=mkdir(newdir);
    scaledir='\Meso1';
    newdir=strcat(baseimagepath,selectedImageFolder,topicdir,scaledir);
    [status,msg,msgID]=mkdir(newdir);
    scaledir='\Meso2';
    newdir=strcat(baseimagepath,selectedImageFolder,topicdir,scaledir);
    [status,msg,msgID]=mkdir(newdir);
    fprintf(fid,'%s\n',subfolder19);
% Now make the individual folders for the ABI_L2_Sea_Surface_Temp
% folder which has 4 scale folders
    topicdir='\ABI_L2_Sea_Surface_Temp';
    newdir=strcat(baseimagepath,selectedImageFolder,topicdir);
    subfolder20=strcat('-----Completed Creating subdirectory-',baseimagepath,selectedImageFolder,topicdir);
    [status,msg,msgID]=mkdir(newdir);
    scaledir='\Full_Disk';
    newdir=strcat(baseimagepath,selectedImageFolder,topicdir,scaledir);
    [status,msg,msgID]=mkdir(newdir);
    scaledir='\Conus';
    newdir=strcat(baseimagepath,selectedImageFolder,topicdir,scaledir);
    [status,msg,msgID]=mkdir(newdir);
    scaledir='\Meso1';
    newdir=strcat(baseimagepath,selectedImageFolder,topicdir,scaledir);
    [status,msg,msgID]=mkdir(newdir);
    scaledir='\Meso2';
    newdir=strcat(baseimagepath,selectedImageFolder,topicdir,scaledir);
    [status,msg,msgID]=mkdir(newdir);
    fprintf(fid,'%s\n',subfolder20);
% Now make the individual folders for the ABI_L2_Total_Precip_Water
% folder which has 4 scale folders
    topicdir='\ABI_L2_Total_Precip_Water';
    newdir=strcat(baseimagepath,selectedImageFolder,topicdir);
    subfolder21=strcat('-----Completed Creating subdirectory-',baseimagepath,selectedImageFolder,topicdir);
    [status,msg,msgID]=mkdir(newdir);
    scaledir='\Full_Disk';
    newdir=strcat(baseimagepath,selectedImageFolder,topicdir,scaledir);
    [status,msg,msgID]=mkdir(newdir);
    scaledir='\Conus';
    newdir=strcat(baseimagepath,selectedImageFolder,topicdir,scaledir);
    [status,msg,msgID]=mkdir(newdir);
    scaledir='\Meso1';
    newdir=strcat(baseimagepath,selectedImageFolder,topicdir,scaledir);
    [status,msg,msgID]=mkdir(newdir);
    scaledir='\Meso2';
    newdir=strcat(baseimagepath,selectedImageFolder,topicdir,scaledir);
    [status,msg,msgID]=mkdir(newdir);
    fprintf(fid,'%s\n',subfolder21);
% Now make the individual folders for the ABI_L2_Volcanic_Ash
% folder which has 4 scale folders
    topicdir='\ABI_L2_Volcanic_Ash';
    newdir=strcat(baseimagepath,selectedImageFolder,topicdir);
    subfolder22=strcat('-----Completed Creating subdirectory-',baseimagepath,selectedImageFolder,topicdir);
    [status,msg,msgID]=mkdir(newdir);
    scaledir='\Full_Disk';
    newdir=strcat(baseimagepath,selectedImageFolder,topicdir,scaledir);
    [status,msg,msgID]=mkdir(newdir);
    scaledir='\Conus';
    newdir=strcat(baseimagepath,selectedImageFolder,topicdir,scaledir);
    [status,msg,msgID]=mkdir(newdir);
    scaledir='\Meso1';
    newdir=strcat(baseimagepath,selectedImageFolder,topicdir,scaledir);
    [status,msg,msgID]=mkdir(newdir);
    scaledir='\Meso2';
    newdir=strcat(baseimagepath,selectedImageFolder,topicdir,scaledir);
    [status,msg,msgID]=mkdir(newdir);
    fprintf(fid,'%s\n',subfolder22);
% Now make the individual folders for the GLM_L2_Flash
% folder which has 4 scale folders
    topicdir='\GLM_L2_Flash';
    newdir=strcat(baseimagepath,selectedImageFolder,topicdir);
    subfolder23=strcat('-----Completed Creating subdirectory-',baseimagepath,selectedImageFolder,topicdir);
    [status,msg,msgID]=mkdir(newdir);
    scaledir='\Full_Disk';
    newdir=strcat(baseimagepath,selectedImageFolder,topicdir,scaledir);
    [status,msg,msgID]=mkdir(newdir);
    scaledir='\Conus';
    newdir=strcat(baseimagepath,selectedImageFolder,topicdir,scaledir);
    [status,msg,msgID]=mkdir(newdir);
    scaledir='\Meso1';
    newdir=strcat(baseimagepath,selectedImageFolder,topicdir,scaledir);
    [status,msg,msgID]=mkdir(newdir);
    scaledir='\Meso2';
    newdir=strcat(baseimagepath,selectedImageFolder,topicdir,scaledir);
    [status,msg,msgID]=mkdir(newdir);
    fprintf(fid,'%s\n',subfolder23);
% Now make the individual folders for the SUV_L1b_Fe093
% folder which has 4 scale folders
    topicdir='\SUV_L1b_Fe093';
    newdir=strcat(baseimagepath,selectedImageFolder,topicdir);
    subfolder24=strcat('-----Completed Creating subdirectory-',baseimagepath,selectedImageFolder,topicdir);
    [status,msg,msgID]=mkdir(newdir);
    scaledir='\Full_Disk';
    newdir=strcat(baseimagepath,selectedImageFolder,topicdir,scaledir);
    [status,msg,msgID]=mkdir(newdir);
    scaledir='\Conus';
    newdir=strcat(baseimagepath,selectedImageFolder,topicdir,scaledir);
    [status,msg,msgID]=mkdir(newdir);
    scaledir='\Meso1';
    newdir=strcat(baseimagepath,selectedImageFolder,topicdir,scaledir);
    [status,msg,msgID]=mkdir(newdir);
    scaledir='\Meso2';
    newdir=strcat(baseimagepath,selectedImageFolder,topicdir,scaledir);
    [status,msg,msgID]=mkdir(newdir);
    fprintf(fid,'%s\n',subfolder24);
% Now make the individual folders for the SUV_L1b_Fe131
% folder which has 4 scale folders
    topicdir='\SUV_L1b_Fe131';
    newdir=strcat(baseimagepath,selectedImageFolder,topicdir);
    subfolder25=strcat('-----Completed Creating subdirectory-',baseimagepath,selectedImageFolder,topicdir);
    [status,msg,msgID]=mkdir(newdir);
    scaledir='\Full_Disk';
    newdir=strcat(baseimagepath,selectedImageFolder,topicdir,scaledir);
    [status,msg,msgID]=mkdir(newdir);
    scaledir='\Conus';
    newdir=strcat(baseimagepath,selectedImageFolder,topicdir,scaledir);
    [status,msg,msgID]=mkdir(newdir);
    scaledir='\Meso1';
    newdir=strcat(baseimagepath,selectedImageFolder,topicdir,scaledir);
    [status,msg,msgID]=mkdir(newdir);
    scaledir='\Meso2';
    newdir=strcat(baseimagepath,selectedImageFolder,topicdir,scaledir);
    [status,msg,msgID]=mkdir(newdir);
    fprintf(fid,'%s\n',subfolder25);
% Now make the individual folders for the SUV_L1b_Fe171
% folder which has 4 scale folders
    topicdir='\SUV_L1b_Fe171';
    newdir=strcat(baseimagepath,selectedImageFolder,topicdir);
    subfolder26=strcat('-----Completed Creating subdirectory-',baseimagepath,selectedImageFolder,topicdir);
    [status,msg,msgID]=mkdir(newdir);
    scaledir='\Full_Disk';
    newdir=strcat(baseimagepath,selectedImageFolder,topicdir,scaledir);
    [status,msg,msgID]=mkdir(newdir);
    scaledir='\Conus';
    newdir=strcat(baseimagepath,selectedImageFolder,topicdir,scaledir);
    [status,msg,msgID]=mkdir(newdir);
    scaledir='\Meso1';
    newdir=strcat(baseimagepath,selectedImageFolder,topicdir,scaledir);
    [status,msg,msgID]=mkdir(newdir);
    scaledir='\Meso2';
    newdir=strcat(baseimagepath,selectedImageFolder,topicdir,scaledir);
    [status,msg,msgID]=mkdir(newdir);
    fprintf(fid,'%s\n',subfolder26);
% Now make the individual folders for the SUV_L1b_Fe195
% folder which has 4 scale folders
    topicdir='\SUV_L1b_Fe195';
    newdir=strcat(baseimagepath,selectedImageFolder,topicdir);
    subfolder27=strcat('-----Completed Creating subdirectory-',baseimagepath,selectedImageFolder,topicdir);
    [status,msg,msgID]=mkdir(newdir);
    scaledir='\Full_Disk';
    newdir=strcat(baseimagepath,selectedImageFolder,topicdir,scaledir);
    [status,msg,msgID]=mkdir(newdir);
    scaledir='\Conus';
    newdir=strcat(baseimagepath,selectedImageFolder,topicdir,scaledir);
    [status,msg,msgID]=mkdir(newdir);
    scaledir='\Meso1';
    newdir=strcat(baseimagepath,selectedImageFolder,topicdir,scaledir);
    [status,msg,msgID]=mkdir(newdir);
    scaledir='\Meso2';
    newdir=strcat(baseimagepath,selectedImageFolder,topicdir,scaledir);
    [status,msg,msgID]=mkdir(newdir);
    fprintf(fid,'%s\n',subfolder27);
% Now make the individual folders for the SUV_L1b_Fe284
% folder which has 4 scale folders
    topicdir='\SUV_L1b_Fe284';
    newdir=strcat(baseimagepath,selectedImageFolder,topicdir);
    subfolder28=strcat('-----Completed Creating subdirectory-',baseimagepath,selectedImageFolder,topicdir);
    [status,msg,msgID]=mkdir(newdir);
    scaledir='\Full_Disk';
    newdir=strcat(baseimagepath,selectedImageFolder,topicdir,scaledir);
    [status,msg,msgID]=mkdir(newdir);
    scaledir='\Conus';
    newdir=strcat(baseimagepath,selectedImageFolder,topicdir,scaledir);
    [status,msg,msgID]=mkdir(newdir);
    scaledir='\Meso1';
    newdir=strcat(baseimagepath,selectedImageFolder,topicdir,scaledir);
    [status,msg,msgID]=mkdir(newdir);
    scaledir='\Meso2';
    newdir=strcat(baseimagepath,selectedImageFolder,topicdir,scaledir);
    [status,msg,msgID]=mkdir(newdir);
    fprintf(fid,'%s\n',subfolder28);
% Now make the individual folders for the SUV_L1b_He303
% folder which has 4 scale folders
    topicdir='\SUV_L1b_He303';
    newdir=strcat(baseimagepath,selectedImageFolder,topicdir);
    subfolder29=strcat('-----Completed Creating subdirectory-',baseimagepath,selectedImageFolder,topicdir);
    [status,msg,msgID]=mkdir(newdir);
    scaledir='\Full_Disk';
    newdir=strcat(baseimagepath,selectedImageFolder,topicdir,scaledir);
    [status,msg,msgID]=mkdir(newdir);
    scaledir='\Conus';
    newdir=strcat(baseimagepath,selectedImageFolder,topicdir,scaledir);
    [status,msg,msgID]=mkdir(newdir);
    scaledir='\Meso1';
    newdir=strcat(baseimagepath,selectedImageFolder,topicdir,scaledir);
    [status,msg,msgID]=mkdir(newdir);
    scaledir='\Meso2';
    newdir=strcat(baseimagepath,selectedImageFolder,topicdir,scaledir);
    [status,msg,msgID]=mkdir(newdir);
    fprintf(fid,'%s\n',subfolder29);
% Now make the  folder for the Jpeg Files Only one folder
    topicdir='\Jpeg_Files';
    newdir=strcat(baseimagepath,selectedImageFolder,topicdir);
    subfolder29=strcat('-----Completed Creating subdirectory-',baseimagepath,selectedImageFolder,topicdir);
    [status,msg,msgID]=mkdir(newdir);
% Now make the  folders for the PDF Files Only one folder
    topicdir='\PDF_Files';
    newdir=strcat(baseimagepath,selectedImageFolder,topicdir);
    subfolder20=strcat('-----Completed Creating subdirectory-',baseimagepath,selectedImageFolder,topicdir);
    [status,msg,msgID]=mkdir(newdir);
% Put a filler file in a single directory so the whole package has at least
% one file ending in .nc in it
filename1='Filler_File.nc';
fullFile1=strcat(matlabpath,filename1);
fullFile2=strcat(holdir,'\',filename1);
[status,message,messageId] = copyfile(fullFile1,fullFile2);
ab=1;
end

