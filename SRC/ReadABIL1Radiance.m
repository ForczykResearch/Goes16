function ReadABIL1Radiance()
% Modified: This function will read in the GOES ABI-L1-Radiance Data
% This script loads netCDF files into MATLAB and displays info about the 
% dimensions and variables. I wrote this since can't find a function in the
% built-in set of netCDF functions included in MATLAB that displays all 
% header info of the file (equivalent to the old 'ncdump' function). 
%
% Replace the string 'filename.nc' with the file name you want to load.
% Make sure that the nc-file is located in the same folder as this script.
% Written By: Stephen Forczyk
% Created: Dec 19,2020
% Revised: Dec 20,2020 continue with added variable to decoder list
% Revised: Dec 21,2020 completed decoder list
% Classification: Unclassified
global BandDataS MetaDataS;
global RadS DQFS tS yS xS tBS goesImagerS yImgS yImgBS;
global xImgS xImgBS SatDataS GeoSpatialS YawFlipS;
global AlgoS ErrorS EarthSunS VersionContainerS;
global GoesWaveBand ESunS kappa0S PlanckS FocalPlaneS;
global TStarS BWaveTStarS StarIDS;
global GOESFileName;
global Band_IDS VPixCS OutPixCS MissingPixelS SaturatedPixelS TNumPtsS;
global UnSatPixS;
global ValidPixRadS AlgoProdVerCS;
global idebug isavefiles;
global MapFormFactor;
% additional paths needed for mapping
global matpath1 mappath GOES16path;
global jpegpath fid;
global GOES16Band1path GOES16Band2path GOES16Band3path GOES16Band4path;
global GOES16Band5path GOES16Band6path GOES16Band7path GOES16Band8path
global GOES16Band9path GOES16Band10path GOES16Band11path GOES16Band12path;
global GOES16Band13path GOES16Band14path GOES16Band15path GOES16Band16path;
global GOES16CloudTopHeightpath;

fprintf(fid,'%s\n','Start reading ABI-L1 Radiance data');

[nc_filenamesuf,path]=uigetfile('*nc','Select One GOES Data File');% SMF Modification
GOESFileName=nc_filenamesuf;
nc_filename=strcat(path,nc_filenamesuf);
ncid=netcdf.open(nc_filename,'nowrite');
MetaDataS=struct('source_file',[],'Level',[],'SatelliteID',[],'data_type',[],'bandID',[],...
    'start_scan_year',[],'start_scan_day',[],'start_scan_hour',[],'start_scan_min',[],...
    'start_scan_sec',[],'end_scan_year',[],'end_scan_day',[],'end_scan_hour',[],...
    'end_scan_min',[],'end_scan_sec',[]);
[iunder]=strfind(nc_filenamesuf,'_');
numunder=length(iunder);
[idash]=strfind(nc_filenamesuf,'-');
numdash=length(idash);
MetaDataS.source_file=nc_filenamesuf;
is=idash(1)+1;
ie=idash(2)-1;
MetaDataS.Level=nc_filenamesuf(is:ie);
is=iunder(2)+1;
ie=iunder(3)-1;
MetaDataS.SatelliteID=nc_filenamesuf(is:ie);
is=idash(2)+1;
ie=idash(3)-1;
MetaDataS.data_type=nc_filenamesuf(is:ie);
is=idash(3)+1;
ie=iunder(2)-1;
substr=nc_filenamesuf(is:ie);
strlen=length(substr);
[is]=strfind(substr,'C');
bandstr=substr(is+1:strlen);
bandnum=str2num(bandstr);
MetaDataS.bandID=bandnum;
is=iunder(3)+2;
ie=is+3;
MetaDataS.start_scan_year=str2num(nc_filenamesuf(is:ie));
is=ie+1;
ie=is+2;
MetaDataS.start_scan_day=str2num(nc_filenamesuf(is:ie));
is=ie+1;
ie=is+1;
MetaDataS.start_scan_hour=str2num(nc_filenamesuf(is:ie));
is=ie+1;
ie=is+1;
MetaDataS.start_scan_min=str2num(nc_filenamesuf(is:ie));
is=ie+1;
ie=is+2;
MetaDataS.start_scan_sec=str2num(nc_filenamesuf(is:ie));
is=iunder(4)+2;
ie=is+3;
MetaDataS.end_scan_year=str2num(nc_filenamesuf(is:ie));
is=ie+1;
ie=is+2;
MetaDataS.end_scan_day=str2num(nc_filenamesuf(is:ie));
is=ie+1;
ie=is+1;
MetaDataS.end_scan_hour=str2num(nc_filenamesuf(is:ie));
is=ie+1;
ie=is+1;
MetaDataS.end_scan_min=str2num(nc_filenamesuf(is:ie));
is=ie+1;
ie=is+2;
MetaDataS.end_scan_sec=str2num(nc_filenamesuf(is:ie));
RadS=struct('values',[],'FillValue',[],'Unsigned',[],'bit_depth',[],'valid_range',[],...
    'scale_factor',[],'add_offset',[],'resolution',[],'grid_mapping',[],...
    'ancillary_variables',[],'long_name',[],'standard_name',[],'units',[],'coordinates',[],...
    'cell_methods',[]); 
DQFS=struct('values',[],'fill',[],'valid_range',[],'units',[],'Unsigned',[],...
    'coordinates',[],'grid_mapping',[],'flag_values',[],'flag_meanings',[],...
    'number_of_qf_values',[],'long_name',[],'standard_name',[],'cell_methods',[],...
    'percent_good_pixel_qf',[],'percent_conditionally_usable_pixel_qf',[],...
    'percent_out_of_range_pixel_qf',[],'percent_no_value_pixel_qf',[],...
    'percent_focal_plane_temperature_threshold_exceeded_qf',[]);
tS=struct('long_name',[],'standard_name',[],'units',[],'axis',[],'bounds',[],'values',[]);
yS=struct('scale_factor',[],'add_offset',[],'units',[],'axis',[],'long_name',[],...
    'standard_name',[]);
xS=yS;
YawFlipS=struct('values',[],'long_name',[],'Unsigned',[],'FillValue',[],...
    'valid_range',[],'units',[],'coordinates',[],'flag_values',[],'flag_meanings',[]);
Band_IDS=struct('values',[],'long_name',[],'standard_name',[],'units',[]);
VPixCS=struct('values',[],'long_name',[],'FillValue',[],...
    'units',[],'coordinates',[],'grid_mapping',[],'cell_methods',[]);
OutPixCS=VPixCS;
TNumPtsS=VPixCS;
MissingPixelS=VPixCS;
SaturatedPixelS=VPixCS;
UnSatPixS=VPixCS;
TStarS=struct('values',[],'long_name',[],'standard_name',[],...
    'units',[],'axis',[]);
BWaveTStarS=struct('values',[],'long_name',[],'standard_name',[],'units',[]);
StarIDS=struct('values',[],'long_name',[],'Unsigned',[],'FillValue',[],'coordinates',[]);
AlgoProdVerCS=struct('values',[],'long_name',[],'algorithm_version',[],'product_version',[]);
ValidPixRadS=struct('values1',[],'long_name1',[],'standard_name1',[],'FillValue1',[],...
    'valid_range1',[],'units1',[],'coordinates1',[],'grid_mapping1',[],'cell_methods1',[],...
    'values2',[],'long_name2',[],'standard_name2',[],'FillValue2',[],...
    'valid_range2',[],'units2',[],'coordinates2',[],'grid_mapping2',[],'cell_methods2',[],...
    'values3',[],'long_name3',[],'standard_name3',[],'FillValue3',[],...
    'valid_range3',[],'units3',[],'coordinates3',[],'grid_mapping3',[],'cell_methods3',[],...
    'values4',[],'long_name4',[],'standard_name4',[],'FillValue4',[],...
    'units4',[],'coordinates4',[],'grid_mapping4',[],'cell_methods4',[]);
tBS=struct('values',[],'long_name',[]);
goesImagerS=struct('values',[],'long_name',[],'perspective_point_height',[],...
    'semi_major_axis',[],'semi_minor_axis',[],'inverse_flattening',[],...
    'latitude_of_projection_origin',[],'longitude_of_projection_origin',[],...
    'sweep_angle_axis',[]);
yImgS=struct('values',[],'long_name',[],'standard_name',[],'units',[],'axis',[]);
yImgBS=struct('values',[],'long_name',[],'units',[]);
xImgS=struct('values',[],'long_name',[],'standard_name',[],'units',[],'axis',[]);
xImgBS=struct('values',[],'long_name',[],'units',[]);
SatDataS=struct('values1',[],'long_name1',[],'standard_name1',[],...
    'FillValue1',[],'units1',[],'values2',[],'long_name2',[],'standard_name2',[],...
    'FillValue2',[],'units2',[],'values3',[],'long_name3',[],'standard_name3',[],...
    'FillValue3',[],'units3',[]);
GeoSpatialS=struct('values',[],'long_name',[],'geospatial_westbound_longitude',[],...
    'geospatial_northbound_latitude',[],'geospatial_eastbound_longitude',[],...
    'geospatial_southbound_latitude',[],'geospatial_lat_center',[],...
    'geospatial_lon_center',[],'geospatial_lat_nadir',[],'geospatial_lon_nadir',[],...
    'geospatial_lat_units',[],'geospatial_lon_units',[]);
