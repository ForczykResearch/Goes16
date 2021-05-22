function ReadDerivedMotionWinds()
% Modified: This function will read in the GOES Derived Motion Wind Data
% Written By: Stephen Forczyk
% Created: Nov 4,2020
% Revised: Nov 10,2020 made changes to complete initial reading of data
% Classification: Unclassified

global BandDataS MetaDataS;
global DQFS tS yS xS tBS goesImagerS yImgS yImgBS;
global latS lonS timeS SecBetwnImagesS TimeBoundsS;
global LatImageS LatImageBS LonImageS LonImageBS;
global WindSpeedS WindDirectionS WindSpeedOutlierS WindVectorS;
global PressureS TempS GOESProjS;
global RetLZAS RetLZABS;
global ATMLayerPS ATMLayerPBS;
global TargetBoxS LagSizeS NestTrkFlagS TargetTypeS;
global MinWindSpeedS MaxWindSpeedS MeanWindSpeedS StdevWindSpeedS;
global MinCloudTopPressureS MaxCloudTopPressureS MeanCloudTopPressureS;
global StdevCloudTopPressureS;
global Band_IDS Band_WavelengthS;
global WindData;
global xImgS xImgBS SatDataS GeoSpatialS;
global ReflectanceS AlgoS ErrorS EarthSunS VersionContainerS;
global GoesWaveBand ESunS kappa0S PlanckS FocalPlaneS;
global GOESFileName OutlierPS CloudTopTS LZAS LZABS SZAS SZABS;
global Algo2S ProcessParamTS AlgoProductTS Error1S CloudPixelsS;
global GRBErrorsS L0ErrorsS;
global idebug isavefiles;
global NumProcFiles ProcFileList;
global RptGenPresent iCreatePDFReport pdffilename rpt chapter;
global JpegCounter JpegFileList;
% additional paths needed for mapping
global fid;
global matpath1 mappath GOES16path;
global jpegpath figpath;
global GOES16Band1path GOES16Band2path GOES16Band3path GOES16Band4path;
global GOES16Band5path GOES16Band6path GOES16Band7path GOES16Band8path
global GOES16Band9path GOES16Band10path GOES16Band11path GOES16Band12path;
global GOES16Band13path GOES16Band14path GOES16Band15path GOES16Band16path;
global GOES16CloudTopHeightpath;

if((iCreatePDFReport==1) && (RptGenPresent==1))
    import mlreportgen.dom.*;
    import mlreportgen.report.*;
end
fprintf(fid,'%s\n','Start reading derived winds data');

[nc_filenamesuf,path]=uigetfile('*nc','Select One GOES Data File');% SMF Modification
GOESFileName=nc_filenamesuf;
filestr=strcat('Working on file-',GOESFileName);
fprintf(fid,'%s\n',filestr);
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

latS=struct('values',[],'FillValue',[],'long_name',[],'standard_name',[],...
    'units',[],'axis',[]);
lonS=latS;
timeS=struct('values',[],'FillValue',[],'long_name',[],'standard_name',[],...
    'units',[],'axis',[]);
WindSpeedS=struct('values',[],'FillValue',[],'long_name',[],'standard_name',[],...
    'valid_range',[],'units',[],'coordinates',[],'grid_mapping',[],...
    'cell_methods',[],'ancillary_variables',[]);
WindDirectionS=WindSpeedS;
WindSpeedOutlierS=struct('values',[],'long_name',[],'FillValue',[],'units',[],...
  'coordinates',[],'cell_methods',[]); 
WindVectorS=WindSpeedOutlierS;
TargetBoxS=struct('values',[],'long_name',[],'FillValue',[],'valid_range',[],...
    'units',[],'coordinates',[],'cell_methods',[]);
LagSizeS=TargetBoxS;
NestTrkFlagS=struct('values',[],'long_name',[],'FillValue',[],'valid_range',[],...
    'units',[],'coordinates',[],'cell_methods',[],'flag_values',[],'flag_meanings',[]);
TargetTypeS=NestTrkFlagS;
MinWindSpeedS=struct('values',[],'long_name',[],'standard_name',[],'FillValue',[],...
    'valid_range',[],'units',[],'coordinates',[],'cell_methods',[]);
MaxWindSpeedS=MinWindSpeedS;
MeanWindSpeedS=MinWindSpeedS;
MaxWindSpeedS=MinWindSpeedS;
StdevWindSpeedS=struct('values',[],'long_name',[],'standard_name',[],'FillValue',[],...
    'units',[],'coordinates',[],'cell_methods',[]);
MinCloudTopPressureS=struct('values',[],'long_name',[],'standard_name',[],...
    'FillValue',[],'valid_range',[],'units',[],'coordinates',[],'cell_methods',[]);
MaxCloudTopPressureS=MinCloudTopPressureS;
StdevCloudTopPressureS=struct('values',[],'long_name',[],'standard_name',[],...
    'FillValue',[],'units',[],'coordinates',[],'cell_methods',[]);
PressureS=struct('values',[],'FillValue',[],'long_name',[],'standard_name',[],...
    'valid_range',[],'units',[],'coordinates',[],'grid_mapping',[],...
    'cell_methods',[]);
TempS=PressureS;
DQFS=struct('values',[],'fill',[],'valid_range',[],'units',[],...
    'coordinates',[],'flag_values',[],'flag_meanings',[],...
    'number_of_qf_values',[],'long_name',[],'standard_name',[],...
    'pct_invalid_due_to_wind_speed_below_threshold_qf',[],...
    'pct_inval_due_to_cloud_height_median_pressure_threshold_qf',[],...
    'pct_inval_due_to_terminator_proximity_below_threshold_qf',[],...
    'pct_inval_due_to_location_on_earth_limb_qf',[],...
    'pct_inval_due_to_cloud_amount_below_or_exceeds_threshold_qf',[],...
    'pct_inval_due_to_median_pressure_retrieval_failure_qf',[],...
    'pct_inval_due_to_bad_or_missing_bright_temp_or_reflec_qf',[],...
    'pct_inval_due_to_multiple_cloud_layers_qf',[],...
    'pct_inval_due_to_insuff_structure_for_reliable_tracking_qf',[],...
    'pct_inval_due_to_cloud_tracking_correlation_below_threshold_qf',[],...
    'pct_inval_due_to_u_component_acceleration_exceeds_threshold_qf',[],...
    'pct_inval_due_to_v_component_acceleration_exceeds_threshold_qf',[],...
    'pct_inval_due_to_u_v_components_accel_exceeds_threshold_qf',[],...
    'pct_inval_due_to_feature_match_at_search_region_boundary_qf',[],...
    'pct_inval_due_to_difference_with_forecast_wind_qf',[],...
    'pct_inval_due_to_diff_in_image_pairs_cloud_ht_exceeds_threshold',[],...
    'pct_inval_due_to_data_for_search_region_unavailable_qf',[],...
    'pct_inval_due_to_failure_of_qual_indicator_and_error_checks_qf',[],...
    'pct_inval_due_to_missing_data_in_search_region_qf',[],...
    'pct_inval_due_to_winds_not_found_qf',[],...
    'pct_inval_due_to_feature_cluster_not_found_qf',[]);
LatImageS=struct('values',[],'long_name',[],'standard_name',[],'units',[],...
    'axis',[],'bounds',[]);
LatImageBS=struct('values',[],'long_name',[]);
LonImageS=LatImageS;
LonImageBS=LatImageBS;
GOESProjS=struct('values',[],'long_name',[],'grid_mapping_name',[],...
    'semi_major_axis',[],'semi_minor_axis',[],'inverse_flattening',[],...
    'longitude_of_prime_meridian',[]);
SecBetwnImagesS=struct('values',[],'long_name',[],'Unsigned',[],...
    'FillValue',[],'units',[],'coordinates',[],'cell_methods',[]);
TimeBoundsS=struct('values',[],'long_name',[]);
RetLZAS=struct('values',[],'long_name',[],'standard_name',[],'units',[],'bounds',[]);
RetLZABS=struct('values',[],'long_name',[]);
ATMLayerPS=struct('values',[],'long_name',[],'standard_name',[],'units',[],...
    'axis',[],'bounds',[]);
ATMLayerPBS=struct('values',[],'long_name',[]);
GRBErrorsS=struct('values',[],'long_name',[],'FillValue',[],'valid_range',[],...
    'units',[],'coordinates',[],'cell_methods',[]);
L0ErrorsS=GRBErrorsS;
tS=struct('long_name',[],'standard_name',[],'units',[],'axis',[],'bounds',[],'values',[]);
yS=struct('scale_factor',[],'add_offset',[],'units',[],'axis',[],'long_name',[],...
    'standard_name',[]);
