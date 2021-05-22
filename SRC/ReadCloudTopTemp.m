function ReadCloudTopTemp()
% Modified: This function will read in the GOES ABI-L2-Cloud Top Temp Data
% Written By: Stephen Forczyk
% Created: August 2,2020
% Revised: ------
% Classification: Unclassified

global BandDataS MetaDataS;
global CMIS DQF2S tS yS xS tBS goesImagerS yImgS yImgBS;
global xImgS xImgBS SatDataS GeoSpatialS;
global ReflectanceS AlgoS ErrorS EarthSunS VersionContainerS;
global GoesWaveBand ESunS kappa0S PlanckS FocalPlaneS;
global GOESFileName OutlierPS CloudTopTS LZAS LZABS SZAS SZABS;
global TempS Algo2S ProcessParamTS AlgoProductTS Error1S CloudPixelsS;
% additional paths needed for mapping
global matpath1 mappath GOES16path;
global jpegpath;
global GOES16Band1path GOES16Band2path GOES16Band3path GOES16Band4path;
global GOES16Band5path GOES16Band6path GOES16Band7path GOES16Band8path
global GOES16Band9path GOES16Band10path GOES16Band11path GOES16Band12path;
global GOES16Band13path GOES16Band14path GOES16Band15path GOES16Band16path;
global GOES16CloudTopHeightpath;



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
% CMIS=struct('values',[],'fill',[],'bit_depth',[],'valid_range',[],...
%     'scale_factor',[],'add_offset',[],'resolution',[],'grid_mapping',[],...
%     'ancillary_variables',[],'long_name',[],'standard_name',[]); 
DQF2S=struct('values',[],'valid_range',[],'units',[],'unsigned',[],...
    'coordinates',[],'grid_mapping',[],'flag_values',[],'flag_meanings',[],...
    'number_of_qf_values',[],'long_name',[],'standard_name',[],'FillValue',[],...
    'percent_good_quality_qf',[],'percent_invalid_due_to_not_geolocated_qf',[],...
    'percent_invalid_due_to_LZA_threshold_exceeded_qf',[],...
    'percent_invalid_due_to_bad_or_missing_brightness_temp_data_qf',[],...
    'percent_focal_plane_temperature_threshold_exceeded_qf',[],...
    'percent_invalid_due_to_clear_or_probably_clear_sky_qf',[],...
    'percent_invalid_due_to_unknown_cloud_type_qf',[],...
    'percent_invalid_due_to_nonconvergent_retrieval_qf',[]);
tS=struct('long_name',[],'standard_name',[],'units',[],'axis',[],'bounds',[],'values',[]);
yS=struct('scale_factor',[],'add_offset',[],'units',[],'axis',[],'long_name',[],...
    'standard_name',[]);
xS=yS;
tBS=struct('values',[],'long_name',[]);
CloudPixelsS=struct('values',[],'long_name',[],'FillValue',[],'units',[],...
    'coordinates',[],'grid_mapping',[],'cell_methods',[]);
CloudTopTS=struct('values1',[],'long_name1',[],'standard_name1',[],'FillValue1',[],...
    'valid_range1',[],'units1',[],'coordinates1',[],'grid_mapping1',[],'cell_methods1',[],...
    'values2',[],'long_name2',[],'standard_name2',[],'FillValue2',[],...
    'valid_range2',[],'units2',[],'coordinates2',[],'grid_mapping2',[],'cell_methods2',[],...
    'values3',[],'long_name3',[],'standard_name3',[],'FillValue3',[],...
    'valid_range3',[],'units3',[],'coordinates3',[],'grid_mapping3',[],'cell_methods3',[],...;
    'values4',[],'long_name4',[],'standard_name4',[],'FillValue4',[],...
    'valid_range4',[],'units4',[],'coordinates4',[],'grid_mapping4',[],'cell_methods4',[]);
ProcessParamTS=struct('values',[],'long_name',[],'L2_processing_parm_version',[]);
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
OutlierPS=struct('values',[],'long_name',[],'FillValue',[],'units',[],...
    'coordinates',[],'grid_mapping',[],'cell_methods',[]);
BandDataS=struct('values',[],'long_name',[],'standard_name',[],'units',[]);
ReflectanceS=struct('values1',[],'long_name1',[],'standard_name1',[],...
    'FillValue1',[],'valid_range1',[],'units1',[],'coordinates1',[],'grid_mapping1',[],...
    'cell_methods1',[],'values2',[],'long_name2',[],'standard_name2',[],...
    'FillValue2',[],'valid_range2',[],'units2',[],'coordinates2',[],'grid_mapping2',[],...
    'cell_methods2',[],'values3',[],'long_name3',[],'standard_name3',[],...
    'FillValue3',[],'valid_range3',[],'units3',[],'coordinates3',[],'grid_mapping3',[],...
    'cell_methods3',[],'values4',[],'long_name4',[],'standard_name4',[],...
    'FillValue4',[],'valid_range4',[],'units4',[],'coordinates4',[],'grid_mapping4',[],...
    'cell_methods4',[]);
AlgoS=struct('values',[],'long_name',[],'input_ABI_L2_auxiliary_solar_zenith_angle_data',[],...
    'input_ABI_L1b_radiance_band_data',[]);
