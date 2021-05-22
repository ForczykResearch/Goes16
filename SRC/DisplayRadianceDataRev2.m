function DisplayRadianceDataRev2(titlestr,itype,bandnum)
% Display the Radiance Data from the GOES16/17 data
% Derived from DisplayRadianceData big change add the capability to
% build meso form factor grids on the fly
% Written By: Stephen Forczyk
% Created: April 13,2021
% Revised: --------
% Classification: Unclassified
% Notes: Band 1 mapping probably Okay
%        Band 2 mapping probably okay
%        Band 3 mapping Okay
%        Band 4 mapping Okay
%        Band 5 mapping Okay
%        Band 6 mapping Okay
%        Band 7 mapping Okay
%        Band 8 mapping Okay
%        Band 9 mapping Okay
%        Band 10 mapping Okay
%        Band 11 mapping Okay
%        Band 12 mapping Okay
%        Band 13 mapping Okay
%        Band 14 mapping Okay
%        Band 15 mapping Okay
%        Band 16 mapping Okay
global BandDataS MetaDataS GoesWaveBand;
global RadS DQFS tS yS xS tBS goesImagerS yImgS yImgBS;
global xImgS xImgBS SatDataS GeoSpatialS;
global ReflectanceS AlgoS ErrorS EarthSunS VersionContainerS;
global GoesWaveBand ESunS kappa0S PlanckS FocalPlaneS;
global HTS DQF1S OutlierPS CloudTopS Algo1S ProcessParamS;
global LZAS LZABS SZAS SZABS Error1S CloudPixelsS;
global GOESFileName;
global Band_IDS VPixCS MissingPixelS SaturatedPixelS ;
global UnSatPixS StarIDS;
global ValidPixRadS AlgoProdVerCS;
global RptGenPresent iCreatePDFReport pdffilename rpt chapter;
global JpegCounter JpegFileList;
global DQFHdr DQFTable MiscHdr MiscTable RqmtsHdr RqmtsTable;
global MonthDayStr MonthDayYearStr;
global DayMonthNonLeapYear DayMonthLeapYear CalendarFileName;
global westEdge eastEdge northEdge southEdge;
global MapFormFactor;

global widd2 lend2;
global initialtimestr igrid ijpeg ilog imovie;
global vert1 hor1 widd lend;
global vert2 hor2 machine;
global chart_time;
global Fz1 Fz2 fid;
global idirector mov izoom iwindow;
global matpath GOES16path;
global jpegpath ;
global smhrpath excelpath ascpath;
global ipowerpoint PowerPointFile scaling stretching padding;
global ichartnum;
% additional paths needed for mapping
global matpath1 mappath;
global canadapath stateshapepath topopath;
global trajpath militarypath gridpath;
global figpath screencapturepath;
global shapepath2 countrypath countryshapepath usstateboundariespath;
global GOES16Band1path GOES16Band2path GOES16Band3path GOES16Band4path;
global GOES16Band5path GOES16Band6path GOES16Band7path GOES16Band8path
global GOES16Band9path GOES16Band10path GOES16Band11path GOES16Band12path;
global GOES16Band13path GOES16Band14path GOES16Band15path GOES16Band16path;
global GOES16CloudTopHeightpath;

if((iCreatePDFReport==1) && (RptGenPresent==1))
    import mlreportgen.dom.*;
    import mlreportgen.report.*;
end

if(itype==1)
    fprintf(fid,'%s\n','------- Plot Radiance Data For Full Disk ------');
elseif(itype==2)
    fprintf(fid,'%s\n','------- Plot Radiance Data For Conus ------');
elseif(itype==3)
    fprintf(fid,'%s\n','------- Plot Radiance Data Meso1 Scale ------'); 
elseif(itype==4)
    fprintf(fid,'%s\n','------- Plot Radiance Data Meso2 Scale ------'); 
else
    
end
eval(['cd ' gridpath(1:length(gridpath)-1)]);
Radiance=RadS.values;
measunits=RadS.units;
scalebarlen=1000;
scalebarloc='nw'; % location of scale (sw=southwest)
if(itype==1)
    GridMatFileName='CMIFullDiskGrid.mat';