xS=yS;
tBS=struct('values',[],'long_name',[]);

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

AlgoProductTS=struct('values',[],'long_name',[],'algorithm_version',[],'product_version',[]);
Band_IDS=struct('values',[],'long_name',[],'standard_name',[],'units',[]);
Band_WavelengthS=struct('values',[],'long_name',[],'standard_name',[],'units',[]);
LZAS=struct('values',[],'long_name',[],'standard_name',[],'units',[]);
LZABS=struct('values',[],'long_name',[]);
SZAS=struct('values',[],'long_name',[],'standard_name',[],'units',[]);
SZABS=struct('values',[],'long_name',[]);


Algo2S=struct('values',[],'long_name',[],'input_ABI_L2_auxiliary_solar_zenith_angle_data',[],...
    'input_ABI_L1b_radiance_band_14_2km_data',[],...
    'input_ABI_L2_brightness_temperature_band_7_2km_data',[],...
    'input_ABI_L2_brightness_temperature_band_8_2km_data',[],...
    'input_ABI_L2_brightness_temperature_band_9_2km_data',[],...
    'input_ABI_L2_brightness_temperature_band_10_2km_data',[],...
    'input_ABI_L2_brightness_temperature_band_14_2km_data',[],...
    'input_ABI_L2_cloud_top_phase_data',[],...
    'input_ABI_L2_cloud_top_temperature_data',[],...
    'input_ABI_L2_interm_product_reflectance_band_2_half_km_data',[],...
    'input_ABI_L2_intermediate_product_4_level_cloud_mask_data',[],...
    'input_ABI_L2_intermediate_product_cloud_top_height_data',[],...
    'input_ABI_L2_intermediate_product_cloud_top_pressure_data',[],...
    'input_ABI_L2_intermediate_product_cloud_type_data',[],...
    'input_ABI_L2_inter_product_low_level_temp_inversion_flag_data',[],...
    'input_dynamic_ancillary_NWP_raw_temperature_profile_data',[],...
    'input_dynamic_ancillary_NWP_wind_vector_profile_data',[]);
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
        a10=strcmp(varname,'lat');
        a20=strcmp(varname,'lon');
        a30=strcmp(varname,'time');
        a40=strcmp(varname,'wind_speed');
        a50=strcmp(varname,'wind_direction');
        a60=strcmp(varname,'pressure');
        a70=strcmp(varname,'temperature');
        a80=strcmp(varname,'local_zenith_angle');
        a90=strcmp(varname,'solar_zenith_angle');
        a100=strcmp(varname,'DQF');
        a110=strcmp(varname,'lat_image');
        a120=strcmp(varname,'lat_image_bounds');
        a130=strcmp(varname,'lon_image');
        a140=strcmp(varname,'lon_image_bounds');
        a150=strcmp(varname,'goes_lat_lon_projection');
        a160=strcmp(varname,'geospatial_lat_lon_extent');
        a240=strcmp(varname,'earth_sun_distance_anomaly_in_AU');
        a250=strcmp(varname,'processing_parm_version_container');
        a260=strcmp(varname,'algorithm_product_version_container');
        a270=strcmp(varname,'local_zenith_angle');
        a280=strcmp(varname,'local_zenith_angle_bounds');
        a290=strcmp(varname,'solar_zenith_angle');
        a300=strcmp(varname,'solar_zenith_angle_bounds');
        a330=strcmp(varname,'cloud_pixels');
        a340=strcmp(varname,'nominal_satellite_subpoint_lat');
        a350=strcmp(varname,'nominal_satellite_subpoint_lon');
        a360=strcmp(varname,'nominal_satellite_height');
        a370=strcmp(varname,'seconds_between_images');
        a380=strcmp(varname,'time_bounds');
        a390=strcmp(varname,'retrieval_local_zenith_angle');
        a400=strcmp(varname,'retrieval_local_zenith_angle_bounds');
        a410=strcmp(varname,'atmospheric_layer_pressure');
        a420=strcmp(varname,'atmospheric_layer_pressure_bounds');
        a430=strcmp(varname,'wind_speed_outlier_count');
        a440=strcmp(varname,'number_of_wind_vectors_in_atmospheric_layer');
        a450=strcmp(varname,'target_box_size');
        a460=strcmp(varname,'lag_size');
        a470=strcmp(varname,'nested_tracking_flag');
        a480=strcmp(varname,'target_type');
        a490=strcmp(varname,'minimum_wind_speed');
        a500=strcmp(varname,'maximum_wind_speed');
        a510=strcmp(varname,'mean_wind_speed');
        a520=strcmp(varname,'standard_deviation_wind_speed');
        a530=strcmp(varname,'min_cloud_top_pressure_in_atmospheric_layer');
        a540=strcmp(varname,'max_cloud_top_pressure_in_atmospheric_layer');
        a550=strcmp(varname,'mean_cloud_top_pressure_in_atmospheric_layer');
        a560=strcmp(varname,'standard_deviation_cloud_top_pressure_in_atmospheric_layer');
        a570=strcmp(varname,'percent_uncorrectable_GRB_errors');
        a580=strcmp(varname,'percent_uncorrectable_L0_errors');
        a590=strcmp(varname,'algorithm_dynamic_input_data_container');
        a600=strcmp(varname,'band_id');
        a610=strcmp(varname,'band_wavelength');
        if (a10==1)
            attname1 = netcdf.inqAttName(ncid,i,j);
            attname2 = netcdf.getAtt(ncid,i,attname1);
            if(idebug==1)
                disp([attname1 ':  ' num2str(attname2)])
                dispstr=strcat(attname1,': ',num2str(attname2));
                fprintf(fid,'%s\n',dispstr);
            end
            if strmatch('add_offset',attname1)
                offset = attname2;
            end
            if strmatch('scale_factor',attname1)
                scale = attname2;
                flag = 1;
            end 
            a1=strcmp(attname1,'long_name');
            if(a1==1)
                latS.long_name=attname2;
            end
            a1=strcmp(attname1,'standard_name');
            if(a1==1)
                latS.standard_name=attname2;
            end
            a1=strcmp(attname1,'units');
            if(a1==1)
                latS.units=attname2;
            end
            a1=strcmp(attname1,'_FillValue');
            if(a1==1)
                latS.FillValue=attname2;
            end
            a1=strcmp(attname1,'axis');
            if(a1==1)
                latS.axis=attname2;
            end


        elseif (a20==1)
            attname1 = netcdf.inqAttName(ncid,i,j);
            attname2 = netcdf.getAtt(ncid,i,attname1);
            if(idebug==1)
                disp([attname1 ':  ' num2str(attname2)])
                dispstr=strcat(attname1,': ',num2str(attname2));
                fprintf(fid,'%s\n',dispstr);
            end
            if strmatch('add_offset',attname1)
                offset = attname2;
            end
            if strmatch('scale_factor',attname1)
                scale = attname2;
                flag = 1;
            end 
            a1=strcmp(attname1,'long_name');
            if(a1==1)
                lonS.long_name=attname2;
            end
            a1=strcmp(attname1,'standard_name');
            if(a1==1)
                lonS.standard_name=attname2;
            end
            a1=strcmp(attname1,'units');
            if(a1==1)
                lonS.units=attname2;
            end
            a1=strcmp(attname1,'_FillValue');
            if(a1==1)
                lonS.FillValue=attname2;
            end
            a1=strcmp(attname1,'axis');
            if(a1==1)
                lonS.axis=attname2;
            end
        elseif (a30==1)
            attname1 = netcdf.inqAttName(ncid,i,j);
            attname2 = netcdf.getAtt(ncid,i,attname1);
            if(idebug==1)
                disp([attname1 ':  ' num2str(attname2)])
                dispstr=strcat(attname1,': ',num2str(attname2));
                fprintf(fid,'%s\n',dispstr);
            end
            if strmatch('add_offset',attname1)
                offset = attname2;
            end
            if strmatch('scale_factor',attname1)
                scale = attname2;
                flag = 1;
            end 
            a1=strcmp(attname1,'_FillValue');
            if(a1==1)
                timeS.FillValue=attname2;
            end
            a1=strcmp(attname1,'units');
            if(a1==1)
                timeS.units=attname2;
            end
            a1=strcmp(attname1,'axis');
            if(a1==1)
                timeS.axis=attname2;
            end
            a1=strcmp(attname1,'long_name');
            if(a1==1)
                timeS.long_name=attname2;
            end
            a1=strcmp(attname1,'standard_name');
            if(a1==1)
                timeS.standard_name=attname2;
            end
        elseif (a40==1)
            attname1 = netcdf.inqAttName(ncid,i,j);
            attname2 = netcdf.getAtt(ncid,i,attname1);
            if(idebug==1)
                disp([attname1 ':  ' num2str(attname2)])
                dispstr=strcat(attname1,': ',num2str(attname2));
                fprintf(fid,'%s\n',dispstr);
            end
            if strmatch('add_offset',attname1)
                offset = attname2;
            end
            if strmatch('scale_factor',attname1)
                scale = attname2;
                flag = 1;
            end 
            a1=strcmp(attname1,'_FillValue');
            if(a1==1)
                WindSpeedS.FillValue=attname2;
            end
            a1=strcmp(attname1,'long_name');
            if(a1==1)
                WindSpeedS.long_name=attname2;
            end
            a1=strcmp(attname1,'standard_name');
            if(a1==1)
                WindSpeedS.standard_name=attname2;
            end
            a1=strcmp(attname1,'valid_range');
            if(a1==1)
                WindSpeedS.valid_range=attname2;
            end
            a1=strcmp(attname1,'units');
            if(a1==1)
                WindSpeedS.units=attname2;
            end
            a1=strcmp(attname1,'coordinates');
            if(a1==1)
                WindSpeedS.coordinates=attname2;
            end
            a1=strcmp(attname1,'grid_mapping');
            if(a1==1)
                WindSpeedS.grid_mapping=attname2;
            end
            a1=strcmp(attname1,'cell_methods');
            if(a1==1)
                WindSpeedS.cell_methods=attname2;
            end
            a1=strcmp(attname1,'ancillary_variables');
            if(a1==1)
                WindSpeedS.ancillary_variables=attname2;
            end
        elseif (a50==1)
            attname1 = netcdf.inqAttName(ncid,i,j);
            attname2 = netcdf.getAtt(ncid,i,attname1);
            if(idebug==1)
                disp([attname1 ':  ' num2str(attname2)])
                dispstr=strcat(attname1,': ',num2str(attname2));
                fprintf(fid,'%s\n',dispstr);
            end
            a1=strcmp(attname1,'_FillValue');
            if(a1==1)
                WindDirectionS.FillValue=attname2;
            end
            a1=strcmp(attname1,'long_name');
            if(a1==1)
                WindDirectionS.long_name=attname2;
            end
            a1=strcmp(attname1,'standard_name');
            if(a1==1)
                WindDirectionS.standard_name=attname2;
            end
            a1=strcmp(attname1,'valid_range');
            if(a1==1)
                WindDirectionS.valid_range=attname2;
            end
            a1=strcmp(attname1,'units');
            if(a1==1)
                WindDirectionS.units=attname2;
            end
            a1=strcmp(attname1,'coordinates');
            if(a1==1)
                WindDirectionS.coordinates=attname2;
            end
            a1=strcmp(attname1,'grid_mapping');
            if(a1==1)
                WindDirectionS.grid_mapping=attname2;
            end
            a1=strcmp(attname1,'cell_methods');
            if(a1==1)
                WindDirectionS.cell_methods=attname2;
            end
            a1=strcmp(attname1,'ancillary_variables');
            if(a1==1)
                WindDirectionS.ancillary_variables=attname2;
            end
        elseif (a60==1)
            attname1 = netcdf.inqAttName(ncid,i,j);
            attname2 = netcdf.getAtt(ncid,i,attname1);
            if(idebug==1)
                disp([attname1 ':  ' num2str(attname2)])
                dispstr=strcat(attname1,': ',num2str(attname2));
                fprintf(fid,'%s\n',dispstr);
            end
            a1=strcmp(attname1,'_FillValue');
            if(a1==1)
                PressureS.FillValue=attname2;
            end
            a1=strcmp(attname1,'long_name');
            if(a1==1)
                PressureS.long_name=attname2;
            end
            a1=strcmp(attname1,'standard_name');
            if(a1==1)
                PressureS.standard_name=attname2;
            end
            a1=strcmp(attname1,'valid_range');
            if(a1==1)
                PressureS.valid_range=attname2;
            end
            a1=strcmp(attname1,'units');
            if(a1==1)
                PressureS.units=attname2;
            end
            a1=strcmp(attname1,'coordinates');
            if(a1==1)
                PressureS.coordinates=attname2;
            end
            a1=strcmp(attname1,'grid_mapping');
            if(a1==1)
                PressureS.grid_mapping=attname2;
            end
            a1=strcmp(attname1,'cell_methods');
            if(a1==1)
                PressureS.cell_methods=attname2;
            end
        elseif (a70==1)
            attname1 = netcdf.inqAttName(ncid,i,j);
            attname2 = netcdf.getAtt(ncid,i,attname1);
            if(idebug==1)
                disp([attname1 ':  ' num2str(attname2)])
                dispstr=strcat(attname1,': ',num2str(attname2));
                fprintf(fid,'%s\n',dispstr);
            end
            a1=strcmp(attname1,'_FillValue');
            if(a1==1)
                TempS.FillValue=attname2;
            end
            a1=strcmp(attname1,'long_name');
            if(a1==1)
                TempS.long_name=attname2;
            end
            a1=strcmp(attname1,'standard_name');
            if(a1==1)
                TempS.standard_name=attname2;
            end
            a1=strcmp(attname1,'valid_range');
            if(a1==1)
                TempS.valid_range=attname2;
            end
            a1=strcmp(attname1,'units');
            if(a1==1)
                TempS.units=attname2;
            end
            a1=strcmp(attname1,'coordinates');
            if(a1==1)
                TempS.coordinates=attname2;
            end
            a1=strcmp(attname1,'grid_mapping');
            if(a1==1)
                TempS.grid_mapping=attname2;
            end
            a1=strcmp(attname1,'cell_methods');
            if(a1==1)
                TempS.cell_methods=attname2;
            end
       elseif (a80==1)
            attname1 = netcdf.inqAttName(ncid,i,j);
            attname2 = netcdf.getAtt(ncid,i,attname1);
            if(idebug==1)
                disp([attname1 ':  ' num2str(attname2)])
                dispstr=strcat(attname1,': ',num2str(attname2));
                fprintf(fid,'%s\n',dispstr);
            end
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
            a1=strcmp(attname1,'_FillValue');
            if(a1==1)
                LZAS.FillValue=attname2;
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
            a1=strcmp(attname1,'_FillValue');
            if(a1==1)
                SZAS.FillValue=attname2;
            end
        elseif (a100==1)
            attname1 = netcdf.inqAttName(ncid,i,j);
            attname2 = netcdf.getAtt(ncid,i,attname1);
            if(idebug==1)
                disp([attname1 ':  ' num2str(attname2)])
                dispstr=strcat(attname1,': ',num2str(attname2));
                fprintf(fid,'%s\n',dispstr);
            end
            if strmatch('add_offset',attname1)
                offset = attname2;
            end
            if strmatch('scale_factor',attname1)
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
            a1=strcmp(attname1,'percent_good_wind_qf');
            if(a1==1)
                DQFS.pct_good_wind_qf=attname2;
            end 
            a1=strcmp(attname1,'percent_invalid_due_to_difference_with_forecast_wind_exceeds_threshold_qf');
            if(a1==1)
                DQFS.pct_inval_due_to_difference_with_forecast_wind_qf=attname2;
            end
            a1=strcmp(attname1,'percent_out_of_range_pixel_qf');
            if(a1==1)
                DQFS.pct_out_of_range_pixel_qf=attname2;
            end
            a1=strcmp(attname1,'percent_no_value_pixel_qf');
            if(a1==1)
                DQFS.pct_no_value_pixel_qf=attname2;
            end
            a1=strcmp(attname1,'percent_focal_plane_temperature_threshold_exceeded_qf');
            if(a1==1)
                DQFS.pct_focal_plane_temperature_threshold_exceeded_qf=attname2;
            end 
            a1=strcmp(attname1,'percent_invalid_due_to_max_gradient_below_threshold_qf');
            if(a1==1)
                DQFS.pct_invalid_due_to_max_gradient_below_threshold_qf=attname2;
            end
            a1=strcmp(attname1,'percent_invalid_due_to_location_on_earth_limb_qf');
            if(a1==1)
                DQFS.pct_inval_due_to_location_on_earth_limb_qf=attname2;
            end
            a1=strcmp(attname1,'percent_invalid_due_to_cloud_amount_below_or_exceeds_threshold_qf');
            if(a1==1)
                DQFS.pct_inval_due_to_cloud_amount_below_or_exceeds_threshold_qf=attname2;
            end
            a1=strcmp(attname1,'percent_invalid_due_to_median_pressure_retrieval_failure_qf');
            if(a1==1)
                DQFS.pct_inval_due_to_median_pressure_retrieval_failure_qf=attname2;
            end
            a1=strcmp(attname1,'percent_invalid_due_to_bad_or_missing_brightness_temp_or_reflectance_qf');
            if(a1==1)
                DQFS.pct_inval_due_to_bad_or_missing_bright_temp_or_reflec_qf=attname2;
            end
            a1=strcmp(attname1,'percent_invalid_due_to_multiple_cloud_layers_qf');
            if(a1==1)
                DQFS.pct_inval_due_to_multiple_cloud_layers_qf=attname2;
            end
            a1=strcmp(attname1,'percent_invalid_due_to_insufficient_structure_for_reliable_tracking_qf');
            if(a1==1)
                DQFS.pct_inval_due_to_insuff_structure_for_reliable_tracking_qf=attname2;
            end
            a1=strcmp(attname1,'percent_invalid_due_to_cloud_tracking_correlation_below_threshold_qf');
            if(a1==1)
                DQFS.pct_inval_due_to_cloud_tracking_correlation_below_threshold_qf=attname2;
            end
            a1=strcmp(attname1,'percent_invalid_due_to_u_component_acceleration_exceeds_threshold_qf');
            if(a1==1)
                DQFS.pct_inval_due_to_u_component_acceleration_exceeds_threshold_qf=attname2;
            end
            a1=strcmp(attname1,'percent_invalid_due_to_v_component_acceleration_exceeds_threshold_qf');
            if(a1==1)
                DQFS.pct_inval_due_to_v_component_acceleration_exceeds_threshold_qf=attname2;
            end
            a1=strcmp(attname1,'percent_invalid_due_to_u_and_v_components_acceleration_exceeds_threshold_qf');
            if(a1==1)
                DQFS.pct_inval_due_to_u_v_components_accel_exceeds_threshold_qf=attname2;
            end
            a1=strcmp(attname1,'percent_invalid_due_to_u_and_v_components_acceleration_exceeds_threshold_qf');
            if(a1==1)
                DQFS.pct_inval_due_to_u_v_components_accel_exceeds_threshold_qf=attname2;
            end
            a1=strcmp(attname1,'percent_invalid_due_to_wind_speed_below_threshold_qf');
            if(a1==1)
                DQFS.pct_invalid_due_to_wind_speed_below_threshold_qf=attname2;
            end
            a1=strcmp(attname1,'percent_invalid_due_to_day_night_terminator_proximity_below_threshold_qf');
            if(a1==1)
                DQFS.pct_inval_due_to_terminator_proximity_below_threshold_qf=attname2;
            end
            a1=strcmp(attname1,'percent_invalid_due_to_cloud_height_median_pressure_below_or_exceeds_threshold_qf');
            if(a1==1)
                DQFS.pct_inval_due_to_cloud_height_median_pressure_threshold_qf=attname2;
            end
            a1=strcmp(attname1,'percent_invalid_due_to_feature_match_at_search_region_boundary_qf');
            if(a1==1)
                DQFS.pct_inval_due_to_feature_match_at_search_region_boundary_qf=attname2;
            end
            a1=strcmp(attname1,'percent_invalid_due_to_difference_in_image_pairs_cloud_height_median_pressure_exceeds_threshold_qf');
            if(a1==1)
                DQFS.pct_inval_due_to_diff_in_image_pairs_cloud_ht_exceeds_threshold=attname2;
            end
            a1=strcmp(attname1,'percent_invalid_due_to_data_needed_for_search_region_unavailable_qf');
            if(a1==1)
                DQFS.pct_inval_due_to_data_for_search_region_unavailable_qf=attname2;
            end
            a1=strcmp(attname1,'percent_invalid_due_to_falure_of_quality_indicator_and_expected_error_method_checks_qf');
            if(a1==1)
                DQFS.pct_inval_due_to_failure_of_qual_indicator_and_error_checks_qf=attname2;
            end
            a1=strcmp(attname1,'percent_invalid_due_to_missing_data_in_search_region_qf');
            if(a1==1)
                DQFS.pct_inval_due_to_missing_data_in_search_region_qf=attname2;
            end
            a1=strcmp(attname1,'percent_invalid_due_to_winds_not_found_qf');
            if(a1==1)
                DQFS.pct_inval_due_to_winds_not_found_qf=attname2;
            end
            a1=strcmp(attname1,'percent_invalid_due_to_feature_cluster_not_found_qf');
            if(a1==1)
                DQFS.pct_inval_due_to_feature_cluster_not_found_qf=attname2;
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
                LatImageS.long_name=attname2;
            end
            a1=strcmp(attname1,'standard_name');
            if(a1==1)
                LatImageS.standard_name=attname2;
            end
            a1=strcmp(attname1,'units');
            if(a1==1)
                LatImageS.units=attname2;
            end
            a1=strcmp(attname1,'axis');
            if(a1==1)
                LatImageS.axis=attname2;
            end
            a1=strcmp(attname1,'bounds');
            if(a1==1)
                LatImageS.bounds=attname2;
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
                LatImageBS.long_name=attname2;
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
                LonImageS.long_name=attname2;
            end
            a1=strcmp(attname1,'standard_name');
            if(a1==1)
                LonImageS.standard_name=attname2;
            end
            a1=strcmp(attname1,'units');
            if(a1==1)
                LonImageS.units=attname2;
            end
            a1=strcmp(attname1,'axis');
            if(a1==1)
                LonImageS.axis=attname2;
            end
            a1=strcmp(attname1,'bounds');
            if(a1==1)
                LonImageS.bounds=attname2;
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
                LonImageBS.long_name=attname2;
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
                GOESProjS.long_name=attname2;
            end
            a1=strcmp(attname1,'grid_mapping_name');
            if(a1==1)
                GOESProjS.grid_mapping_name=attname2;
            end
            a1=strcmp(attname1,'semi_major_axis');
            if(a1==1)
                GOESProjS.semi_major_axis=attname2;
            end
            a1=strcmp(attname1,'semi_minor_axis');
            if(a1==1)
                GOESProjS.semi_minor_axis=attname2;
            end
            a1=strcmp(attname1,'inverse_flattening');
            if(a1==1)
                GOESProjS.inverse_flattening=attname2;
            end
            a1=strcmp(attname1,'longitude_of_prime_meridian');
            if(a1==1)
                 GOESProjS.longitude_of_prime_meridian=attname2;
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
                ProcessParamTS.long_name=attname2;
            end
            a1=strcmp(attname1,'L2_processing_parm_version');
            if(a1==1)
                ProcessParamTS.L2_processing_parm_version=attname2;
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
                LZABS.long_name=attname2;
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
                SZABS.long_name=attname2;
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
                SecBetwnImagesS.long_name=attname2;
            end
            a1=strcmp(attname1,'_Unsigned');
            if(a1==1)
                SecBetwnImagesS.Unsigned=attname2;
            end
            a1=strcmp(attname1,'_FillValue');
            if(a1==1)
                SecBetwnImagesS.FillValue=attname2;
            end
            a1=strcmp(attname1,'units');
            if(a1==1)
                SecBetwnImagesS.units=attname2;
            end
            a1=strcmp(attname1,'coordinates');
            if(a1==1)
                SecBetwnImagesS.coordinates=attname2;
            end
            a1=strcmp(attname1,'cell_methods');
            if(a1==1)
                SecBetwnImagesS.cell_methods=attname2;
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
                TimeBoundsS.long_name=attname2;
            end
        elseif (a390==1)
            attname1 = netcdf.inqAttName(ncid,i,j);
            attname2 = netcdf.getAtt(ncid,i,attname1);
            if(idebug==1)
                disp([attname1 ':  ' num2str(attname2)])
                dispstr=strcat(attname1,': ',num2str(attname2));
                fprintf(fid,'%s\n',dispstr);
            end
            a1=strcmp(attname1,'long_name');
            if(a1==1)
                RetLZAS.long_name=attname2;
            end
            a1=strcmp(attname1,'standard_name');
            if(a1==1)
                RetLZAS.standard_name=attname2;
            end
            a1=strcmp(attname1,'units');
            if(a1==1)
                RetLZAS.units=attname2;
            end
            a1=strcmp(attname1,'bounds');
            if(a1==1)
                RetLZAS.bounds=attname2;
            end
        elseif (a400==1)
            attname1 = netcdf.inqAttName(ncid,i,j);
            attname2 = netcdf.getAtt(ncid,i,attname1);
            if(idebug==1)
                disp([attname1 ':  ' num2str(attname2)])
                dispstr=strcat(attname1,': ',num2str(attname2));
                fprintf(fid,'%s\n',dispstr);
            end
            a1=strcmp(attname1,'long_name');
            if(a1==1)
                RetLZABS.long_name=attname2;
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
                ATMLayerPS.long_name=attname2;
            end
            a1=strcmp(attname1,'standard_name');
            if(a1==1)
                ATMLayerPS.standard_name=attname2;
            end
            a1=strcmp(attname1,'units');
            if(a1==1)
                ATMLayerPS.units=attname2;
            end
            a1=strcmp(attname1,'axis');
            if(a1==1)
                ATMLayerPS.axis=attname2;
            end
            a1=strcmp(attname1,'bounds');
            if(a1==1)
                ATMLayerPS.bounds=attname2;
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
                ATMLayerPBS.long_name=attname2;
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
                WindSpeedOutlierS.long_name=attname2;
            end
            a1=strcmp(attname1,'_FillValue');
            if(a1==1)
                WindSpeedOutlierS.FillValue=attname2;
            end
            a1=strcmp(attname1,'units');
            if(a1==1)
                WindSpeedOutlierS.units=attname2;
            end
            a1=strcmp(attname1,'coordinates');
            if(a1==1)
                WindSpeedOutlierS.coordinates=attname2;
            end
            a1=strcmp(attname1,'cell_methods');
            if(a1==1)
                WindSpeedOutlierS.cell_methods=attname2;
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
                WindVectorS.long_name=attname2;
            end
            a1=strcmp(attname1,'_FillValue');
            if(a1==1)
                WindVectorS.FillValue=attname2;
            end
            a1=strcmp(attname1,'units');
            if(a1==1)
                WindVectorS.units=attname2;
            end
            a1=strcmp(attname1,'coordinates');
            if(a1==1)
                WindVectorS.coordinates=attname2;
            end
            a1=strcmp(attname1,'cell_methods');
            if(a1==1)
                WindVectorS.cell_methods=attname2;
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
                TargetBoxS.long_name=attname2;
            end
            a1=strcmp(attname1,'_FillValue');
            if(a1==1)
                TargetBoxS.FillValue=attname2;
            end
            a1=strcmp(attname1,'units');
            if(a1==1)
                TargetBoxS.units=attname2;
            end
            a1=strcmp(attname1,'coordinates');
            if(a1==1)
                TargetBoxS.coordinates=attname2;
            end
            a1=strcmp(attname1,'cell_methods');
            if(a1==1)
                TargetBoxS.cell_methods=attname2;
            end
            a1=strcmp(attname1,'valid_range');
            if(a1==1)
                TargetBoxS.valid_range=attname2;
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
                LagSizeS.long_name=attname2;
            end
            a1=strcmp(attname1,'_FillValue');
            if(a1==1)
                LagSizeS.FillValue=attname2;
            end
            a1=strcmp(attname1,'units');
            if(a1==1)
                LagSizeS.units=attname2;
            end
            a1=strcmp(attname1,'coordinates');
            if(a1==1)
                LagSizeS.coordinates=attname2;
            end
            a1=strcmp(attname1,'cell_methods');
            if(a1==1)
                LagSizeS.cell_methods=attname2;
            end
            a1=strcmp(attname1,'valid_range');
            if(a1==1)
                LagSizeS.valid_range=attname2;
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
                NestTrkFlagS.long_name=attname2;
            end
            a1=strcmp(attname1,'_FillValue');
            if(a1==1)
                NestTrkFlagS.FillValue=attname2;
            end
            a1=strcmp(attname1,'units');
            if(a1==1)
                NestTrkFlagS.units=attname2;
            end
            a1=strcmp(attname1,'coordinates');
            if(a1==1)
                NestTrkFlagS.coordinates=attname2;
            end
            a1=strcmp(attname1,'cell_methods');
            if(a1==1)
                NestTrkFlagS.cell_methods=attname2;
            end
            a1=strcmp(attname1,'valid_range');
            if(a1==1)
                NestTrkFlagS.valid_range=attname2;
            end
            a1=strcmp(attname1,'flag_values');
            if(a1==1)
                NestTrkFlagS.flag_values=attname2;
            end
            a1=strcmp(attname1,'flag_meanings');
            if(a1==1)
                NestTrkFlagS.flag_meanings=attname2;
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
                TargetTypeS.long_name=attname2;
            end
            a1=strcmp(attname1,'_FillValue');
            if(a1==1)
                TargetTypeS.FillValue=attname2;
            end
            a1=strcmp(attname1,'units');
            if(a1==1)
                TargetTypeS.units=attname2;
            end
            a1=strcmp(attname1,'coordinates');
            if(a1==1)
                TargetTypeS.coordinates=attname2;
            end
            a1=strcmp(attname1,'cell_methods');
            if(a1==1)
                TargetTypeS.cell_methods=attname2;
            end
            a1=strcmp(attname1,'valid_range');
            if(a1==1)
                TargetTypeS.valid_range=attname2;
            end
            a1=strcmp(attname1,'flag_values');
            if(a1==1)
                TargetTypeS.flag_values=attname2;
            end
            a1=strcmp(attname1,'flag_meanings');
            if(a1==1)
                TargetTypeS.flag_meanings=attname2;
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
                MinWindSpeedS.long_name=attname2;
            end
            a1=strcmp(attname1,'standard_name');
            if(a1==1)
                MinWindSpeedS.standard_name=attname2;
            end
            a1=strcmp(attname1,'_FillValue');
            if(a1==1)
                MinWindSpeedS.FillValue=attname2;
            end
            a1=strcmp(attname1,'units');
            if(a1==1)
                MinWindSpeedS.units=attname2;
            end
            a1=strcmp(attname1,'coordinates');
            if(a1==1)
                MinWindSpeedS.coordinates=attname2;
            end
            a1=strcmp(attname1,'cell_methods');
            if(a1==1)
                MinWindSpeedS.cell_methods=attname2;
            end
            a1=strcmp(attname1,'valid_range');
            if(a1==1)
                MinWindSpeedS.valid_range=attname2;
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
                MaxWindSpeedS.long_name=attname2;
            end
            a1=strcmp(attname1,'standard_name');
            if(a1==1)
                MaxWindSpeedS.standard_name=attname2;
            end
            a1=strcmp(attname1,'_FillValue');
            if(a1==1)
                MaxWindSpeedS.FillValue=attname2;
            end
            a1=strcmp(attname1,'units');
            if(a1==1)
                MaxWindSpeedS.units=attname2;
            end
            a1=strcmp(attname1,'coordinates');
            if(a1==1)
                MaxWindSpeedS.coordinates=attname2;
            end
            a1=strcmp(attname1,'cell_methods');
            if(a1==1)
                MaxWindSpeedS.cell_methods=attname2;
            end
            a1=strcmp(attname1,'valid_range');
            if(a1==1)
                MaxWindSpeedS.valid_range=attname2;
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
                MeanWindSpeedS.long_name=attname2;
            end
            a1=strcmp(attname1,'standard_name');
            if(a1==1)
                MeanWindSpeedS.standard_name=attname2;
            end
            a1=strcmp(attname1,'_FillValue');
            if(a1==1)
                MeanWindSpeedS.FillValue=attname2;
            end
            a1=strcmp(attname1,'units');
            if(a1==1)
                MeanWindSpeedS.units=attname2;
            end
            a1=strcmp(attname1,'coordinates');
            if(a1==1)
                MeanWindSpeedS.coordinates=attname2;
            end
            a1=strcmp(attname1,'cell_methods');
            if(a1==1)
                MeanWindSpeedS.cell_methods=attname2;
            end
            a1=strcmp(attname1,'valid_range');
            if(a1==1)
                MeanWindSpeedS.valid_range=attname2;
            end
         elseif (a520==1)
            attname1 = netcdf.inqAttName(ncid,i,j);
            attname2 = netcdf.getAtt(ncid,i,attname1);
            if(idebug==1)
                disp([attname1 ':  ' num2str(attname2)])
                dispstr=strcat(attname1,': ',num2str(attname2));
                fprintf(fid,'%s\n',dispstr);
            end
            a1=strcmp(attname1,'long_name');
            if(a1==1)
                StdevWindSpeedS.long_name=attname2;
            end
            a1=strcmp(attname1,'standard_name');
            if(a1==1)
                StdevWindSpeedS.standard_name=attname2;
            end
            a1=strcmp(attname1,'_FillValue');
            if(a1==1)
                StdevWindSpeedS.FillValue=attname2;
            end
            a1=strcmp(attname1,'units');
            if(a1==1)
                StdevWindSpeedS.units=attname2;
            end
            a1=strcmp(attname1,'coordinates');
            if(a1==1)
                StdevWindSpeedS.coordinates=attname2;
            end
            a1=strcmp(attname1,'cell_methods');
            if(a1==1)
                StdevWindSpeedS.cell_methods=attname2;
            end
            a1=strcmp(attname1,'valid_range');
            if(a1==1)
                StdevWindSpeedS.valid_range=attname2;
            end
         elseif (a530==1)
            attname1 = netcdf.inqAttName(ncid,i,j);
            attname2 = netcdf.getAtt(ncid,i,attname1);
            if(idebug==1)
                disp([attname1 ':  ' num2str(attname2)])
                dispstr=strcat(attname1,': ',num2str(attname2));
                fprintf(fid,'%s\n',dispstr);
            end
            a1=strcmp(attname1,'long_name');
            if(a1==1)
                MinCloudTopPressureS.long_name=attname2;
            end
            a1=strcmp(attname1,'standard_name');
            if(a1==1)
                MinCloudTopPressureS.standard_name=attname2;
            end
            a1=strcmp(attname1,'_FillValue');
            if(a1==1)
                MinCloudTopPressureS.FillValue=attname2;
            end
            a1=strcmp(attname1,'units');
            if(a1==1)
                MinCloudTopPressureS.units=attname2;
            end
            a1=strcmp(attname1,'coordinates');
            if(a1==1)
                MinCloudTopPressureS.coordinates=attname2;
            end
            a1=strcmp(attname1,'cell_methods');
            if(a1==1)
                MinCloudTopPressureS.cell_methods=attname2;
            end
            a1=strcmp(attname1,'valid_range');
            if(a1==1)
                MinCloudTopPressureS.valid_range=attname2;
            end
         elseif (a540==1)
            attname1 = netcdf.inqAttName(ncid,i,j);
            attname2 = netcdf.getAtt(ncid,i,attname1);
            if(idebug==1)
                disp([attname1 ':  ' num2str(attname2)])
                dispstr=strcat(attname1,': ',num2str(attname2));
                fprintf(fid,'%s\n',dispstr);
            end
            a1=strcmp(attname1,'long_name');
            if(a1==1)
                MaxCloudTopPressureS.long_name=attname2;
            end
            a1=strcmp(attname1,'standard_name');
            if(a1==1)
                MaxCloudTopPressureS.standard_name=attname2;
            end
            a1=strcmp(attname1,'_FillValue');
            if(a1==1)
                MaxCloudTopPressureS.FillValue=attname2;
            end
            a1=strcmp(attname1,'units');
            if(a1==1)
                MaxCloudTopPressureS.units=attname2;
            end
            a1=strcmp(attname1,'coordinates');
            if(a1==1)
                MaxCloudTopPressureS.coordinates=attname2;
            end
            a1=strcmp(attname1,'cell_methods');
            if(a1==1)
                MaxCloudTopPressureS.cell_methods=attname2;
            end
            a1=strcmp(attname1,'valid_range');
            if(a1==1)
                MaxCloudTopPressureS.valid_range=attname2;
            end
        elseif (a550==1)
            attname1 = netcdf.inqAttName(ncid,i,j);
            attname2 = netcdf.getAtt(ncid,i,attname1);
            if(idebug==1)
                disp([attname1 ':  ' num2str(attname2)])
                dispstr=strcat(attname1,': ',num2str(attname2));
                fprintf(fid,'%s\n',dispstr);
            end
            a1=strcmp(attname1,'long_name');
            if(a1==1)
                MeanCloudTopPressureS.long_name=attname2;
            end
            a1=strcmp(attname1,'standard_name');
            if(a1==1)
                MeanCloudTopPressureS.standard_name=attname2;
            end
            a1=strcmp(attname1,'_FillValue');
            if(a1==1)
                MeanCloudTopPressureS.FillValue=attname2;
            end
            a1=strcmp(attname1,'units');
            if(a1==1)
                MeanCloudTopPressureS.units=attname2;
            end
            a1=strcmp(attname1,'coordinates');
            if(a1==1)
                MeanCloudTopPressureS.coordinates=attname2;
            end
            a1=strcmp(attname1,'cell_methods');
            if(a1==1)
                MeanCloudTopPressureS.cell_methods=attname2;
            end
            a1=strcmp(attname1,'valid_range');
            if(a1==1)
                MeanCloudTopPressureS.valid_range=attname2;
            end
        elseif (a560==1)
            attname1 = netcdf.inqAttName(ncid,i,j);
            attname2 = netcdf.getAtt(ncid,i,attname1);
            if(idebug==1)
                disp([attname1 ':  ' num2str(attname2)])
                dispstr=strcat(attname1,': ',num2str(attname2));
                fprintf(fid,'%s\n',dispstr);
            end
            a1=strcmp(attname1,'long_name');
            if(a1==1)
                StdevCloudTopPressureS.long_name=attname2;
            end
            a1=strcmp(attname1,'standard_name');
            if(a1==1)
                StdevCloudTopPressureS.standard_name=attname2;
            end
            a1=strcmp(attname1,'_FillValue');
            if(a1==1)
                StdevCloudTopPressureS.FillValue=attname2;
            end
            a1=strcmp(attname1,'units');
            if(a1==1)
                StdevCloudTopPressureS.units=attname2;
            end
            a1=strcmp(attname1,'coordinates');
            if(a1==1)
                StdevCloudTopPressureS.coordinates=attname2;
            end
            a1=strcmp(attname1,'cell_methods');
            if(a1==1)
                StdevCloudTopPressureS.cell_methods=attname2;
            end
        elseif (a570==1)
            attname1 = netcdf.inqAttName(ncid,i,j);
            attname2 = netcdf.getAtt(ncid,i,attname1);
            if(idebug==1)
                disp([attname1 ':  ' num2str(attname2)])
                dispstr=strcat(attname1,': ',num2str(attname2));
                fprintf(fid,'%s\n',dispstr);
            end
            a1=strcmp(attname1,'long_name');
            if(a1==1)
                GRBErrorsS.long_name=attname2;
            end
            a1=strcmp(attname1,'_FillValue');
            if(a1==1)
                GRBErrorsS.FillValue=attname2;
            end
            a1=strcmp(attname1,'units');
            if(a1==1)
                GRBErrorsS.units=attname2;
            end
            a1=strcmp(attname1,'coordinates');
            if(a1==1)
                GRBErrorsS.coordinates=attname2;
            end
            a1=strcmp(attname1,'cell_methods');
            if(a1==1)
                GRBErrorsS.cell_methods=attname2;
            end
            a1=strcmp(attname1,'valid_range');
            if(a1==1)
                GRBErrorsS.valid_range=attname2;
            end
        elseif (a580==1)
            attname1 = netcdf.inqAttName(ncid,i,j);
            attname2 = netcdf.getAtt(ncid,i,attname1);
            if(idebug==1)
                disp([attname1 ':  ' num2str(attname2)])
                dispstr=strcat(attname1,': ',num2str(attname2));
                fprintf(fid,'%s\n',dispstr);
            end
            a1=strcmp(attname1,'long_name');
            if(a1==1)
                L0ErrorsS.long_name=attname2;
            end
            a1=strcmp(attname1,'_FillValue');
            if(a1==1)
                L0ErrorsS.FillValue=attname2;
            end
            a1=strcmp(attname1,'units');
            if(a1==1)
                L0ErrorsS.units=attname2;
            end
            a1=strcmp(attname1,'coordinates');
            if(a1==1)
                L0ErrorsS.coordinates=attname2;
            end
            a1=strcmp(attname1,'cell_methods');
            if(a1==1)
                L0ErrorsS.cell_methods=attname2;
            end
            a1=strcmp(attname1,'valid_range');
            if(a1==1)
                L0ErrorsS.valid_range=attname2;
            end
        elseif (a590==1)
            attname1 = netcdf.inqAttName(ncid,i,j);
            attname2 = netcdf.getAtt(ncid,i,attname1);
            if(idebug==1)
                disp([attname1 ':  ' num2str(attname2)])
                dispstr=strcat(attname1,': ',num2str(attname2));
                fprintf(fid,'%s\n',dispstr);
            end
            a1=strcmp(attname1,'long_name');
            if(a1==1)
                Algo2S.long_name=attname2;
            end
            a1=strcmp(attname1,'input_ABI_L2_auxiliary_solar_zenith_angle_data');
            if(a1==1)
                Algo2S.input_ABI_L2_auxiliary_solar_zenith_angle_data=attname2;
            end
            a1=strcmp(attname1,'input_ABI_L1b_radiance_band_14_2km_data');
            if(a1==1)
                Algo2S.units=attname2;
            end
            a1=strcmp(attname1,'input_ABI_L2_brightness_temperature_band_7_2km_data');
            if(a1==1)
                Algo2S.input_ABI_L2_brightness_temperature_band_7_2km_data=attname2;
            end
            a1=strcmp(attname1,'input_ABI_L2_brightness_temperature_band_8_2km_data');
            if(a1==1)
                Algo2S.cell_methods=attname2;
            end
            a1=strcmp(attname1,'input_ABI_L2_brightness_temperature_band_8_2km_data');
            if(a1==1)
                Algo2S.input_ABI_L2_brightness_temperature_band_8_2km_data=attname2;
            end
            a1=strcmp(attname1,'input_ABI_L2_brightness_temperature_band_9_2km_data');
            if(a1==1)
                Algo2S.input_ABI_L2_brightness_temperature_band_9_2km_data=attname2;
            end
            a1=strcmp(attname1,'input_ABI_L2_brightness_temperature_band_10_2km_data');
            if(a1==1)
                Algo2S.input_ABI_L2_brightness_temperature_band_10_2km_data=attname2;
            end
            a1=strcmp(attname1,'input_ABI_L2_brightness_temperature_band_14_2km_data');
            if(a1==1)
                Algo2S.input_ABI_L2_brightness_temperature_band_14_2km_data=attname2;
            end
            a1=strcmp(attname1,'input_ABI_L2_cloud_top_phase_data');
            if(a1==1)
                Algo2S.input_ABI_L2_cloud_top_phase_data=attname2;
            end
            a1=strcmp(attname1,'input_ABI_L2_cloud_top_temperature_data');
            if(a1==1)
                Algo2S.input_ABI_L2_cloud_top_temperature_data=attname2;
            end
            a1=strcmp(attname1,'input_ABI_L2_intermediate_product_reflectance_band_2_half_km_data');
            if(a1==1)
                Algo2S.input_ABI_L2_interm_product_reflectance_band_2_half_km_data=attname2;
            end
            a1=strcmp(attname1,'input_ABI_L2_intermediate_product_4_level_cloud_mask_data');
            if(a1==1)
                Algo2S.input_ABI_L2_intermediate_product_4_level_cloud_mask_data=attname2;
            end
            a1=strcmp(attname1,'input_ABI_L2_intermediate_product_cloud_top_height_data');
            if(a1==1)
                Algo2S.input_ABI_L2_intermediate_product_cloud_top_height_data=attname2;
            end
            a1=strcmp(attname1,'input_ABI_L2_intermediate_product_cloud_top_pressure_data');
            if(a1==1)
                Algo2S.input_ABI_L2_intermediate_product_cloud_top_pressure_data=attname2;
            end
            a1=strcmp(attname1,'input_ABI_L2_intermediate_product_cloud_type_data');
            if(a1==1)
                Algo2S.input_ABI_L2_intermediate_product_cloud_type_data=attname2;
            end
            a1=strcmp(attname1,'input_ABI_L2_intermediate_product_low_level_temperature_inversion_flag_data');
            if(a1==1)
                Algo2S.input_ABI_L2_inter_product_low_level_temp_inversion_flag_data=attname2;
            end
            a1=strcmp(attname1,'input_dynamic_ancillary_NWP_raw_temperature_profile_data');
            if(a1==1)
                Algo2S.input_dynamic_ancillary_NWP_raw_temperature_profile_data=attname2;
            end
            a1=strcmp(attname1,'input_dynamic_ancillary_NWP_wind_vector_profile_data');
            if(a1==1)
                Algo2S.input_dynamic_ancillary_NWP_wind_vector_profile_data=attname2;
            end
        elseif (a600==1)
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
        elseif (a610==1)
            attname1 = netcdf.inqAttName(ncid,i,j);
            attname2 = netcdf.getAtt(ncid,i,attname1);
            if(idebug==1)
                disp([attname1 ':  ' num2str(attname2)])
                dispstr=strcat(attname1,': ',num2str(attname2));
                fprintf(fid,'%s\n',dispstr);
            end
            a1=strcmp(attname1,'long_name');
            if(a1==1)
                Band_WavelengthS.long_name=attname2;
            end
            a1=strcmp(attname1,'standard_name');
            if(a1==1)
                Band_WavelengthS.standard_name=attname2;
            end
            a1=strcmp(attname1,'units');
            if(a1==1)
                Band_WavelengthS.units=attname2;
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
    if(idebug==1)
        disp(' ')
    end
    
    if flag
        eval([varname '= double(double(netcdf.getVar(ncid,i))*scale + offset);'])
        if(varname=='TEMP')
            TempS.values=TEMP;
        end
        if(varname=='y')
            yS.values=y;
        end
        if(varname=='x')
            xS.values=x;
        end
    else
        eval([varname '= double(netcdf.getVar(ncid,i));'])   
        if(a10==1)
            latS.values=lat;
        end
        if(a20==1)
            lonS.values=lon;
        end
        if(a30==1)
            timeS.values=time;
        end
        if(a40==1)
            WindSpeedS.values=wind_speed;
        end
        if(a50==1)
            WindDirectionS.values=wind_direction;
        end
        if(a60==1)
            PressureS.values=pressure;
        end

        if(a70==1)
            TempS.values=temperature;
        end
        if(a80==1)
            LZAS.values=local_zenith_angle;
        end
        if(a90==1)
            SZAS.values=solar_zenith_angle;
        end
        if(a100==1)
            DQFS.values=DQF;
        end
        if(a110==1)
            LatImageS.values=lat_image;
        end
        if(a120==1)
            LatImageBS.values=lat_image_bounds;
        end
        if(a130==1)
            LonImageS.values=lon_image;
        end
        if(a140==1)
            LonImageBS.values=lon_image_bounds;
        end
        if(a150==1)
            GOESProjS.values=goes_lat_lon_projection;
        end
        if(a160==1)
            GeoSpatialS.values=geospatial_lat_lon_extent;
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

        if(a300==1)
            SZABS.values=solar_zenith_angle_bounds;
        end

        if(a340==1)
            SatDataS.values1=nominal_satellite_subpoint_lat;
        end
        if(a350==1)
            SatDataS.values2=nominal_satellite_subpoint_lon;
        end
        if(a360==1)
            SatDataS.values3=nominal_satellite_height;
        end
        if(a370==1)
            SecBetwnImagesS.values=seconds_between_images;
        end
        if(a380==1)
            TimeBoundsS.values=time_bounds;
        end
        if(a390==1)
            RetLZAS.values=retrieval_local_zenith_angle;
        end
        if(a400==1)
            RetLZABS.values=retrieval_local_zenith_angle_bounds;
        end
        if(a410==1)
            ATMLayerPS.values=atmospheric_layer_pressure;
        end
        if(a420==1)
            ATMLayerPBS.values=atmospheric_layer_pressure_bounds;
        end
        if(a430==1)
            WindSpeedOutlierS.values=wind_speed_outlier_count;
        end
        if(a440==1)
            WindVectorS.values=number_of_wind_vectors_in_atmospheric_layer;
        end
        if(a450==1)
            TargetBoxS.values=target_box_size;
        end
        if(a460==1)
            LagSizeS.values=lag_size;
        end
        if(a470==1)
            NestTrkFlagS.values=nested_tracking_flag;
        end
        if(a480==1)
            TargetTypeS.values=target_type;
        end
        if(a490==1)
            MinWindSpeedS.values=minimum_wind_speed;
        end
        if(a500==1)
            MaxWindSpeedS.values=maximum_wind_speed;
        end
        if(a510==1)
            MeanWindSpeedS.values=mean_wind_speed;
        end
        if(a520==1)
            StdevWindSpeedS.values=standard_deviation_wind_speed;
        end
        if(a530==1)
            MinCloudTopPressureS.values=min_cloud_top_pressure_in_atmospheric_layer;
        end
        if(a540==1)
            MaxCloudTopPressureS.values=max_cloud_top_pressure_in_atmospheric_layer;
        end
        if(a550==1)
            MeanCloudTopPressureS.values=mean_cloud_top_pressure_in_atmospheric_layer;
        end
        if(a560==1)
            StdevCloudTopPressureS.values=standard_deviation_cloud_top_pressure_in_atmospheric_layer;
        end
        if(a570==1)
            GRBErrorsS.values=percent_uncorrectable_GRB_errors;
        end
        if(a580==1)
            L0ErrorsS.values=percent_uncorrectable_L0_errors;
        end
        if(a590==1)
            Algo2S.values=algorithm_dynamic_input_data_container;
        end
        if(a600==1)
            Band_IDS.values=band_id;
        end
        if(a610==1)
            Band_WavelengthS.values=band_wavelength;
        end
    end