AlgoProductTS=struct('values',[],'long_name',[],'algorithm_version',[],'product_version',[]);
LZAS=struct('values',[],'long_name',[],'standard_name',[],'units',[],'bounds',[]);
LZABS=struct('values',[],'long_name',[]);
SZAS=struct('values',[],'long_name',[],'standard_name',[],'units',[],'bounds',[]);
SZABS=struct('values',[],'long_name',[]);
ErrorS=struct('values1',[],'long_name1',[],'FillValue1',[],'valid_range1',[],'units1',[],...
    'coordinates1',[],'grid_mapping1',[],'cell_methods1',[],...
    'values2',[],'long_name2',[],'FillValue2',[],'valid_range2',[],'units2',[],...
    'coordinates2',[],'grid_mapping2',[],'cell_methods2',[]);
EarthSunS=struct('values',[],'long_name',[],'FillValue',[],'units',[],...
    'coordinates',[],'cell_methods',[]);
VersionContainerS=struct('values1',[],'long_name1',[],'L2_processing_parm_version',[],...
    'values2',[],'long_name2',[],'algorithm_version',[],'product_version',[]);
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
    'long_name2',[],'FillValue2',[],'units2',[],'coordinates2',[],'grid_mapping2',[],...
    'values3',[],'long_name3',[],'FillValue3',[],'units3',[],'coordinates3',[],...
    'grid_mapping3',[],'values4',[],'long_name4',[],'FillValue4',[],...
    'units4',[],'coordinates4',[],'grid_mapping4',[]);
TempS=struct('values',[],'long_name',[],'standard_name',[],'unsigned',[],'valid_range',[],...
    'scale_factor',[],'add_offset',[],'units',[],'resolution',[],'coordinates',[],...
    'grid_mapping',[],'cell_methods',[],'ancillary_variables',[]);
Algo2S=struct('values',[],'long_name',[],'input_ABI_L1b_radiance_band_14_2km_data',[],...
    'input_ABI_L2_brightness_temperature_band_14_2km_data',[],...
    'input_ABI_L2_brightness_temperature_band_15_2km_data',[],...
    'input_ABI_L2_brightness_temperature_band_16_2km_data',[],...
    'input_ABI_L2_intermediate_product_4_level_cloud_mask_data',[],...
    'input_ABI_L2_intermediate_product_cloud_type_data',[],...
    'ABI_L2_inter_prod_CRTM_clear_sky_rad_band_14_data',[],...
    'ABI_L2_inter_prod_CRTM_clear_sky_rad_band_15_data',[],...
    'ABI_L2_inter_prod_CRTM_clear_sky_rad_band_16_data',[],...
    'ABI_L2_inter_prod_CRTM_clear_sky_rad_band_14_profile_data',[],...
    'ABI_L2_inter_prod_CRTM_clear_sky_rad_band_15_profile_data',[],...
    'ABI_L2_inter_prod_CRTM_clear_sky_rad_band_16_profile_data',[],...
    'ABI_L2_inter_prod_CRTM_clear_sky_trans_band_14_profile_data',[],...
    'ABI_L2_inter_prod_CRTM_clear_sky_trans_band_15_profile_data',[],...
    'ABI_L2_inter_prod_CRTM_clear_sky_trans_band_16_profile_data',[],...
    'ABI_L2_inter_prod_CRTM_cloudy_sky_rad_band_14_profile_data',[],...
    'ABI_L2_inter_prod_CRTM_cloudy_sky_rad_band_15_profile_data',[],...
    'ABI_L2_inter_prod_CRTM_cloudy_sky_rad_band_16_profile_data',[],...
    'input_dynamic_ancillary_NWP_surface_pressure_data',[],...
    'input_dynamic_ancillary_NWP_surface_temperature_data',[],...
    'input_dynamic_ancillary_NWP_tropopause_temperature_data',[],...
    'input_dynamic_ancillary_NWP_temperature_profile_data',[],...
    'input_dynamic_ancillary_NWP_temperature_inversion_profile_data',[],...
    'input_dynamic_ancillary_NWP_geopotential_height_profile_data',[],...
    'input_dynamic_ancillary_NWP_pressure_profile_data',[],...
    'input_dynamic_ancillary_NWP_surface_level_index_data',[],...
    'input_dynamic_ancillary_NWP_tropopause_level_index_data',[]);