elseif(itype==2)
    if(bandnum==1)
        GridMatFileName='ConusBand1RadLatLonGrid.mat';
    end
    if(bandnum==2)
        GridMatFileName='ConusBand2RadLatLonGrid.mat';
    end
    if(bandnum==3)
        GridMatFileName='ConusBand3RadLatLonGrid.mat';
    end
    if(bandnum==4)
        GridMatFileName='ConusBand4RadLatLonGrid.mat';
    end
    if(bandnum==5)
        GridMatFileName='ConusBand5RadLatLonGrid.mat';
    end
    if(bandnum==6)
        GridMatFileName='ConusBand6RadLatLonGrid.mat';
    end
    if(bandnum==7)
        GridMatFileName='ConusBand7RadLatLonGrid.mat';
    end
    if(bandnum==8)
        GridMatFileName='ConusBand8RadLatLonGrid.mat';
    end
    if(bandnum==9)
        GridMatFileName='ConusBand9RadLatLonGrid.mat';
    end
    if(bandnum==10)
        GridMatFileName='ConusBand10RadLatLonGrid.mat';
    end
    if(bandnum==11)
        GridMatFileName='ConusBand11RadLatLonGrid.mat';
    end
    if(bandnum==12)
        GridMatFileName='ConusBand12RadLatLonGrid.mat';
    end
    if(bandnum==13)
        GridMatFileName='ConusBand13RaDLatLonGrid.mat';
    end
    if(bandnum==14)
        GridMatFileName='ConusBand14RadLatLonGrid.mat';
    end
    if(bandnum==15)
        GridMatFileName='ConusBand15RadLatLonGrid.mat';
    end
    if(bandnum==16)
        GridMatFileName='ConusBand16RadLatLonGrid.mat';
    end
elseif((itype==3) || (itype==4))
    if(itype==3)
        mesostr='Meso1';
    else
        mesostr='Meso2';
    end
    numrasterlon=length(xS.values);
    numrasterlat=length(yS.values);
    numvals=numrasterlon*numrasterlat;
    xx=xS.values;
    yy=yS.values;
    RasterLats=zeros(numrasterlon,numrasterlat);
    RasterLons=RasterLats;
    waitstr=strcat('Calculating Geographic Raster for-',mesostr);
    h=waitbar(0,waitstr);
    tic;
    for jj=1:numrasterlat
        for kk=1:numrasterlon
            [GeodLat,GeodLon] = CalculateGeodCoordFromXYPosRev1(xx(kk,1),yy(jj,1));
            RasterLats(jj,kk)=GeodLat;
            RasterLons(jj,kk)=GeodLon;
        end
        waitbar(jj/numrasterlat);
    end
    close(h);
    elapsed_time=toc;
    dispstr=strcat('Calculating the Raster took-',num2str(elapsed_time,5),'-sec');
    disp(dispstr)
    mesostr2=strcat('Calcuated Geographic raster for-',mesostr,'-Form Factor which took-',...
        num2str(elapsed_time,6),'-sec');
    fprintf(fid,'%s\n',mesostr2);
    GridMatFileName='ComputedInPlace';
end
[nrows,ncols]=size(Radiance);
gridstr2='****Grid Limits Follow*****';
fprintf(fid,'%s\n',gridstr2);
gridstr1=strcat('Will Load Map Grid From File=',GridMatFileName,'-for band-',num2str(bandnum));
fprintf(fid,'%s\n',gridstr1);
if(itype<3)
    load(GridMatFileName,'RasterLats','RasterLons');
    dispstr=strcat('Loaded Grid Raster File-',GridMatFileName);
    disp(dispstr)
end
minRasterLat=min(min(RasterLats));
minRasterLon=min(min(RasterLons));
maxRasterLat=max(max(RasterLats));
maxRasterLon=max(max(RasterLons));
gridstr3=strcat('Min Raster Lat=',num2str(minRasterLat,6),'-Max RasterLat=',num2str(maxRasterLat,6));
fprintf(fid,'%s\n',gridstr3);
gridstr4=strcat('Min Raster Lon=',num2str(minRasterLon,6),'-Max RasterLon=',num2str(maxRasterLon,6));
fprintf(fid,'%s\n',gridstr4);
gridstr6='****Grid Limits End*****';
fprintf(fid,'%s\n',gridstr6);
% Retrieve some data about this waveband
bandnumstr=num2str(bandnum);
bandres=GoesWaveBand{1+bandnum,2};
bandwave=GoesWaveBand{1+bandnum,3};
bandspec=char(GoesWaveBand{1+bandnum,4});
banddesc=char(GoesWaveBand{1+bandnum,5});
bandstr1=strcat('Radiance File is for waveband-',bandnumstr,'-wavelength=',num2str(bandwave,4),'-microns');
fprintf(fid,'%s\n',bandstr1);
bandstr2=strcat('resolution-km=',num2str(bandres),'-band specificiation-',bandspec,...
    '-band description=',banddesc);
fprintf(fid,'%s\n',bandstr2);
sizestr1=strcat('Radiance grid has-',num2str(nrows),'-rows and-',num2str(ncols),...
    '-cols of data');