end
if(idebug==1)
    disp('^~^~^~^~^~^~^~^~^~^~^~^~^~^~^~^~^~^~^~^~^~^~^~^~^~^~^~^~')
    disp('________________________________________________________')
    disp(' '),disp(' ')
end
% Close the file
netcdf.close(ncid);
fprintf(fid,'%s\n','Finished reading derived winds data');
%Now write a Matlab file containing the decoded data
%use the original file name with a .mat extension
[iper]=strfind(GOESFileName,'.');
is=1;
ie=iper(1)-1;
MatFileName=strcat(GOESFileName(is:ie),'.mat');
if(isavefiles==1)
    eval(['cd ' GOES16path(1:length(GOES16path)-1)]);
    actionstr='save';
    varstr1='TempS MetaDataS yS xS tBS goesImagerS AlgoProductTS';
    varstr2=' latS lonS timeS WindSpeedS WindDirectionS PressureS LZAS SZAS';
    varstr3=' DQFS LatImageS LonImageS LatImageBS LonImageBS GOESProjS GeoSpatialS';
    varstr4=' Algo2S ProcessParamTS AlgoProductTS SatDataS SecBetwnImagesS';
    varstr5=' GoesWaveBand SZAS SZABS GOESFileName';
    varstr6=' TimeBoundsS RetLZAS RetLZABS ATMLayerPS WindSpeedOutlierS';
    varstr7=' WindVectorS TargetBoxS LagSizeS NestTrkFlagS TargetTypeS';
    varstr8=' MinWindSpeedS MaxWindSpeedS MeanWindSpeedS StdevWindSpeedS';
    varstr9=' MinCloudTopPressureS MaxCloudTopPressureS MeanCloudTopPressureS';
    varstr10=' StdevCloudTopPressureS GRBErrorsS L0ErrorsS Band_IDS Band_WavelengthS';
    varstr=strcat(varstr1,varstr2,varstr3,varstr4,varstr5);
    varstr=strcat(varstr,varstr6,varstr7,varstr8,varstr9,varstr10);
    qualstr='-v7.3';
    [cmdString]=MyStrcatV73(actionstr,MatFileName,varstr,qualstr);
    eval(cmdString)
    dispstr=strcat('Saved Matlab File-',MatFileName);
    disp(dispstr);