Error1S=struct('values1',[],'long_name1',[],'FillValue1',[],'valid_range1',[],'units1',[],...
    'coordinates1',[],'grid_mapping1',[],'cell_methods1',[],...
    'values2',[],'long_name2',[],'FillValue2',[],'valid_range2',[],'units2',[],...
    'coordinates2',[],'grid_mapping2',[],'cell_methods2',[]);
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
%     if(varname=='CMI')
%        CMIS=struct('values',[],'fill',[],'bit_depth',[],'valid_range',[]); 
%     end
    for j = 0:numatts - 1
        a10=strcmp(varname,'TEMP');
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
        a160=strcmp(varname,'outlier_pixels');
        a170=strcmp(varname,'minimum_cloud_top_temperature');
        a180=strcmp(varname,'maximum_cloud_top_temperature');
        a190=strcmp(varname,'mean_cloud_top_temperature');
        a200=strcmp(varname,'std_dev_cloud_top_temperature');
        a210=strcmp(varname,'algorithm_dynamic_input_data_container');

        a240=strcmp(varname,'earth_sun_distance_anomaly_in_AU');
        a250=strcmp(varname,'processing_parm_version_container');
        a260=strcmp(varname,'algorithm_product_version_container');
        a270=strcmp(varname,'local_zenith_angle');
        a280=strcmp(varname,'local_zenith_angle_bounds');
        a290=strcmp(varname,'solar_zenith_angle');
        a300=strcmp(varname,'solar_zenith_angle_bounds');
        a310=strcmp(varname,'percent_uncorrectable_GRB_errors');
        a320=strcmp(varname,'percent_uncorrectable_L0_errors');
        a330=strcmp(varname,'cloud_pixels');

        if (a10==1)
            attname1 = netcdf.inqAttName(ncid,i,j);
            attname2 = netcdf.getAtt(ncid,i,attname1);
            disp([attname1 ':  ' num2str(attname2)])
            if strmatch('add_offset',attname1)
                offset = attname2;
            end
            if strmatch('scale_factor',attname1)
                scale = attname2;
                flag = 1;
            end 
            a1=strcmp(attname1,'long_name');
            if(a1==1)
                TempS.long_name=attname2;
            end
            a1=strcmp(attname1,'standard_name');
            if(a1==1)
                TempS.standard_name=attname2;
            end
            a1=strcmp(attname1,'units');
            if(a1==1)
                TempS.units=attname2;
            end
            a1=strcmp(attname1,'_Unsigned');
            if(a1==1)
                TempS.unsigned=attname2;
            end
            a1=strcmp(attname1,'valid_range');
            if(a1==1)
                TempS.valid_range=attname2;
            end
            a1=strcmp(attname1,'resolution');
            if(a1==1)
                TempS.resolution=attname2;
            end
            a1=strcmp(attname1,'coordinates');
            if(a1==1)
                TempS.coordinates=attname2;
            end
            a1=strcmp(attname1,'scale_factor');
            if(a1==1)
                TempS.scale_factor=attname2;
            end
            a1=strcmp(attname1,'add_offset');
            if(a1==1)
                TempS.add_offset=attname2;
            end
            a1=strcmp(attname1,'resolution');
            if(a1==1)
                TempS.resolution=attname2;
            end
            a1=strcmp(attname1,'grid_mapping');
            if(a1==1)
                TempS.grid_mapping=attname2;
            end
            a1=strcmp(attname1,'cell_methods');
            if(a1==1)
                TempS.cell_methods=attname2;
            end
            a1=strcmp(attname1,'ancillary_variables');
            if(a1==1)
                TempS.ancillary_variables=attname2;
            end

        elseif (a20==1)
            attname1 = netcdf.inqAttName(ncid,i,j);
            attname2 = netcdf.getAtt(ncid,i,attname1);
            disp([attname1 ':  ' num2str(attname2)])
            if strmatch('add_offset',attname1)
                offset = attname2;
            end
            if strmatch('scale_factor',attname1)
                scale = attname2;
                flag = 1;
            end 
            a1=strcmp(attname1,'_FillValue');
            if(a1==1)
                DQF2S.FillValue=attname2;
            end

            a1=strcmp(attname1,'valid_range');
            if(a1==1)
                DQF2S.valid_range=attname2;
            end
            a1=strcmp(attname1,'units');
            if(a1==1)
                DQF2S.units=attname2;
            end
            a1=strcmp(attname1,'coordinates');
            if(a1==1)
                DQF2S.coordinates=attname2;
            end
            a1=strcmp(attname1,'_Unsigned');
            if(a1==1)
                DQF2S.unsigned=attname2;
            end
            a1=strcmp(attname1,'grid_mapping');
            if(a1==1)
                DQF2S.grid_mapping=attname2;
            end
            a1=strcmp(attname1,'flag_values');
            if(a1==1)
                DQF2S.flag_values=attname2;
            end
            a1=strcmp(attname1,'flag_meanings');
            if(a1==1)
                DQF2S.flag_meanings=attname2;
            end
            a1=strcmp(attname1,'number_of_qf_values');
            if(a1==1)
                DQF2S.number_of_qf_values=attname2;
            end
            a1=strcmp(attname1,'long_name');
            if(a1==1)
                DQF2S.long_name=attname2;
            end
            a1=strcmp(attname1,'standard_name');
            if(a1==1)
                DQF2S.standard_name=attname2;
            end
            a1=strcmp(attname1,'percent_good_quality_qf');
            if(a1==1)
                DQF2S.percent_good_quality_qf=attname2;
            end 
            a1=strcmp(attname1,'percent_invalid_due_to_not_geolocated_qf');
            if(a1==1)
                DQF2S.percent_invalid_due_to_not_geolocated_qf=attname2;
            end
            a1=strcmp(attname1,'percent_invalid_due_to_LZA_threshold_exceeded_qf');
            if(a1==1)
                DQF2S.percent_invalid_due_to_LZA_threshold_exceeded_qf=attname2;
            end
            a1=strcmp(attname1,'percent_invalid_due_to_bad_or_missing_brightness_temp_data_qf');
            if(a1==1)
                DQF2S.percent_invalid_due_to_bad_or_missing_brightness_temp_data_qf=attname2;
            end
            a1=strcmp(attname1,'percent_focal_plane_temperature_threshold_exceeded_qf');
            if(a1==1)
                DQF2S.percent_focal_plane_temperature_threshold_exceeded_qf=attname2;
            end
            a1=strcmp(attname1,'percent_invalid_due_to_clear_or_probably_clear_sky_qf');
            if(a1==1)
                DQF2S.percent_invalid_due_to_clear_or_probably_clear_sky_qf=attname2;
            end 
            a1=strcmp(attname1,'percent_invalid_due_to_unknown_cloud_type_qf');
            if(a1==1)
                DQF2S.percent_invalid_due_to_unknown_cloud_type_qf=attname2;
            end 
            a1=strcmp(attname1,'percent_invalid_due_to_nonconvergent_retrieval_qf');
            if(a1==1)
                DQF2S.percent_invalid_due_to_nonconvergent_retrieval_qf=attname2;
            end 
        elseif (a30==1)
            attname1 = netcdf.inqAttName(ncid,i,j);
            attname2 = netcdf.getAtt(ncid,i,attname1);
            disp([attname1 ':  ' num2str(attname2)])
            if strmatch('add_offset',attname1)
                offset = attname2;
            end
            if strmatch('scale_factor',attname1)
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
            disp([attname1 ':  ' num2str(attname2)])
            if strmatch('add_offset',attname1)
                offset = attname2;
            end
            if strmatch('scale_factor',attname1)
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
            disp([attname1 ':  ' num2str(attname2)])
            if strmatch('add_offset',attname1)
                offset = attname2;
            end
            if strmatch('scale_factor',attname1)
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
            disp([attname1 ':  ' num2str(attname2)])
            if strmatch('add_offset',attname1)
                offset = attname2;
            end
            if strmatch('scale_factor',attname1)
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
            disp([attname1 ':  ' num2str(attname2)])
            if strmatch('add_offset',attname1)
                offset = attname2;
            end
            if strmatch('scale_factor',attname1)
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
                ab=1;
            end
            a1=strcmp(attname1,'sweep_angle_axis');
            if(a1==1)
                goesImagerS.sweep_angle_axis=attname2;
                ab=1;
            end
       elseif (a80==1)
            attname1 = netcdf.inqAttName(ncid,i,j);
            attname2 = netcdf.getAtt(ncid,i,attname1);
            disp([attname1 ':  ' num2str(attname2)])
            if strmatch('add_offset',attname1)
                offset = attname2;
            end
            if strmatch('scale_factor',attname1)
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
            disp([attname1 ':  ' num2str(attname2)])
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
            disp([attname1 ':  ' num2str(attname2)])
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
            disp([attname1 ':  ' num2str(attname2)])
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
            disp([attname1 ':  ' num2str(attname2)])
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
            disp([attname1 ':  ' num2str(attname2)])
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
            disp([attname1 ':  ' num2str(attname2)])
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
            disp([attname1 ':  ' num2str(attname2)])
            a1=strcmp(attname1,'long_name');
            if(a1==1)
                OutlierPS.long_name=attname2;
            end
            a1=strcmp(attname1,'_FillValue');
            if(a1==1)
                OutlierPS.FillValue=attname2;
            end
            a1=strcmp(attname1,'units');
            if(a1==1)
                OutlierPS.units=attname2;
            end
            a1=strcmp(attname1,'coordinates');
            if(a1==1)
                OutlierPS.coordinates=attname2;
            end
            a1=strcmp(attname1,'grid_mapping');
            if(a1==1)
                OutlierPS.grid_mapping=attname2;
            end
            a1=strcmp(attname1,'cell_methods');
            if(a1==1)
                OutlierPS.cell_methods=attname2;
            end
        elseif (a170==1)
            attname1 = netcdf.inqAttName(ncid,i,j);
            attname2 = netcdf.getAtt(ncid,i,attname1);
            disp([attname1 ':  ' num2str(attname2)])
            a1=strcmp(attname1,'long_name');
            if(a1==1)
                CloudTopTS.long_name1=attname2;
            end
            a1=strcmp(attname1,'standard_name');
            if(a1==1)
                CloudTopTS.standard_name1=attname2;
            end
            a1=strcmp(attname1,'_FillValue');
            if(a1==1)
                CloudTopTS.FillValue1=attname2;
            end
            a1=strcmp(attname1,'valid_range');
            if(a1==1)
                CloudTopTS.valid_range1=attname2;
            end
            a1=strcmp(attname1,'units');
            if(a1==1)
                CloudTopTS.units1=attname2;
            end
            a1=strcmp(attname1,'coordinates');
            if(a1==1)
                CloudTopTS.coordinates1=attname2;
            end
            a1=strcmp(attname1,'grid_mapping');
            if(a1==1)
                CloudTopTS.grid_mapping1=attname2;
            end
            a1=strcmp(attname1,'cell_methods');
            if(a1==1)
                CloudTopTS.cell_methods1=attname2;
            end
        elseif (a180==1)
            attname1 = netcdf.inqAttName(ncid,i,j);
            attname2 = netcdf.getAtt(ncid,i,attname1);
            disp([attname1 ':  ' num2str(attname2)])
            a1=strcmp(attname1,'long_name');
            if(a1==1)
                CloudTopTS.long_name2=attname2;
            end
            a1=strcmp(attname1,'standard_name');
            if(a1==1)
                CloudTopTS.standard_name2=attname2;
            end
            a1=strcmp(attname1,'_FillValue');
            if(a1==1)
                CloudTopTS.FillValue2=attname2;
            end
            a1=strcmp(attname1,'valid_range');
            if(a1==1)
                CloudTopTS.valid_range2=attname2;
            end
            a1=strcmp(attname1,'units');
            if(a1==1)
                CloudTopTS.units2=attname2;
            end
            a1=strcmp(attname1,'coordinates');
            if(a1==1)
                CloudTopTS.coordinates2=attname2;
            end
            a1=strcmp(attname1,'grid_mapping');
            if(a1==1)
                CloudTopTS.grid_mapping2=attname2;
            end
            a1=strcmp(attname1,'cell_methods');
            if(a1==1)
                CloudTopTS.cell_methods2=attname2;
            end
       elseif (a190==1)
            attname1 = netcdf.inqAttName(ncid,i,j);
            attname2 = netcdf.getAtt(ncid,i,attname1);
            disp([attname1 ':  ' num2str(attname2)])
            a1=strcmp(attname1,'long_name');
            if(a1==1)
                CloudTopTS.long_name3=attname2;
            end
            a1=strcmp(attname1,'standard_name');
            if(a1==1)
                CloudTopTS.standard_name3=attname2;
            end
            a1=strcmp(attname1,'_FillValue');
            if(a1==1)
                CloudTopTS.FillValue3=attname2;
            end
            a1=strcmp(attname1,'valid_range');
            if(a1==1)
                CloudTopTS.valid_range3=attname2;
            end
            a1=strcmp(attname1,'units');
            if(a1==1)
                CloudTopTS.units3=attname2;
            end
            a1=strcmp(attname1,'coordinates');
            if(a1==1)
                CloudTopTS.coordinates3=attname2;
            end
            a1=strcmp(attname1,'grid_mapping');
            if(a1==1)
                CloudTopTS.grid_mapping3=attname2;
            end
            a1=strcmp(attname1,'cell_methods');
            if(a1==1)
                CloudTopTS.cell_methods3=attname2;
            end
        elseif (a200==1)
            attname1 = netcdf.inqAttName(ncid,i,j);
            attname2 = netcdf.getAtt(ncid,i,attname1);
            disp([attname1 ':  ' num2str(attname2)])
            a1=strcmp(attname1,'long_name');
            if(a1==1)
                CloudTopTS.long_name4=attname2;
            end
            a1=strcmp(attname1,'standard_name');
            if(a1==1)
                CloudTopTS.standard_name4=attname2;
            end
            a1=strcmp(attname1,'_FillValue');
            if(a1==1)
                CloudTopTS.FillValue4=attname2;
            end
            a1=strcmp(attname1,'valid_range');
            if(a1==1)
                CloudTopTS.valid_range4=attname2;
            end
            a1=strcmp(attname1,'units');
            if(a1==1)
                CloudTopTS.units4=attname2;
            end
            a1=strcmp(attname1,'coordinates');
            if(a1==1)
                CloudTopTS.coordinates4=attname2;
            end
            a1=strcmp(attname1,'grid_mapping');
            if(a1==1)
                CloudTopTS.grid_mapping4=attname2;
            end
            a1=strcmp(attname1,'cell_methods');
            if(a1==1)
                CloudTopTS.cell_methods4=attname2;
            end
        elseif (a210==1)
            attname1 = netcdf.inqAttName(ncid,i,j);
            attname2 = netcdf.getAtt(ncid,i,attname1);
            disp([attname1 ':  ' num2str(attname2)])
            a1=strcmp(attname1,'long_name');
            if(a1==1)
                Algo2S.long_name=attname2;
            end
            a1=strcmp(attname1,'input_ABI_L1b_radiance_band_14_2km_data');
            if(a1==1)
                Algo2S.input_ABI_L1b_radiance_band_14_2km_data=attname2;
            end
            a1=strcmp(attname1,'input_ABI_L2_brightness_temperature_band_14_2km_data');
            if(a1==1)
                Algo2S.input_ABI_L2_brightness_temperature_band_14_2km_data=attname2;
            end
            a1=strcmp(attname1,'input_ABI_L2_brightness_temperature_band_15_2km_data');
            if(a1==1)
                Algo2S.input_ABI_L2_brightness_temperature_band_15_2km_data=attname2;
            end
            a1=strcmp(attname1,'input_ABI_L2_brightness_temperature_band_16_2km_data');
            if(a1==1)
                Algo2S.input_ABI_L2_brightness_temperature_band_16_2km_data=attname2;
            end
            a1=strcmp(attname1,'input_ABI_L2_intermediate_product_4_level_cloud_mask_data');
            if(a1==1)
                Algo2S.input_ABI_L2_intermediate_product_4_level_cloud_mask_data=attname2;
            end
            a1=strcmp(attname1,'input_ABI_L2_intermediate_product_cloud_type_data');
            if(a1==1)
                Algo2S.input_ABI_L2_intermediate_product_cloud_type_data=attname2;
            end
            a1=strcmp(attname1,'input_ABI_L2_intermediate_product_CRTM_clear_sky_radiance_band_14_data');
            if(a1==1)
                Algo2S.ABI_L2_inter_prod_CRTM_clear_sky_rad_band_14_data=attname2;
            end
            a1=strcmp(attname1,'input_ABI_L2_intermediate_product_CRTM_clear_sky_radiance_band_15_data');
            if(a1==1)
                Algo2S.ABI_L2_inter_prod_CRTM_clear_sky_rad_band_15_data=attname2;
            end
            a1=strcmp(attname1,'input_ABI_L2_intermediate_product_CRTM_clear_sky_radiance_band_16_data');
            if(a1==1)
                Algo2S.ABI_L2_inter_prod_CRTM_clear_sky_rad_band_16_data=attname2;
            end
            a1=strcmp(attname1,'input_ABI_L2_intermediate_product_CRTM_clear_sky_radiance_band_14_profile_data');
            if(a1==1)
                Algo2S.ABI_L2_inter_prod_CRTM_clear_sky_rad_band_14_profile_data=attname2;
            end
            a1=strcmp(attname1,'input_ABI_L2_intermediate_product_CRTM_clear_sky_radiance_band_15_profile_data');
            if(a1==1)
                Algo2S.ABI_L2_inter_prod_CRTM_clear_sky_rad_band_15_profile_data=attname2;
            end
            a1=strcmp(attname1,'input_ABI_L2_intermediate_product_CRTM_clear_sky_radiance_band_16_profile_data');
            if(a1==1)
                Algo2S.ABI_L2_inter_prod_CRTM_clear_sky_rad_band_16_profile_data=attname2;
            end
            a1=strcmp(attname1,'input_ABI_L2_intermediate_product_CRTM_clear_sky_radiance_band_14_profile_data');
            if(a1==1)
                Algo2S.ABI_L2_inter_prod_CRTM_clear_sky_rad_band_14_profile_data=attname2;
            end
            a1=strcmp(attname1,'input_ABI_L2_intermediate_product_CRTM_clear_sky_radiance_band_15_profile_data');
            if(a1==1)
                Algo2S.ABI_L2_inter_prod_CRTM_clear_sky_rad_band_15_profile_data=attname2;
            end
            a1=strcmp(attname1,'input_ABI_L2_intermediate_product_CRTM_clear_sky_radiance_band_16_profile_data');
            if(a1==1)
                Algo2S.ABI_L2_inter_prod_CRTM_clear_sky_rad_band_16_profile_data=attname2;
            end
            a1=strcmp(attname1,'input_ABI_L2_intermediate_product_CRTM_clear_sky_transmittance_band_14_profile_data');
            if(a1==1)
                Algo2S.ABI_L2_inter_prod_CRTM_clear_sky_trans_band_14_profile_data=attname2;
            end
            a1=strcmp(attname1,'input_ABI_L2_intermediate_product_CRTM_clear_sky_transmittance_band_15_profile_data');
            if(a1==1)
                Algo2S.ABI_L2_inter_prod_CRTM_clear_sky_trans_band_15_profile_data=attname2;
            end
            a1=strcmp(attname1,'input_ABI_L2_intermediate_product_CRTM_clear_sky_transmittance_band_16_profile_data');
            if(a1==1)
                Algo2S.ABI_L2_inter_prod_CRTM_clear_sky_trans_band_16_profile_data=attname2;
            end
            a1=strcmp(attname1,'input_ABI_L2_intermediate_product_CRTM_cloudy_sky_radiance_band_14_profile_data');
            if(a1==1)
                Algo2S.ABI_L2_inter_prod_CRTM_cloudy_sky_rad_band_14_profile_data=attname2;
            end
            a1=strcmp(attname1,'input_ABI_L2_intermediate_product_CRTM_cloudy_sky_radiance_band_15_profile_data');
            if(a1==1)
                Algo2S.ABI_L2_inter_prod_CRTM_cloudy_sky_rad_band_15_profile_data=attname2;
            end
            a1=strcmp(attname1,'input_ABI_L2_intermediate_product_CRTM_cloudy_sky_radiance_band_16_profile_data');
            if(a1==1)
                Algo2S.ABI_L2_inter_prod_CRTM_cloudy_sky_rad_band_16_profile_data=attname2;
            end
            a1=strcmp(attname1,'input_dynamic_ancillary_NWP_surface_pressure_data');
            if(a1==1)
                Algo2S.input_dynamic_ancillary_NWP_surface_pressure_data=attname2;
            end
            a1=strcmp(attname1,'input_dynamic_ancillary_NWP_surface_temperature_data');
            if(a1==1)
                Algo2S.input_dynamic_ancillary_NWP_surface_temperature_data=attname2;
            end
            a1=strcmp(attname1,'input_dynamic_ancillary_NWP_tropopause_temperature_data');
            if(a1==1)
                Algo2S.input_dynamic_ancillary_NWP_tropopause_temperature_data=attname2;
            end
            a1=strcmp(attname1,'input_dynamic_ancillary_NWP_temperature_profile_data');
            if(a1==1)
                Algo2S.input_dynamic_ancillary_NWP_temperature_profile_data=attname2;
            end
            a1=strcmp(attname1,'input_dynamic_ancillary_NWP_temperature_inversion_profile_data');
            if(a1==1)
                Algo2S.input_dynamic_ancillary_NWP_temperature_inversion_profile_data=attname2;
            end
            a1=strcmp(attname1,'input_dynamic_ancillary_NWP_geopotential_height_profile_data');
            if(a1==1)
                Algo2S.input_dynamic_ancillary_NWP_geopotential_height_profile_data=attname2;
            end
            a1=strcmp(attname1,'input_dynamic_ancillary_NWP_pressure_profile_data');
            if(a1==1)
                Algo2S.input_dynamic_ancillary_NWP_pressure_profile_data=attname2;
            end
            a1=strcmp(attname1,'input_dynamic_ancillary_NWP_surface_level_index_data');
            if(a1==1)
                Algo2S.input_dynamic_ancillary_NWP_surface_level_index_data=attname2;
            end
            a1=strcmp(attname1,'input_dynamic_ancillary_NWP_tropopause_level_index_data');
            if(a1==1)
                Algo2S.input_dynamic_ancillary_NWP_tropopause_level_index_data=attname2;
            end

        elseif (a240==1)
            attname1 = netcdf.inqAttName(ncid,i,j);
            attname2 = netcdf.getAtt(ncid,i,attname1);
            disp([attname1 ':  ' num2str(attname2)])
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
            disp([attname1 ':  ' num2str(attname2)])
            a1=strcmp(attname1,'long_name');
            if(a1==1)
                ProcessParamTS.long_name=attname2;
            end
            a1=strcmp(attname1,'L2_processing_parm_version');
            if(a1==1)
                ProcessParamTS.L2_processing_parm_version=attname2;
            end
        elseif (a260==1)
            attname1 = netcdf.inqAttName(ncid,i,j);
            attname2 = netcdf.getAtt(ncid,i,attname1);
            disp([attname1 ':  ' num2str(attname2)])
            a1=strcmp(attname1,'long_name');
            if(a1==1)
                AlgoProductTS.long_name=attname2;
            end
            a1=strcmp(attname1,'algorithm_version');
            if(a1==1)
                AlgoProductTS.algorithm_version=attname2;
            end
            a1=strcmp(attname1,'product_version');
            if(a1==1)
                AlgoProductTS.product_version=attname2;
            end
       elseif (a270==1)
            attname1 = netcdf.inqAttName(ncid,i,j);
            attname2 = netcdf.getAtt(ncid,i,attname1);
            disp([attname1 ':  ' num2str(attname2)])
            a1=strcmp(attname1,'long_name');
            if(a1==1)
                LZAS.long_name=attname2;
            end
            a1=strcmp(attname1,'standard_name');
            if(a1==1)
                LZAS.standard_name=attname2;
            end
            a1=strcmp(attname1,'units');
            if(a1==1)
                LZAS.units=attname2;
            end
            a1=strcmp(attname1,'bounds');
            if(a1==1)
                LZAS.bounds=attname2;
            end
        elseif (a280==1)
            attname1 = netcdf.inqAttName(ncid,i,j);
            attname2 = netcdf.getAtt(ncid,i,attname1);
            disp([attname1 ':  ' num2str(attname2)])
            a1=strcmp(attname1,'long_name');
            if(a1==1)
                LZABS.long_name=attname2;
            end
        elseif (a290==1)
            attname1 = netcdf.inqAttName(ncid,i,j);
            attname2 = netcdf.getAtt(ncid,i,attname1);
            disp([attname1 ':  ' num2str(attname2)])
            a1=strcmp(attname1,'long_name');
            if(a1==1)
                SZAS.long_name=attname2;
            end
            a1=strcmp(attname1,'standard_name');
            if(a1==1)
                SZAS.standard_name=attname2;
            end
            a1=strcmp(attname1,'units');
            if(a1==1)
                SZAS.units=attname2;
            end
            a1=strcmp(attname1,'bounds');
            if(a1==1)
                SZAS.bounds=attname2;
            end
        elseif (a300==1)
            attname1 = netcdf.inqAttName(ncid,i,j);
            attname2 = netcdf.getAtt(ncid,i,attname1);
            disp([attname1 ':  ' num2str(attname2)])
            a1=strcmp(attname1,'long_name');
            if(a1==1)
                SZABS.long_name=attname2;
            end
        elseif (a310==1)
            attname1 = netcdf.inqAttName(ncid,i,j);
            attname2 = netcdf.getAtt(ncid,i,attname1);
            disp([attname1 ':  ' num2str(attname2)])
            a1=strcmp(attname1,'long_name');
            if(a1==1)
                Error1S.long_name1=attname2;
            end
            a1=strcmp(attname1,'_FillValue');
            if(a1==1)
                Error1S.FillValue1=attname2;
            end
            a1=strcmp(attname1,'valid_range');
            if(a1==1)
                Error1S.valid_range1=attname2;
            end
            a1=strcmp(attname1,'units');
            if(a1==1)
                Error1S.units1=attname2;
            end
            a1=strcmp(attname1,'coordinates');
            if(a1==1)
                Error1S.coordinates1=attname2;
            end
            a1=strcmp(attname1,'grid_mapping');
            if(a1==1)
                Error1S.grid_mapping1=attname2;
            end
            a1=strcmp(attname1,'cell_methods');
            if(a1==1)
                Error1S.cell_methods1=attname2;
            end
         elseif (a320==1)
            attname1 = netcdf.inqAttName(ncid,i,j);
            attname2 = netcdf.getAtt(ncid,i,attname1);
            disp([attname1 ':  ' num2str(attname2)])
            a1=strcmp(attname1,'long_name');
            if(a1==1)
                Error1S.long_name2=attname2;
            end
            a1=strcmp(attname1,'_FillValue');
            if(a1==1)
                Error1S.FillValue2=attname2;
            end
            a1=strcmp(attname1,'valid_range');
            if(a1==1)
                Error1S.valid_range2=attname2;
            end
            a1=strcmp(attname1,'units');
            if(a1==1)
                Error1S.units2=attname2;
            end
            a1=strcmp(attname1,'coordinates');
            if(a1==1)
                Error1S.coordinates2=attname2;
            end
            a1=strcmp(attname1,'grid_mapping');
            if(a1==1)
                Error1S.grid_mapping2=attname2;
            end
            a1=strcmp(attname1,'cell_methods');
            if(a1==1)
                Error1S.cell_methods2=attname2;
            end

          elseif (a330==1)
            attname1 = netcdf.inqAttName(ncid,i,j);
            attname2 = netcdf.getAtt(ncid,i,attname1);
            disp([attname1 ':  ' num2str(attname2)])
            a1=strcmp(attname1,'long_name');
            if(a1==1)
                CloudPixelsS.long_name=attname2;
            end
            a1=strcmp(attname1,'_FillValue');
            if(a1==1)
                CloudPixelsS.FillValue=attname2;
            end
            a1=strcmp(attname1,'units');
            if(a1==1)
                CloudPixelsS.units=attname2;
            end
            a1=strcmp(attname1,'coordinates');
            if(a1==1)
                CloudPixelsS.coordinates=attname2;
            end
            a1=strcmp(attname1,'grid_mapping');
            if(a1==1)
                CloudPixelsS.grid_mapping=attname2;
            end
            a1=strcmp(attname1,'cell_methods');
            if(a1==1)
                CloudPixelsS.cell_methods=attname2;
            end
        else
            attname1 = netcdf.inqAttName(ncid,i,j);
            attname2 = netcdf.getAtt(ncid,i,attname1);
            disp([attname1 ':  ' num2str(attname2)])
            if strmatch('add_offset',attname1)
                offset = attname2;
            end
            if strmatch('scale_factor',attname1)
                scale = attname2;
                flag = 1;
            end   
        end
    end
    disp(' ')
    
    if flag
        eval([varname '= double(double(netcdf.getVar(ncid,i))*scale + offset);'])
        if(varname=='TEMP')
            TempS.values=TEMP;
            ab=1;
        end
        if(varname=='y')
            yS.values=y;
        end
        if(varname=='x')
            xS.values=x;
            ab=1;
        end
    else
        eval([varname '= double(netcdf.getVar(ncid,i));'])   
        if(a20==1)
            DQF2S.values=DQF;
        end
        if(varname=='t')
            tS.values=t;
            ab=1;
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
            OutlierPS.values=outlier_pixels;
        end
        if(a170==1)
            CloudTopTS.values1=minimum_cloud_top_temperature;
        end
        if(a180==1)
            CloudTopTS.values2=maximum_cloud_top_temperature;
        end
        if(a190==1)
            CloudTopTS.values3=mean_cloud_top_temperature;
        end
        if(a200==1)
            CloudTopTS.values4=std_dev_cloud_top_temperature;
        end
        if(a210==1)
            Algo2S.values=algorithm_dynamic_input_data_container;
            ab=1;
        end

        if(a240==1)
            EarthSunS.values=earth_sun_distance_anomaly_in_AU;
        end
        if(a250==1)
            ProcessParamTS.values=processing_parm_version_container;
        end
        if(a260==1)
            AlgoProductTS.values=algorithm_product_version_container;
        end
        if(a270==1)
            LZAS.values=local_zenith_angle;
        end
        if(a280==1)
            LZABS.values=local_zenith_angle_bounds;
        end
        if(a290==1)
            SZAS.values=local_zenith_angle_bounds;
        end
        if(a300==1)
            SZABS.values=local_zenith_angle_bounds;
        end
        if(a310==1)
            Error1S.values1=percent_uncorrectable_GRB_errors;
        end
        if(a320==1)
            Error1S.values2=percent_uncorrectable_L0_errors;
        end


        if(a330==1)
            CloudPixelsS.values=cloud_pixels;
        end


    end
