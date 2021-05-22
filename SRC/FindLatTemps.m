function [meanTemp,nhits] = FindLatTemps(RasterLats,SSTS,lowerlimit,upperlimit)
% This function will find the mean temperature for a latitude band running
% from lowerlimit (Lat Deg) to upperlimit (Lat Deg) for GOES surface
% temperature data
% Written By: Stephen Forczyk
% Created: Jan 23,2021
% Revised:----
% Classification: Unclassified
meanTemp=0;
nhits=0;
ST=SSTS.values;
[nrows,ncols]=size(RasterLats);
[ix,iy]=find((RasterLats>=lowerlimit) & (RasterLats<upperlimit));
numhits=length(ix);
a1=isempty(ix);
if(a1==1)
    meanTemp=NaN;
else 
    holdtemps=zeros(numhits,1);
    nhits=0;
    for k=1:numhits
        ixn=ix(k,1);
        iyn=iy(k,1);
        nowTemp=ST(ixn,iyn);
        holdtemps(k,1)=nowTemp;
    end
    a2=isnan(holdtemps);
    sumnan=sum(a2);
    nhits=numhits-sumnan;
    meanTemp=mean(holdtemps,'omitnan');
end
clear holdtemps
end

