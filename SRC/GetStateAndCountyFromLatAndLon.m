function [StateName,CountyName,StateFP,CountyFP] = GetStateAndCountyFromLatAndLon(FireLat,FireLon,mx,S2)
% This routine will go through each State and County in the US to find the 
% location of a item described by a Lat and Lon-if not in the US dummy
% values will be returned
% Written By: Stephen Forczyk
% Created: Sept 26,2020
% Revised: -----
% Classification: Unclassified
global CountyBoundaries StateFIPSFile;
global StateFIPSCodes FireDetails;
StateName='NotUSState';
CountyName = 'NotUSCounty';
StateFP=0;
CountyFP=0;
numrec=length(CountyBoundaries);
igo=1;
ihitlon=0;
ihitlat=0;
PossibleRecords=zeros(numrec,3);
% search the record of the CountyBoundary file for a county that contains
% the Lat and Lon point of Interest;
ind=1;
ifnd=0;
while igo>0
    ind=ind+1;
    westEdge=CountyBoundaries{ind,5};
    eastEdge=CountyBoundaries{ind,6};
    northEdge=CountyBoundaries{ind,7};
    southEdge=CountyBoundaries{ind,8};
    a1=0;
    a2=0;
    if((FireLon>=westEdge) && (FireLon<=eastEdge))
        a1=1;
        ihitlon=ihitlon+1;
        PossibleRecords(ind,1)=1;
    end
    if((FireLat>=southEdge) && (FireLat<=northEdge))
        a2=1;
        ihitlat=ihitlat+1;
        PossibleRecords(ind,2)=1;
    end
    a3=a1*a2;
    PossibleRecords(ind,3)=a3;
    if(a3==1)
        StateName=char(CountyBoundaries{ind,2});
        CountyName=char(CountyBoundaries{ind,10});
        StateFP=CountyBoundaries{ind,3};
        igo=0;
        ifnd=1;
    end
    if(ind==numrec)
       igo=0; 
    end
end
% Check to see if a point was found
if(ifnd==0)
    dispstr=strcat('No hits found-for Lat=',num2str(FireLat,6),...
        '-FireLon=',num2str(FireLon),'-which was point-',num2str(mx),'-this probably outisde the US');
    disp(dispstr);
    ab=1;
% Since no point satisfied the criteria lets look at those point records
% that met either the lat on lon criteria;
%     [inear1]=find(PossibleRecords(:,1)==1);
%     numlatpts=length(inear1);
%     [inear2]=find(PossibleRecords(:,2)==1);
%     numlonpts=length(inear2);
%     isum=numlatpts+numlonpts;
%     CandidateCases=zeros(isum,1);
%     CandidateMatches=zeros(isum,1);
%     for m=1:numlatpts
%         CandidateCases(m,1)=inear1(m,1);
%     end
%     indx=numlatpts;
%     for m=1:numlonpts
%         indx=indx+1;
%         CandidateCases(indx,1)=inear2(m,1);
%     end
%     ab=2;
% Now loop through each of these candidate cases to see how many points if amy fall
% inside the county polygon
%     for m=1:isum
%         indx=CandidateCases(m,1);
%         CountyLon=S2(indx).Lon;
%         CountyLat=S2(indx).Lat;
%         numpts=length(CountyLon);
%         [xin,yin,Ind]=Inside(CountyLon,CountyLat,FireLon,FireLat);
%         nmatch=length(xin);
%         CandidateMatches(m,1)=nmatch;
%         ab=3;
%     end
%     nummatches=sum(CadidateMatches);
%     ab=4;
end
ab=1;
end