disp(sizestr1);
fprintf(fid,'%s\n',sizestr1);
% Get some stats on the moisture
Radiance1D=reshape(Radiance,nrows*ncols,1);
Radiance1DS=sort(Radiance1D);
maxRadiance=max(Radiance1D);
minRadiance=min(Radiance1D);
nvals=nrows*ncols;
num01=floor(.01*nvals);
num02=floor(.02*nvals);
num03=floor(.03*nvals);
num50=floor(.5*nvals);
num90=floor(.9*nvals);
num99=floor(.99*nvals);
val01=Radiance1DS(num01,1);
val02=Radiance1DS(num02,1);
val03=Radiance1DS(num03,1);
val50=Radiance1DS(num50,1);
val90=Radiance1DS(num90,1);
val99=Radiance1DS(num99,1);
BandCutoffCounts=ones(16,1);
BandReplaceValue=-0.5*ones(16,1);
if((itype==1) || (itype==2))
    BandCutoffCounts(1,1)=60;
    BandCutoffCounts(2,1)=30;
    BandCutoffCounts(3,1)=2*ceil(val01);
    BandCutoffCounts(5,1)=3*ceil(val01);
    BandCutoffCounts(6,1)=3*ceil(val01);
    BandCutoffCounts(7,1)=3*abs(val01);
    BandCutoffCounts(8,1)=2*abs(val01);
    BandCutoffCounts(9,1)=2*abs(val01);
    BandCutoffCounts(10,1)=2*abs(val01);
    BandCutoffCounts(11,1)=2*abs(val01);
    BandCutoffCounts(12,1)=2*abs(val01);
    BandCutoffCounts(13,1)=2*abs(val01);
    BandCutoffCounts(14,1)=2*abs(val01);
    BandCutoffCounts(15,1)=2*abs(val01);
    BandCutoffCounts(16,1)=2*abs(val01);
    BandReplaceValue(1,1)=-5;
    BandReplaceValue(2,1)=-5;
    BandReplaceValue(3,1)=-abs(val01);
    BandReplaceValue(5,1)=min(-abs(2*val01),-1);
    BandReplaceValue(6,1)=min(-abs(2*val01),-0.10);
    BandReplaceValue(7,1)=-0.5*abs(val01);
    BandReplaceValue(8,1)=-0.01;
    BandReplaceValue(9,1)=-0.01;
    BandReplaceValue(10,1)=-0.01;
    BandReplaceValue(11,1)=-0.01;
    BandReplaceValue(12,1)=-0.01;
    BandReplaceValue(13,1)=-0.01;
    BandReplaceValue(14,1)=-0.01;
    BandReplaceValue(15,1)=-0.01;
    BandReplaceValue(16,1)=val02;
elseif(itype==3)
    BandCutoffCounts(1,1)=abs(val03);
    BandReplaceValue(1,1)=-0.5;
    BandCutoffCounts(2,1)=abs(val03);
    BandReplaceValue(2,1)=-0.5;
    BandCutoffCounts(3,1)=abs(val03);
    BandReplaceValue(3,1)=-0.5;
    BandCutoffCounts(4,1)=abs(val03);
    BandReplaceValue(4,1)=-0.5;
    BandCutoffCounts(5,1)=abs(val03);
    BandReplaceValue(5,1)=-0.5;
    BandCutoffCounts(6,1)=abs(val03);
    BandReplaceValue(6,1)=-0.1;
    BandCutoffCounts(7,1)=abs(val03);
    BandReplaceValue(7,1)=-0.01;
    BandCutoffCounts(8,1)=abs(val03);
    BandReplaceValue(8,1)=-0.005;
    BandCutoffCounts(9,1)=abs(val03);
    BandReplaceValue(9,1)=-0.005;
    BandCutoffCounts(10,1)=abs(val03);
    BandReplaceValue(10,1)=-0.005;
    BandCutoffCounts(11,1)=abs(val03);
    BandReplaceValue(11,1)=-0.005;
    BandCutoffCounts(12,1)=abs(val03);
    BandReplaceValue(12,1)=-0.005;
    BandCutoffCounts(13,1)=abs(val03);
    BandReplaceValue(13,1)=-0.005;
    BandCutoffCounts(14,1)=abs(val03);
    BandReplaceValue(14,1)=-0.005;
    BandCutoffCounts(15,1)=abs(val03);
    BandReplaceValue(15,1)=-0.005;
    BandCutoffCounts(16,1)=abs(val03);
    BandReplaceValue(16,1)=-0.005;