BandDataS=struct('values',[],'long_name',[],'standard_name',[],'units',[]);

AlgoS=struct('values',[],'long_name',[],'input_ABI_L0_data',[]);
ErrorS=struct('values1',[],'long_name1',[],'FillValue1',[],'valid_range1',[],'units1',[],...
    'coordinates1',[],'grid_mapping1',[],'cell_methods1',[],...
    'values2',[],'long_name2',[],'FillValue2',[],'valid_range2',[],'units2',[],...
    'coordinates2',[],'grid_mapping2',[],'cell_methods2',[]);
EarthSunS=struct('values',[],'long_name',[],'FillValue',[],'units',[],...
    'coordinates',[],'cell_methods',[]);
VersionContainerS=struct('values',[],'long_name',[],'L1b_processing_parm_version',[]);
ESunS=struct('value',[],'long_name',[],'standard_name',[],'FillValue',[],...
    'units',[],'coordinates',[],'cell_methods',[]);
kappa0S=struct('values',[],'long_name',[],'FillValue',[],'units',[],'coordinates',[],...
    'cell_methods',[]);
PlanckS=struct('values1',[],'long_name1',[],'FillValue1',[],'units1',[],'coordinates1',[],...
   'values2',[],'long_name2',[],'FillValue2',[],'units2',[],'coordinates2',[],...
   'values3',[],'long_name3',[],'FillValue3',[],'units3',[],'coordinates3',[],...
   'values4',[],'long_name4',[],'FillValue4',[],'units4',[],'coordinates4',[]);
FocalPlaneS=struct('values1',[],'long_name1',[],'FillValue1',[],'units1',[],...
    'coordinates1',[],'grid_mapping1',[],'cell_methods1',[],'values2',[],...
    'long_name2',[],'FillValue2',[],'units2',[],...
    'values3',[],'long_name3',[],'FillValue3',[],'units3',[],...
    'values4',[],'long_name4',[],'FillValue4',[],...
    'units4',[]);
% Get information about the contents of the file.
[numdims, numvars, numglobalatts, unlimdimID] = netcdf.inq(ncid);
if(idebug==1)
    disp(' '),disp(' '),disp(' ')
    disp('________________________________________________________')
    disp('^~^~^~^~^~^~^~^~^~^~^~^~^~^~^~^~^~^~^~^~^~^~^~^~^~^~^~^~')
    disp(['VARIABLES CONTAINED IN THE netCDF FILE: ' nc_filename ])
    dispstr=strcat('VARIABLES CONTAINED IN THE netCDF FILE:',GOESFileName);
    disp(' ')
    fprintf(fid,'%s\n','________________________________________________________');
    fprintf(fid,'%s\n','^~^~^~^~^~^~^~^~^~^~^~^~^~^~^~^~^~^~^~^~^~^~^~^~^~^~^~^~');
    fprintf(fid,'%s\n',dispstr);
    variablestr=strcat('Number of variables in file=',num2str(numvars));
    disp(variablestr);
    fprintf(fid,'%s\n',variablestr);
    fprintf(fid,'\n');
