function [output,numnanvals] = ReplaceFillValues3(input,FillValue)
%The purpose of this routine is to replace the fill values in a GOES 16
% 3 D array with NaN values
% Written By: Stephen Forczyk
% Created: Mar 7,2021
% Revised:-----
% Classification: Unclassified
numnanvals=0;
[nlvs,nrows,ncols]=size(input);
output=input;
for i=1:nlvs
    for j=1:nrows
        for k=1:ncols
            value=input(i,j,k);
            if(value==FillValue)
                output(i,j,k)=NaN;
                numnanvals=numnanvals+1;
            end
        end
    end
end
end