elseif(itype==4)
    BandCutoffCounts(1,1)=abs(val03);
    BandReplaceValue(1,1)=-0.5;
    BandCutoffCounts(2,1)=abs(val03);
    BandReplaceValue(2,1)=-0.5;
    BandCutoffCounts(3,1)=abs(val03);
    BandReplaceValue(3,1)=-0.5;
    BandCutoffCounts(4,1)=2*abs(val03);
    BandReplaceValue(4,1)=-0.5;
    BandCutoffCounts(5,1)=abs(val03);
    BandReplaceValue(5,1)=-0.5;
    BandCutoffCounts(6,1)=abs(val03);
    BandReplaceValue(6,1)=-0.1;
    BandCutoffCounts(7,1)=abs(val03);
    BandReplaceValue(7,1)=-0.01;
    BandCutoffCounts(8,1)=abs(val03);
    BandReplaceValue(8,1)=-0.005;
    BandCutoffCounts(9,1)=abs(val03);
    BandReplaceValue(9,1)=-0.005;
    BandCutoffCounts(10,1)=abs(val03);
    BandReplaceValue(10,1)=-0.005;
    BandCutoffCounts(11,1)=abs(val03);
    BandReplaceValue(11,1)=-0.005;
    BandCutoffCounts(12,1)=abs(val03);
    BandReplaceValue(12,1)=-0.005;
    BandCutoffCounts(13,1)=abs(val03);
    BandReplaceValue(13,1)=-0.005;
    BandCutoffCounts(14,1)=abs(val03);
    BandReplaceValue(14,1)=-0.005;
    BandCutoffCounts(15,1)=abs(val03);
    BandReplaceValue(15,1)=-0.005;
    BandCutoffCounts(16,1)=abs(val03);
    BandReplaceValue(16,1)=-0.005;
end
statstr1=strcat('Min Radiance value=',num2str(minRadiance,6),'-Max Radiance value=',num2str(maxRadiance,6));
fprintf(fid,'%s\n',statstr1);
statstr2=strcat('Median Radiance value=',num2str(val50,6),'//-90 pctile value=',num2str(val90,6),...
    '//-99 pctile value=',num2str(val99,6));
fprintf(fid,'%s\n',statstr2);
% Adjust the radiance values to make positive values stand out
nowCutoff=BandCutoffCounts(bandnum,1);
nowReplaceValue=BandReplaceValue(bandnum,1);
[ilow,jlow]=find(Radiance<=nowCutoff);
numlow=length(ilow);
RadianceAdj=Radiance;
if(numlow>0)
    for jj=1:numlow
        indx=ilow(jj,1);
        indy=jlow(jj,1);
        nowval=Radiance(indx,indy);
        if(nowval<=nowCutoff)
            RadianceAdj(indx,indy)=nowReplaceValue;
        end

    end
end
adjstr1=strcat('A total of-',num2str(numlow),'-pixels had their Radiance adjusted to-',num2str(nowReplaceValue,4));
adjstr2=strcat('The cutoff values of this adjustment was-',num2str(nowCutoff,4));
fprintf(fid,'%s\n',adjstr1);
fprintf(fid,'%s\n',adjstr2);
% Fetch the map limits
westEdge=double(GeoSpatialS.geospatial_westbound_longitude);
eastEdge=double(GeoSpatialS.geospatial_eastbound_longitude);
southEdge=double(GeoSpatialS.geospatial_southbound_latitude);
northEdge=double(GeoSpatialS.geospatial_northbound_latitude);
maplimitstr1='****Map Limits Follow*****';
fprintf(fid,'%s\n',maplimitstr1);
maplimitstr2=strcat('WestEdge=',num2str(westEdge,7),'-EastEdge=',num2str(eastEdge));
fprintf(fid,'%s\n',maplimitstr2);
maplimitstr3=strcat('SouthEdge=',num2str(southEdge,7),'-NorthEdge=',num2str(northEdge));
fprintf(fid,'%s\n',maplimitstr3);
maplimitstr4='****Map Limits End*****';
fprintf(fid,'%s\n',maplimitstr4);


% Get the scan start date and time data based on the file name
[YearS,DayS,HourS,MinuteS,SecondS] = GetGOESDateTimeString(GOESFileName,1);
% Get the scan end date and time data based on the file name
[YearE,DayE,HourE,MinuteE,SecondE] = GetGOESDateTimeString(GOESFileName,2);
result = is_leap_year(YearS);
if(result==0)
    MonthDayStr=char(DayMonthNonLeapYear{DayS,1});
else
    MonthDayStr=char(DayMonthLeapYear{DayS,1});
end
MonthDayYearStr=strcat(MonthDayStr,'-',num2str(YearS));
datestr10='***** Scan Time Definition Follows *****';
datestr14='***** Scan Time Definition End *****';
fprintf(fid,'%s\n',datestr10);
datestr11=strcat('Year=',num2str(YearS,4),'-Day=',num2str(DayS,3),'-Hour=',num2str(HourS,2),...
    '-Minute=',num2str(MinuteS,2),'-Second=',num2str(SecondS,5));
