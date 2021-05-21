function [output,numnanvals] = ReplaceFillValues(input,FillValue)
%The purpose of this routine is to replace the fill values in a GOES 16
% 2 D array with NaN values
% Written By: Stephen Forczyk
% Created: Nov 23,2020
% Revised:-----
% Classification: Unclassified
numnanvals=0;
[nrows,ncols]=size(input);
output=input;
for i=1:nrows
    for j=1:ncols
        value=input(i,j);
        if(value==FillValue)
           output(i,j)=NaN;
           numnanvals=numnanvals+1;
        end
    end
end
end