else
    dispstr=strcat('User Choise Not To Save Matlab File-',MatFileName);
    disp(dispstr);
end
% Now put the wind data in format for plotting and analysis
lats=latS.values;
lons=lonS.values;
numlats=length(lats);
WindData=zeros(1,6);
WindSpeed=WindSpeedS.values;
WindDirection=WindDirectionS.values;
WindSpeedFillValue=WindSpeedS.FillValue;
% Now find out how many points have wind measurements a make a list of just
% these values
% Find the median winds
meanwindspeed=MeanWindSpeedS.values;
[ibig]=find(WindSpeed>WindSpeedFillValue);
numbig=length(ibig);
if(numbig>0)% Plot will be created only if significant winds were found
    WindData=zeros(numbig,6);
    for i=1:numbig
        ind=ibig(i,1);
        WindData(i,1)=lats(ind,1);
        WindData(i,2)=lons(ind,1);
        WindData(i,3)=WindSpeed(ind,1);
        WindData(i,4)=WindDirection(ind,1);
        WindData(i,5)=WindSpeed(ind,1)*sind(WindDirection(ind,1));
        WindData(i,6)=WindSpeed(ind,1)*cosd(WindDirection(ind,1));
    end
    numwinds=length(WindData);
    minlat=floor(min(WindData(:,1)));
    maxlat=ceil(max(WindData(:,1)));
    difflat=maxlat-minlat;
    moddifflat=mod(difflat,2);
    if(moddifflat>0)
        maxlat=maxlat-1;
        difflat=maxlat-minlat;
    end
    minlon=floor(min(WindData(:,2)));
    maxlon=ceil(max(WindData(:,2)));
    difflon=maxlon-minlon;
    moddifflon=mod(difflon,2);
    if(moddifflon>0)
        maxlon=maxlon-1;
        difflon=maxlon-minlon;
    end
    latboxes=difflat/2;
    lonboxes=difflon/2;
    fprintf(fid,'%s\n','---Start Wind Divergence Caclulation---');
    latstr1=strcat('Min Lat=',num2str(minlat,4),'-Max Lat=',num2str(maxlat,4));
    fprintf(fid,'%s\n',latstr1);
    lonstr1=strcat('Min Lon=',num2str(minlon,4),'-Max Lon=',num2str(maxlon,4));
    fprintf(fid,'%s\n',lonstr1);
    boxstr1=strcat('# of lat boxes=',num2str(latboxes),'-# of lon boxes=',num2str(lonboxes));
    fprintf(fid,'%s\n',boxstr1);
    WindSpread=zeros(lonboxes,latboxes);
    WindBoxLoc1=zeros(lonboxes,latboxes);
    WindBoxLoc2=zeros(lonboxes,latboxes);
    WindCases=zeros(lonboxes,latboxes);