fprintf(fid,'%s\n',datestr11);
datestr12=strcat('Calender Month and Day=',MonthDayStr);
fprintf(fid,'%s\n',datestr12);
fprintf(fid,'%s\n',datestr14);
% Pull some addition quantities of interest out of the data
numvalidpix=VPixCS.values;
nummissingpix=MissingPixelS.values;
numsatpix=SaturatedPixelS.values;
numunsatpix=UnSatPixS.values;
numpixaboveTThresh=FocalPlaneS.values1;
MaxFPATemp=FocalPlaneS.values2;
FPATempIncreaseThresh=FocalPlaneS.values3;
FPATempDecreaseThresh=FocalPlaneS.values4;
StarID=StarIDS.values;
miscstr1='***** Miscellaneous Data Start *****'; 
miscstr2='***** Miscellaneous Data End *****';
fprintf(fid,'\n');
fprintf(fid,'%s\n',miscstr1);
miscstr3=strcat('Number of Valid Pixel Measurements=',num2str(numvalidpix));
miscstr4=strcat('Number of Missing Pixel Measurements=',num2str(nummissingpix));
miscstr5=strcat('Number of Saturated Pixel Measurements=',num2str(numsatpix));
miscstr6=strcat('Number of UnSaturated Pixel Measurements=',num2str(numunsatpix));
miscstr7=strcat('Number of Pixels Ave Temp Threshold=',num2str(numpixaboveTThresh));
miscstr8=strcat('MaxFPATemp=',num2str(MaxFPATemp),'-Deg-K');
fprintf(fid,'%s\n',miscstr3);
fprintf(fid,'%s\n',miscstr4);
fprintf(fid,'%s\n',miscstr5);
fprintf(fid,'%s\n',miscstr6);
fprintf(fid,'%s\n',miscstr7);
fprintf(fid,'%s\n',miscstr8);
fprintf(fid,'%s\n',miscstr2);
% Set up the map axis
if(itype==1)
    axesm ('globe','Frame','on','Grid','on','meridianlabel','off','parallellabel','on',...
        'plabellocation',[-60 -50 -40 -30 -20 -10 0 10 20 30 40 50 60],'mlabellocation',[]);
elseif(itype==2)
    axesm ('pcarree','Frame','on','Grid','on','MapLatLimit',[southEdge northEdge],...
     'MapLonLimit',[westEdge eastEdge],'meridianlabel','on','parallellabel','on','plabellocation',10,'mlabellocation',20,...
     'MLabelParallel','south','Frame','on','FontColor','b'); 
     gridm('GLineStyle','-','Gcolor',[.1 .1 .1],'Galtitude',.002,'MLineLocation',10,...
    'PLineLocation',10)
elseif((itype==3)||(itype==4))
    axesm ('pcarree','Frame','on','Grid','on','MapLatLimit',[southEdge northEdge],...
     'MapLonLimit',[westEdge eastEdge],'meridianlabel','on','parallellabel','on','plabellocation',2,'mlabellocation',2,...
     'MLabelParallel','south','Frame','on','FontColor','b');
    gridm('GLineStyle','-','Gcolor',[.1 .1 .1],'Galtitude',.002,'MLineLocation',2,...
    'PLineLocation',2)