end
for i = 0:numvars-1
    [varname, xtype, dimids, numatts] = netcdf.inqVar(ncid,i);
     if(idebug==1)
        disp(['--------------------< ' varname ' >---------------------'])
        dispstr=strcat('--------------',varname,'--------------');
        fprintf(fid,'\n');
        fprintf(fid,'%s\n',dispstr);
     end
    flag = 0;
    for j = 0:numatts - 1
        a10=strcmp(varname,'Rad');
        a20=strcmp(varname,'DQF');
        a30=strcmp(varname,'t');
        a40=strcmp(varname,'y');
        a50=strcmp(varname,'x');
        a60=strcmp(varname,'time_bounds');
        a70=strcmp(varname,'goes_imager_projection');
        a80=strcmp(varname,'y_image');
        a90=strcmp(varname,'y_image_bounds');
        a100=strcmp(varname,'x_image');
        a110=strcmp(varname,'x_image_bounds');
        a120=strcmp(varname,'nominal_satellite_subpoint_lat');
        a130=strcmp(varname,'nominal_satellite_subpoint_lon');
        a140=strcmp(varname,'nominal_satellite_height');
        a150=strcmp(varname,'geospatial_lat_lon_extent');
        a160=strcmp(varname,'band_wavelength');
        a210=strcmp(varname,'algorithm_dynamic_input_data_container');
        a220=strcmp(varname,'percent_uncorrectable_GRB_errors');
        a230=strcmp(varname,'percent_uncorrectable_L0_errors');
        a240=strcmp(varname,'earth_sun_distance_anomaly_in_AU');
        a250=strcmp(varname,'processing_parm_version_container');
        a260=strcmp(varname,'algorithm_product_version_container');
        a270=strcmp(varname,'esun');
        a280=strcmp(varname,'kappa0');
        a290=strcmp(varname,'planck_fk1');
        a300=strcmp(varname,'planck_fk2');
        a310=strcmp(varname,'planck_bc1');
        a320=strcmp(varname,'planck_bc2');
        a330=strcmp(varname,'focal_plane_temperature_threshold_exceeded_count');
        a340=strcmp(varname,'maximum_focal_plane_temperature');
        a350=strcmp(varname,'focal_plane_temperature_threshold_increasing');
        a360=strcmp(varname,'focal_plane_temperature_threshold_decreasing');
        a370=strcmp(varname,'band_id');
        a380=strcmp(varname,'valid_pixel_count');
        a410=strcmp(varname,'yaw_flip_flag');
        a420=strcmp(varname,'missing_pixel_count');
        a430=strcmp(varname,'saturated_pixel_count');
        a440=strcmp(varname,'min_radiance_value_of_valid_pixels');
        a450=strcmp(varname,'max_radiance_value_of_valid_pixels');
        a460=strcmp(varname,'mean_radiance_value_of_valid_pixels');
        a470=strcmp(varname,'std_dev_radiance_value_of_valid_pixels');
        a480=strcmp(varname,'t_star_look');
        a490=strcmp(varname,'band_wavelength_star_look');
        a500=strcmp(varname,'star_id');
        a510=strcmp(varname,'undersaturated_pixel_count');
        if (a10==1)
            attname1 = netcdf.inqAttName(ncid,i,j);
            attname2 = netcdf.getAtt(ncid,i,attname1);
            if(idebug==1)
                disp([attname1 ':  ' num2str(attname2)])
                dispstr=strcat(attname1,': ',num2str(attname2));
                fprintf(fid,'%s\n',dispstr);
            end
            if strcmp('add_offset',attname1)
                offset = attname2;
            end
            if strcmp('scale_factor',attname1)
                scale = attname2;
                flag = 1;
            end 
            a1=strcmp(attname1,'long_name');
            if(a1==1)
                RadS.long_name=attname2;
            end
            a1=strcmp(attname1,'standard_name');
            if(a1==1)
                RadS.standard_name=attname2;
            end
            a1=strcmp(attname1,'_FillValue');
            if(a1==1)
                RadS.FillValue=attname2;
            end
            a1=strcmp(attname1,'units');
            if(a1==1)
                RadS.units=attname2;
            end
            a1=strcmp(attname1,'scale_factor');
            if(a1==1)
                RadS.scale_factor=attname2;
            end
            a1=strcmp(attname1,'add_offset');
            if(a1==1)
                RadS.add_offset=attname2;
            end
            a1=strcmp(attname1,'resolution');
            if(a1==1)
                RadS.resolution=attname2;
            end
            a1=strcmp(attname1,'grid_mapping');
            if(a1==1)
                RadS.grid_mapping=attname2;
            end
            a1=strcmp(attname1,'ancillary_variables');
            if(a1==1)
                RadS.ancillary_variables=attname2;
            end
            a1=strcmp(attname1,'_Unsigned');
            if(a1==1)
                RadS.Unsigned=attname2;
            end
            a1=strcmp(attname1,'sensor_band_bit_depth');
            if(a1==1)
                RadS.bit_depth=attname2;
            end
            a1=strcmp(attname1,'valid_range');
            if(a1==1)
                RadS.valid_range=attname2;
            end
            a1=strcmp(attname1,'cell_methods');
            if(a1==1)
                RadS.cell_methods=attname2;
            end
            a1=strcmp(attname1,'coordinates');
            if(a1==1)
                RadS.coordinates=attname2;
            end
            a1=strcmp(attname1,'units');
            if(a1==1)
                RadS.units=attname2;
            end
        elseif (a20==1)
            attname1 = netcdf.inqAttName(ncid,i,j);
            attname2 = netcdf.getAtt(ncid,i,attname1);
            if(idebug==1)
                disp([attname1 ':  ' num2str(attname2)])
                dispstr=strcat(attname1,': ',num2str(attname2));
                fprintf(fid,'%s\n',dispstr);
            end
            if strcmp('add_offset',attname1)
                offset = attname2;
            end
            if strcmp('scale_factor',attname1)
                scale = attname2;
                flag = 1;
            end 
            a1=strcmp(attname1,'_FillValue');
            if(a1==1)
                DQFS.fill=attname2;
            end
            a1=strcmp(attname1,'valid_range');
            if(a1==1)
                DQFS.valid_range=attname2;
            end
            a1=strcmp(attname1,'units');
            if(a1==1)
                DQFS.units=attname2;
            end
            a1=strcmp(attname1,'coordinates');
            if(a1==1)
                DQFS.coordinates=attname2;
            end
            a1=strcmp(attname1,'grid_mapping');
            if(a1==1)
                DQFS.grid_mapping=attname2;
            end
            a1=strcmp(attname1,'flag_values');
            if(a1==1)
                DQFS.flag_values=attname2;
            end
            a1=strcmp(attname1,'flag_meanings');
            if(a1==1)
                DQFS.flag_meanings=attname2;
            end
            a1=strcmp(attname1,'number_of_qf_values');
            if(a1==1)
                DQFS.number_of_qf_values=attname2;
            end
            a1=strcmp(attname1,'long_name');
            if(a1==1)
                DQFS.long_name=attname2;
            end
            a1=strcmp(attname1,'standard_name');
            if(a1==1)
                DQFS.standard_name=attname2;
            end
            a1=strcmp(attname1,'percent_good_pixel_qf');
            if(a1==1)
                DQFS.percent_good_pixel_qf=attname2;
            end 
            a1=strcmp(attname1,'percent_conditionally_usable_pixel_qf');
            if(a1==1)
                DQFS.percent_conditionally_usable_pixel_qf=attname2;
            end
            a1=strcmp(attname1,'percent_out_of_range_pixel_qf');
            if(a1==1)
                DQFS.percent_out_of_range_pixel_qf=attname2;
            end
            a1=strcmp(attname1,'percent_no_value_pixel_qf');
            if(a1==1)
                DQFS.percent_no_value_pixel_qf=attname2;
            end
            a1=strcmp(attname1,'percent_focal_plane_temperature_threshold_exceeded_qf');
            if(a1==1)
                DQFS.percent_focal_plane_temperature_threshold_exceeded_qf=attname2;
            end 
            a1=strcmp(attname1,'_Unsigned');
            if(a1==1)
                DQFS.Unsigned=attname2;
            end 
            a1=strcmp(attname1,'cell_methods');
            if(a1==1)
                DQFS.cell_methods=attname2;
            end 
        elseif (a30==1)
            attname1 = netcdf.inqAttName(ncid,i,j);
            attname2 = netcdf.getAtt(ncid,i,attname1);
            if(idebug==1)
                disp([attname1 ':  ' num2str(attname2)])
                dispstr=strcat(attname1,': ',num2str(attname2));
                fprintf(fid,'%s\n',dispstr);
            end
            if strcmp('add_offset',attname1)
                offset = attname2;
            end
            if strcmp('scale_factor',attname1)
                scale = attname2;
                flag = 1;
            end 
            a1=strcmp(attname1,'units');
            if(a1==1)
                tS.units=attname2;
            end
            a1=strcmp(attname1,'axis');
            if(a1==1)
                tS.axis=attname2;
            end
            a1=strcmp(attname1,'bounds');
            if(a1==1)
                tS.bounds=attname2;
            end
            a1=strcmp(attname1,'long_name');
            if(a1==1)
                tS.long_name=attname2;
            end
            a1=strcmp(attname1,'standard_name');
            if(a1==1)
                tS.standard_name=attname2;
            end
        elseif (a40==1)
            attname1 = netcdf.inqAttName(ncid,i,j);
            attname2 = netcdf.getAtt(ncid,i,attname1);
            if(idebug==1)
                disp([attname1 ':  ' num2str(attname2)])
                dispstr=strcat(attname1,': ',num2str(attname2));
                fprintf(fid,'%s\n',dispstr);
            end
            if strcmp('add_offset',attname1)
                offset = attname2;
            end
            if strcmp('scale_factor',attname1)
                scale = attname2;
                flag = 1;
            end 
            a1=strcmp(attname1,'scale_factor');
            if(a1==1)
                yS.scale_factor=attname2;
            end
            a1=strcmp(attname1,'add_offset');
            if(a1==1)
                yS.add_offset=attname2;
            end
            a1=strcmp(attname1,'units');
            if(a1==1)
                yS.units=attname2;
            end
            a1=strcmp(attname1,'axis');
            if(a1==1)
                yS.axis=attname2;
            end
            a1=strcmp(attname1,'long_name');
            if(a1==1)
                yS.long_name=attname2;
            end
            a1=strcmp(attname1,'standard_name');
            if(a1==1)
                yS.standard_name=attname2;
            end
        elseif (a50==1)
            attname1 = netcdf.inqAttName(ncid,i,j);
            attname2 = netcdf.getAtt(ncid,i,attname1);
            if(idebug==1)
                disp([attname1 ':  ' num2str(attname2)])
                dispstr=strcat(attname1,': ',num2str(attname2));
                fprintf(fid,'%s\n',dispstr);
            end
            if strcmp('add_offset',attname1)
                offset = attname2;
            end
            if strcmp('scale_factor',attname1)
                scale = attname2;
                flag = 1;
            end 
            a1=strcmp(attname1,'scale_factor');
            if(a1==1)
                xS.scale_factor=attname2;
            end
            a1=strcmp(attname1,'add_offset');
            if(a1==1)
                xS.add_offset=attname2;
            end
            a1=strcmp(attname1,'units');
            if(a1==1)
                xS.units=attname2;
            end
            a1=strcmp(attname1,'axis');
            if(a1==1)
                xS.axis=attname2;
            end
            a1=strcmp(attname1,'long_name');
            if(a1==1)
                xS.long_name=attname2;
            end
            a1=strcmp(attname1,'standard_name');
            if(a1==1)
                xS.standard_name=attname2;
            end
        elseif (a60==1)
            attname1 = netcdf.inqAttName(ncid,i,j);
            attname2 = netcdf.getAtt(ncid,i,attname1);
            if(idebug==1)
                disp([attname1 ':  ' num2str(attname2)])
                dispstr=strcat(attname1,': ',num2str(attname2));
                fprintf(fid,'%s\n',dispstr);
            end
            if strcmp('add_offset',attname1)
                offset = attname2;
            end
            if strcmp('scale_factor',attname1)
                scale = attname2;
                flag = 1;
            end 
            a1=strcmp(attname1,'long_name');
            if(a1==1)
                tBS.long_name=attname2;
            end
        elseif (a70==1)
            attname1 = netcdf.inqAttName(ncid,i,j);
            attname2 = netcdf.getAtt(ncid,i,attname1);
            if(idebug==1)
                disp([attname1 ':  ' num2str(attname2)])
                dispstr=strcat(attname1,': ',num2str(attname2));
                fprintf(fid,'%s\n',dispstr);
            end
            if strcmp('add_offset',attname1)
                offset = attname2;
            end
            if strcmp('scale_factor',attname1)
                scale = attname2;
                flag = 1;
            end 
            a1=strcmp(attname1,'long_name');
            if(a1==1)
                goesImagerS.long_name=attname2;
            end
            a1=strcmp(attname1,'grid_mapping_name');
            if(a1==1)
                goesImagerS.grid_Mapping_name=attname2;
            end
            a1=strcmp(attname1,'perspective_point_height');
            if(a1==1)
                goesImagerS.perspective_point_height=attname2;
            end
            a1=strcmp(attname1,'semi_major_axis');
            if(a1==1)
                goesImagerS.semi_major_axis=attname2;
            end
            a1=strcmp(attname1,'semi_minor_axis');
            if(a1==1)
                goesImagerS.semi_minor_axis=attname2;
            end
            a1=strcmp(attname1,'inverse_flattening');
            if(a1==1)
                goesImagerS.inverse_flattening=attname2;
            end
            a1=strcmp(attname1,'latitude_of_projection_origin');
            if(a1==1)
                goesImagerS.latitude_of_projection_origin=attname2;
            end
            a1=strcmp(attname1,'longitude_of_projection_origin');
            if(a1==1)
                goesImagerS.longitude_of_projection_origin=attname2;
            end
            a1=strcmp(attname1,'sweep_angle_axis');
            if(a1==1)
                goesImagerS.sweep_angle_axis=attname2;
            end
       elseif (a80==1)
            attname1 = netcdf.inqAttName(ncid,i,j);
            attname2 = netcdf.getAtt(ncid,i,attname1);
            if(idebug==1)
                disp([attname1 ':  ' num2str(attname2)])
                dispstr=strcat(attname1,': ',num2str(attname2));
                fprintf(fid,'%s\n',dispstr);
            end
            if strcmp('add_offset',attname1)
                offset = attname2;
            end
            if strcmp('scale_factor',attname1)
                scale = attname2;
                flag = 1;
            end 
            a1=strcmp(attname1,'long_name');
            if(a1==1)
                yImgS.long_name=attname2;
            end
            a1=strcmp(attname1,'standard_name');
            if(a1==1)
                yImgS.standard_name=attname2;
            end
            a1=strcmp(attname1,'units');
            if(a1==1)
                yImgS.units=attname2;
            end
            a1=strcmp(attname1,'axis');
            if(a1==1)
                yImgS.axis=attname2;
            end
        elseif (a90==1)
            attname1 = netcdf.inqAttName(ncid,i,j);
            attname2 = netcdf.getAtt(ncid,i,attname1);
            if(idebug==1)
                disp([attname1 ':  ' num2str(attname2)])
                dispstr=strcat(attname1,': ',num2str(attname2));
                fprintf(fid,'%s\n',dispstr);
            end
            a1=strcmp(attname1,'long_name');
            if(a1==1)
                yImgBS.long_name=attname2;
            end
            a1=strcmp(attname1,'units');
            if(a1==1)
                yImgBS.units=attname2;
            end
        elseif (a100==1)
            attname1 = netcdf.inqAttName(ncid,i,j);
            attname2 = netcdf.getAtt(ncid,i,attname1);
            if(idebug==1)
                disp([attname1 ':  ' num2str(attname2)])
                dispstr=strcat(attname1,': ',num2str(attname2));
                fprintf(fid,'%s\n',dispstr);
            end
            a1=strcmp(attname1,'long_name');
            if(a1==1)
                xImgS.long_name=attname2;
            end
            a1=strcmp(attname1,'standard_name');
            if(a1==1)
                xImgS.standard_name=attname2;
            end
            a1=strcmp(attname1,'units');
            if(a1==1)
                xImgS.units=attname2;
            end
            a1=strcmp(attname1,'axis');
            if(a1==1)
                xImgS.axis=attname2;
            end
        elseif (a110==1)
            attname1 = netcdf.inqAttName(ncid,i,j);
            attname2 = netcdf.getAtt(ncid,i,attname1);
            if(idebug==1)
                disp([attname1 ':  ' num2str(attname2)])
                dispstr=strcat(attname1,': ',num2str(attname2));
                fprintf(fid,'%s\n',dispstr);
            end
            a1=strcmp(attname1,'long_name');
            if(a1==1)
                xImgBS.long_name=attname2;
            end
            a1=strcmp(attname1,'units');
            if(a1==1)
                xImgBS.units=attname2;
            end
        elseif (a120==1)
            attname1 = netcdf.inqAttName(ncid,i,j);
            attname2 = netcdf.getAtt(ncid,i,attname1);
            if(idebug==1)
                disp([attname1 ':  ' num2str(attname2)])
                dispstr=strcat(attname1,': ',num2str(attname2));
                fprintf(fid,'%s\n',dispstr);
            end
            a1=strcmp(attname1,'long_name');
            if(a1==1)
                SatDataS.long_name1=attname2;
            end
            a1=strcmp(attname1,'standard_name');
            if(a1==1)
                SatDataS.standard_name1=attname2;
            end
            a1=strcmp(attname1,'_FillValue');
            if(a1==1)
                SatDataS.FillValue1=attname2;
            end
            a1=strcmp(attname1,'units');
            if(a1==1)
                SatDataS.units1=attname2;
            end
        elseif (a130==1)
            attname1 = netcdf.inqAttName(ncid,i,j);
            attname2 = netcdf.getAtt(ncid,i,attname1);
            if(idebug==1)
                disp([attname1 ':  ' num2str(attname2)])
                dispstr=strcat(attname1,': ',num2str(attname2));
                fprintf(fid,'%s\n',dispstr);
            end
            a1=strcmp(attname1,'long_name');
            if(a1==1)
                SatDataS.long_name2=attname2;
            end
            a1=strcmp(attname1,'standard_name');
            if(a1==1)
                SatDataS.standard_name2=attname2;
            end
            a1=strcmp(attname1,'_FillValue');
            if(a1==1)
                SatDataS.FillValue2=attname2;
            end
            a1=strcmp(attname1,'units');
            if(a1==1)
                SatDataS.units2=attname2;
            end
        elseif (a140==1)
            attname1 = netcdf.inqAttName(ncid,i,j);
            attname2 = netcdf.getAtt(ncid,i,attname1);
            if(idebug==1)
                disp([attname1 ':  ' num2str(attname2)])
                dispstr=strcat(attname1,': ',num2str(attname2));
                fprintf(fid,'%s\n',dispstr);
            end
            a1=strcmp(attname1,'long_name');
            if(a1==1)
                SatDataS.long_name3=attname2;
            end
            a1=strcmp(attname1,'standard_name');
            if(a1==1)
                SatDataS.standard_name3=attname2;
            end
            a1=strcmp(attname1,'_FillValue');
            if(a1==1)
                SatDataS.FillValue3=attname2;
            end
            a1=strcmp(attname1,'units');
            if(a1==1)
                SatDataS.units3=attname2;
            end
        elseif (a150==1)
            attname1 = netcdf.inqAttName(ncid,i,j);
            attname2 = netcdf.getAtt(ncid,i,attname1);
            if(idebug==1)
                disp([attname1 ':  ' num2str(attname2)])
                dispstr=strcat(attname1,': ',num2str(attname2));
                fprintf(fid,'%s\n',dispstr);
            end
            a1=strcmp(attname1,'long_name');
            if(a1==1)
                GeoSpatialS.long_name=attname2;
            end
            a1=strcmp(attname1,'geospatial_westbound_longitude');
            if(a1==1)
                GeoSpatialS.geospatial_westbound_longitude=attname2;
            end
            a1=strcmp(attname1,'geospatial_northbound_latitude');
            if(a1==1)
                GeoSpatialS.geospatial_northbound_latitude=attname2;
            end
            a1=strcmp(attname1,'geospatial_eastbound_longitude');
            if(a1==1)
                GeoSpatialS.geospatial_eastbound_longitude=attname2;
            end
            a1=strcmp(attname1,'geospatial_southbound_latitude');
            if(a1==1)
                GeoSpatialS.geospatial_southbound_latitude=attname2;
            end
            a1=strcmp(attname1,'geospatial_lat_center');
            if(a1==1)
                GeoSpatialS.geospatial_lat_center=attname2;
            end
            a1=strcmp(attname1,'geospatial_lon_center');
            if(a1==1)
                GeoSpatialS.geospatial_lon_center=attname2;
            end
            a1=strcmp(attname1,'geospatial_lat_nadir');
            if(a1==1)
                GeoSpatialS.geospatial_lat_nadir=attname2;
            end
            a1=strcmp(attname1,'geospatial_lon_nadir');
            if(a1==1)
                GeoSpatialS.geospatial_lon_nadir=attname2;
            end
            a1=strcmp(attname1,'geospatial_lat_units');
            if(a1==1)
                GeoSpatialS.geospatial_lat_units=attname2;
            end
            a1=strcmp(attname1,'geospatial_lon_units');
            if(a1==1)
                GeoSpatialS.geospatial_lon_units=attname2;
            end
        elseif (a160==1)
            attname1 = netcdf.inqAttName(ncid,i,j);
            attname2 = netcdf.getAtt(ncid,i,attname1);
            if(idebug==1)
                disp([attname1 ':  ' num2str(attname2)])
                dispstr=strcat(attname1,': ',num2str(attname2));
                fprintf(fid,'%s\n',dispstr);
            end
            a1=strcmp(attname1,'long_name');
            if(a1==1)
                BandDataS.long_name=attname2;
            end
            a1=strcmp(attname1,'standard_name');
            if(a1==1)
                BandDataS.standard_name=attname2;
            end
            a1=strcmp(attname1,'units');
            if(a1==1)
                BandDataS.units=attname2;
            end
        elseif (a210==1)
            attname1 = netcdf.inqAttName(ncid,i,j);
            attname2 = netcdf.getAtt(ncid,i,attname1);
            if(idebug==1)
                disp([attname1 ':  ' num2str(attname2)])
                dispstr=strcat(attname1,': ',num2str(attname2));
                fprintf(fid,'%s\n',dispstr);
            end
            a1=strcmp(attname1,'long_name');
            if(a1==1)
                AlgoS.long_name=attname2;
            end
            a1=strcmp(attname1,'input_ABI_L0_data');
            if(a1==1)
                AlgoS.input_ABI_L0_data=attname2;
            end
        elseif (a220==1)
            attname1 = netcdf.inqAttName(ncid,i,j);
            attname2 = netcdf.getAtt(ncid,i,attname1);
            if(idebug==1)
                disp([attname1 ':  ' num2str(attname2)])
                dispstr=strcat(attname1,': ',num2str(attname2));
                fprintf(fid,'%s\n',dispstr);
            end
            a1=strcmp(attname1,'long_name');
            if(a1==1)
                ErrorS.long_name1=attname2;
            end
            a1=strcmp(attname1,'_FillValue');
            if(a1==1)
                ErrorS.FillValue1=attname2;
            end
            a1=strcmp(attname1,'valid_range');
            if(a1==1)
                ErrorS.valid_range1=attname2;
            end
            a1=strcmp(attname1,'units');
            if(a1==1)
                ErrorS.units1=attname2;
            end
            a1=strcmp(attname1,'coordinates');
            if(a1==1)
                ErrorS.coordinates1=attname2;
            end
            a1=strcmp(attname1,'grid_mapping');
            if(a1==1)
                ErrorS.grid_mapping1=attname2;
            end
            a1=strcmp(attname1,'cell_methods');
            if(a1==1)
                ErrorS.cell_methods1=attname2;
            end
         elseif (a230==1)
            attname1 = netcdf.inqAttName(ncid,i,j);
            attname2 = netcdf.getAtt(ncid,i,attname1);
            if(idebug==1)
                disp([attname1 ':  ' num2str(attname2)])
                dispstr=strcat(attname1,': ',num2str(attname2));
                fprintf(fid,'%s\n',dispstr);
            end
            a1=strcmp(attname1,'long_name');
            if(a1==1)
                ErrorS.long_name2=attname2;
            end
            a1=strcmp(attname1,'_FillValue');
            if(a1==1)
                ErrorS.FillValue2=attname2;
            end
            a1=strcmp(attname1,'valid_range');
            if(a1==1)
                ErrorS.valid_range2=attname2;
            end
            a1=strcmp(attname1,'units');
            if(a1==1)
                ErrorS.units2=attname2;
            end
            a1=strcmp(attname1,'coordinates');
            if(a1==1)
                ErrorS.coordinates2=attname2;
            end
            a1=strcmp(attname1,'grid_mapping');
            if(a1==1)
                ErrorS.grid_mapping2=attname2;
            end
            a1=strcmp(attname1,'cell_methods');
            if(a1==1)
                ErrorS.cell_methods2=attname2;
            end
        elseif (a240==1)
            attname1 = netcdf.inqAttName(ncid,i,j);
            attname2 = netcdf.getAtt(ncid,i,attname1);
            if(idebug==1)
                disp([attname1 ':  ' num2str(attname2)])
                dispstr=strcat(attname1,': ',num2str(attname2));
                fprintf(fid,'%s\n',dispstr);
            end
            a1=strcmp(attname1,'long_name');
            if(a1==1)
                EarthSunS.long_name=attname2;
            end
            a1=strcmp(attname1,'_FillValue');
            if(a1==1)
                EarthSunS.FillValue=attname2;
            end
            a1=strcmp(attname1,'units');
            if(a1==1)
                EarthSunS.units=attname2;
            end
            a1=strcmp(attname1,'coordinates');
            if(a1==1)
                EarthSunS.coordinates=attname2;
            end
            a1=strcmp(attname1,'cell_methods');
            if(a1==1)
                EarthSunS.cell_methods=attname2;
            end
        elseif (a250==1)
            attname1 = netcdf.inqAttName(ncid,i,j);
            attname2 = netcdf.getAtt(ncid,i,attname1);
            if(idebug==1)
                disp([attname1 ':  ' num2str(attname2)])
                dispstr=strcat(attname1,': ',num2str(attname2));
                fprintf(fid,'%s\n',dispstr);
            end
            a1=strcmp(attname1,'long_name');
            if(a1==1)
                VersionContainerS.long_name=attname2;
            end
            a1=strcmp(attname1,'L1b_processing_parm_version');
            if(a1==1)
                VersionContainerS.L1b_processing_parm_version=attname2;
            end
        elseif (a260==1)
            attname1 = netcdf.inqAttName(ncid,i,j);
            attname2 = netcdf.getAtt(ncid,i,attname1);
            if(idebug==1)
                disp([attname1 ':  ' num2str(attname2)])
                dispstr=strcat(attname1,': ',num2str(attname2));
                fprintf(fid,'%s\n',dispstr);
            end
            a1=strcmp(attname1,'long_name');
            if(a1==1)
                AlgoProdVerCS.long_name=attname2;
            end
            a1=strcmp(attname1,'algorithm_version');
            if(a1==1)
                AlgoProdVerCS.algorithm_version=attname2;
            end
            a1=strcmp(attname1,'product_version');
            if(a1==1)
                AlgoProdVerCS.product_version=attname2;
            end
        elseif (a270==1)
            attname1 = netcdf.inqAttName(ncid,i,j);
            attname2 = netcdf.getAtt(ncid,i,attname1);
            if(idebug==1)
                disp([attname1 ':  ' num2str(attname2)])
                dispstr=strcat(attname1,': ',num2str(attname2));
                fprintf(fid,'%s\n',dispstr);
            end
            a1=strcmp(attname1,'long_name');
            if(a1==1)
                ESunS.long_name=attname2;
            end
            a1=strcmp(attname1,'standard_name');
            if(a1==1)
                ESunS.standard_name=attname2;
            end
            a1=strcmp(attname1,'_FillValue');
            if(a1==1)
                ESunS.FillValue=attname2;
            end
            a1=strcmp(attname1,'units');
            if(a1==1)
                ESunS.units=attname2;
            end
            a1=strcmp(attname1,'coordinates');
            if(a1==1)
                ESunS.coordinates=attname2;
            end
            a1=strcmp(attname1,'cell_methods');
            if(a1==1)
                ESunS.cell_methods=attname2;
            end
        elseif (a280==1)
            attname1 = netcdf.inqAttName(ncid,i,j);
            attname2 = netcdf.getAtt(ncid,i,attname1);
            if(idebug==1)
                disp([attname1 ':  ' num2str(attname2)])
                dispstr=strcat(attname1,': ',num2str(attname2));
                fprintf(fid,'%s\n',dispstr);
            end
            a1=strcmp(attname1,'long_name');
            if(a1==1)
                kappa0S.long_name=attname2;
            end
            a1=strcmp(attname1,'_FillValue');
            if(a1==1)
                kappa0S.FillValue=attname2;
            end
            a1=strcmp(attname1,'units');
            if(a1==1)
                kappa0S.units=attname2;
            end
            a1=strcmp(attname1,'coordinates');
            if(a1==1)
                kappa0S.coordinates=attname2;
            end
            a1=strcmp(attname1,'cell_methods');
            if(a1==1)
                kappa0S.cell_methods=attname2;
            end
        elseif (a290==1)
            attname1 = netcdf.inqAttName(ncid,i,j);
            attname2 = netcdf.getAtt(ncid,i,attname1);
            if(idebug==1)
                disp([attname1 ':  ' num2str(attname2)])
                dispstr=strcat(attname1,': ',num2str(attname2));
                fprintf(fid,'%s\n',dispstr);
            end
            a1=strcmp(attname1,'long_name');
            if(a1==1)
                PlanckS.long_name1=attname2;
            end
            a1=strcmp(attname1,'_FillValue');
            if(a1==1)
                PlanckS.FillValue1=attname2;
            end
            a1=strcmp(attname1,'units');
            if(a1==1)
                PlanckS.units1=attname2;
            end
            a1=strcmp(attname1,'coordinates');
            if(a1==1)
                PlanckS.coordinates1=attname2;
            end
        elseif (a300==1)
            attname1 = netcdf.inqAttName(ncid,i,j);
            attname2 = netcdf.getAtt(ncid,i,attname1);
            if(idebug==1)
                disp([attname1 ':  ' num2str(attname2)])
                dispstr=strcat(attname1,': ',num2str(attname2));
                fprintf(fid,'%s\n',dispstr);
            end
            a1=strcmp(attname1,'long_name');
            if(a1==1)
                PlanckS.long_name2=attname2;
            end
            a1=strcmp(attname1,'_FillValue');
            if(a1==1)
                PlanckS.FillValue2=attname2;
            end
            a1=strcmp(attname1,'units');
            if(a1==1)
                PlanckS.units2=attname2;
            end
            a1=strcmp(attname1,'coordinates');
            if(a1==1)
                PlanckS.coordinates2=attname2;
            end
        elseif (a310==1)
            attname1 = netcdf.inqAttName(ncid,i,j);
            attname2 = netcdf.getAtt(ncid,i,attname1);
            if(idebug==1)
                disp([attname1 ':  ' num2str(attname2)])
                dispstr=strcat(attname1,': ',num2str(attname2));
                fprintf(fid,'%s\n',dispstr);
            end
            a1=strcmp(attname1,'long_name');
            if(a1==1)
                PlanckS.long_name3=attname2;
            end
            a1=strcmp(attname1,'_FillValue');
            if(a1==1)
                PlanckS.FillValue3=attname2;
            end
            a1=strcmp(attname1,'units');
            if(a1==1)
                PlanckS.units3=attname2;
            end
            a1=strcmp(attname1,'coordinates');
            if(a1==1)
                PlanckS.coordinates3=attname2;
            end
        elseif (a320==1)
            attname1 = netcdf.inqAttName(ncid,i,j);
            attname2 = netcdf.getAtt(ncid,i,attname1);
            if(idebug==1)
                disp([attname1 ':  ' num2str(attname2)])
                dispstr=strcat(attname1,': ',num2str(attname2));
                fprintf(fid,'%s\n',dispstr);
            end
            a1=strcmp(attname1,'long_name');
            if(a1==1)
                PlanckS.long_name4=attname2;
            end
            a1=strcmp(attname1,'_FillValue');
            if(a1==1)
                PlanckS.FillValue4=attname2;
            end
            a1=strcmp(attname1,'units');
            if(a1==1)
                PlanckS.units4=attname2;
            end
            a1=strcmp(attname1,'coordinates');
            if(a1==1)
                PlanckS.coordinates4=attname2;
            end
        elseif (a330==1)
            attname1 = netcdf.inqAttName(ncid,i,j);
            attname2 = netcdf.getAtt(ncid,i,attname1);
            if(idebug==1)
                disp([attname1 ':  ' num2str(attname2)])
                dispstr=strcat(attname1,': ',num2str(attname2));
                fprintf(fid,'%s\n',dispstr);
            end
            a1=strcmp(attname1,'long_name');
            if(a1==1)
                FocalPlaneS.long_name1=attname2;
            end
            a1=strcmp(attname1,'_FillValue');
            if(a1==1)
                FocalPlaneS.FillValue1=attname2;
            end
            a1=strcmp(attname1,'units');
            if(a1==1)
                FocalPlaneS.units1=attname2;
            end
            a1=strcmp(attname1,'coordinates');
            if(a1==1)
                FocalPlaneS.coordinates1=attname2;
            end
            a1=strcmp(attname1,'grid_mapping');
            if(a1==1)
                FocalPlaneS.grid_mapping1=attname2;
            end
            a1=strcmp(attname1,'cell_methods');
            if(a1==1)
                FocalPlaneS.cell_methods1=attname2;
            end
         elseif (a340==1)
            attname1 = netcdf.inqAttName(ncid,i,j);
            attname2 = netcdf.getAtt(ncid,i,attname1);
            if(idebug==1)
                disp([attname1 ':  ' num2str(attname2)])
                dispstr=strcat(attname1,': ',num2str(attname2));
                fprintf(fid,'%s\n',dispstr);
            end
            a1=strcmp(attname1,'long_name');
            if(a1==1)
                FocalPlaneS.long_name2=attname2;
            end
            a1=strcmp(attname1,'_FillValue');
            if(a1==1)
                FocalPlaneS.FillValue2=attname2;
            end
            a1=strcmp(attname1,'units');
            if(a1==1)
                FocalPlaneS.units2=attname2;
            end
            a1=strcmp(attname1,'coordinates');
            if(a1==1)
                FocalPlaneS.coordinates2=attname2;
            end
            a1=strcmp(attname1,'grid_mapping');
            if(a1==1)
                FocalPlaneS.grid_mapping2=attname2;
            end
        elseif (a350==1)
            attname1 = netcdf.inqAttName(ncid,i,j);
            attname2 = netcdf.getAtt(ncid,i,attname1);
            if(idebug==1)
                disp([attname1 ':  ' num2str(attname2)])
                dispstr=strcat(attname1,': ',num2str(attname2));
                fprintf(fid,'%s\n',dispstr);
            end
            a1=strcmp(attname1,'long_name');
            if(a1==1)
                FocalPlaneS.long_name3=attname2;
            end
            a1=strcmp(attname1,'_FillValue');
            if(a1==1)
                FocalPlaneS.FillValue3=attname2;
            end
            a1=strcmp(attname1,'units');
            if(a1==1)
                FocalPlaneS.units3=attname2;
            end
            a1=strcmp(attname1,'coordinates');
            if(a1==1)
                FocalPlaneS.coordinates3=attname2;
            end
            a1=strcmp(attname1,'grid_mapping');
            if(a1==1)
                FocalPlaneS.grid_mapping3=attname2;
            end
        elseif (a360==1)
            attname1 = netcdf.inqAttName(ncid,i,j);
            attname2 = netcdf.getAtt(ncid,i,attname1);
            if(idebug==1)
                disp([attname1 ':  ' num2str(attname2)])
                dispstr=strcat(attname1,': ',num2str(attname2));
                fprintf(fid,'%s\n',dispstr);
            end
            a1=strcmp(attname1,'long_name');
            if(a1==1)
                FocalPlaneS.long_name4=attname2;
            end
            a1=strcmp(attname1,'_FillValue');
            if(a1==1)
                FocalPlaneS.FillValue4=attname2;
            end
            a1=strcmp(attname1,'units');
            if(a1==1)
                FocalPlaneS.units4=attname2;
            end
            a1=strcmp(attname1,'coordinates');
            if(a1==1)
                FocalPlaneS.coordinates4=attname2;
            end
            a1=strcmp(attname1,'grid_mapping');
            if(a1==1)
                FocalPlaneS.grid_mapping4=attname2;
            end
        elseif (a370==1)
            attname1 = netcdf.inqAttName(ncid,i,j);
            attname2 = netcdf.getAtt(ncid,i,attname1);
            if(idebug==1)
                disp([attname1 ':  ' num2str(attname2)])
                dispstr=strcat(attname1,': ',num2str(attname2));
                fprintf(fid,'%s\n',dispstr);
            end
            a1=strcmp(attname1,'long_name');
            if(a1==1)
                Band_IDS.long_name=attname2;
            end
            a1=strcmp(attname1,'standard_name');
            if(a1==1)
                Band_IDS.standard_name=attname2;
            end
            a1=strcmp(attname1,'units');
            if(a1==1)
                Band_IDS.units=attname2;
            end
        elseif (a380==1)
            attname1 = netcdf.inqAttName(ncid,i,j);
            attname2 = netcdf.getAtt(ncid,i,attname1);
            if(idebug==1)
                disp([attname1 ':  ' num2str(attname2)])
                dispstr=strcat(attname1,': ',num2str(attname2));
                fprintf(fid,'%s\n',dispstr);
            end
            a1=strcmp(attname1,'long_name');
            if(a1==1)
                VPixCS.long_name=attname2;
            end
            a1=strcmp(attname1,'_FillValue');
            if(a1==1)
                VPixCS.FillValue=attname2;
            end
            a1=strcmp(attname1,'units');
            if(a1==1)
                VPixCS.units=attname2;
            end
            a1=strcmp(attname1,'coordinates');
            if(a1==1)
                VPixCS.coordinates=attname2;
            end
            a1=strcmp(attname1,'grid_mapping');
            if(a1==1)
                VPixCS.grid_mapping=attname2;
            end
            a1=strcmp(attname1,'cell_methods');
            if(a1==1)
                VPixCS.cell_methods=attname2;
            end
        elseif (a410==1)
            attname1 = netcdf.inqAttName(ncid,i,j);
            attname2 = netcdf.getAtt(ncid,i,attname1);
            if(idebug==1)
                disp([attname1 ':  ' num2str(attname2)])
                dispstr=strcat(attname1,': ',num2str(attname2));
                fprintf(fid,'%s\n',dispstr);
            end
            a1=strcmp(attname1,'long_name');
            if(a1==1)
                YawFlipS.long_name=attname2;
            end
            a1=strcmp(attname1,'_FillValue');
            if(a1==1)
                YawFlipS.FillValue=attname2;
            end
            a1=strcmp(attname1,'units');
            if(a1==1)
                YawFlipS.units=attname2;
            end
            a1=strcmp(attname1,'coordinates');
            if(a1==1)
                YawFlipS.coordinates=attname2;
            end
            a1=strcmp(attname1,'flag_values');
            if(a1==1)
                YawFlipS.flag_values=attname2;
            end
            a1=strcmp(attname1,'flag_meanings');
            if(a1==1)
                YawFlipS.flag_meanings=attname2;
            end
            a1=strcmp(attname1,'_Unsigned');
            if(a1==1)
                YawFlipS.Unsigned=attname2;
            end
            a1=strcmp(attname1,'valid_range');
            if(a1==1)
                YawFlipS.valid_range=attname2;
            end
        elseif (a420==1)
            attname1 = netcdf.inqAttName(ncid,i,j);
            attname2 = netcdf.getAtt(ncid,i,attname1);
            if(idebug==1)
                disp([attname1 ':  ' num2str(attname2)])
                dispstr=strcat(attname1,': ',num2str(attname2));
                fprintf(fid,'%s\n',dispstr);
            end
            a1=strcmp(attname1,'long_name');
            if(a1==1)
                MissingPixelS.long_name=attname2;
            end
            a1=strcmp(attname1,'_FillValue');
            if(a1==1)
                MissingPixelS.FillValue=attname2;
            end
            a1=strcmp(attname1,'units');
            if(a1==1)
                MissingPixelS.units=attname2;
            end
            a1=strcmp(attname1,'coordinates');
            if(a1==1)
                MissingPixelS.coordinates=attname2;
            end
            a1=strcmp(attname1,'grid_mapping');
            if(a1==1)
                MissingPixelS.grid_mapping=attname2;
            end
            a1=strcmp(attname1,'cell_methods');
            if(a1==1)
                MissingPixelS.cell_methods=attname2;
            end
        elseif (a430==1)
            attname1 = netcdf.inqAttName(ncid,i,j);
            attname2 = netcdf.getAtt(ncid,i,attname1);
            if(idebug==1)
                disp([attname1 ':  ' num2str(attname2)])
                dispstr=strcat(attname1,': ',num2str(attname2));
                fprintf(fid,'%s\n',dispstr);
            end
            a1=strcmp(attname1,'long_name');
            if(a1==1)
                SaturatedPixelS.long_name=attname2;
            end
            a1=strcmp(attname1,'_FillValue');
            if(a1==1)
                SaturatedPixelS.FillValue=attname2;
            end
            a1=strcmp(attname1,'units');
            if(a1==1)
                SaturatedPixelS.units=attname2;
            end
            a1=strcmp(attname1,'coordinates');
            if(a1==1)
                SaturatedPixelS.coordinates=attname2;
            end
            a1=strcmp(attname1,'grid_mapping');
            if(a1==1)
                SaturatedPixelS.grid_mapping=attname2;
            end
            a1=strcmp(attname1,'cell_methods');
            if(a1==1)
                SaturatedPixelS.cell_methods=attname2;
            end
        elseif (a440==1)
            attname1 = netcdf.inqAttName(ncid,i,j);
            attname2 = netcdf.getAtt(ncid,i,attname1);
            if(idebug==1)
                disp([attname1 ':  ' num2str(attname2)])
                dispstr=strcat(attname1,': ',num2str(attname2));
                fprintf(fid,'%s\n',dispstr);
            end
            a1=strcmp(attname1,'long_name');
            if(a1==1)
                ValidPixRadS.long_name1=attname2;
            end
            a1=strcmp(attname1,'standard_name');
            if(a1==1)
                ValidPixRadS.standard_name1=attname2;
            end
            a1=strcmp(attname1,'_FillValue');
            if(a1==1)
                ValidPixRadS.FillValue1=attname2;
            end
            a1=strcmp(attname1,'valid_range');
            if(a1==1)
                ValidPixRadS.valid_range1=attname2;
            end
            a1=strcmp(attname1,'units');
            if(a1==1)
                ValidPixRadS.units1=attname2;
            end
            a1=strcmp(attname1,'coordinates');
            if(a1==1)
                ValidPixRadS.coordinates1=attname2;
            end
            a1=strcmp(attname1,'grid_mapping');
            if(a1==1)
                ValidPixRadS.grid_mapping1=attname2;
            end
            a1=strcmp(attname1,'cell_methods');
            if(a1==1)
                 ValidPixRadS.cell_methods1=attname2;
            end
        elseif (a450==1)
            attname1 = netcdf.inqAttName(ncid,i,j);
            attname2 = netcdf.getAtt(ncid,i,attname1);
            if(idebug==1)
                disp([attname1 ':  ' num2str(attname2)])
                dispstr=strcat(attname1,': ',num2str(attname2));
                fprintf(fid,'%s\n',dispstr);
            end
            a1=strcmp(attname1,'long_name');
            if(a1==1)
                ValidPixRadS.long_name2=attname2;
            end
            a1=strcmp(attname1,'standard_name');
            if(a1==1)
                ValidPixRadS.standard_name2=attname2;
            end
            a1=strcmp(attname1,'_FillValue');
            if(a1==1)
                ValidPixRadS.FillValue2=attname2;
            end
            a1=strcmp(attname1,'valid_range');
            if(a1==1)
                ValidPixRadS.valid_range2=attname2;
            end
            a1=strcmp(attname1,'units');
            if(a1==1)
                ValidPixRadS.units2=attname2;
            end
            a1=strcmp(attname1,'coordinates');
            if(a1==1)
                ValidPixRadS.coordinates2=attname2;
            end
            a1=strcmp(attname1,'grid_mapping');
            if(a1==1)
                ValidPixRadS.grid_mapping2=attname2;
            end
            a1=strcmp(attname1,'cell_methods');
            if(a1==1)
                 ValidPixRadS.cell_methods2=attname2;
            end
        elseif (a460==1)
            attname1 = netcdf.inqAttName(ncid,i,j);
            attname2 = netcdf.getAtt(ncid,i,attname1);
            if(idebug==1)
                disp([attname1 ':  ' num2str(attname2)])
                dispstr=strcat(attname1,': ',num2str(attname2));
                fprintf(fid,'%s\n',dispstr);
            end
            a1=strcmp(attname1,'long_name');
            if(a1==1)
                ValidPixRadS.long_name3=attname2;
            end
            a1=strcmp(attname1,'standard_name');
            if(a1==1)
                ValidPixRadS.standard_name3=attname2;
            end
            a1=strcmp(attname1,'_FillValue');
            if(a1==1)
                ValidPixRadS.FillValue3=attname2;
            end
            a1=strcmp(attname1,'valid_range');
            if(a1==1)
                ValidPixRadS.valid_range3=attname2;
            end
            a1=strcmp(attname1,'units');
            if(a1==1)
                ValidPixRadS.units3=attname2;
            end
            a1=strcmp(attname1,'coordinates');
            if(a1==1)
                ValidPixRadS.coordinates3=attname2;
            end
            a1=strcmp(attname1,'grid_mapping');
            if(a1==1)
                ValidPixRadS.grid_mapping3=attname2;
            end
            a1=strcmp(attname1,'cell_methods');
            if(a1==1)
                 ValidPixRadS.cell_methods3=attname2;
            end
        elseif (a470==1)
            attname1 = netcdf.inqAttName(ncid,i,j);
            attname2 = netcdf.getAtt(ncid,i,attname1);
            if(idebug==1)
                disp([attname1 ':  ' num2str(attname2)])
                dispstr=strcat(attname1,': ',num2str(attname2));
                fprintf(fid,'%s\n',dispstr);
            end
            a1=strcmp(attname1,'long_name');
            if(a1==1)
                ValidPixRadS.long_name4=attname2;
            end
            a1=strcmp(attname1,'standard_name');
            if(a1==1)
                ValidPixRadS.standard_name4=attname2;
            end
            a1=strcmp(attname1,'_FillValue');
            if(a1==1)
                ValidPixRadS.FillValue4=attname2;
            end
            a1=strcmp(attname1,'valid_range');
            if(a1==1)
                ValidPixRadS.valid_range4=attname2;
            end
            a1=strcmp(attname1,'units');
            if(a1==1)
                ValidPixRadS.units4=attname2;
            end
            a1=strcmp(attname1,'coordinates');
            if(a1==1)
                ValidPixRadS.coordinates4=attname2;
            end
            a1=strcmp(attname1,'grid_mapping');
            if(a1==1)
                ValidPixRadS.grid_mapping4=attname2;
            end
            a1=strcmp(attname1,'cell_methods');
            if(a1==1)
                 ValidPixRadS.cell_methods4=attname2;
            end
         elseif (a480==1)
            attname1 = netcdf.inqAttName(ncid,i,j);
            attname2 = netcdf.getAtt(ncid,i,attname1);
            if(idebug==1)
                disp([attname1 ':  ' num2str(attname2)])
                dispstr=strcat(attname1,': ',num2str(attname2));
                fprintf(fid,'%s\n',dispstr);
            end
            a1=strcmp(attname1,'long_name');
            if(a1==1)
                TStarS.long_name=attname2;
            end
            a1=strcmp(attname1,'standard_name');
            if(a1==1)
                TStarS.standard_name=attname2;
            end
            a1=strcmp(attname1,'units');
            if(a1==1)
                TStarS.units=attname2;
            end
            a1=strcmp(attname1,'axis');
            if(a1==1)
                TStarS.axis=attname2;
            end
         elseif (a490==1)
            attname1 = netcdf.inqAttName(ncid,i,j);
            attname2 = netcdf.getAtt(ncid,i,attname1);
            if(idebug==1)
                disp([attname1 ':  ' num2str(attname2)])
                dispstr=strcat(attname1,': ',num2str(attname2));
                fprintf(fid,'%s\n',dispstr);
            end
            a1=strcmp(attname1,'long_name');
            if(a1==1)
                BWaveTStarS.long_name=attname2;
            end
            a1=strcmp(attname1,'standard_name');
            if(a1==1)
                BWaveTStarS.standard_name=attname2;
            end
            a1=strcmp(attname1,'units');
            if(a1==1)
                BWaveTStarS.units=attname2;
            end
         elseif (a500==1)
            attname1 = netcdf.inqAttName(ncid,i,j);
            attname2 = netcdf.getAtt(ncid,i,attname1);
            if(idebug==1)
                disp([attname1 ':  ' num2str(attname2)])
                dispstr=strcat(attname1,': ',num2str(attname2));
                fprintf(fid,'%s\n',dispstr);
            end
            a1=strcmp(attname1,'long_name');
            if(a1==1)
                StarIDS.long_name=attname2;
            end
            a1=strcmp(attname1,'_Unsigned');
            if(a1==1)
                StarIDS.Unsigned=attname2;
            end
            a1=strcmp(attname1,'_FillValue');
            if(a1==1)
                StarIDS.FillValue=attname2;
            end
            a1=strcmp(attname1,'coordinates');
            if(a1==1)
                StarIDS.coordinates=attname2;
            end
        elseif (a510==1)
            attname1 = netcdf.inqAttName(ncid,i,j);
            attname2 = netcdf.getAtt(ncid,i,attname1);
            if(idebug==1)
                disp([attname1 ':  ' num2str(attname2)])
                dispstr=strcat(attname1,': ',num2str(attname2));
                fprintf(fid,'%s\n',dispstr);
            end
            a1=strcmp(attname1,'long_name');
            if(a1==1)
                UnSatPixS.long_name=attname2;
            end
            a1=strcmp(attname1,'_FillValue');
            if(a1==1)
                UnSatPixS.FillValue=attname2;
            end
            a1=strcmp(attname1,'units');
            if(a1==1)
                UnSatPixS.units=attname2;
            end
            a1=strcmp(attname1,'coordinates');
            if(a1==1)
                UnSatPixS.coordinates=attname2;
            end
            a1=strcmp(attname1,'grid_mapping');
            if(a1==1)
                UnSatPixS.grid_mapping=attname2;
            end
            a1=strcmp(attname1,'cell_methods');
            if(a1==1)
                UnSatPixS.cell_methods=attname2;
            end
        else
            attname1 = netcdf.inqAttName(ncid,i,j);
            attname2 = netcdf.getAtt(ncid,i,attname1);
            disp([attname1 ':  ' num2str(attname2)])
            if strcmp('add_offset',attname1)
                offset = attname2;
            end
            if strcmp('scale_factor',attname1)
                scale = attname2;
                flag = 1;
            end   
        end
    end
    if(idebug==1)
        disp(' ')
    end
    
    if flag
        eval([varname '=( double(double(netcdf.getVar(ncid,i))-0));'])
        if(a10==1)
            RadS.values=Rad;
            Radiance=RadS.values;
            [nrows,ncols]=size(Radiance);
            maxValues=RadS.valid_range;
            maxValue=maxValues(1,2);
