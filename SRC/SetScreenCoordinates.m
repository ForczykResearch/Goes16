function [hor1,vert1,Fz1,Fz2,machine] = SetScreenCoordinates(widd,lend)
% This routine will set the lower left hand coordinate of plot
% so they are centered on the screen and of with widd and length lend
% Written By Stephen Forczyk  Jan 11,2012
%
% First get the screen size and use this to set the anchor points
  ScreenSize=get(0,'ScreenSize');
  midX=ScreenSize(1,3)/2;
  midY=ScreenSize(1,4)/2;
  hor1=midX-widd/2;
  vert1=midY-lend/2;
%
% Next find out what system this is and set the default Font Sizes
%
  Fz1=10;
  Fz2=12;
  platformstr=computer;
  machineID='PCW';
  if(machineID=='PCW')
      Fz1=10;
      Fz2=12;
      machine=1;
  else
      Fz1=14;
      Fz2=16;
      machine=2;
  end

end

