function [DownLoadFileList] = ParseRedstonefullList(fullList,itype,fileext)
% This function will parse through the output of a call to websave
%  to get a list of files to be downloaded from RedstoneArsenal
DownLoadFileList=cell(1,1);
listLen=length(fullList);
index=0;
% now parse through this list looking through occurances of two particular
% strings
str1='<tr>';
str2='</tr>';
str3='alt="[TXT]"';
str4='href="';
str5=strcat(fileext,'">');
str10='OR_ABI';
if(itype==2)
    str10='CG_ABI';
end
str11='.nc';
inds=strfind(fullList,str10);
inde=strfind(fullList,str11);
numlines=length(inds);
inds=inds';
inde=inde';
laststr='dud';
% Now loop through these lines to find files to download
for n=1:numlines
    is=inds(n,1);
    ie=inde(n,1)+2;
    nowstr=fullList(is:ie);
    a1=isempty(nowstr);
    a2=strcmp(laststr,nowstr);
    if((a1==0)&& (a2~=1))% this segment has a filename on it-try to isolate it
        ab=2;
        isfilename=strfind(nowstr,str11);
        a2=isempty(isfilename);
        if(a2==0)
            index=index+1;
            DownLoadFileList{index,1}=nowstr;
            ab=3;
        end
    end
    laststr=nowstr;
    ab=1;
end
ab=1;
end