% Replace the fill values with NaN's
            numnan=0;
            for ii=1:nrows
                for jj=1:ncols
                   nowvalue=Radiance(ii,jj); 
                   if(nowvalue>=maxValue)
                      numnan=numnan+1;
                      Radiance(ii,jj)=NaN;
                   else
                      Radiance(ii,jj)=nowvalue*double(scale)+offset;
                   end
                end
            end
            RadS.values=Radiance;
        end
        if(varname=='y')
            eval([varname '= double(double(netcdf.getVar(ncid,i))*scale + offset);'])
            yS.values=y;
        end
        if(varname=='x')
            eval([varname '= double(double(netcdf.getVar(ncid,i))*scale + offset);'])
            xS.values=x;
        end
    else
        eval([varname '= double(netcdf.getVar(ncid,i));'])   
        if(a20==1)
            DQFS.values=DQF;
        end
        if(varname=='t')
            tS.values=t;
        end
        if(a60==1)
            tBS.values=time_bounds;
        end
        if(a70==1)
            goesImagerS.values=goes_imager_projection;
        end
        if(a80==1)
            yImgS.values=y_image;
        end
        if(a90==1)
            yImgBS.values=y_image_bounds;
        end
        if(a100==1)
            xImgS.values=x_image;
        end
        if(a110==1)
            xImgBS.values=x_image_bounds;
        end
        if(a120==1)
            val=nominal_satellite_subpoint_lat;
            SatDataS.values1=val;
        end
        if(a130==1)
            val=nominal_satellite_subpoint_lon;
            SatDataS.values2=val;
        end
        if(a140==1)
            val=nominal_satellite_height;
            SatDataS.values3=val;
        end
        if(a150==1)
            GeoSpatialS.values=geospatial_lat_lon_extent;
        end
        if(a160==1)
            BandDataS.values=band_wavelength;
        end
        if(a210==1)
            AlgoS.values=[];
        end
        if(a220==1)
            ErrorS.values1=percent_uncorrectable_GRB_errors;
        end
        if(a230==1)
            ErrorS.values2=percent_uncorrectable_L0_errors;
        end
        if(a240==1)
            EarthSunS.values=earth_sun_distance_anomaly_in_AU;
        end
        if(a250==1)
            VersionContainerS.values=processing_parm_version_container;
        end
        if(a260==1)
            AlgoProdVerCS.values=algorithm_product_version_container;
        end
        if(a270==1)
            ESunS.value=esun;
        end
        if(a280==1)
            kappa0S.values=kappa0;
        end
        if(a290==1)
            PlanckS.values1=planck_fk1;
        end
        if(a300==1)
            PlanckS.values2=planck_fk2;
        end
        if(a310==1)
            PlanckS.values3=planck_bc1;
        end
        if(a320==1)
            PlanckS.values4=planck_bc2;
        end
        if(a330==1)
            FocalPlaneS.values1=focal_plane_temperature_threshold_exceeded_count;
        end
        if(a340==1)
            FocalPlaneS.values2=maximum_focal_plane_temperature;
        end
        if(a350==1)
            FocalPlaneS.values3=focal_plane_temperature_threshold_increasing;
        end
        if(a360==1)
            FocalPlaneS.values4=focal_plane_temperature_threshold_decreasing;
        end
        if(a370==1)
            Band_IDS.values=band_id;
        end
        if(a380==1)
            VPixCS.values=valid_pixel_count;
        end
        if(a410==1)
            YawFlipS.values=yaw_flip_flag;
        end
        if(a420==1)
            MissingPixelS.values=missing_pixel_count;
        end
        if(a430==1)
            SaturatedPixelS.values=saturated_pixel_count;
        end
        if(a440==1)
            ValidPixRadS.values1=min_radiance_value_of_valid_pixels;
        end
        if(a450==1)
            ValidPixRadS.values2=max_radiance_value_of_valid_pixels;
        end
        if(a460==1)
            ValidPixRadS.values3=mean_radiance_value_of_valid_pixels;
        end
        if(a470==1)
            ValidPixRadS.values4=std_dev_radiance_value_of_valid_pixels;
        end
        if(a480==1)
            TStarS.values=t_star_look;
        end
        if(a490==1)
            BWaveTStarS.values=band_wavelength_star_look;
        end
        if(a500==1)
            StarIDS.values=star_id;
        end
        if(a510==1)
            UnSatPixS.values=undersaturated_pixel_count;
        end
    end
    if(idebug==1)
        disp('^~^~^~^~^~^~^~^~^~^~^~^~^~^~^~^~^~^~^~^~^~^~^~^~^~^~^~^~')
        disp('________________________________________________________')
        disp(' '),disp(' ')
    end
