function [outFolderList] = MakeDateFolderList(basePath,inFolderList)
% This folder is intended to make a list of folders in odered by date
% the foldername is in  MMMDD_YYYYformat. This list will then go into a
% list dialog box
% Written By: Stephen Forczyk
% Created:April 9,2021
% Revised: -----
% Classification: Unclassified
outFolderList=cell(1,1);
numin=length(inFolderList);
validFolderList=cell(1,7);
nvalid=0;
Months=cell(12,1);
Months{1,1}='Jan';
Months{2,1}='Feb';
Months{3,1}='Mar';
Months{4,1}='Apr';
Months{5,1}='May';
Months{6,1}='Jun';
Months{7,1}='Jul';
Months{8,1}='Aug';
Months{9,1}='Sep';
Months{10,1}='Oct';
Months{11,1}='Nov';
Months{12,1}='Dec';
waitstr='Building Valid Image Folders List';
h=waitbar(0,waitstr);
for n=1:numin
% Get each folder one at a time and see if it is a valid folder
    nowFolder=char(inFolderList{n,1});
    dispstr=strcat('Now looking at Folder-',nowFolder);
    disp(dispstr)
%     tic
%     h1 = msgbox({dispstr});
%     uiwait(h1,3)
%     close (h1)
    nowMonthstr=nowFolder(1:3);
    jmatch=0;
    waitbar(n/numin);
    for j=1:12
        matchMonth=char(Months{j,1}); 
        a1=strcmp(nowMonthstr,matchMonth);
        if(a1==1)
            jmatch=j;
        end
    end
    if((jmatch>=1) && (jmatch<=12))
        daystr=nowFolder(4:5);
        yearstr=nowFolder(7:10);
        Month=Months{jmatch,1};
        day=str2num(daystr);
        year=str2num(yearstr);
        fullPath=strcat(basePath,nowFolder,'\');
        [FileList] = getfilelist(fullPath,'.nc',1);
        numfiles=length(FileList);
        if(numfiles>200)
            nvalid=nvalid+1;
            validFolderList{nvalid,1}=basePath;
            validFolderList{nvalid,2}=nowFolder;
            validFolderList{nvalid,3}=Month;
            validFolderList{nvalid,4}=day;
            validFolderList{nvalid,5}=year;
            validFolderList{nvalid,6}=numfiles;
            Datestr=strcat(daystr,'-',Month,'-',yearstr);
            DateNumber=datenum(Datestr);
            validFolderList{nvalid,7}=DateNumber;
            dispstr=strcat('Folder-',nowFolder,'-is valid with-',num2str(numfiles),'-files with extension .nc in it');
            disp(dispstr)
            ab=1;
        end
    end
end
ab=1;
close(h);
% Now sort these in date order
DateList=zeros(nvalid,1);
for n=1:nvalid
    DateList(n,1)=validFolderList{n,7};
end
ab=2;
[SortedDateList,SIndex]=sort(DateList);
ab=3;
% Now create the final List based on the date sort
for n=1:nvalid
    nowsortindex=SIndex(n,1);
    outFolderList{n,1}=validFolderList{nowsortindex,2};
end
ab=4;
end

