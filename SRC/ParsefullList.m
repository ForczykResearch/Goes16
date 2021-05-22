function [DownLoadFileList] = ParsefullList(fullList,fileext)
% This function will parse through the output of a call to websave
%  to get a list of files to be downloaded
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

inds = strfind(fullList,str1);
inde = strfind(fullList,str2);
indtxt=strfind(fullList,str3);
inds=inds';
inde=inde';
indtxt=indtxt';
numlines=length(inds);
numtxt=length(indtxt);
% Now loop through these lines to find files to download
for n=1:numlines
    is=inds(n,1);
    ie=inde(n,1);
    nowstr=fullList(is:ie);
    istxt=strfind(nowstr,str3);
    a1=isempty(istxt);
    if(a1==0)% this segment has a filename on it-try to isolate it
        ab=2;
        isfilename=strfind(nowstr,str5);
        a2=isempty(isfilename);
        if(a2==0)
            ihref=strfind(nowstr,str4);
            iclose=strfind(nowstr,str5);
            a3=isempty(ihref);
            a4=isempty(iclose);
            a5=a3+a4;
            if(a5==0)
                shortstr=nowstr(ihref+6:iclose-1);
                filename=strcat(shortstr,fileext);
                index=index+1;
                DownLoadFileList{index,1}=filename;
            end
            ab=3;
        end
    end
    ab=1;
end
ab=1;
end