end
set(gcf,'MenuBar','none');
set(gcf,'Position',[hor1 vert1 widd lend])
geoshow(RasterLats',RasterLons',RadianceAdj,'DisplayType','texturemap');
demcmap(RadianceAdj',256);
hold on
% load the country borders and plot them
eval(['cd ' mappath(1:length(mappath)-1)]);
load('USAHiResBoundaries.mat','USALat','USALon');
plotm(USALat,USALon,'r');
load('CanadaBoundaries.mat','CanadaLat','CanadaLon');
plotm(CanadaLat,CanadaLon,'r');
load('MexicoBoundaries.mat','MexicoLat','MexicoLon');
plotm(MexicoLat,MexicoLon,'r');
load('CubaBoundaries.mat','CubaLat','CubaLon');
plotm(CubaLat,CubaLon,'r');
load('DominicanRepublicBoundaries.mat','DRLat','DRLon');
plotm(DRLat,DRLon,'r');
load('HaitiBoundaries.mat','HaitiLat','HaitiLon');
plotm(HaitiLat,HaitiLon,'r');
load('BelizeBoundaries.mat','BelizeLat','BelizeLon');
plotm(BelizeLat,BelizeLon,'r');
load('GautemalaBoundaries.mat','GautemalaLat','GautemalaLon');
plotm(GautemalaLat,GautemalaLon,'r')
load('JamaicaBoundaries.mat','JamaicaLat','JamaicaLon');
plotm(JamaicaLat,JamaicaLon,'r');
load('NicaraguaBoundaries.mat','NicaraguaLat','NicaraguaLon');
plotm(NicaraguaLat,NicaraguaLon,'r')
load('HondurasBoundaries.mat','HondurasLat','HondurasLon');
plotm(HondurasLat,HondurasLon,'r')
load('ElSalvadorBoundaries.mat','ElSalvadorLat','ElSalvadorLon');
plotm(ElSalvadorLat,ElSalvadorLon,'r');
load('PanamaBoundaries.mat','PanamaLat','PanamaLon');
plotm(PanamaLat,PanamaLon,'r');
load('ColumbiaBoundaries.mat','ColumbiaLat','ColumbiaLon');
plotm(ColumbiaLat,ColumbiaLon,'r');
load('VenezuelaBoundaries.mat','VenezuelaLat','VenezuelaLon');
plotm(VenezuelaLat,VenezuelaLon,'r')
load('PeruBoundaries.mat','PeruLat','PeruLon');
plotm(PeruLat,PeruLon,'r');
load('EcuadorBoundaries.mat','EcuadorLat','EcuadorLon');
plotm(EcuadorLat,EcuadorLon,'r')
load('BrazilBoundaries.mat','BrazilLat','BrazilLon');
plotm(BrazilLat,BrazilLon,'r');
load('BoliviaBoundaries.mat','BoliviaLat','BoliviaLon');
plotm(BoliviaLat,BoliviaLon,'r')
load('ChileBoundaries.mat','ChileLat','ChileLon');
plotm(ChileLat,ChileLon,'r');
load('ArgentinaBoundaries.mat','ArgentinaLat','ArgentinaLon');
plotm(ArgentinaLat,ArgentinaLon,'r');
load('UruguayBoundaries.mat','UruguayLat','UruguayLon');
plotm(UruguayLat,UruguayLon,'r');
load('CostaRicaBoundaries.mat','CostaRicaLat','CostaRicaLon');
plotm(CostaRicaLat,CostaRicaLon,'r');
load('FrenchGuianaBoundaries.mat','FrenchGuianaLat','FrenchGuianaLon');
plotm(FrenchGuianaLat,FrenchGuianaLon,'r');
load('GuyanaBoundaries.mat','GuyanaLat','GuyanaLon');
plotm(GuyanaLat,GuyanaLon,'r');
load('SurinameBoundaries.mat','SurinameLat','SurinameLon');
plotm(SurinameLat,SurinameLon,'r');
title(titlestr)
if(itype==3)
   BatonRougeLat=30.4475;
   BatonRougeLon=-91.1786;
   plotm(BatonRougeLat,BatonRougeLon,'r*');
   textm(BatonRougeLat+.2,BatonRougeLon+.2,'BatonRouge','Color','r'); 
   HoustonLat=29.7628;
   HoustonLon=-95.3831;
   plotm(HoustonLat,HoustonLon,'r*');
   textm(HoustonLat+.2,HoustonLon+.2,'Houston','Color','r'); 
   DallasLat=32.7792;
   DallasLon=-96.8089;
   plotm(DallasLat,DallasLon,'r*');
   textm(DallasLat+.2,DallasLon+.2,'Dallas','Color','r'); 
   NewOrleansLat=29.95;
   NewOrleansLon=-90.08;
   plotm(NewOrleansLat,NewOrleansLon,'r*');
   textm(NewOrleansLat+.2,NewOrleansLon+.2,'New Orleans','Color','r');
elseif(itype==4)
   ChicagoLat=41.8819;
   ChicagoLon=-87.6278;
   plotm(ChicagoLat,ChicagoLon,'r*');
   textm(ChicagoLat+.2,ChicagoLon+.2,'Chicago','Color','r'); 
%    HoustonLat=29.7628;
%    HoustonLon=-95.3831;
%    plotm(HoustonLat,HoustonLon,'r*');
%    textm(HoustonLat+.2,HoustonLon+.2,'Houston','Color','r'); 
%    DallasLat=32.7792;
%    DallasLon=-96.8089;
%    plotm(DallasLat,DallasLon,'r*');
%    textm(DallasLat+.2,DallasLon+.2,'Dallas','Color','r'); 
%    NewOrleansLat=29.95;
%    NewOrleansLon=-90.08;
%    plotm(NewOrleansLat,NewOrleansLon,'r*');
%    textm(NewOrleansLat+.2,NewOrleansLon+.2,'New Orleans','Color','r'); 
end
hold off
tightmap;
if((itype==3)|| (itype==4))
    scalebar('length',scalebarlen,'units','km','color','r','location',scalebarloc,'fontangle','bold',...
        'RulerStyle','patches','orientation','vertical');
end
hc=colorbar;
newaxesh=axes('Position',[0 0 1 1]);
set(newaxesh,'XLim',[0 1],'YLim',[0 1]);
if((itype==1)||(itype==2))
    Pos=get(hc,'Position');
    PosyL=.80*Pos(1,2);
    PosyU=1.03*(Pos(1,2)+Pos(1,4));
    tx1=.13;
    ty1=PosyL;
    tx2=tx1;
    ty2=ty1-.04;
    txtstr2=strcat('Band-',bandnumstr,'-Res-km=',num2str(bandres),'-Wavelength=',num2str(bandwave),...
        '-Spectrum=',bandspec,'-Description=',banddesc,'-----',MonthDayYearStr);
    txt2=text(tx2,ty2,txtstr2,'FontWeight','bold','FontSize',12);
    tx3=.74;
    ty3=.76;
    txtstr3=strcat('Radiance in-',measunits);
    txt3=text(tx3,ty3,txtstr3,'FontWeight','bold','FontSize',10);
    tx4=tx1;
    ty4=ty2-.04;
    txtstr4=strcat('Band-',bandnumstr,'-Median Radiance=',num2str(val50,6),'-Max Radiance=',...
        num2str(maxRadiance,6));
    txt4=text(tx4,ty4,txtstr4,'FontWeight','bold','FontSize',12);
elseif(itype==3)
    Pos=get(hc,'Position');
    PosyL=.80*Pos(1,2);
    PosyU=1.03*(Pos(1,2)+Pos(1,4));
    tx1=.13;
    ty1=PosyL;
    tx2=tx1;
    ty2=ty1-.03;
    txtstr2=strcat('Band-',bandnumstr,'-Res-km=',num2str(bandres),'-Wavelength=',num2str(bandwave),...
        '-Spectrum=',bandspec,'-Description=',banddesc,'-----',MonthDayYearStr);
    txt2=text(tx2,ty2,txtstr2,'FontWeight','bold','FontSize',12);
    tx3=.80;
    tx3=0.9*Pos(1,1);
    ty3=.94;
    ty3=PosyU;
    txtstr3=strcat('Rad in-',measunits);
    txt3=text(tx3,ty3,txtstr3,'FontWeight','bold','FontSize',10);
    tx4=tx1;
    ty4=ty2-.03;
    txtstr4=strcat('Band-',bandnumstr,'-Median Radiance=',num2str(val50,6),'-Max Radiance=',...
        num2str(maxRadiance,6));
    txt4=text(tx4,ty4,txtstr4,'FontWeight','bold','FontSize',12);
elseif(itype==4)
    Pos=get(hc,'Position');
    PosyL=.80*Pos(1,2);
    PosyU=1.03*(Pos(1,2)+Pos(1,4));
    tx1=.13;
    ty1=PosyL;
    tx2=tx1;
    ty2=ty1-.03;
    txtstr2=strcat('Band-',bandnumstr,'-Res-km=',num2str(bandres),'-Wavelength=',num2str(bandwave),...
        '-Spectrum=',bandspec,'-Description=',banddesc,'-----',MonthDayYearStr);
    txt2=text(tx2,ty2,txtstr2,'FontWeight','bold','FontSize',12);
    tx3=.80;
    tx3=0.9*Pos(1,1);
    ty3=.94;
    ty3=PosyU;
    txtstr3=strcat('Rad in-',measunits);
    txt3=text(tx3,ty3,txtstr3,'FontWeight','bold','FontSize',10);
    tx4=tx1;
    ty4=ty2-.03;
    txtstr4=strcat('Band-',bandnumstr,'-Median Radiance=',num2str(val50,6),'-Max Radiance=',...
        num2str(maxRadiance,6));
    txt4=text(tx4,ty4,txtstr4,'FontWeight','bold','FontSize',12);
end
set(newaxesh,'Visible','Off');
% Save this chart
figstr=strcat(titlestr,'.jpg');
eval(['cd ' jpegpath(1:length(jpegpath)-1)]);
actionstr='print';
typestr='-djpeg';
[cmdString]=MyStrcat2(actionstr,typestr,figstr);
eval(cmdString);
pause(chart_time);
JpegCounter=JpegCounter+1;
JpegFileList{JpegCounter+1,1}=figstr;
JpegFileList{JpegCounter+1,2}=jpegpath;
close('all');
savestr=strcat('Saved Radiance data plot to file-',figstr);
fprintf(fid,'%s\n',savestr);
if((iCreatePDFReport==1) && (RptGenPresent==1))
    [ibreak]=strfind(GOESFileName,'_e');
    is=1;
    ie=ibreak(1)-1;
    GOESShortFileName=GOESFileName(is:ie);
    headingstr1=strcat('ABI-Radiance Data-',GOESShortFileName);
    chapter = Chapter("Title",headingstr1);
    sectionstr=strcat('ABI-Radiance-',MapFormFactor,'-Band-',bandnumstr);
    add(chapter,Section(sectionstr));
    imdata = imread(figstr);
    [nhigh,nwid,ndepth]=size(imdata);
    image = mlreportgen.report.FormalImage();
    image.Image = which(figstr);% 
    pdftxtstr=strcat('ABI-Radiance-Data-For File-',GOESShortFileName);
    pdftext = Text(pdftxtstr);
    pdftext.Color = 'red';
    image.Caption = pdftext;
    nhighs=floor(nhigh/2.5);
    nwids=floor(nwid/2.5);
    heightstr=strcat(num2str(nhighs),'px');
    widthstr=strcat(num2str(nwids),'px');
    image.Height = heightstr;
    image.Width = widthstr;
    image.ScaleToFit=0;
    add(chapter,image);
% Now add some text -start by decribing the GLM2 Lightning
    parastr11=strcat('The Data for this chart was taken from file-',GOESShortFileName,'.');
    parastr12='Plotted on the chart is the radiance data detected by the ABI sensor.';
    parastr13=strcat('The radiance value shown here is for ABI channel-',bandnumstr,'-and is in units of-',measunits,'.');
    parastr14='To enhance the contrast between cloud data and clear backgrounds 2 band dependent adjustment factors were applied to the plotted data.';
    parastr15=strcat('First radiance levels below-',num2str(nowCutoff,3),'-',measunits,'were flagged and then their values replace by-',...
        num2str(nowReplaceValue),'-',measunits,'.');
    parastr16=strcat('These changes effectively move many negative or very low values to the blue end of the scale which makes for easier viewing.',...
        'The actual radiance values are unchanged so the statistics are not affected by this adjustment.');
    parastr17=strcat('The maximum FPA Temp=',num2str(MaxFPATemp,4),'-Deg-K-if this number is negative it is meaningless.');
    parastr18=strcat('This map was drawn using the scale-',MapFormFactor,'.');
    parastr18a=strcat('The radiance data shown is for band-',bandnumstr,'-with a center wavelength of-',num2str(bandwave,3),'-microns.');
    parastr18b=strcat('This ABI channel has a resolution of about-',num2str(bandres,2),'-km.');
    parastr19=strcat(parastr11,parastr12,parastr13,parastr14,parastr15,parastr16,parastr17,parastr18,parastr18a,parastr18b);
    p1 = Paragraph(parastr19);
    p1.Style = {OuterMargin("0pt", "0pt","10pt","10pt")};
    add(chapter,p1);
% Now build a small data quality table
    dqfflag1=100*DQFS.percent_good_pixel_qf;
    dqfflagstr1=num2str(dqfflag1,6);
    dqfflag2=100*DQFS.percent_conditionally_usable_pixel_qf;
    dqfflagstr2=num2str(dqfflag2,6);
    dqfflag3=100*DQFS.percent_out_of_range_pixel_qf;
    dqfflagstr3=num2str(dqfflag3,6);
    dqfflag4=100*DQFS.percent_no_value_pixel_qf;
    dqfflagstr4=num2str(dqfflag4,6);
    dqfflag5=100*DQFS.percent_focal_plane_temperature_threshold_exceeded_qf;
    dqfflagstr5=num2str(dqfflag5,6);
    DQFHdr={'Item' '% of Pixels'};
    DQFTable=cell(5,2);
    DQFTable{1,1}='Pct Qood Pixel';
    DQFTable{1,2}=dqfflagstr1;
    DQFTable{2,1}='Pct Conditionally Useable';
    DQFTable{2,2}=dqfflagstr2;
    DQFTable{3,1}='Pct Out Of Range';
    DQFTable{3,2}=dqfflagstr3;
    DQFTable{4,1}='Pct No Value Pixel';
    DQFTable{4,2}=dqfflagstr4;
    DQFTable{5,1}='Pct FPA Temp Exceeded';
    DQFTable{5,2}=dqfflagstr5;
    T4=[DQFHdr;DQFTable];
    tbl4=Table(T4);
    tbl4.Style = [tbl4.Style {Border('solid','black','3px')}];
    tbl4.HAlign='center';
    tbl4.TableEntriesHAlign = 'center';
    tbl4.ColSep = 'single';
    tbl4.RowSep = 'single';
    r = row(tbl4,1);
    r.Style = [r.Style {Color('red'),Bold(true)}];
    bt4 = BaseTable(tbl4);
    tabletitle = Text('DQF ABI Radiance');
    tabletitle.Bold = false;
    bt4.Title = tabletitle;
    bt4.TableWidth="7in";
    add(chapter,bt4);
% Add text for this table
    parastr21='The Data Quality Factor (DQF) table for the Cloud Top Radiance Product is shown above.';
    parastr22=strcat('There are a total of DQF factors-there are fewer quality factors than some other reportable metrics.',...
        'This is because the measurement of the Radiance at the top of the atmosphere is not greatly influenced by items such as the local zenith angle.');
    parastr23='One factor that can degrade this measurement is that over time the FPA can degrade and show higher noise levels and lower response.';
    parastr24='As a result of this,over time the ABI sensor can have pixels that report values that exceed what the GOES ReBroadcast System (GRB) can carry.';
    parastr25='In these cases the GRB can "roll over" large to 0.';
    parastr26='When this occurs cold pixels can suddenly appear in the middle of a hot scene.';
    parastr29=strcat(parastr21,parastr22,parastr23,parastr24,parastr25,parastr26);
    p2 = Paragraph(parastr29);
    p2.Style = {OuterMargin("0pt", "0pt","10pt","10pt")};
    add(chapter,p2);
end
fprintf(fid,'%s\n','------- Finished Plotting Radiance data ------');
end


