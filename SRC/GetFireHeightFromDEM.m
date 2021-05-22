function [FireHeight,indLat,indLon] = GetFireHeightFromDEM(LatC,LonC,latRef,lonRef,Z)
% This routine will get the height of the fire location based on the
% location of the fire in lat and long,the reference grid lat/lon values
% from the DEM file along with the Z (height) values from the DEM file
% Written By: Stephen Forczyk
% Created: Oct 9,2020
% Revised:----
% Classification: Unclassified
FireHeight=0;
indLat=0;
indLon=0;
igoodLat=0;
igoodLon=0;
[numrows,numcols]=size(latRef);
diff=1E10;
for n=1:numrows
    diffnow=abs(LatC-latRef(n,1));
    if(diffnow<diff)
        diff=diffnow;
        indLat=n;
    end
end
if((indLat>0) && (indLat<=numrows))
    igoodLat=1;
end
diff=1E10;
for n=1:numcols
    diffnow=abs(LonC-lonRef(1,n));
    if(diffnow<diff)
        diff=diffnow;
        indLon=n;
    end
end
if((indLon>0) && (indLon<=numcols))
    igoodLon=1;
end
% Now get the corresponding height value if noth indices are good
igood=igoodLat*igoodLon;
if(igood==1)
    FireHeight=Z(indLat,indLon);
end
ab=1;
end

