function [ImageOut] = Make3ColorImage(RedImage,GreenImage,BlueImage)
% This function will take the GOES 16/17 data using channels 01/02/03 to
% make a three color image
% Written By: Stephen Forczyk
% Created: August 22,2020
% Revised: ----
% Classification: Unclassified
lowval=0;
highval=1;
ImageOut=[];
RedVals=RedImage.values1;
GreenVals=GreenImage.values1;
BlueVals=BlueImage.values1;
[RedVals,lowclip,highclip] = ClipImageValues(RedVals,lowval,highval);
[GreenVals,lowclip,highclip] = ClipImageValues(GreenVals,lowval,highval);
[BlueVals,lowclip,highclip] = ClipImageValues(BlueVals,lowval,highval);
% Now apply a gamma correction to the image
gamma=2.2;
RedVals=power(RedVals,1/gamma);
GreenVals=power(GreenVals,1/gamma);
BlueVals=power(BlueVals,1/gamma);
%Calculate the True Green Values
GreenTrueVals = 0.45 * RedVals + 0.1 * GreenVals + 0.45 * BlueVals;
[GreenTrueVals,lowclip,highclip] = ClipImageValues(GreenTrueVals,lowval,highval);
ImageOut=RedVals+GreenTrueVals+BlueVals;

ab=1;
end

