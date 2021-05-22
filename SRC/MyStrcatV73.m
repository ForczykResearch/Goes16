function [outString]=MyStrcatV73(actionstr,filestr,varstr,qualstr)
% Create a cmdstring to save selected variables. The qualstr will save it
% as a Matlab 7.3 format due to large file sizes
% Created: July 30,2020
% Written By: Stephen Forczyk
% Revised:-----
% Classification: Unclassified
spacestr=char(32);
actionlen=length(actionstr);
filelen=length(filestr);
varlen=length(varstr);
quallen=length(qualstr);
cmdlen=actionlen+filelen+varlen+quallen+3;
outString(1:actionlen)=actionstr;
nowpos=actionlen+1;
outString(nowpos)=spacestr;
nowpos=nowpos+1;
outString(nowpos:nowpos+filelen-1)=filestr;
nowpos=nowpos+filelen;
outString(nowpos:nowpos)=spacestr;
nowpos=nowpos+1;
outString(nowpos:nowpos+varlen-1)=varstr;
nowpos=length(outString)+1;
outString(nowpos:nowpos)=spacestr;
nowpos=length(outString)+1;
outString(nowpos:nowpos+quallen-1)=qualstr;


