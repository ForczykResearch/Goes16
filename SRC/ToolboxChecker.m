function [isPresent] = ToolboxChecker(toolbox)
% this function will check if the the user has a particular toolbox
% Written By: Stephen Forczyk
% Created: Dec 29,2020
% Revised:----
% Classification: Unclassified
isPresent=0;
pt=ver;
numpt=length(pt);
for n=1:numpt
    nowbox=pt(n).Name;
    a1=strcmp(nowbox,toolbox);
    if(a1==1)
        isPresent=1;
    end
end
    
end