% Now start caclulating the spread in wind directions in each of these
% boxes
    maxvar=0;
    ihold=0;
    maxFOM=0;
    for i=1:lonboxes
        nowLon1=minlon+2*(i-1);
        nowLon2=nowLon1+2;
        nowLonC=(nowLon1+nowLon2)/2;
        for j=1:latboxes
            FOM=0;
            nowLat1=minlat+2*(j-1);
            nowLat2=nowLat1+2;
            nowLatC=(nowLat1+nowLat2)/2;
            WindBoxLoc1(i,j)=nowLonC;
            WindBoxLoc2(i,j)=nowLatC;
% now find all the wind measurements that lie within this 2 x 2 deg box
            numinside=0;
            HoldDir=NaN(numbig,1);
            HoldSpeed=NaN(numbig,1);
            for k=1:numwinds
                windlat=WindData(k,1);
                windlon=WindData(k,2);
                winddir=WindData(k,4);
                windvel=WindData(k,3);
                ihit1=0;
                ihit2=0;
                if((windlon>=nowLon1) && (windlon<=nowLon2))
                    ihit1=1;
                end
                if((windlat>=nowLat1) && (windlat<=nowLat2))
                    ihit2=1;
                end
                ihit3=ihit1*ihit2;
                if(ihit3==1)
                    numinside=numinside+1;
                    HoldDir(numinside,1)=winddir;
                    HoldSpeed(numinside,1)=windvel;
                    WindCases(i,j)=WindCases(i,j)+1;
                end
             end % Loop over wind measurements
            if(numinside>5)
                var=std(HoldDir,'omitnan');
                meanwind=5*mean(HoldSpeed,'omitnan');
                FOM=var+meanwind;
                if(FOM>maxFOM)
                    maxFOM=FOM;
                    ihold=i;
                    jhold=j;
                    ab=1;
                end
            else
                var=0;
            end
            WindSpread(i,j)=FOM;
        end% loop over lat boxes
    end% loop over lon boxes
    HurricaneLonEst=0;
    HurricaneLatEst=0;
    if(ihold>0)
        locstr1=strcat('Crude Lon Est=',num2str(WindBoxLoc1(ihold,jhold)),'-Lat Est=',...
        num2str(WindBoxLoc2(ihold,jhold)),'-Max FOM=',num2str(maxFOM,6),'-which had-',...
        num2str(WindCases(ihold,jhold)),'-points');
        disp(locstr1);
        fprintf(fid,'%s\n',locstr1);
        HurricaneLonEst=WindBoxLoc1(ihold,jhold);
        HurricaneLatEst=WindBoxLoc2(ihold,jhold);
    end
% Make A quiver plot showing the wind direction and speed
    fileprefix=GOESFileName(is:ie);
    filename=RemoveUnderScores(fileprefix);
    titlestr=strcat('WindData-',filename);
    figstr=strcat(titlestr,'.jpg');
    PlotWindSpeedVsLocationRev1(HurricaneLonEst,HurricaneLatEst,titlestr,figstr)
% Now plot the histogram of the wind velocities
    titlestr=strcat('WindVelHistogram-',filename);
    figstr=strcat(titlestr,'.jpg');
    PlotDerivedWindsVelHistogram(titlestr,figstr)
% Plot the Cumilative Distribution of Windspeeds
    titlestr=strcat('WindVelCumilDist-',filename);
    PlotWindSpeedCumilDist(titlestr)
else
    dispstr='No significant winds detected';
    disp(dispstr)
    fprintf(fid,'%s\n',dispstr);
    f = msgbox('No Significant Winds', 'Try Another File','warn');
end
end