end
% Close the file
netcdf.close(ncid)
fprintf(fid,'%s\n','Finished reading ABI-L1 Radiance Data');
% Now write a Matlab file containing the decoded data
% use the original file name with a .mat extension
[iper]=strfind(GOESFileName,'.');
is=1;
ie=iper(1)-1;
MatFileName=strcat(GOESFileName(is:ie),'.mat');
stub=(GOESFileName(15:16));
Radiance=RadS.values;
[nrows,ncols]=size(Radiance);
a1=strcmp(stub,'M1');
a2=strcmp(stub,'M2');
if((nrows==500) && (ncols==500) && (a1==1))
    MapFormFactor='Meso1';
    itype=3;
elseif((nrows==500) && (ncols==500) && (a2==1))
    MapFormFactor='Meso2';
    itype=4;
elseif(a1==1)
    MapFormFactor='Meso2';
    itype=3;
elseif(a2==1)
    MapFormFactor='Meso2';
    itype=4;
else
    MapFormFactor='CONUS';
    itype=2;
end
if(isavefiles==1)
    eval(['cd ' GOES16path(1:length(GOES16path)-1)]);
    actionstr='save';
    varstr1='BandDataS MetaDataS RadS DQFS tS yS xS tBS goesImagerS';
    varstr2=' yImgS yImgBS xImgS xImgBS SatDataS GeoSpatialS';
    varstr3=' AlgoS ErrorS EarthSunS VersionContainerS';
    varstr4=' GoesWaveBand ESunS kappa0S PlanckS FocalPlaneS GOESFileName';
    varstr5=' Band_IDS VPixCS  YawFlipS ValidPixRadS';
    varstr6=' TStarS BWaveTStarS StarIDS UnSatPixS';
    varstr=strcat(varstr1,varstr2,varstr3,varstr4,varstr5,varstr6);
    qualstr='-v7.3';
    [cmdString]=MyStrcatV73(actionstr,MatFileName,varstr,qualstr);
    eval(cmdString)
    dispstr=strcat('Wrote Matlab File-',MatFileName);
    disp(dispstr);
    fprintf(fid,'%s\n',dispstr);
else
    dispstr=strcat('Did not save Matlab File-',MatFileName);
    disp(dispstr);
    fprintf(fid,'%s\n',dispstr);
end
% establish the band number
[iunder]=strfind(GOESFileName,'_');
numunder=length(iunder);
[idash]=strfind(GOESFileName,'-');
numdash=length(idash);
is=idash(3)+4;
ie=iunder(2)-1;
channelstr=GOESFileName(is:ie);
bandnum=str2num(channelstr);
is=iunder(3)+1;
ie=iunder(4)-1;
% Display the Radiance Data
fileprefix=GOESFileName(is:ie);
filename=RemoveUnderScores(fileprefix);
titlestr=strcat('Radiance-',MapFormFactor,'-Data-Band-',num2str(bandnum),'-',filename);
DisplayRadianceDataRev2(titlestr,itype,bandnum)
titlestr=strcat('RadianceHist-',MapFormFactor,'-Data-Band',num2str(bandnum),'-',filename);
PlotRadianceHistogram(titlestr,itype,bandnum)
titlestr=strcat('RadianceCumilDist-',MapFormFactor,'-Band',num2str(bandnum),'-',filename);
PlotRadianceCumilDist(titlestr,itype,bandnum)
end