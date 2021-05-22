function SetUpExtraColors()
% The purpose of this routine is to set up extra colors to be used in
% mapping for the GOES-16 program
% Written By: Stephen Forczyk
% Created: Feb 15,2021
% Revised:-------
% Classification: Unclassfied
global ColorList RGBVals ColorList2 xkcdVals LandColors;
global orange bubblegum brown brightblue;
[ColorList,RGBVals] = colornames('dvips');
[ColorList2,xkcdVals] = colornames('xkcd');
orange=[.9765 .4510 .0235];
bubblegum=[1 .4235 .7098];
brown=[.396 .263 .129];
brightblue=[.0039 .3961 .9882];
LandColors=zeros(16,3);
LandColors(1,1)=xkcdVals(6,1);% Almond
LandColors(1,2)=xkcdVals(6,2);
LandColors(1,3)=xkcdVals(6,3);
LandColors(2,1)=xkcdVals(10,1);% Apricot
LandColors(2,2)=xkcdVals(10,2);
LandColors(2,3)=xkcdVals(10,3);
LandColors(3,1)=xkcdVals(41,1);% Beige
LandColors(3,2)=xkcdVals(41,2);
LandColors(3,3)=xkcdVals(41,3);
LandColors(4,1)=xkcdVals(899,1);% Very Light Brown
LandColors(4,2)=xkcdVals(899,2);
LandColors(4,3)=xkcdVals(899,3);
LandColors(5,1)=xkcdVals(928,1);% Wheat
LandColors(5,2)=xkcdVals(928,2);
LandColors(5,3)=xkcdVals(928,3);
LandColors(6,1)=xkcdVals(45,1);% Bland
LandColors(6,2)=xkcdVals(45,2);
LandColors(6,3)=xkcdVals(45,3);
LandColors(7,1)=xkcdVals(110,1);% Brown Yellow
LandColors(7,2)=xkcdVals(110,2);
LandColors(7,3)=xkcdVals(110,3);
LandColors(8,1)=xkcdVals(136,1);% Butterscotch
LandColors(8,2)=xkcdVals(136,2);
LandColors(8,3)=xkcdVals(136,3);
LandColors(9,1)=xkcdVals(70,1);% Blush
LandColors(9,2)=xkcdVals(70,2);
LandColors(9,3)=xkcdVals(70,3);
LandColors(10,1)=xkcdVals(947,1);% Yellowish Tan
LandColors(10,2)=xkcdVals(947,2);
LandColors(10,3)=xkcdVals(947,3);
LandColors(11,1)=xkcdVals(620,1);% Orange Yellow
LandColors(11,2)=xkcdVals(620,2);
LandColors(11,3)=xkcdVals(620,3);
LandColors(12,1)=xkcdVals(692,1);% Pinkish Tan
LandColors(12,2)=xkcdVals(692,2);
LandColors(12,3)=xkcdVals(692,3);
LandColors(13,1)=xkcdVals(854,1);% Tan Brown
LandColors(13,2)=xkcdVals(854,2);
LandColors(13,3)=xkcdVals(854,3);
LandColors(14,1)=xkcdVals(793,1);% Sandstone
LandColors(14,2)=xkcdVals(793,2);
LandColors(14,3)=xkcdVals(793,3);
LandColors(15,1)=xkcdVals(836,1);% Squash
LandColors(15,2)=xkcdVals(836,2);
LandColors(15,3)=xkcdVals(836,3);
LandColors(16,1)=xkcdVals(853,1);% Tan
LandColors(16,2)=xkcdVals(853,2);
LandColors(16,3)=xkcdVals(853,3);
end

