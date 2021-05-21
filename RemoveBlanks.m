function [outstr] = RemoveBlanks(instr)
% This function will remove blanks from anywhere in a string
% Written By: Stephen Forczyk
% Created: Oct 16,2020
% Revised:------
% Classification: Unclassified
outstr=[];
inlen=length(instr);
indbl=double(instr);
[idbl]=find(instr>47 & instr<58);
numdbl=length(idbl);
outstr=instr(idbl(1):idbl(numdbl));
end

