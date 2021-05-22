function GetGOESGrid()
% This routine will read a NetCDF file that has the GOES Lat Lon Grid already precomputed 
%
% Written By: Stephen Forczyk
% Created: Aug 30,2020
% Revised: -----
% Classification: Unclassified
% global BandDataS MetaDataS;
% global CMIS DQFS tS yS xS tBS goesImagerS yImgS yImgBS;
% global xImgS xImgBS SatDataS GeoSpatialS;
% global ReflectanceS AlgoS ErrorS EarthSunS VersionContainerS;
% global GoesWaveBand ESunS kappa0S PlanckS FocalPlaneS;
% global HTS DQF1S OutlierPS CloudTopS Algo1S ProcessParamS;
% global LZAS LZABS SZAS SZABS Error1S CloudPixelsS;
global GOESFileName GOESGridS;
global westEdge eastEdge northEdge southEdge;
global RasterLats RasterLons;

global widd2 lend2;
global initialtimestr igrid ijpeg ilog imovie;
global vert1 hor1 widd lend;
global vert2 hor2 machine;
global chart_time;
global Fz1 Fz2;
global idirector mov izoom iwindow;
global matpath GOES16path;
global jpegpath ;
global smhrpath excelpath ascpath;
global ipowerpoint PowerPointFile scaling stretching padding;
global ichartnum;
% additional paths needed for mapping
global matpath1 mappath;
global canadapath stateshapepath topopath;
global trajpath militarypath;
global figpath screencapturepath;
global shapepath2 countrypath countryshapepath usstateboundariespath;
global GOES16Band1path GOES16Band2path GOES16Band3path GOES16Band4path;
global GOES16Band5path GOES16Band6path GOES16Band7path GOES16Band8path
global GOES16Band9path GOES16Band10path GOES16Band11path GOES16Band12path;
global GOES16Band13path GOES16Band14path GOES16Band15path GOES16Band16path;
global GOES16CloudTopHeightpath;
global GOESGrid;
%nc_filename = 'OR_ABI-L2-CMIPC-M6C01_G16_s20201930001213_e20201930003586_c20201930004076.nc';   
[nc_filenamesuf,path]=uigetfile('*nc','Select One GOES Data File');% SMF Modification
GOESFileName=nc_filenamesuf;
nc_filename=strcat(path,nc_filenamesuf);
ncid=netcdf.open(nc_filename,'nowrite');

GOESGridS=struct('LatValues',[],'FillValue1',[],'LonValues',[],'FillValue2',[]);
% Get information about the contents of the file.
[numdims, numvars, numglobalatts, unlimdimID] = netcdf.inq(ncid);

disp(' '),disp(' '),disp(' ')
disp('________________________________________________________')
disp('^~^~^~^~^~^~^~^~^~^~^~^~^~^~^~^~^~^~^~^~^~^~^~^~^~^~^~^~')
disp(['VARIABLES CONTAINED IN THE netCDF FILE: ' nc_filename ])
disp(' ')
for i = 0:numvars-1
    [varname, xtype, dimids, numatts] = netcdf.inqVar(ncid,i);
    disp(['--------------------< ' varname ' >---------------------'])
    flag = 0;

    for j = 0:numatts - 1
        a10=strcmp(varname,'Latitude');
        a20=strcmp(varname,'Longitude');
        if (a10==1)
            attname1 = netcdf.inqAttName(ncid,i,j);
            attname2 = netcdf.getAtt(ncid,i,attname1);
            disp([attname1 ':  ' num2str(attname2)])
            a1=strcmp(attname1,'_FillValue');
            if(a1==1)
                GOESGridS.FillValue1=attname2;
            end
        elseif (a20==1)
            attname1 = netcdf.inqAttName(ncid,i,j);
            attname2 = netcdf.getAtt(ncid,i,attname1);
            disp([attname1 ':  ' num2str(attname2)])
            a1=strcmp(attname1,'_FillValue');
            if(a1==1)
                GOESGridS.FillValue2=attname2;
            end
        end

    end
    disp(' ')
    
    if flag

    else
        eval([varname '= double(netcdf.getVar(ncid,i));'])   
        if(a10==1)
            GOESGridS.LatValues=Latitude;
        end
        if(a20==1)
            GOESGridS.LonValues=Longitude;
        end
    end
end
disp('^~^~^~^~^~^~^~^~^~^~^~^~^~^~^~^~^~^~^~^~^~^~^~^~^~^~^~^~')
disp('________________________________________________________')
disp(' '),disp(' ')
netcdf.close(ncid);
Lats=GOESGridS.LatValues;
Lons=GOESGridS.LonValues;
RasterLats=Lats;
RasterLons=Lons;
[numrows,numcols]=size(Lats);
% Remove the Fill Values and replace with NaN's for the
% field limit calculations
for i=1:numrows
    for j=1:numcols
        nowLatValue=Lats(i,j);
        nowLonValue=Lons(i,j);
        if(nowLatValue<-998)
            Lats(i,j)=NaN;
        end
        if(nowLonValue<-998)
            Lons(i,j)=NaN;
        end
    end
end
% Get the image west and east edges
westEdge1=min(Lons,[],'omitnan');
westEdge=min(westEdge1,[],'omitnan');
eastEdge1=max(Lons,[],'omitnan');
eastEdge=max(eastEdge1,[],'omitnan');
if((eastEdge-westEdge>100))
    eastEdge=westEdge+100;
end
northEdge1=max(Lats,[],'omitnan');
northEdge=max(northEdge1,[],'omitnan');
southEdge1=min(Lats,[],'omitnan');
southEdge=min(southEdge1,[],'omitnan');
if(northEdge>60)
    northEdge=60;
end
if(southEdge<30)
    southEdge=30;
end
% Set up the GeoRef cells
GeoRef = georefcells();
GeoRef.LatitudeLimits=[southEdge northEdge];
GeoRef.LongitudeLimits=[westEdge eastEdge];
GeoRef.RasterSize=[1 1];
GeoRef.CellExtentInLatitude=[(northEdge-southEdge)/numcols];
GeoRef.CellExtentInLongitude=[abs((eastEdge-westEdge))/numrows];
GOESRasterFile=GOESFileName;
% Now write a Matlab file containing the decoded data
% use the original file name with a .mat extension
MatFileName='GOES16-Lat-Lon-Boundaries.mat';
eval(['cd ' GOES16path(1:length(GOES16path)-1)]);
actionstr='save';
varstr1='GOESGridS RasterLats RasterLons GOESRasterFile';
varstr2=' GeoRef southEdge westEdge northEdge eastEdge';
varstr=strcat(varstr1,varstr2);
%[cmdString]=MyStrcat(actionstr,MatFileName,varstr,'-v7.3');
qualstr='-v7.3';
[cmdString]=MyStrcatV73(actionstr,MatFileName,varstr,qualstr);
eval(cmdString)
dispstr=strcat('Wrote Matlab File-',MatFileName);
disp(dispstr);
ab=1;
end