end
disp('^~^~^~^~^~^~^~^~^~^~^~^~^~^~^~^~^~^~^~^~^~^~^~^~^~^~^~^~')
disp('________________________________________________________')
disp(' '),disp(' ')
%Now write a Matlab file containing the decoded data
%use the original file name with a .mat extension
[iper]=strfind(GOESFileName,'.');
is=1;
ie=iper(1)-1;
MatFileName=strcat(GOESFileName(is:ie),'.mat');
eval(['cd ' GOES16path(1:length(GOES16path)-1)]);
actionstr='save';
varstr1='TempS MetaDataS DQF2S tS yS xS tBS goesImagerS AlgoProductTS';
varstr2=' yImgS yImgBS xImgS xImgBS SatDataS GeoSpatialS ProcessParamTS';
varstr3=' OutlierPS CloudTopTS Algo2S Error1S  LZAS LZABS';
varstr4=' GoesWaveBand SZAS SZABS GOESFileName';
varstr=strcat(varstr1,varstr2,varstr3,varstr4);
qualstr='-v7.3';
[cmdString]=MyStrcatV73(actionstr,MatFileName,varstr,qualstr);
eval(cmdString)
dispstr=strcat('Wrote Matlab File-',MatFileName);
disp(dispstr);
% Display the Moisture Data
fileprefix=GOESFileName(is:ie);
filename=RemoveUnderScores(fileprefix);
titlestr=strcat('CloudTopTemps-',filename);
DisplayCloudTopTemps(titlestr)

end

